const std = @import("std");
const node = @import("../node.zig");
const Rows = @import("rows.zig").Rows;
const Columns = @import("columns.zig").Columns;
pub const stored = @import("stored.zig");

const Self = @This();

allocator: std.mem.Allocator,
expressions: Rows(stored.Value(node.Expression)) = .init(),
statements: Rows(stored.Value(node.Statement)) = .init(),
declaration_rows: Rows(stored.Value(node.Declaration)) = .init(),
field_columns: Columns(node.Field) = .init(),
arm_columns: Columns(node.SelectionArm) = .init(),
pub fn init(allocator: std.mem.Allocator) Self {
    return .{ .allocator = allocator };
}

pub fn append(self: *Self, allocator: std.mem.Allocator, value: node.Expression) std.mem.Allocator.Error!node.ExpressionId {
    return @fromBackingInt(try self.expressions.append(allocator, try stored.copy(self, allocator, value)));
}

pub fn get(self: *const Self, id: node.ExpressionId) stored.Value(node.Expression) {
    return self.expressions.get(@backingInt(id));
}

pub fn block(self: *Self, allocator: std.mem.Allocator, values: []const node.Statement) std.mem.Allocator.Error!node.Block {
    const start: u32 = @intCast(self.statements.tags.items.len);

    for (values) |value| _ = try self.statements.append(allocator, try stored.copy(self, allocator, value));

    return .{ .start = start, .len = @intCast(values.len) };
}

pub fn statement(self: *const Self, selected: node.Block, index: usize) stored.Value(node.Statement) {
    std.debug.assert(index < selected.len);

    return self.statements.get(selected.start + @as(u32, @intCast(index)));
}

pub fn fields(self: *Self, allocator: std.mem.Allocator, values: []const node.Field) std.mem.Allocator.Error!stored.Fields {
    const start: u32 = @intCast(self.field_columns.count());

    try self.field_columns.reserve(allocator, values.len);
    for (values) |value| self.field_columns.append(value);

    return .{ .start = start, .len = @intCast(values.len) };
}

pub fn arms(self: *Self, allocator: std.mem.Allocator, values: []const node.SelectionArm) std.mem.Allocator.Error!stored.Arms {
    const start: u32 = @intCast(self.arm_columns.count());

    try self.arm_columns.reserve(allocator, values.len);
    for (values) |value| self.arm_columns.append(value);

    return .{ .start = start, .len = @intCast(values.len) };
}

pub fn declarations(self: *Self, allocator: std.mem.Allocator, values: []const node.Declaration) std.mem.Allocator.Error!stored.Declarations {
    const start: u32 = @intCast(self.declaration_rows.tags.items.len);

    for (values) |value| _ = try self.declaration_rows.append(allocator, try stored.copy(self, allocator, value));

    return .{ .start = start, .len = @intCast(values.len) };
}

pub fn selectDeclarations(self: *Self, allocator: std.mem.Allocator, indices: []const u32) (std.mem.Allocator.Error || error{InvalidAst})!stored.Declarations {
    const first = self.declaration_rows.tags.items.len;

    if (indices.len > std.math.maxInt(u32) - first) return error.OutOfMemory;
    for (indices) |index| if (index >= first) return error.InvalidAst;
    try self.declaration_rows.tags.ensureUnusedCapacity(allocator, indices.len);
    try self.declaration_rows.offsets.ensureUnusedCapacity(allocator, indices.len);

    for (indices) |index| {
        self.declaration_rows.tags.appendAssumeCapacity(self.declaration_rows.tags.items[index]);
        self.declaration_rows.offsets.appendAssumeCapacity(self.declaration_rows.offsets.items[index]);
    }

    return .{ .start = @intCast(first), .len = @intCast(indices.len) };
}

pub fn materializeDeclaration(self: *const Self, allocator: std.mem.Allocator, index: u32) std.mem.Allocator.Error!node.Declaration {
    return switch (self.declaration_rows.get(index)) {
        .function => .{ .function = try self.materializeFunction(allocator, index) },
        inline else => |payload, tag| @unionInit(node.Declaration, @tagName(tag), payload),
    };
}

pub fn materializeFunction(self: *const Self, allocator: std.mem.Allocator, index: u32) std.mem.Allocator.Error!node.Function {
    const value = self.declaration_rows.get(index).function;
    const parameters = try allocator.alloc(node.Field, value.parameters.len);

    for (parameters, 0..) |*parameter, offset| parameter.* = self.field_columns.get(value.parameters.start + offset);

    return .{
        .name = value.name,
        .parameters = parameters,
        .return_type = value.return_type,
        .body = value.body,
        .exported = value.exported,
        .abi_export = value.abi_export,
        .inlined = value.inlined,
        .calling_convention = value.calling_convention,
    };
}
