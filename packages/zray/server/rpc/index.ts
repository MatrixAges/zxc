import { createRouter } from './trpc.ts'
import workspace from './workspace.ts'
import execution from './execution.ts'
import iterations from './iterations.ts'

const router = createRouter({ workspace, execution, iterations })

export type Router = typeof router
export default router
