import type { Router } from '../../server/rpc/index'
import { createTRPCClient, httpBatchLink } from '@trpc/client'

const rpc = createTRPCClient<Router>({
	links: [httpBatchLink({ url: '/trpc', headers: { 'X-Zray-Request': '1' } })]
})

export default rpc
