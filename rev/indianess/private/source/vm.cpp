#include <iostream>
#include <stdlib.h>
#include <string.h>

#define N 256
#define FLAG_LEN 30

typedef unsigned char u8;

enum OP_Code {
	ADD,
	SUB,
	MUL,
	DIV,
	MOD,
	NOT,
	OR,
	AND,
	XOR,
	MOV,
	ASSERT,
	PRINT,
};

enum MOD_Code {
	REG_REG,
	MEM_IMM_MEM_IMM,
	MEM_IMM_MEM_REG,
	MEM_REG_MEM_IMM,
	MEM_REG_MEM_REG,
	REG_IMM,
	REG_MEM_IMM,
	REG_MEM_REG,
	MEM_IMM_IMM,
	MEM_REG_IMM,
	MEM_IMM_REG,
	MEM_REG_REG,
	REG_PLAIN,
};

void execute(u8 *code, long size, std::string &flag) {
	int i = 0, correct = 1;
	u8 reg[8] = {0};
	u8 mem[N + FLAG_LEN];

	if (flag.size() != FLAG_LEN) {
		std::cerr << "Invalid Flag Len\n";
		return ;
	}

	memset(mem, 0, N + FLAG_LEN);
	memcpy(&mem[N], flag.c_str(), flag.size());
	
	while (i < size) {
		u8 inst = code[i];
		u8 mode;
		switch (inst) {
			case ADD:
				mode = code[i + 1];
				switch (mode) {
					case REG_REG:
						reg[code[i + 2]] += reg[code[i + 3]];
						i += 4;
						break ;
					case MEM_IMM_MEM_IMM:
						mem[code[i + 2]] += mem[code[i + 3]];
						i += 4;
						break ;
					case MEM_IMM_MEM_REG:
						mem[code[i + 2]] += mem[reg[code[i + 3]]];
						i += 4;
						break ;
					case MEM_REG_MEM_IMM:
						mem[reg[code[i + 2]]] += mem[code[i + 3]];
						i += 4;
						break ;
					case MEM_REG_MEM_REG:
						mem[reg[code[i + 2]]] += mem[reg[code[i + 3]]];
						i += 4;
						break ;
					case REG_IMM:
						reg[code[i + 2]] += code[i + 3];
						i += 4;
						break ;
					case REG_MEM_IMM:
						reg[code[i + 2]] += mem[code[i + 3]];
						i += 4;
						break ;
					case REG_MEM_REG:
						reg[code[i + 2]] += mem[reg[code[i + 3]]];
						i += 4;
						break ;
					case MEM_IMM_IMM:
						mem[code[i + 2]] += code[i + 3];
						i += 4;
						break ;
					case MEM_REG_IMM:
						mem[reg[code[i + 2]]] += code[i + 3];
						i += 4;
						break ;
					case MEM_IMM_REG:
						mem[code[i + 2]] += reg[code[i + 3]];
						i += 4;
						break ;
					case MEM_REG_REG:
						mem[reg[code[i + 2]]] += reg[code[i + 3]];
						i += 4;
						break ;
					default:
						std::cerr << "Unknown mode\n";
						i += 2;
						break;
				}
				break;
			
			case SUB:
				mode = code[i + 1];
				switch (mode) {
					case REG_REG:
						reg[code[i + 2]] -= reg[code[i + 3]];
						i += 4;
						break ;
					case MEM_IMM_MEM_IMM:
						mem[code[i + 2]] -= mem[code[i + 3]];
						i += 4;
						break ;
					case MEM_IMM_MEM_REG:
						mem[code[i + 2]] -= mem[reg[code[i + 3]]];
						i += 4;
						break ;
					case MEM_REG_MEM_IMM:
						mem[reg[code[i + 2]]] -= mem[code[i + 3]];
						i += 4;
						break ;
					case MEM_REG_MEM_REG:
						mem[reg[code[i + 2]]] -= mem[reg[code[i + 3]]];
						i += 4;
						break ;
					case REG_IMM:
						reg[code[i + 2]] -= code[i + 3];
						i += 4;
						break ;
					case REG_MEM_IMM:
						reg[code[i + 2]] -= mem[code[i + 3]];
						i += 4;
						break ;
					case REG_MEM_REG:
						reg[code[i + 2]] -= mem[reg[code[i + 3]]];
						i += 4;
						break ;
					case MEM_IMM_IMM:
						mem[code[i + 2]] -= code[i + 3];
						i += 4;
						break ;
					case MEM_REG_IMM:
						mem[reg[code[i + 2]]] -= code[i + 3];
						i += 4;
						break ;
					case MEM_IMM_REG:
						mem[code[i + 2]] -= reg[code[i + 3]];
						i += 4;
						break ;
					case MEM_REG_REG:
						mem[reg[code[i + 2]]] -= reg[code[i + 3]];
						i += 4;
						break ;
					default:
						std::cerr << "Unknown mode\n";
						i += 2;
						break;
				}
			
			case MUL:
				mode = code[i + 1];
				switch (mode) {
					case REG_REG:
						reg[code[i + 2]] *= reg[code[i + 3]];
						i += 4;
						break ;
					case MEM_IMM_MEM_IMM:
						mem[code[i + 2]] *= mem[code[i + 3]];
						i += 4;
						break ;
					case MEM_IMM_MEM_REG:
						mem[code[i + 2]] *= mem[reg[code[i + 3]]];
						i += 4;
						break ;
					case MEM_REG_MEM_IMM:
						mem[reg[code[i + 2]]] *= mem[code[i + 3]];
						i += 4;
						break ;
					case MEM_REG_MEM_REG:
						mem[reg[code[i + 2]]] *= mem[reg[code[i + 3]]];
						i += 4;
						break ;
					case REG_IMM:
						reg[code[i + 2]] *= code[i + 3];
						i += 4;
						break ;
					case REG_MEM_IMM:
						reg[code[i + 2]] *= mem[code[i + 3]];
						i += 4;
						break ;
					case REG_MEM_REG:
						reg[code[i + 2]] *= mem[reg[code[i + 3]]];
						i += 4;
						break ;
					case MEM_IMM_IMM:
						mem[code[i + 2]] *= code[i + 3];
						i += 4;
						break ;
					case MEM_REG_IMM:
						mem[reg[code[i + 2]]] *= code[i + 3];
						i += 4;
						break ;
					case MEM_IMM_REG:
						mem[code[i + 2]] *= reg[code[i + 3]];
						i += 4;
						break ;
					case MEM_REG_REG:
						mem[reg[code[i + 2]]] *= reg[code[i + 3]];
						i += 4;
						break ;
					default:
						std::cerr << "Unknown mode\n";
						i += 2;
						break;
				}
				break;
			
			case DIV:
				mode = code[i + 1];
				switch (mode) {
					case REG_REG:
						reg[code[i + 2]] /= reg[code[i + 3]];
						i += 4;
						break ;
					case MEM_IMM_MEM_IMM:
						mem[code[i + 2]] /= mem[code[i + 3]];
						i += 4;
						break ;
					case MEM_IMM_MEM_REG:
						mem[code[i + 2]] /= mem[reg[code[i + 3]]];
						i += 4;
						break ;
					case MEM_REG_MEM_IMM:
						mem[reg[code[i + 2]]] /= mem[code[i + 3]];
						i += 4;
						break ;
					case MEM_REG_MEM_REG:
						mem[reg[code[i + 2]]] /= mem[reg[code[i + 3]]];
						i += 4;
						break ;
					case REG_IMM:
						reg[code[i + 2]] /= code[i + 3];
						i += 4;
						break ;
					case REG_MEM_IMM:
						reg[code[i + 2]] /= mem[code[i + 3]];
						i += 4;
						break ;
					case REG_MEM_REG:
						reg[code[i + 2]] /= mem[reg[code[i + 3]]];
						i += 4;
						break ;
					case MEM_IMM_IMM:
						mem[code[i + 2]] /= code[i + 3];
						i += 4;
						break ;
					case MEM_REG_IMM:
						mem[reg[code[i + 2]]] /= code[i + 3];
						i += 4;
						break ;
					case MEM_IMM_REG:
						mem[code[i + 2]] /= reg[code[i + 3]];
						i += 4;
						break ;
					case MEM_REG_REG:
						mem[reg[code[i + 2]]] /= reg[code[i + 3]];
						i += 4;
						break ;
					default:
						std::cerr << "Unknown mode\n";
						i += 2;
						break;
				}
				break;

			case MOD:
				mode = code[i + 1];
				switch (mode) {
					case REG_REG:
						reg[code[i + 2]] %= reg[code[i + 3]];
						i += 4;
						break ;
					case MEM_IMM_MEM_IMM:
						mem[code[i + 2]] %= mem[code[i + 3]];
						i += 4;
						break ;
					case MEM_IMM_MEM_REG:
						mem[code[i + 2]] %= mem[reg[code[i + 3]]];
						i += 4;
						break ;
					case MEM_REG_MEM_IMM:
						mem[reg[code[i + 2]]] %= mem[code[i + 3]];
						i += 4;
						break ;
					case MEM_REG_MEM_REG:
						mem[reg[code[i + 2]]] %= mem[reg[code[i + 3]]];
						i += 4;
						break ;
					case REG_IMM:
						reg[code[i + 2]] %= code[i + 3];
						i += 4;
						break ;
					case REG_MEM_IMM:
						reg[code[i + 2]] %= mem[code[i + 3]];
						i += 4;
						break ;
					case REG_MEM_REG:
						reg[code[i + 2]] %= mem[reg[code[i + 3]]];
						i += 4;
						break ;
					case MEM_IMM_IMM:
						mem[code[i + 2]] %= code[i + 3];
						i += 4;
						break ;
					case MEM_REG_IMM:
						mem[reg[code[i + 2]]] %= code[i + 3];
						i += 4;
						break ;
					case MEM_IMM_REG:
						mem[code[i + 2]] %= reg[code[i + 3]];
						i += 4;
						break ;
					case MEM_REG_REG:
						mem[reg[code[i + 2]]] %= reg[code[i + 3]];
						i += 4;
						break ;
					default:
						std::cerr << "Unknown mode\n";
						i += 2;
						break;
				}
				break;

			case NOT:
				mode = code[i + 1];
				switch (mode) {
					case REG_REG:
						reg[code[i + 2]] = ~reg[code[i + 2]];
						i += 3;
						break ;
					case MEM_IMM_MEM_IMM:
						mem[code[i + 2]] = ~mem[code[i + 2]];
						i += 3;
						break ;
					case MEM_REG_MEM_REG:
						mem[reg[code[i + 2]]] = ~mem[reg[code[i + 2]]];
						i += 3;
						break ;
					default:
						std::cerr << "Unknown mode\n";
						i += 2;
						break;
				}
				break;
			
			case OR:
				mode = code[i + 1];
				switch (mode) {
					case REG_REG:
						reg[code[i + 2]] |= reg[code[i + 3]];
						i += 4;
						break ;
					case MEM_IMM_MEM_IMM:
						mem[code[i + 2]] |= mem[code[i + 3]];
						i += 4;
						break ;
					case MEM_IMM_MEM_REG:
						mem[code[i + 2]] |= mem[reg[code[i + 3]]];
						i += 4;
						break ;
					case MEM_REG_MEM_IMM:
						mem[reg[code[i + 2]]] |= mem[code[i + 3]];
						i += 4;
						break ;
					case MEM_REG_MEM_REG:
						mem[reg[code[i + 2]]] |= mem[reg[code[i + 3]]];
						i += 4;
						break ;
					case REG_IMM:
						reg[code[i + 2]] |= code[i + 3];
						i += 4;
						break ;
					case REG_MEM_IMM:
						reg[code[i + 2]] |= mem[code[i + 3]];
						i += 4;
						break ;
					case REG_MEM_REG:
						reg[code[i + 2]] |= mem[reg[code[i + 3]]];
						i += 4;
						break ;
					case MEM_IMM_IMM:
						mem[code[i + 2]] |= code[i + 3];
						i += 4;
						break ;
					case MEM_REG_IMM:
						mem[reg[code[i + 2]]] |= code[i + 3];
						i += 4;
						break ;
					case MEM_IMM_REG:
						mem[code[i + 2]] |= reg[code[i + 3]];
						i += 4;
						break ;
					case MEM_REG_REG:
						mem[reg[code[i + 2]]] |= reg[code[i + 3]];
						i += 4;
						break ;
					default:
						std::cerr << "Unknown mode\n";
						i += 2;
						break;
				}
				break;

			case AND:
				mode = code[i + 1];
				switch (mode) {
					case REG_REG:
						reg[code[i + 2]] &= reg[code[i + 3]];
						i += 4;
						break ;
					case MEM_IMM_MEM_IMM:
						mem[code[i + 2]] &= mem[code[i + 3]];
						i += 4;
						break ;
					case MEM_IMM_MEM_REG:
						mem[code[i + 2]] &= mem[reg[code[i + 3]]];
						i += 4;
						break ;
					case MEM_REG_MEM_IMM:
						mem[reg[code[i + 2]]] &= mem[code[i + 3]];
						i += 4;
						break ;
					case MEM_REG_MEM_REG:
						mem[reg[code[i + 2]]] &= mem[reg[code[i + 3]]];
						i += 4;
						break ;
					case REG_IMM:
						reg[code[i + 2]] &= code[i + 3];
						i += 4;
						break ;
					case REG_MEM_IMM:
						reg[code[i + 2]] &= mem[code[i + 3]];
						i += 4;
						break ;
					case REG_MEM_REG:
						reg[code[i + 2]] &= mem[reg[code[i + 3]]];
						i += 4;
						break ;
					case MEM_IMM_IMM:
						mem[code[i + 2]] &= code[i + 3];
						i += 4;
						break ;
					case MEM_REG_IMM:
						mem[reg[code[i + 2]]] &= code[i + 3];
						i += 4;
						break ;
					case MEM_IMM_REG:
						mem[code[i + 2]] &= reg[code[i + 3]];
						i += 4;
						break ;
					case MEM_REG_REG:
						mem[reg[code[i + 2]]] &= reg[code[i + 3]];
						i += 4;
						break ;
					default:
						std::cerr << "Unknown mode\n";
						i += 2;
						break;
				}
				break;

			case XOR:
				mode = code[i + 1];
				switch (mode) {
					case REG_REG:
						reg[code[i + 2]] ^= reg[code[i + 3]];
						i += 4;
						break ;
					case MEM_IMM_MEM_IMM:
						mem[code[i + 2]] ^= mem[code[i + 3]];
						i += 4;
						break ;
					case MEM_IMM_MEM_REG:
						mem[code[i + 2]] ^= mem[reg[code[i + 3]]];
						i += 4;
						break ;
					case MEM_REG_MEM_IMM:
						mem[reg[code[i + 2]]] ^= mem[code[i + 3]];
						i += 4;
						break ;
					case MEM_REG_MEM_REG:
						mem[reg[code[i + 2]]] ^= mem[reg[code[i + 3]]];
						i += 4;
						break ;
					case REG_IMM:
						reg[code[i + 2]] ^= code[i + 3];
						i += 4;
						break ;
					case REG_MEM_IMM:
						reg[code[i + 2]] ^= mem[code[i + 3]];
						i += 4;
						break ;
					case REG_MEM_REG:
						reg[code[i + 2]] ^= mem[reg[code[i + 3]]];
						i += 4;
						break ;
					case MEM_IMM_IMM:
						mem[code[i + 2]] ^= code[i + 3];
						i += 4;
						break ;
					case MEM_REG_IMM:
						mem[reg[code[i + 2]]] ^= code[i + 3];
						i += 4;
						break ;
					case MEM_IMM_REG:
						mem[code[i + 2]] ^= reg[code[i + 3]];
						i += 4;
						break ;
					case MEM_REG_REG:
						mem[reg[code[i + 2]]] ^= reg[code[i + 3]];
						i += 4;
						break ;
					case REG_PLAIN:
						reg[code[i + 2]] ^= mem[N + code[i + 3]];
						i += 4;
						break ;
					default:
						std::cerr << "Unknown mode\n";
						i += 2;
						break;
				}
				break;

			case MOV:
				mode = code[i + 1];
				switch (mode) {
					case REG_REG:
						reg[code[i + 2]] = reg[code[i + 3]];
						i += 4;
						break ;
					case MEM_IMM_MEM_IMM:
						mem[code[i + 2]] = mem[code[i + 3]];
						i += 4;
						break ;
					case MEM_IMM_MEM_REG:
						mem[code[i + 2]] = mem[reg[code[i + 3]]];
						i += 4;
						break ;
					case MEM_REG_MEM_IMM:
						mem[reg[code[i + 2]]] = mem[code[i + 3]];
						i += 4;
						break ;
					case MEM_REG_MEM_REG:
						mem[reg[code[i + 2]]] = mem[reg[code[i + 3]]];
						i += 4;
						break ;
					case REG_IMM:
						reg[code[i + 2]] = code[i + 3];
						i += 4;
						break ;
					case REG_MEM_IMM:
						reg[code[i + 2]] = mem[code[i + 3]];
						i += 4;
						break ;
					case REG_MEM_REG:
						reg[code[i + 2]] = mem[reg[code[i + 3]]];
						i += 4;
						break ;
					case MEM_IMM_IMM:
						mem[code[i + 2]] = code[i + 3];
						i += 4;
						break ;
					case MEM_REG_IMM:
						mem[reg[code[i + 2]]] = code[i + 3];
						i += 4;
						break ;
					case MEM_IMM_REG:
						mem[code[i + 2]] = reg[code[i + 3]];
						i += 4;
						break ;
					case MEM_REG_REG:
						mem[reg[code[i + 2]]] = reg[code[i + 3]];
						i += 4;
						break ;
					default:
						std::cerr << "Unknown mode\n";
						i += 2;
						break;
				}
				break;

			case ASSERT:
				mode = code[i + 1];
				switch (mode) {
					case REG_REG:
						correct &= (reg[code[i + 2]] == reg[code[i + 3]]);
						i += 4;
						break ;
					case MEM_IMM_MEM_IMM:
						correct &= (mem[code[i + 2]] == mem[code[i + 3]]);
						i += 4;
						break ;
					case MEM_IMM_MEM_REG:
						correct &= (mem[code[i + 2]] == mem[reg[code[i + 3]]]);
						i += 4;
						break ;
					case MEM_REG_MEM_IMM:
						correct &= (mem[reg[code[i + 2]]] == mem[code[i + 3]]);
						i += 4;
						break ;
					case MEM_REG_MEM_REG:
						correct &= (mem[reg[code[i + 2]]] == mem[reg[code[i + 3]]]);
						i += 4;
						break ;
					case REG_IMM:
						correct &= (reg[code[i + 2]] == code[i + 3]);
						i += 4;
						break ;
					case REG_MEM_IMM:
						correct &= (reg[code[i + 2]] == mem[code[i + 3]]);
						i += 4;
						break ;
					case REG_MEM_REG:
						correct &= (reg[code[i + 2]] == mem[reg[code[i + 3]]]);
						i += 4;
						break ;
					case MEM_IMM_IMM:
						correct &= (mem[code[i + 2]] == code[i + 3]);
						i += 4;
						break ;
					case MEM_REG_IMM:
						correct &= (mem[reg[code[i + 2]]] == code[i + 3]);
						i += 4;
						break ;
					case MEM_IMM_REG:
						correct &= (mem[code[i + 2]] == reg[code[i + 3]]);
						i += 4;
						break ;
					case MEM_REG_REG:
						correct &= (mem[reg[code[i + 2]]] == reg[code[i + 3]]);
						i += 4;
						break ;
					default:
						std::cerr << "Unknown mode\n";
						i += 2;
						break;
				}
				break;

			case PRINT:
				if (correct) {
					std::cout << "Success!" << std::endl;
				} else {
					std::cout << "Better Luck Next Time!" << std::endl;
				}
				i += 1;
				break;

			default:
				std::cerr << "Unknown instruction\n";
				++i;
				break;
		}
	}
}

void compute(char *fname, std::string &flag) {
	FILE *f = fopen(fname, "r");
	if (!f) {
		std::cerr << "Failed to open file\n";
		return ;
	}
	fseek(f, 0, SEEK_END);
	long size = ftell(f);
	fseek(f, 0L, SEEK_SET);
	u8 *buf = (u8 *)malloc(size);
	if (!buf) {
		std::cerr << "Failed to allocate memory\n";
		fclose(f);
		return ;
	}
	fread(buf, 1, size, f);
	fclose(f);

	execute(buf, size, flag);

	free(buf);
}

int main(int argc, char **argv) {
	if (argc != 3) {
		std::cerr << "Usage: " << argv[0] << " <bytecode> <flag>\n";
		return (1);
	}
	std::string flag = std::string(argv[2]);
	compute(argv[1], flag);
	return (0);
}
