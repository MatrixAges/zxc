const h = @import("../helpers.zig");

test "ownership push: borrowed input" {
    try h.analyzeCase("export type Input = u64[]; export type Output = u64; export default function (in: Input): Output { const [next, _] = in.push(2); return next.length; }", .ownership);
}

test "ownership push: old owner" {
    try h.analyzeCase("export type Input = void; export type Output = u64; export default function (in: Input): Output { const values = [1]; const [next, _] = values.push(2); return values.length; }", .ownership);
}

test "ownership push: constructed owner preserves borrowed input" {
    try h.analyzeCase("export type Input = u64[]; export type Output = u64; export default function (in: Input): Output { const values: u64[] = [in.length]; const [next, _] = values.push(2); return next.length + in.length; }", null);
}

test "ownership push: nested borrowed field" {
    try h.analyzeCase("export type Input = { items: u64[]; }; export type Output = u64; export default function (in: Input): Output { const [next, _] = in.items.push(2); return next.length; }", .ownership);
}

test "ownership pop: borrowed input" {
    try h.analyzeCase("export type Input = u64[]; export type Output = u64; export default function (in: Input): Output { const [next, _] = in.pop(); return next.length; }", .ownership);
}

test "ownership pop: old owner" {
    try h.analyzeCase("export type Input = void; export type Output = u64; export default function (in: Input): Output { const values = [1]; const [next, _] = values.pop(); return values.length; }", .ownership);
}

test "ownership pop: constructed owner preserves borrowed input" {
    try h.analyzeCase("export type Input = u64[]; export type Output = u64; export default function (in: Input): Output { const values: u64[] = [in.length]; const [next, _] = values.pop(); return next.length + in.length; }", null);
}

test "ownership pop: nested borrowed field" {
    try h.analyzeCase("export type Input = { items: u64[]; }; export type Output = u64; export default function (in: Input): Output { const [next, _] = in.items.pop(); return next.length; }", .ownership);
}

test "ownership sort: borrowed input" {
    try h.analyzeCase("export type Input = u64[]; export type Output = u64; export default function (in: Input): Output { const [next, _] = in.sort(); return next.length; }", .ownership);
}

test "ownership sort: old owner" {
    try h.analyzeCase("export type Input = void; export type Output = u64; export default function (in: Input): Output { const values = [1]; const [next, _] = values.sort(); return values.length; }", .ownership);
}

test "ownership sort: constructed owner preserves borrowed input" {
    try h.analyzeCase("export type Input = u64[]; export type Output = u64; export default function (in: Input): Output { const values: u64[] = [in.length]; const [next, _] = values.sort(); return next.length + in.length; }", null);
}

test "ownership sort: nested borrowed field" {
    try h.analyzeCase("export type Input = { items: u64[]; }; export type Output = u64; export default function (in: Input): Output { const [next, _] = in.items.sort(); return next.length; }", .ownership);
}

test "ownership reverse: borrowed input" {
    try h.analyzeCase("export type Input = u64[]; export type Output = u64; export default function (in: Input): Output { const [next, _] = in.reverse(); return next.length; }", .ownership);
}

test "ownership reverse: old owner" {
    try h.analyzeCase("export type Input = void; export type Output = u64; export default function (in: Input): Output { const values = [1]; const [next, _] = values.reverse(); return values.length; }", .ownership);
}

test "ownership reverse: constructed owner preserves borrowed input" {
    try h.analyzeCase("export type Input = u64[]; export type Output = u64; export default function (in: Input): Output { const values: u64[] = [in.length]; const [next, _] = values.reverse(); return next.length + in.length; }", null);
}

test "ownership reverse: nested borrowed field" {
    try h.analyzeCase("export type Input = { items: u64[]; }; export type Output = u64; export default function (in: Input): Output { const [next, _] = in.items.reverse(); return next.length; }", .ownership);
}

test "ownership concat: borrowed input" {
    try h.analyzeCase("export type Input = u64[]; export type Output = u64; export default function (in: Input): Output { const [next, _] = in.concat([2]); return next.length; }", .ownership);
}

test "ownership concat: old owner" {
    try h.analyzeCase("export type Input = void; export type Output = u64; export default function (in: Input): Output { const values = [1]; const [next, _] = values.concat([2]); return values.length; }", .ownership);
}

test "ownership concat: constructed owner preserves borrowed input" {
    try h.analyzeCase("export type Input = u64[]; export type Output = u64; export default function (in: Input): Output { const values: u64[] = [in.length]; const [next, _] = values.concat([2]); return next.length + in.length; }", null);
}

test "ownership concat: nested borrowed field" {
    try h.analyzeCase("export type Input = { items: u64[]; }; export type Output = u64; export default function (in: Input): Output { const [next, _] = in.items.concat([2]); return next.length; }", .ownership);
}

test "ownership splice: borrowed input" {
    try h.analyzeCase("export type Input = u64[]; export type Output = u64; export default function (in: Input): Output { const [next, _] = in.splice(0, 0, [2]); return next.length; }", .ownership);
}

test "ownership splice: old owner" {
    try h.analyzeCase("export type Input = void; export type Output = u64; export default function (in: Input): Output { const values = [1]; const [next, _] = values.splice(0, 0, [2]); return values.length; }", .ownership);
}

test "ownership splice: constructed owner preserves borrowed input" {
    try h.analyzeCase("export type Input = u64[]; export type Output = u64; export default function (in: Input): Output { const values: u64[] = [in.length]; const [next, _] = values.splice(0, 0, [2]); return next.length + in.length; }", null);
}

test "ownership splice: nested borrowed field" {
    try h.analyzeCase("export type Input = { items: u64[]; }; export type Output = u64; export default function (in: Input): Output { const [next, _] = in.items.splice(0, 0, [2]); return next.length; }", .ownership);
}
