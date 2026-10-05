import type createApplication from './application.ts'

export type Gateway = Awaited<ReturnType<ReturnType<typeof createApplication>['start']>>
export type Check = (name: string, body: () => Promise<void>) => Promise<void>
