const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const standardField = @import("../intrinsics.zig").standardField;

pub fn required(allocator: std.mem.Allocator, program: ir.Program) Lower.Error!bool {
    const functions = try allocator.alloc(bool, program.functions.len);

    defer allocator.free(functions);

    for (program.functions, 0..) |function, index| functions[index] = uses(function.expressions, functions[0..index]);

    return uses(program.expressions, functions);
}

fn uses(expressions: []const ir.Expression, functions: []const bool) bool {
    for (expressions) |expression| switch (expression.value) {
        .task, .await_task, .parallel => return true,
        .call => |call| if (functions[@backingInt(call.function)]) return true,
        else => {},
    };

    return false;
}

pub fn initialize(self: *Lower, body: *std.ArrayList(node.Statement)) Lower.Error!void {
    const fields = try self.allocator.dupe(node.Field, &.{
        .{ .name = "child", .value = try self.call(try self.field(try self.builder.identifier("arena"), "allocator"), &.{}, false) },
        .{ .name = "io", .value = try self.builder.identifier("io") },
        .{ .name = "mutex", .value = try self.builder.expression(.{ .enum_literal = "init" }) },
    });

    try self.task_declarations.append(self.allocator, .{ .constant = .{ .name = "zx_task_allocator", .value = try allocatorType(self) } });
    try body.append(self.allocator, .{ .variable = .{ .name = "task_allocator", .value = try self.builder.expression(.{ .object = .{ .type_expr = try self.builder.identifier("zx_task_allocator"), .fields = fields } }) } });
    try body.append(self.allocator, .{ .constant = .{ .name = "allocator", .value = try self.call(try self.field(try self.builder.identifier("task_allocator"), "allocator"), &.{}, false) } });
}

fn allocatorType(self: *Lower) Lower.Error!*const node.Expression {
    const fields = try self.allocator.dupe(node.Field, &.{
        .{ .name = "child", .value = try standardField(self, &.{ "mem", "Allocator" }) },
        .{ .name = "io", .value = try standardField(self, &.{"Io"}) },
        .{ .name = "mutex", .value = try standardField(self, &.{ "Io", "Mutex" }) },
    });

    var declarations: std.ArrayList(node.Declaration) = .empty;
    var vtable: std.ArrayList(node.Field) = .empty;

    for ([_][]const u8{ "alloc", "resize", "remap", "free" }) |name| {
        try declarations.append(self.allocator, try operation(self, name));
        try vtable.append(self.allocator, .{ .name = name, .value = try self.builder.identifier(name) });
    }

    const result = try self.builder.expression(.{ .object = .{ .fields = try self.allocator.dupe(node.Field, &.{
        .{ .name = "ptr", .value = try self.builder.identifier("self") },
        .{ .name = "vtable", .value = try self.builder.expression(.{ .address_of = try self.builder.expression(.{ .object = .{ .fields = try vtable.toOwnedSlice(self.allocator) } }) }) },
    }) } });

    try declarations.append(self.allocator, .{ .function = .{
        .name = "allocator",
        .parameters = try self.allocator.dupe(node.Field, &.{.{ .name = "self", .value = try self.builder.expression(.{ .pointer = try self.builtin(.This, &.{}) }) }}),
        .return_type = try standardField(self, &.{ "mem", "Allocator" }),
        .body = try self.allocator.dupe(node.Statement, &.{.{ .result = result }}),
    } });

    return self.builder.expression(.{ .container_type = .{ .fields = fields, .declarations = try declarations.toOwnedSlice(self.allocator) } });
}

fn operation(self: *Lower, name: []const u8) Lower.Error!node.Declaration {
    const allocate = std.mem.eql(u8, name, "alloc");
    const release = std.mem.eql(u8, name, "free");
    const resize = std.mem.eql(u8, name, "resize");
    const usize_type = try self.builder.expression(.{ .primitive = .usize });
    const u8_type = try self.builder.expression(.{ .primitive = .u8 });
    var parameters: std.ArrayList(node.Field) = .empty;
    var arguments: std.ArrayList(*const node.Expression) = .empty;

    try parameters.append(self.allocator, .{ .name = "context", .value = try self.builder.expression(.{ .pointer = try self.builder.expression(.{ .primitive = .anyopaque }) }) });
    try parameters.append(self.allocator, .{ .name = if (allocate) "len" else "memory", .value = if (allocate) usize_type else try self.builder.expression(.{ .mutable_slice = u8_type }) });
    try parameters.append(self.allocator, .{ .name = "alignment", .value = try standardField(self, &.{ "mem", "Alignment" }) });
    if (!allocate and !release) try parameters.append(self.allocator, .{ .name = "len", .value = usize_type });
    try parameters.append(self.allocator, .{ .name = "ret_addr", .value = usize_type });
    for (parameters.items[1..]) |parameter| try arguments.append(self.allocator, try self.builder.identifier(parameter.name));

    const instance = try self.builder.identifier("self");
    const io = try self.field(instance, "io");
    const mutex = try self.field(instance, "mutex");
    const raw_name = if (allocate) "rawAlloc" else if (release) "rawFree" else if (resize) "rawResize" else "rawRemap";
    const call = try self.call(try self.field(try self.field(instance, "child"), raw_name), arguments.items, false);

    const body = try self.allocator.dupe(node.Statement, &.{
        .{ .constant = .{ .name = "self", .type_expr = try self.builder.expression(.{ .pointer = try self.builtin(.This, &.{}) }), .value = try self.builtin(.ptrCast, &.{try self.builtin(.alignCast, &.{try self.builder.identifier("context")})}) } },
        .{ .expression = try self.call(try self.field(mutex, "lockUncancelable"), &.{io}, false) },
        .{ .defer_expression = try self.call(try self.field(mutex, "unlock"), &.{io}, false) },
        if (release) .{ .expression = call } else .{ .result = call },
    });

    const result_type = if (release) try self.builder.expression(.{ .primitive = .void }) else if (resize) try self.builder.expression(.{ .primitive = .bool }) else try self.builder.expression(.{ .optional_type = try self.builder.expression(.{ .many_pointer = u8_type }) });

    return .{ .function = .{ .name = name, .parameters = try parameters.toOwnedSlice(self.allocator), .return_type = result_type, .body = body } };
}
