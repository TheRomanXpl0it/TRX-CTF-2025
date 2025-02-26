import { env } from '$env/dynamic/private';
import { db } from '$lib/server/db';
import { notes } from '$lib/server/db/schema';
import type { ServerInit } from '@sveltejs/kit';

export const init: ServerInit = async () => {
	await db.insert(notes).values({
        id: 1,
        content: env.FLAG ?? 'TRX{this_is_a_fake_flag}',
        hidden: true
    }).onConflictDoNothing();
};