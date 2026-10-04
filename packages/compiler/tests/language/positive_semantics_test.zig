const h = @import("../helpers.zig");

test "positive analyze: void explicit return" {
    try h.analyzeCase("export type Input = void\n export type Output = void\n export default function (in: Input): Output { return }", null);
}

test "positive analyze: void implicit return" {
    try h.analyzeCase("export type Input = void\n export type Output = void\n export default function (in: Input): Output {  }", null);
}

test "positive analyze: else if exhaustive" {
    try h.analyzeCase("export type Input = i64\n export type Output = u64\n export default function (in: Input): Output { if (in < 0) { return 1 } else if (in == 0) { return 2 } else { return 3 } }", null);
}

test "positive analyze: nested scope shadows outer" {
    try h.analyzeCase("export type Input = bool\n export type Output = u64\n export default function (in: Input): Output { const value = 1\n if (in) { const value = 2\n return value } return value }", null);
}

test "positive analyze: object shorthand" {
    try h.analyzeCase("export type Input = u64\n export type Output = { value: u64 }\n export default function (in: Input): Output { const value = in\n return { value } }", null);
}

test "positive analyze: typed empty tuple" {
    try h.analyzeCase("export type Input = void\n export type Output = void\n export default function (in: Input): Output { const pair: [] = []\n const [] = pair\n return }", null);
}

test "positive analyze: typed nested lists" {
    try h.analyzeCase("export type Input = void\n export type Output = u64[][]\n export default function (in: Input): Output { return [[], [1, 2]] }", null);
}

test "positive analyze: optional tuple payload" {
    try h.analyzeCase("export type Input = void\n export type Output = [u64?, bool]\n export default function (in: Input): Output { return [null, true] }", null);
}

test "positive analyze: empty map" {
    try h.analyzeCase("export type Input = void\n export type Output = u64[]\n export default function (in: Input): Output { const values: u64[] = []\n return values.map(item => item + 1) }", null);
}

test "positive analyze: empty reduce" {
    try h.analyzeCase("export type Input = void\n export type Output = u64\n export default function (in: Input): Output { const values: u64[] = []\n return values.reduce((sum, item) => sum + item, 9) }", null);
}

test "positive analyze: string length" {
    try h.analyzeCase("export type Input = string\n export type Output = u64\n export default function (in: Input): Output { return in.length }", null);
}
