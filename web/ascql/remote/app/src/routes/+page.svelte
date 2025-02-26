<script lang="ts">
	import { enhance } from "$app/forms";
	import type { PageData } from "./$types";


    let { data }: { data: PageData } = $props();
</script>

<div class="w-full flex flex-col gap-4 p-4">
    {#each data.notes as note}
        <p class="text-lg text-gray-200 p-3 rounded-md bg-slate-700 border border-slate-800 text-center">{note.content}</p>
    {/each}
    <form class="flex flex-col gap-3 p-2" use:enhance method="POST">
        <input type="text" name="content" placeholder="Note" class="w-full p-2 rounded-md border border-slate-800" />
        <button type="submit" class="w-full p-2 rounded-md bg-slate-700 text-white">Add Note</button>
    </form>
    <p class="text-red-600 text-xl font-bold font-sans hover:rotate-180 transition-all duration-1000">YOU WILL NEVER ACCESS MY /secret!!!!!!</p>
</div>

<style lang="postcss">
    :global(body) {
        @apply bg-slate-900;
    }
</style>