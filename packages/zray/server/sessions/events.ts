import type { Iteration } from '../../shared/types.ts'

function isRecord(value: unknown): value is Record<string, unknown> {
	return typeof value === 'object' && value !== null
}

export default function consumeEvent(iteration: Iteration, line: string) {
	let event: unknown
	try {
		event = JSON.parse(line)
	} catch {
		return
	}
	if (!isRecord(event) || typeof event.type !== 'string') return

	if (event.type === 'thread.started' && typeof event.thread_id === 'string') iteration.session_id = event.thread_id
	if (event.type === 'turn.started' && iteration.status === 'starting') iteration.status = 'running'
	if ((event.type === 'turn.failed' || event.type === 'error') && iteration.status !== 'cancelled')
		iteration.status = 'failed'

	const item = isRecord(event.item) ? event.item : undefined
	let text = event.type

	if (item) {
		text = [item.type, item.command, item.text, item.aggregated_output]
			.filter(value => typeof value === 'string')
			.join('\n')
		if (Array.isArray(item.changes))
			text +=
				'\n' +
				item.changes
					.filter(isRecord)
					.map(change => `${change.kind}: ${change.path}`)
					.join('\n')
		if (item.type === 'agent_message' && typeof item.text === 'string') iteration.summary = item.text
	}

	if (isRecord(event.error) && typeof event.error.message === 'string') text += `\n${event.error.message}`
	if (typeof event.message === 'string') text += `\n${event.message}`

	iteration.events.push({ type: event.type, text: text.slice(-12_000), at: new Date().toISOString() })
	iteration.events = iteration.events.slice(-100)
}
