const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Binding = @import("frontend").expressions.Binding;
const Builder = @import("builder.zig");
const Writer = @import("control/writer.zig");
const Counts = @import("control/plan.zig").Counts;

pub fn bind(builder: *Builder, writer: *Writer, cursor: *Writer.Cursor, input_type: ir.TypeId, captures: []const Binding, span: zx.Span) std.mem.Allocator.Error!void {
    const input = try builder.symbol("@environment", input_type, span);
    const reference = try builder.expression(.{ .type_id = input_type, .span = span, .value = .{ .reference = input } });

    for (captures, 0..) |capture, index| {
        const symbol = try builder.symbol(capture.name, capture.type_id, span);
        const value = try builder.expression(.{ .type_id = capture.type_id, .span = span, .value = .{ .tuple_field = .{ .target = reference, .index = @intCast(index) } } });

        writer.constant(cursor, symbol, value);

        try builder.bindings.append(builder.allocator, symbol);
    }
}

pub fn argument(allocator: std.mem.Allocator, owner: []const u8, types: ir.TypeTable, environment_type: ir.TypeId, environment: []const Binding, input_type: ir.TypeId, captures: []const Binding, positions: []const u32, span: zx.Span) std.mem.Allocator.Error!ir.Program {
    var builder = Builder{ .allocator = allocator, .types = types, .native_modules = .{} };
    const count = std.math.cast(u32, environment.len) orelse return error.OutOfMemory;
    const size = Counts{ .constants = count, .results = 1 };

    if (size.statements() > std.math.maxInt(u32)) return error.OutOfMemory;

    var writer = try Writer.init(allocator, size, 1);
    var cursor = Writer.Cursor.init(.{});

    errdefer writer.columns.deinit(allocator);

    try bind(&builder, &writer, &cursor, environment_type, environment, span);

    const elements = try allocator.alloc(ir.ExprId, captures.len);

    for (captures, positions, elements) |capture, position, *value| {
        const binding = environment[position];
        const symbol = builder.bindings.items[position];

        std.debug.assert(std.mem.eql(u8, binding.name, capture.name));

        const reference = try builder.expression(.{ .type_id = binding.type_id, .span = span, .value = .{ .reference = symbol } });

        value.* = if (binding.type_id == capture.type_id) reference else try builder.expression(.{ .type_id = capture.type_id, .span = span, .value = .{ .optional_value = reference } });
    }

    const result = try builder.expression(.{ .type_id = input_type, .span = span, .value = .{ .tuple = elements } });

    writer.result(&cursor, result);

    const root = writer.block(.{ .first = .{}, .tag = 0 }, cursor, size) catch unreachable;

    return .{ .file_name = owner, .types = types, .input_type = environment_type, .output_type = input_type, .symbols = builder.symbols.view(), .expressions = builder.expressions.view(), .body = try writer.columns.finish(allocator, root) };
}
