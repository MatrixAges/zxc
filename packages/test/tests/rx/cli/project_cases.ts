export function helper(amount: number): string {
    return (
        'export type Input = u64\n\nexport type Output = u64\n\nexport default function (in: Input): Output {\n  return in + ' +
        amount +
        '\n}\n'
    )
}

export const files: Record<string, string> = {
    'main.rx': "<Module><Call module='./flows/forward.rx' in={$in}/><Return value={$ctx.forward}/></Module>\n",
    'flows/forward.rx': "<Module><Call fn='../functions/plus.zx' in={$in}/><Return value={$ctx.plus}/></Module>\n",
    'functions/plus.zx':
        'import helper from "./helper"\n\nexport type Input = u64\n\nexport type Output = u64\n\nexport default function (in: Input): Output {\n  return helper(in) * 2\n}\n',
    'functions/helper.zx': helper(3)
}

export const failures: Array<{ name: string; changes: Record<string, string>; diagnostic: RegExp }> = [
    {
        name: 'missing RX dependency',
        changes: { 'main.rx': "<Module><Call module='./absent.rx' in={1}/></Module>" },
        diagnostic: /absent\.rx: FileNotFound/
    },
    {
        name: 'missing ZX import dependency',
        changes: {
            'functions/plus.zx':
                'import value from "./absent"\n\nexport type Input = u64\n\nexport type Output = u64\n\nexport default function (in: Input): Output {\n  return value(in)\n}\n'
        },
        diagnostic:
            /(?:^|[\\/])functions[\\/]plus\.zx:1:1: module: source module dependency is missing from the registered input set\r?$/m
    },
    {
        name: 'unused Import cycle',
        changes: {
            'main.rx': '<Module><Import from="./cycle.rx"/></Module>',
            'cycle.rx': '<Module><Import from="./main.rx"/></Module>'
        },
        diagnostic: /circular module dependency/
    },
    {
        name: 'child module name diagnostic',
        changes: { 'flows/forward.rx': '<Module>\n  <Return value={missing}/>\n</Module>' },
        diagnostic: /flows\/forward\.rx:2:\d+: name:/
    },
    {
        name: 'service path escapes project root',
        changes: { 'main.rx': "<Module><Call module='../outside.rx' in={1}/></Module>" },
        diagnostic: /escapes|outside|invalid.*path/
    }
]
