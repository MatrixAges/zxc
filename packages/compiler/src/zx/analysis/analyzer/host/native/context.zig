const std = @import("std");
const zx = @import("zx");
const model = @import("model.zig");
const NativeTypes = @import("../../../semantic/resolving/host/native.zig");
const TypeModel = @import("../../../semantic/resolving/host/model.zig");
const Self = @This();
pub const Expression = struct { source: *const zx.ast.Expression, target: *model.Node, index: usize };
pub const Body = struct { source: zx.ast.Block, target: *model.Block };
pub const Pending = union(enum) { expression: Expression, block: Body };

allocator: std.mem.Allocator,
types: NativeTypes,
pending: std.ArrayList(Pending) = .empty,
references: std.AutoHashMapUnmanaged(*const zx.ast.Expression, u64) = .empty,
nodes: std.ArrayList(*const model.Node) = .empty,
items: std.ArrayList(*const model.Edge) = .empty,
fields: std.ArrayList(*const model.Field) = .empty,
parameters: std.ArrayList(*const model.Parameter) = .empty,
parts: std.ArrayList(*const model.Part) = .empty,
arms: std.ArrayList(*const model.Arm) = .empty,
statements: std.ArrayList(*const model.Statement) = .empty,
blocks: std.ArrayList(*const model.Block) = .empty,
block_items: std.ArrayList(*const model.BlockItem) = .empty,
names: std.ArrayList(*const model.Name) = .empty,
cases: std.ArrayList(*const model.Case) = .empty,
expression_names: std.ArrayList([]const u8) = .empty,
expression_values: std.ArrayList([]const u8) = .empty,
field_names: std.ArrayList([]const u8) = .empty,
parameter_names: std.ArrayList([]const u8) = .empty,
template_values: std.ArrayList([]const u8) = .empty,
statement_names: std.ArrayList([]const u8) = .empty,
destructure_names: std.ArrayList([]const u8) = .empty,
type_references: std.ArrayList(*const TypeModel.Reference) = .empty,
pub fn expression(self: *Self, source: *const zx.ast.Expression) std.mem.Allocator.Error!u64 {
    if (self.references.get(source)) |index| return index;

    const index = self.nodes.items.len;
    const target = try self.allocator.create(model.Node);

    try self.references.put(self.allocator, source, index);
    try self.nodes.append(self.allocator, target);
    try self.expression_names.append(self.allocator, "");
    try self.expression_values.append(self.allocator, "");
    try self.pending.append(self.allocator, .{ .expression = .{ .source = source, .target = target, .index = index } });

    return index;
}

pub fn block(self: *Self, source: zx.ast.Block) std.mem.Allocator.Error!u64 {
    const index = self.blocks.items.len;
    const target = try self.allocator.create(model.Block);

    try self.blocks.append(self.allocator, target);
    try self.pending.append(self.allocator, .{ .block = .{ .source = source, .target = target } });

    return index;
}

pub fn typeReference(self: *Self, source: *const zx.ast.Type) std.mem.Allocator.Error!u64 {
    const value = try self.types.reference(source);
    const index = self.type_references.items.len;

    try self.type_references.append(self.allocator, value);

    return index;
}

pub fn span(self: *Self, source: zx.Span) std.mem.Allocator.Error!*const model.Span {
    return self.keep(model.Span, .{ .start = source.start, .end = source.end });
}

pub fn keep(self: *Self, comptime T: type, value: T) std.mem.Allocator.Error!*const T {
    const result = try self.allocator.create(T);

    result.* = value;

    return result;
}
