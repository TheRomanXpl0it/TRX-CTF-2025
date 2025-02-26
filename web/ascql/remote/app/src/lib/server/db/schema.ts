import { relations } from 'drizzle-orm';
import { sqliteTable, text, integer, uniqueIndex } from 'drizzle-orm/sqlite-core';


export const sessions = sqliteTable('session', {
	id: integer().primaryKey(),
	token: text().notNull(),
}, (table) => [
	uniqueIndex('session_token').on(table.token),
]);

export const sessionsRelations = relations(sessions, ({ many }) => ({
	notes: many(notes),
}));

export const notes = sqliteTable('note', {
	id: integer().primaryKey(),
	sessionId: integer(),
	content: text(),
	hidden: integer({ mode: "boolean" }),
});

export const notesRelations = relations(notes, ({ one }) => ({
	session: one(sessions, {
		fields: [notes.sessionId],
		references: [sessions.id],
	}),
}));