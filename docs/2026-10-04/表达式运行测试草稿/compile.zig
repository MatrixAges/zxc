const std = @import("std");
const compiler = @import("compiler");
const Binding = compiler.expressions.Binding;

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);
    const order = std.mem.eql(u8, args[1], "order");
    const branch = std.mem.eql(u8, args[1], "branch");
    const source = if (order) "root.a * 10 + root.ab" else if (branch) "$choose ? $value : $value / $divisor" else "$choose ? $text.left : $text.right";
    const bindings: []const Binding = if (order) &.{
        .{ .name = "root.ab", .type_id = @enumFromInt(5) },
        .{ .name = "root.a", .type_id = @enumFromInt(5) },
    } else if (branch) &.{
        .{ .name = "$divisor", .type_id = @enumFromInt(5) },
        .{ .name = "$choose", .type_id = @enumFromInt(1) },
        .{ .name = "$value", .type_id = @enumFromInt(5) },
    } else &.{
        .{ .name = "$text.right", .type_id = @enumFromInt(10) },
        .{ .name = "$choose", .type_id = @enumFromInt(1) },
        .{ .name = "$text.left", .type_id = @enumFromInt(10) },
    };
    var result = block: {
        var parsed = try compiler.parseExpression(allocator, source, "expression.rx");

        defer parsed.deinit();

        if (parsed.value != .parsed) return error.InvalidExpression;

        break :block try compiler.expressions.compile(allocator, parsed.value.parsed, .{ .bindings = bindings });
    };

    defer result.deinit();

    if (result.value != .ir) return error.InvalidProgram;
    if (try compiler.validateIr(allocator, result.value.ir) != null) return error.InvalidIr;

    const bundle = try compiler.zig.emitBundle(allocator, result.value.ir);

    defer bundle.deinit(allocator);

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[2], .data = bundle.source });
    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[3], .data = bundle.types });
}
