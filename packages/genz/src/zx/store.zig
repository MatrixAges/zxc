const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../node.zig");
const Lower = @import("lower.zig");

pub fn declaration(self: *Lower, output: *std.ArrayList(node.Declaration)) Lower.Error!void {
    if (self.program.stores.count() == 0) return;

    const fields = try self.allocator.alloc(node.Field, self.program.stores.count());

    for (self.program.stores.types, 0..) |type_id, index| fields[index] = .{
        .name = try slotName(self, index),
        .value = try self.builder.expression(.{ .optional_type = self.types[type_id] }),
    };

    try output.append(self.allocator, .{ .constant = .{ .name = self.pending_name, .value = try self.builder.expression(.{ .struct_type = fields }), .exported = true } });
}

pub fn adapter(self: *Lower, invocation: @FieldType(@FieldType(ir.ExpressionRow, "value"), "call")) Lower.Error!*const node.Expression {
    self.uses_context = true;
    const mapping = invocation.stores;
    const slots = self.program.functions.at(@backingInt(invocation.function)).stores;
    var readable: usize = 0;

    for (slots.readable) |allowed| if (allowed) {
        readable += 1;
    };

    const context = try self.builder.identifier("context");
    const fields = try self.allocator.alloc(node.Field, readable + 1);
    const values = try self.allocator.alloc(node.Field, fields.len);
    fields[0] = .{ .name = "parent", .value = try self.builtin(.TypeOf, &.{context}) };
    values[0] = .{ .name = "parent", .value = context };

    var field_index: usize = 1;

    for (mapping, slots.readable, 0..) |slot, allowed, index| {
        if (!allowed) continue;

        const name = try slotName(self, index);
        const pointer = try self.field(context, try slotName(self, slot));

        fields[field_index] = .{ .name = name, .value = try self.builtin(.TypeOf, &.{pointer}) };
        values[field_index] = .{ .name = name, .value = pointer };
        field_index += 1;
    }

    const pending = try self.builder.identifier("changes");
    const mapped = try self.allocator.alloc(node.Field, self.program.stores.count());

    for (mapped, 0..) |*field, index| field.* = .{ .name = try slotName(self, index), .value = try self.builder.expression(.null_value) };
    for (mapping, 0..) |slot, index| mapped[slot].value = try self.field(pending, try slotName(self, index));

    const patch = try self.builder.expression(.{ .object = .{ .type_expr = try self.builder.identifier(self.pending_name), .fields = mapped } });
    const parent = try self.field(try self.builder.identifier("self"), "parent");
    const commit = try self.call(try self.field(parent, "commit"), &.{patch}, true);

    const parameters = try self.allocator.dupe(node.Field, &.{
        .{ .name = "self", .value = try self.builtin(.This, &.{}) },
        .{ .name = "changes", .value = try self.builder.expression(.{ .primitive = .@"anytype" }) },
    });

    const declarations = try self.allocator.dupe(node.Declaration, &.{ .{ .function = .{
        .name = "commit",
        .parameters = parameters,
        .return_type = try self.builder.expression(.{ .error_union = .{ .payload = try self.builder.expression(.{ .primitive = .void }) } }),
        .body = try self.allocator.dupe(node.Statement, &.{.{ .result = commit }}),
        .exported = true,
    } }, try @import("store/begin_adapter.zig").declaration(self, mapping) });

    const name = try self.fresh("StoreContext");
    const result = try self.builder.expression(.{ .object = .{ .type_expr = try self.builder.identifier(name), .fields = values } });
    const label = try self.fresh("store_context");

    return self.builder.expression(.{ .block = .{ .label = label, .statements = try self.allocator.dupe(node.Statement, &.{
        .{ .constant = .{ .name = name, .value = try self.builder.expression(.{ .container_type = .{ .fields = fields, .declarations = declarations } }) } },
        .{ .break_value = .{ .label = label, .value = result } },
    }) } });
}

fn slotName(self: *Lower, index: usize) Lower.Error![]const u8 {
    return std.fmt.allocPrint(self.allocator, "store_{d}", .{index});
}
