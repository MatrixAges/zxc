const std = @import("std");
const zx = @import("zx");
const Context = @import("context.zig");
const Input = @import("input.zig");
const model = @import("model.zig");
const generated = @import("generated_analyzer");
const borrow = @import("../../../ir/canonical/borrow.zig");

pub fn analyze(analyzer: *Context, source: []const u8, syntax: anytype, file_name: []const u8) zx.Error!zx.ir.Program {
    var arena = std.heap.ArenaAllocator.init(analyzer.allocator);

    defer arena.deinit();

    const prepared = try Input.init(arena.allocator(), analyzer);
    const context = prepared.context(analyzer);

    const input = model.Input{
        .bytes = source,
        .source_text = source,
        .file_name = file_name,
        .syntax = borrow.pointer(@FieldType(model.Input, "syntax"), syntax),
        .context = &context,
    };

    const output = generated.execute(&arena, &input) catch |err| switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => return error.OutOfMemory,
        else => return analyzer.reporter.fail(.contract, .{ .start = 0, .end = 0 }, try std.fmt.allocPrint(analyzer.allocator, "internal compiler error: generated analyzer failed with {s}", .{@errorName(err)})),
    };

    if (output.diagnostic.message.len != 0) return analyzer.reporter.fail(
        std.meta.stringToEnum(@FieldType(zx.Diagnostic, "code"), output.diagnostic.code) orelse unreachable,
        .{ .start = @intCast(output.diagnostic.start), .end = @intCast(output.diagnostic.end) },
        try analyzer.allocator.dupe(u8, output.diagnostic.message),
    );

    return @import("publish.zig").apply(analyzer, output, file_name);
}
