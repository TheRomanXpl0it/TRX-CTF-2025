import { error } from '@sveltejs/kit';
import type { LayoutServerLoad } from './$types';

export const load: LayoutServerLoad = ({ url }) => {
    if (url.pathname.toLowerCase().includes("secret"))
        error(403, "hack detected!!!");
};