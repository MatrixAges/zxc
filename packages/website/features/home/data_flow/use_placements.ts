import type { RefObject } from 'react'
import type { StagePlacement } from './stages'
import { useEffect, useState } from 'react'
import stages from './stages'

export default function usePlacements(rail_ref: RefObject<HTMLDivElement | null>) {
	const [placements, setPlacements] = useState<Array<StagePlacement>>([])

	useEffect(() => {
		const rail = rail_ref.current!
		const copy = rail.parentElement!.querySelector('.home-copy')!

		function measure() {
			const top = rail.getBoundingClientRect().top
			const ratio = Math.min(1, rail.clientWidth / 440)
			let bottom = 0
			const next = stages.map(stage => {
				const element = copy.querySelector(stage.anchor)!
				const rect = element.getBoundingClientRect()
				const height = stage.height * ratio
				const center = Math.max(rect.top - top + rect.height * 0.5, bottom + height / 2 + 64)

				bottom = center + height / 2
				return { center, height }
			})

			setPlacements(next)
		}

		const observer = new ResizeObserver(measure)

		observer.observe(copy)
		observer.observe(rail)
		measure()

		return () => observer.disconnect()
	}, [rail_ref])

	return placements
}
