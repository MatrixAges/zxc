import { TRPCError } from '@trpc/server'
import { z } from 'zod'
import { createRouter, procedure } from './trpc.ts'

export default createRouter({
	list: procedure.query(({ ctx }) => ctx.tests.runs),
	start: procedure.input(z.object({ package: z.string().min(1) })).mutation(async ({ ctx, input }) => {
		const catalog = await ctx.workspace.list()
		if (!catalog.packages.some(item => item.name === input.package && item.runnable)) {
			throw new TRPCError({ code: 'BAD_REQUEST', message: '该包没有 test 构建入口' })
		}

		return ctx.tests.start(input.package)
	}),
	stop: procedure.input(z.object({ id: z.uuid() })).mutation(({ ctx, input }) => {
		ctx.tests.stop(input.id)
		return { ok: true }
	})
})
