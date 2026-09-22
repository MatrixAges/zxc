const h = @import("../helpers.zig");

test "positive analyze: void explicit return" {
    try h.analyzeCase("export type Input = void; export type Output = void; export default function (in: Input): Output { return; }", null);
}

test "positive analyze: void implicit return" {
    try h.analyzeCase("export type Input = void; export type Output = void; export default function (in: Input): Output {  }", null);
}

test "positive analyze: else if exhaustive" {
    try h.analyzeCase("export type Input = i64; export type Output = u64; export default function (in: Input): Output { if (in < 0) { return 1; } else if (in == 0) { return 2; } else { return 3; } }", null);
}

test "positive analyze: nested scope shadows outer" {
    try h.analyzeCase("export type Input = bool; export type Output = u64; export default function (in: Input): Output { const value = 1; if (in) { const value = 2; return value; } return value; }", null);
}

test "positive analyze: object shorthand" {
    try h.analyzeCase("export type Input = u64; export type Output = { value: u64; }; export default function (in: Input): Output { const value = in; return { value }; }", null);
}

test "positive analyze: typed empty tuple" {
    try h.analyzeCase("export type Input = void; export type Output = void; export default function (in: Input): Output { const pair: [] = []; const [] = pair; return; }", null);
}

test "positive analyze: typed nested lists" {
    try h.analyzeCase("export type Input = void; export type Output = u64[][]; export default function (in: Input): Output { return [[], [1, 2]]; }", null);
}

test "positive analyze: optional tuple payload" {
    try h.analyzeCase("export type Input = void; export type Output = [u64?, bool]; export default function (in: Input): Output { return [null, true]; }", null);
}

test "positive analyze: empty map" {
    try h.analyzeCase("export type Input = void; export type Output = u64[]; export default function (in: Input): Output { const values: u64[] = []; return values.map(item => item + 1); }", null);
}

test "positive analyze: empty reduce" {
    try h.analyzeCase("export type Input = void; export type Output = u64; export default function (in: Input): Output { const values: u64[] = []; return values.reduce((sum, item) => sum + item, 9); }", null);
}

test "positive analyze: string length" {
    try h.analyzeCase("export type Input = string; export type Output = u64; export default function (in: Input): Output { return in.length; }", null);
}
