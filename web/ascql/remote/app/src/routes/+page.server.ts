import { db } from '$lib/server/db';
import { notes, sessions } from '$lib/server/db/schema';
import { eq, sql, type InferSelectModel } from 'drizzle-orm';
import type { Actions, PageServerLoad } from './$types';
import { error, fail, type Cookies } from '@sveltejs/kit';
import { SQLiteSyncDialect } from 'drizzle-orm/sqlite-core';
import Crypto from 'crypto';

async function getSession(cookies: Cookies) {
	let session = cookies.get('session');
	const found = session ? (await db.select().from(sessions).where(eq(sessions.token, session)))[0] : null;
	if (!found) {
		session = Crypto.randomUUID();
		cookies.set('session', session, {
			path: '/',
			maxAge: 60 * 60 * 24 * 365,
			secure: false,
		});
		return (await db.insert(sessions).values({ token: session }).returning())[0];
	}
	return found;
}

export const load: PageServerLoad = async ({ url, cookies }) => {
	const session = await getSession(cookies);

	const filter = Object.fromEntries(url.searchParams)["q"];

	const sqliteDialect = new SQLiteSyncDialect();
	const safeFilter = sqliteDialect.escapeString(`%${filter ?? ''}%`);

	// remove all non-ascii characters
	const safeSafefilter = [...safeFilter]
		.map((c) => String.fromCharCode(c.charCodeAt(0) % 256))
		.join('');

    try {
        const query = sql.raw(`
            SELECT * FROM note WHERE 
            NOT hidden
			AND sessionId = ${session.id}
			AND content LIKE ${safeSafefilter} 
            ORDER BY id ASC`
		);
        
        const result = (await db.all(query)) as InferSelectModel<typeof notes>[];
    
        if ((safeSafefilter.match(/'/g) || []).length > 2) {
            error(400, "DO NOT!!!!!");
        }
    
        return {
            notes: result
        };
    } catch {
        error(400, "DO NOT!!!!!");
    }
};

export const actions: Actions = {
	default: async ({ request, cookies }) => {
		const session = await getSession(cookies);

		const data = await request.formData();
		const content = data.get('content')?.toString();
		if (!content) {
			return fail(400);
		}

		await db.insert(notes).values({
			sessionId: session.id,
			content,
			hidden: false
		});
	}
};
