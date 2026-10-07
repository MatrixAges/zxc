const std = @import("std");
const ir = @import("zx").ir;
const generated = @import("body_generated");
const control_model = @import("model.zig");
const expressions = @import("expressions/model.zig");
const borrow = @import("borrow.zig");
const Body = @typeInfo(generated.Input).pointer.child;
const Symbols = @typeInfo(@FieldType(Body, "symbols")).pointer.child;
const ExpressionTable = @typeInfo(@FieldType(Body, "expressions")).pointer.child;
const Control = @typeInfo(@FieldType(Body, "control")).pointer.child;

pub fn compare(arena: *std.heap.ArenaAllocator, program: ir.Program, control: control_model.Table, root: u32) !void {
    @setEvalBranchQuota(100_000);

    const allocator = arena.allocator();
    const table = program.expressions;
    const candidate = borrow.columns(expressions.Table, table);
    const expression_input = borrow.columns(ExpressionTable, table);
    const control_input = borrow.columns(Control, control);
    const symbol_input = borrow.columns(Symbols, program.symbols);
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

    for (0..program.expressions.count()) |index| {
        const source = program.expressions.at(index);
        const restored = @import("expressions/read.zig").expression(&candidate, index);
        const before = try std.json.Stringify.valueAlloc(allocator, source, .{});
        const after = try std.json.Stringify.valueAlloc(allocator, restored, .{});

        if (!std.mem.eql(u8, before, after)) return error.ExpressionContentChanged;
    }

    var kinds = std.mem.zeroes([@typeInfo(expressions.ExpressionKind).@"enum".field_names.len]usize);

    for (table.kinds) |kind| kinds[@backingInt(kind)] += 1;

    const encoded = try std.json.Stringify.valueAlloc(allocator, .{ .file = program.file_name, .expressions = table.kinds.len, .symbols = program.symbols.count(), .kinds = kinds, .expression_columns_borrowed = true, .expression_readers_equal = true, .body_identity_retained = true, .body_structure_valid = true, .body_local_references_valid = true, .allocation_free_reader = true }, .{});

    std.debug.print("canonical-body {s}\n", .{encoded});
}
