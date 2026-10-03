const std = @import("std");
const compiler = @import("compiler");
const supported = "export type Input = { value: u8; enabled: bool; }; export type Output = { value: u8; enabled: bool; }; export default function (in: Input): Output { return { value: in.enabled ? in.value + 1 : in.value, enabled: !in.enabled }; }";
const unsupported = "export type Input = f64; export type Output = f64; export default function (in: Input): Output { return in; }";

test "hardware generation and both RTL emitters release failed allocations" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, checkAllocation, .{ supported, false });
}

test "unsupported hardware input reports diagnostic and releases allocations" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, checkAllocation, .{ unsupported, true });
}

fn checkAllocation(allocator: std.mem.Allocator, source: []const u8, rejected: bool) !void {
    var parsed = try compiler.parse(allocator, source, "hardware.zx");

    defer parsed.deinit();

    try std.testing.expect(parsed.value == .parsed);

    var analyzed = try compiler.analyze(allocator, parsed.value.parsed);

    defer analyzed.deinit();

    try std.testing.expect(analyzed.value == .ir);

    var result = try compiler.hardware.generate(allocator, analyzed.value.ir);

    defer result.deinit();

    if (rejected) {
        try std.testing.expect(result.value == .diagnostic);
        try std.testing.expectEqual(.unsupported, result.value.diagnostic.code);

        return;
    }

    try std.testing.expect(result.value == .module);

    const module = result.value.module;

    try std.testing.expect(compiler.hardware.validate(module));
    try std.testing.expectEqual(@as(usize, 2), module.inputs.len);
    try std.testing.expectEqual(@as(usize, 2), module.outputs.len);

    for ([_]bool{ false, true }) |clocked| {
        const source_code = compiler.verilog.emit(allocator, module, clocked) catch |err| {
            if (err == error.WriteFailed) return error.OutOfMemory;

            return err;
        };

        defer allocator.free(source_code);

        try std.testing.expect(source_code.len > 0);
    }
}

test "hardware rejects malformed frontend IR before symbolic lowering" {
    var parsed = try compiler.parse(std.testing.allocator, supported, "hardware.zx");

    defer parsed.deinit();

    try std.testing.expect(parsed.value == .parsed);

    var analyzed = try compiler.analyze(std.testing.allocator, parsed.value.parsed);

    defer analyzed.deinit();

    try std.testing.expect(analyzed.value == .ir);

    var program = analyzed.value.ir;
    program.version = 0;

    var result = try compiler.hardware.generate(std.testing.allocator, program);

    defer result.deinit();

    try std.testing.expect(result.value == .diagnostic);
    try std.testing.expectEqual(.contract, result.value.diagnostic.code);
}
