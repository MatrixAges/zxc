const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const standardField = @import("../intrinsics.zig").standardField;

pub fn lower(self: *Lower, id: ir.FunctionId) Lower.Error!node.ExpressionId {
    const function = self.program.functions.at(@backingInt(id));
    const instance = try self.builder.identifier("self");

    const fields = try self.allocator.dupe(node.Field, &.{
        .{ .name = "allocator", .value = try standardField(self, &.{ "mem", "Allocator" }) },
        .{ .name = "input", .value = try self.typeExpr(function.input_type) },
        .{ .name = "result", .value = try self.builder.expression(.{ .error_union = .{ .payload = try self.typeExpr(function.output_type) } }) },
    });

    const parameters = try self.allocator.dupe(node.Field, &.{.{ .name = "self", .value = try self.builder.expression(.{ .pointer = try self.builtin(.This, &.{}) }) }});

    const body = try self.allocator.dupe(node.Statement, &.{.{ .assignment = .{
        .target = try self.field(instance, "result"),
        .value = try self.call(try self.functionReference(id), &.{ try self.field(instance, "allocator"), try self.field(instance, "input") }, false),
    } }});

    const declarations = try self.allocator.dupe(node.Declaration, &.{.{ .function = .{ .name = "run", .parameters = parameters, .return_type = try self.builder.expression(.{ .primitive = .void }), .body = try self.builder.statements(body) } }});

    return self.builder.expression(.{ .container_type = .{ .fields = fields, .declarations = declarations } });
}
