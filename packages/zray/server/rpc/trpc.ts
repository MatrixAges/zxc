import type WorkspaceFiles from '../workspace/files.ts'
import type TestRunner from '../execution/runner.ts'
import type SessionRunner from '../sessions/runner.ts'
import { initTRPC } from '@trpc/server'

export type Context = {
	root: string
	workspace: WorkspaceFiles
	tests: TestRunner
	sessions: SessionRunner
}

const trpc = initTRPC.context<Context>().create()

export const createRouter = trpc.router
export const procedure = trpc.procedure
