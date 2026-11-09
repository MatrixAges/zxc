const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const conversion = @import("../state_value/conversion_emission.zig");

pub fn lower(self: *Lower, body: *std.ArrayList(node.Statement), type_id: ir.TypeId, value: node.ExpressionId) Lower.Error!node.ExpressionId {
    const entry = @import("generated_collection_result");
    const Input = std.meta.Child(entry.Input);
    const Bases = std.meta.Child(@FieldType(Input, "bases"));
    const Member = std.meta.Child(@FieldType(Input, "members"));
    const Prepared = std.meta.Child(std.meta.Child(Member));
    const serial = self.serial;
    const declarations = self.task_declarations.count();
    const statements = self.builder.nodes.statements.tags.items.len;
    const roots = body.items.len;
    const storage = self.reference_storage.items.len;
    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var memory = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const temporary = memory.allocator();
    var boundary: conversion.Capture = undefined;

    const capture = if (self.capture) |item| captured: {
        boundary = .{ .name = item.name, .label = item.label, .failure = @backingInt(item.failure) };

        break :captured &boundary;
    } else null;

    const types = self.program.typeOf(type_id).tuple;
    const members = try temporary.alloc(Member, types.len);

    for (members, 0..) |*member, index| {
        const id = types.at(index);

        if (!self.state_plan.represented(self.program, id)) {
            member.* = null;

            continue;
        }

        const prepared = try temporary.create(Prepared);

        prepared.* = zx.columns.view(Prepared, try conversion.prepareFor(self, temporary, id, @fromBackingInt(0), .pointer, capture));
        member.* = prepared;
    }

    std.debug.assert(serial == self.serial and declarations == self.task_declarations.count());
    std.debug.assert(statements == self.builder.nodes.statements.tags.items.len and roots == body.items.len);
    std.debug.assert(storage == self.reference_storage.items.len);

    const bases: Bases = .{
        .capture = if (self.capture) |item| &.{ .name = item.name, .label = item.label, .failure = @backingInt(item.failure) } else null,
        .expression_base = @intCast(self.builder.nodes.expressions.tags.items.len),
        .statement_base = @intCast(self.builder.nodes.statements.tags.items.len),
        .field_base = @intCast(self.builder.nodes.field_columns.count()),
        .serial = self.serial,
    };

    const input: Input = .{
        .value = @backingInt(value),
        .members = members,
        .bases = &bases,
    };

    const output = entry.executeIn(temporary, &input) catch |err| return @import("emission.zig").failure(err);

    return conversion.apply(self, body, body, output);
}
