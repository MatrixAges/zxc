import { z } from 'zod'
import { createRouter, procedure } from './trpc.ts'

export default createRouter({
	versions: procedure.query(({ ctx }) => ctx.workspace.versions()),
	list: procedure.query(({ ctx }) => ctx.workspace.list()),
	source: procedure
		.input(z.object({ path: z.string().min(1) }))
		.query(({ ctx, input }) => ctx.workspace.source(input.path))
})
