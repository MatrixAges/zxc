import { readFile } from 'node:fs/promises'
import { resolve } from 'node:path'
import { TRPCError } from '@trpc/server'
import { z } from 'zod'
import readWorktreeDiff from '../sessions/diff.ts'
import { createRouter, procedure } from './trpc.ts'

const iteration_procedure = procedure.input(z.object({ id: z.uuid() })).use(({ ctx, input, next }) => {
	const iteration = ctx.sessions.iterations.find(item => item.id === input.id)
	if (!iteration) throw new TRPCError({ code: 'NOT_FOUND', message: '迭代不存在' })

	return next({ ctx: { ...ctx, iteration } })
})

export default createRouter({
	list: procedure.query(({ ctx }) =>
		ctx.sessions.iterations.map(item => ({ ...item, events: item.events.slice(-30) }))
	),
	start: procedure
		.input(
			z.object({
				module: z.string().min(1),
				prompt: z.string().trim().min(1).max(12_000),
				previous_id: z.uuid().optional()
			})
		)
		.mutation(async ({ ctx, input }) => {
			const catalog = await ctx.workspace.list()
			if (!catalog.files.some(file => file.kind === 'module' && file.path === input.module)) {
				throw new TRPCError({ code: 'BAD_REQUEST', message: '模块不存在' })
			}

			return ctx.sessions.start(input)
		}),
	stop: iteration_procedure.mutation(async ({ ctx }) => {
		await ctx.sessions.stop(ctx.iteration.id)
		return { ok: true }
	}),
	document: iteration_procedure.query(async ({ ctx }) => ({
		content: await readFile(resolve(ctx.root, ctx.iteration.document), 'utf8')
	})),
	diff: iteration_procedure.query(({ ctx }) => readWorktreeDiff(ctx.iteration.worktree, ctx.iteration.base_commit))
})
