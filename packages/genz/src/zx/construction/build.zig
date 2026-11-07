const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const apply = @import("apply.zig");

pub fn lower(self: *Lower, id: ir.TypeId, value: node.ExpressionId) Lower.Error!node.ExpressionId {
    const policy = @import("generated_construction_policy");
    const Policy = std.meta.Child(policy.Input);
    const index = @backingInt(id);

    const flags: Policy = .{
        .active = self.state_active,
        .selected = if (self.state_active) self.state_plan.selected[index] else false,
        .borrowed = index < self.state_plan.borrowed.len and self.state_plan.borrowed[index],
    };

    var fixed = std.heap.FixedBufferAllocator.init(&.{});
    const mode = zx.columns.invoke(policy.executeValue, fixed.allocator(), &flags) catch unreachable;
    const layout = try self.layoutExpr(id);
    const type_expr = if (mode == .Heap) try self.typeExpr(id) else null;
    const storage_layout = if (mode == .Reference) try @import("../types.zig").get(self, self.state_layouts, id) else null;
    const generated = @import("generated_construction");
    const Input = std.meta.Child(generated.Input);
    const kind = self.program.typeOf(id);
    const ast = @import("ast.zig").borrow(std.meta.Child(@FieldType(Input, "ast")), self);

    const input: Input = .{
        .mode = @fromBackingInt(@backingInt(mode)),
        .ast = &ast,
        .value = @backingInt(value),
        .layout = @backingInt(layout),
        .type_expr = if (type_expr) |item| @backingInt(item) else 0,
        .storage_layout = if (storage_layout) |item| @backingInt(item) else 0,
        .is_tuple = kind == .tuple,
        .arity = if (kind == .tuple) kind.tuple.len else 0,
        .capture = if (self.capture) |capture| &.{ .name = capture.name, .label = capture.label, .failure = @backingInt(capture.failure) } else null,
        .expression_base = @intCast(self.builder.nodes.expressions.tags.items.len),
        .statement_base = @intCast(self.builder.nodes.statements.tags.items.len),
        .serial = self.serial,
    };

    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var buffered = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const output = generated.executeIn(buffered.allocator(), &input) catch |err| switch (@as(anyerror, err)) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => return error.OutOfMemory,
        else => unreachable,
    };

    if (!output.valid) return error.OutOfMemory;
    try apply.expressions(self, output);
    try apply.rows(self, &self.builder.nodes.statements, output.statements);
    try apply.storage(self, output);

    self.serial = @intCast(output.serial);
    self.uses_allocator = self.uses_allocator or output.uses_allocator;

    return @fromBackingInt(output.root);
}
