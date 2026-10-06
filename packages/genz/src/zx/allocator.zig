const std = @import("std");
const node = @import("../node.zig");
const Lower = @import("lower.zig");
const standardField = @import("intrinsics.zig").standardField;

pub fn lower(self: *Lower, with_io: bool) Lower.Error!*const node.Expression {
    var fields: std.ArrayList(node.Field) = .empty;

    try fields.append(self.allocator, .{ .name = "child", .value = try standardField(self, &.{ "mem", "Allocator" }) });
    if (with_io) try fields.append(self.allocator, .{ .name = "io", .value = try standardField(self, &.{"Io"}) });
    try fields.append(self.allocator, .{ .name = "mutex", .value = try standardField(self, &.{ "Io", "Mutex" }), .default_value = try self.builder.expression(.{ .enum_literal = "init" }) });

    var declarations: std.ArrayList(node.Declaration) = .empty;
    var vtable: std.ArrayList(node.Field) = .empty;

    for ([_][]const u8{ "alloc", "resize", "remap", "free" }) |name| {
        try declarations.append(self.allocator, try operation(self, name, with_io));
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

    return self.builder.expression(.{ .container_type = .{ .fields = try fields.toOwnedSlice(self.allocator), .declarations = try declarations.toOwnedSlice(self.allocator) } });
}

fn operation(self: *Lower, name: []const u8, with_io: bool) Lower.Error!node.Declaration {
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
        .{ .expression = if (with_io) try self.call(try self.field(mutex, "lockUncancelable"), &.{io}, false) else try self.call(try standardField(self, &.{ "Io", "Threaded", "mutexLockUncancelable" }), &.{try self.builder.expression(.{ .address_of = mutex })}, false) },
        .{ .defer_expression = if (with_io) try self.call(try self.field(mutex, "unlock"), &.{io}, false) else try self.call(try standardField(self, &.{ "Io", "Threaded", "mutexUnlock" }), &.{try self.builder.expression(.{ .address_of = mutex })}, false) },
        if (release) .{ .expression = call } else .{ .result = call },
    });

    const result_type = if (release) try self.builder.expression(.{ .primitive = .void }) else if (resize) try self.builder.expression(.{ .primitive = .bool }) else try self.builder.expression(.{ .optional_type = try self.builder.expression(.{ .many_pointer = u8_type }) });

    return .{ .function = .{ .name = name, .parameters = try parameters.toOwnedSlice(self.allocator), .return_type = result_type, .body = body } };
}
