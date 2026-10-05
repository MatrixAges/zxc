import checkOwnership from './ownership.ts'
import checkProtocol from './protocol.ts'
import checkState from './state.ts'
import checkLifecycle from './lifecycle.ts'
import checkErrors from './errors.ts'

const root = process.argv[2]
const protocol = await checkProtocol(root)
const ownership = await checkOwnership(root)
const state = await checkState(root)
const lifecycle = await checkLifecycle(root)
const errors = await checkErrors(root)

console.log(
	`NAPI async: ${protocol} protocol, ${ownership} ownership, ${state} State, ${lifecycle} Worker and ${errors} execution failure cases passed`
)
