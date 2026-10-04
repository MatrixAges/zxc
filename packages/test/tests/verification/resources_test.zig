const std = @import("std");
const compiler = @import("compiler");
const supported = "export type Input = u8\n export type Output = u8\n export default function (in: Input): Output requires(in < 255) ensures(out > in) { return in + 1 }";
const unsupported = "export type Input = f64\n export type Output = f64\n export default function (in: Input): Output { return in }";

test "verification query generation releases every failed allocation" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, checkAllocation, .{ supported, false });
}

test "unsupported verification releases earlier allocations" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, checkAllocation, .{ unsupported, true });
}

fn checkAllocation(allocator: std.mem.Allocator, source: []const u8, rejected: bool) !void {
    var parsed = try compiler.parse(allocator, source, "main.zx");

    defer parsed.deinit();

    try std.testing.expect(parsed.value == .parsed);

    var analyzed = try compiler.analyze(allocator, parsed.value.parsed);

    defer analyzed.deinit();

    try std.testing.expect(analyzed.value == .ir);

    var generated = try compiler.verification.generate(allocator, analyzed.value.ir);

    defer generated.deinit();

    if (rejected) {
        try std.testing.expect(generated.value == .diagnostic);
        try std.testing.expectEqual(.unsupported, generated.value.diagnostic.code);
    } else {
        try std.testing.expect(generated.value == .query);
        try std.testing.expect(std.mem.indexOf(u8, generated.value.query.feasibility, "(check-sat)") != null);
        try std.testing.expect(std.mem.indexOf(u8, generated.value.query.correctness, "(check-sat)") != null);
    }
}

test "verification rejects invalid IR before symbolic evaluation" {
    var parsed = try compiler.parse(std.testing.allocator, supported, "main.zx");

    defer parsed.deinit();

    try std.testing.expect(parsed.value == .parsed);

    var analyzed = try compiler.analyze(std.testing.allocator, parsed.value.parsed);

    defer analyzed.deinit();

    try std.testing.expect(analyzed.value == .ir);

    var program = analyzed.value.ir;
    program.version = 0;

    var generated = try compiler.verification.generate(std.testing.allocator, program);

    defer generated.deinit();

    try std.testing.expect(generated.value == .diagnostic);
    try std.testing.expectEqual(.contract, generated.value.diagnostic.code);
}
