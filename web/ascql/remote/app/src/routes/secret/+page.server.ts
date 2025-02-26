import { redirect } from "@sveltejs/kit";
import type { PageServerLoad } from "./$types";


export const load: PageServerLoad = async () => {
    redirect(303, "/sup3rs3cr3tb4ckup.zip");
};