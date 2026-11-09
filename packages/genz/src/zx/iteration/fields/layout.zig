const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../../node.zig");
const Lower = @import("../../lower.zig");

pub const Input = struct {
    types: ir.TypeTable,
    type_id: ir.TypeId,
    borrowed: []const bool,
    field_types: []const u32,
    abi_type: node.ExpressionId,
};

pub fn build(self: *Lower, body: *std.ArrayList(node.Statement), args: Input) Lower.Error!node.ExpressionId {
    const entry = @import("generated_loop_fields_layout");
    const Parameters = std.meta.Child(entry.Input);
    const types = ir.TypeTable.borrow(std.meta.Child(@FieldType(Parameters, "types")), args.types);

    const input: Parameters = .{
        .types = &types,
        .type_id = @backingInt(args.type_id),
        .borrowed = args.borrowed,
        .field_types = args.field_types,
        .abi_type = @backingInt(args.abi_type),
        .expression_base = @intCast(self.builder.nodes.expressions.tags.items.len),
        .field_base = @intCast(self.builder.nodes.field_columns.count()),
        .serial = self.serial,
    };

    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var memory = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const result = entry.executeIn(memory.allocator(), &input) catch |err| return failure(err);

    if (!result.valid) return error.OutOfMemory;

    const name = try self.allocator.dupe(u8, result.statements.constant_name[0]);
    const names = [_][]const u8{name};
    var expressions = result.expressions.*;
    var statements = result.statements.*;
    var fields = result.fields.*;

    expressions.identifier = &names;
    statements.constant_name = &names;

    if (result.origin_owned) {
        const field_names = try memory.allocator().dupe([]const u8, fields.name);
        const index = field_names.len - 1;
        field_names[index] = try self.allocator.dupe(u8, field_names[index]);
        fields.name = field_names;
    }

    @import("../../../node/import_rows.zig").appendBorrowed(self.allocator, &self.builder.nodes.expressions, &expressions) catch |err| return failure(err);
    _ = @import("../../../node/import_fields.zig").appendBorrowingText(self.allocator, &self.builder.nodes.field_columns, &fields) catch |err| return failure(err);
    @import("../../../node/import_statements.zig").appendBorrowingText(self.allocator, body, &statements) catch |err| return failure(err);
    self.serial = @intCast(result.serial);

    return @fromBackingInt(result.root);
}

fn failure(err: anyerror) Lower.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => unreachable,
    };
}
