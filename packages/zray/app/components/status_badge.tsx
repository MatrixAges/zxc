const labels: Record<string, string> = {
	starting: '准备中',
	running: '进行中',
	completed: '待审阅',
	failed: '失败',
	cancelled: '已停止',
	interrupted: '已中断',
	passed: '通过'
}

export default function StatusBadge({ status }: { status: string }) {
	return (
		<span className={`status-badge status-${status}`}>
			<span />
			{labels[status] ?? status}
		</span>
	)
}
