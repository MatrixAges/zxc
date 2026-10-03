export type SourceFile = {
	path: string
	package: string
	kind: 'module' | 'test'
	language: string
}

export type Workspace = {
	name: string
	files: Array<SourceFile>
	packages: Array<{ name: string; runnable: boolean }>
}

export type Run = {
	id: string
	package: string
	status: 'running' | 'passed' | 'failed' | 'cancelled'
	output: string
	started_at: string
	finished_at?: string
}

export type SessionEvent = { type: string; text: string; at: string }

export type Iteration = {
	id: string
	module: string
	prompt: string
	session_id?: string
	previous_id?: string
	worktree: string
	base_commit: string
	status: 'starting' | 'running' | 'completed' | 'failed' | 'cancelled' | 'interrupted'
	started_at: string
	finished_at?: string
	document: string
	events: Array<SessionEvent>
	summary: string
	changes: string
}

export type WorktreeDiff = {
	patch: string
	status: string
	files: Array<{ path: string; content: string }>
	omitted: Array<string>
}
