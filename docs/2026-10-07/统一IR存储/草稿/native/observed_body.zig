const std = @import("std");
const ir = @import("zx").ir;
const generated = @import("body_generated");
const control_model = @import("model.zig");
const expressions = @import("expressions/model.zig");
const Storage = @import("expressions/storage.zig");
const borrow = @import("borrow.zig");
const Body = @typeInfo(generated.Input).pointer.child;
const Symbols = @typeInfo(@FieldType(Body, "symbols")).pointer.child;
const ExpressionTable = @typeInfo(@FieldType(Body, "expressions")).pointer.child;
const Control = @typeInfo(@FieldType(Body, "control")).pointer.child;

pub fn compare(arena: *std.heap.ArenaAllocator, program: ir.Program, control: control_model.Table, root: u32) !void {
    @setEvalBranchQuota(100_000);

    const allocator = arena.allocator();
    var storage: Storage = .{};

    defer storage.deinit(allocator);

    for (program.expressions, 0..) |value, index| {
        if (try storage.append(allocator, value) != index) return error.ExpressionIdChanged;
    }

    const table = try storage.finish(allocator);
    const expression_input = borrow.columns(ExpressionTable, table);
    const control_input = borrow.columns(Control, control);
    const symbol_input = try symbols(allocator, program.symbols);
    const input: Body = .{ .symbols = &symbol_input, .expressions = &expression_input, .control = &control_input, .root = root };

    inline for (@typeInfo(expressions.Table).@"struct".field_names) |name| {
        if (@intFromPtr(@field(expression_input, name).ptr) != @intFromPtr(@field(table, name).ptr)) return error.ExpressionColumnCopied;
        if (@field(expression_input, name).len != @field(table, name).len) return error.ExpressionColumnLengthChanged;
    }

    if (try generated.execute(arena, &input) != &input) return error.BodyIdentityChanged;

    const checker = @import("body_checker");
    const CheckInput = @typeInfo(checker.Input).pointer.child;
    const CheckBody = @typeInfo(@FieldType(CheckInput, "body")).pointer.child;
    const check_expressions = borrow.columns(@typeInfo(@FieldType(CheckBody, "expressions")).pointer.child, table);
    const check_control = borrow.columns(@typeInfo(@FieldType(CheckBody, "control")).pointer.child, control);
    const check_symbols = borrow.columns(@typeInfo(@FieldType(CheckBody, "symbols")).pointer.child, symbol_input);
    const check_body: CheckBody = .{ .symbols = &check_symbols, .expressions = &check_expressions, .control = &check_control, .root = root };

    if (!try checker.execute(arena, &.{ .body = &check_body, .max_offset = std.math.maxInt(usize) })) return error.BodyStructureRejected;

    for (program.expressions, 0..) |source, index| {
        const restored = try @import("expressions/observed_decode.zig").expression(allocator, table, index);
        const before = try std.json.Stringify.valueAlloc(allocator, source, .{});
        const after = try std.json.Stringify.valueAlloc(allocator, restored, .{});

        if (!std.mem.eql(u8, before, after)) return error.ExpressionContentChanged;
    }

    var kinds = std.mem.zeroes([@typeInfo(expressions.ExpressionKind).@"enum".field_names.len]usize);

    for (table.kinds) |kind| kinds[@backingInt(kind)] += 1;

    const encoded = try std.json.Stringify.valueAlloc(allocator, .{ .file = program.file_name, .expressions = table.kinds.len, .symbols = program.symbols.len, .kinds = kinds, .expression_columns_borrowed = true, .expression_roundtrip_equal = true, .body_identity_retained = true, .body_structure_valid = true, .body_local_references_valid = true, .allocation_free_reader = true }, .{});

    std.debug.print("canonical-body {s}\n", .{encoded});
}

fn symbols(allocator: std.mem.Allocator, source: []const ir.Symbol) !Symbols {
    var result: Symbols = undefined;

    inline for (@typeInfo(Symbols).@"struct".field_names) |name| {
        @field(result, name) = try allocator.alloc(@typeInfo(@FieldType(Symbols, name)).pointer.child, source.len);
    }

    for (source, 0..) |value, index| {
        @constCast(result.names)[index] = value.name;
        @constCast(result.types)[index] = @backingInt(value.type_id);
        @constCast(result.span_start)[index] = value.span.start;
        @constCast(result.span_end)[index] = value.span.end;
        @constCast(result.ownership)[index] = @import("expressions/enumeration.zig").convert(@typeInfo(@TypeOf(result.ownership)).pointer.child, value.ownership);
    }

    return result;
}
