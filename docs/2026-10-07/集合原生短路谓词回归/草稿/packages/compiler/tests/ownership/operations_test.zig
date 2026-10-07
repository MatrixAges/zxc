const h = @import("../helpers.zig");

test "persistent push: preserves borrowed input" {
    try h.analyzeCase("export type Input = u64[]\n export type Output = u64\n export default function (in: Input): Output { const [next, _] = in.push(2)\n return next.length + in.length }", null);
}

test "persistent push: preserves the original list" {
    try h.analyzeCase("export type Input = void\n export type Output = u64\n export default function (in: Input): Output { const values = [1]\n const [next, _] = values.push(2)\n return values.length + next.length }", null);
}

test "persistent push: constructed owner preserves borrowed input" {
    try h.analyzeCase("export type Input = u64[]\n export type Output = u64\n export default function (in: Input): Output { const values: u64[] = [in.length]\n const [next, _] = values.push(2)\n return next.length + in.length }", null);
}

test "persistent push: preserves nested borrowed fields" {
    try h.analyzeCase("export type Input = { items: u64[] }\n export type Output = u64\n export default function (in: Input): Output { const [next, _] = in.items.push(2)\n return next.length + in.items.length }", null);
}

test "persistent pop: preserves borrowed input" {
    try h.analyzeCase("export type Input = u64[]\n export type Output = u64\n export default function (in: Input): Output { const [next, _] = in.pop()\n return next.length + in.length }", null);
}

test "persistent pop: preserves the original list" {
    try h.analyzeCase("export type Input = void\n export type Output = u64\n export default function (in: Input): Output { const values = [1]\n const [next, _] = values.pop()\n return values.length + next.length }", null);
}

test "persistent pop: constructed owner preserves borrowed input" {
    try h.analyzeCase("export type Input = u64[]\n export type Output = u64\n export default function (in: Input): Output { const values: u64[] = [in.length]\n const [next, _] = values.pop()\n return next.length + in.length }", null);
}

test "persistent pop: preserves nested borrowed fields" {
    try h.analyzeCase("export type Input = { items: u64[] }\n export type Output = u64\n export default function (in: Input): Output { const [next, _] = in.items.pop()\n return next.length + in.items.length }", null);
}

test "persistent sort: preserves borrowed input" {
    try h.analyzeCase("export type Input = u64[]\n export type Output = u64\n export default function (in: Input): Output { const [next, _] = in.sort()\n return next.length + in.length }", null);
}

test "persistent sort: preserves the original list" {
    try h.analyzeCase("export type Input = void\n export type Output = u64\n export default function (in: Input): Output { const values = [1]\n const [next, _] = values.sort()\n return values.length + next.length }", null);
}

test "persistent sort: constructed owner preserves borrowed input" {
    try h.analyzeCase("export type Input = u64[]\n export type Output = u64\n export default function (in: Input): Output { const values: u64[] = [in.length]\n const [next, _] = values.sort()\n return next.length + in.length }", null);
}

test "persistent sort: preserves nested borrowed fields" {
    try h.analyzeCase("export type Input = { items: u64[] }\n export type Output = u64\n export default function (in: Input): Output { const [next, _] = in.items.sort()\n return next.length + in.items.length }", null);
}

test "persistent reverse: preserves borrowed input" {
    try h.analyzeCase("export type Input = u64[]\n export type Output = u64\n export default function (in: Input): Output { const [next, _] = in.reverse()\n return next.length + in.length }", null);
}

test "persistent reverse: preserves the original list" {
    try h.analyzeCase("export type Input = void\n export type Output = u64\n export default function (in: Input): Output { const values = [1]\n const [next, _] = values.reverse()\n return values.length + next.length }", null);
}

test "persistent reverse: constructed owner preserves borrowed input" {
    try h.analyzeCase("export type Input = u64[]\n export type Output = u64\n export default function (in: Input): Output { const values: u64[] = [in.length]\n const [next, _] = values.reverse()\n return next.length + in.length }", null);
}

test "persistent reverse: preserves nested borrowed fields" {
    try h.analyzeCase("export type Input = { items: u64[] }\n export type Output = u64\n export default function (in: Input): Output { const [next, _] = in.items.reverse()\n return next.length + in.items.length }", null);
}

test "persistent concat: preserves borrowed input" {
    try h.analyzeCase("export type Input = u64[]\n export type Output = u64\n export default function (in: Input): Output { const [next, _] = in.concat([2])\n return next.length + in.length }", null);
}

test "persistent concat: preserves the original list" {
    try h.analyzeCase("export type Input = void\n export type Output = u64\n export default function (in: Input): Output { const values = [1]\n const [next, _] = values.concat([2])\n return values.length + next.length }", null);
}

test "persistent concat: constructed owner preserves borrowed input" {
    try h.analyzeCase("export type Input = u64[]\n export type Output = u64\n export default function (in: Input): Output { const values: u64[] = [in.length]\n const [next, _] = values.concat([2])\n return next.length + in.length }", null);
}

test "persistent concat: preserves nested borrowed fields" {
    try h.analyzeCase("export type Input = { items: u64[] }\n export type Output = u64\n export default function (in: Input): Output { const [next, _] = in.items.concat([2])\n return next.length + in.items.length }", null);
}

test "persistent splice: preserves borrowed input" {
    try h.analyzeCase("export type Input = u64[]\n export type Output = u64\n export default function (in: Input): Output { const [next, _] = in.splice(0, 0, [2])\n return next.length + in.length }", null);
}

test "persistent splice: preserves the original list" {
    try h.analyzeCase("export type Input = void\n export type Output = u64\n export default function (in: Input): Output { const values = [1]\n const [next, _] = values.splice(0, 0, [2])\n return values.length + next.length }", null);
}

test "persistent splice: constructed owner preserves borrowed input" {
    try h.analyzeCase("export type Input = u64[]\n export type Output = u64\n export default function (in: Input): Output { const values: u64[] = [in.length]\n const [next, _] = values.splice(0, 0, [2])\n return next.length + in.length }", null);
}

test "persistent splice: preserves nested borrowed fields" {
    try h.analyzeCase("export type Input = { items: u64[] }\n export type Output = u64\n export default function (in: Input): Output { const [next, _] = in.items.splice(0, 0, [2])\n return next.length + in.items.length }", null);
}
