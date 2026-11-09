const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const construction = @import("../construction/build.zig");

pub fn lower(self: *Lower, id: ir.TypeId, value: node.ExpressionId, layout: ?node.ExpressionId) Lower.Error!node.ExpressionId {
    const entry = @import("generated_collection_finalize");
    const Input = std.meta.Child(entry.Input);
    const Construction = std.meta.Child(@FieldType(Input, "construction"));
    const serial = self.serial;
    const declarations = self.task_declarations.count();
    const statements = self.builder.nodes.statements.tags.items.len;
    const storage = self.reference_storage.items.len;

    const resources: construction.Resources = if (layout) |target| .{
        .mode = .Value,
        .layout = target,
        .type_expr = null,
        .storage_layout = null,
    } else try construction.prepare(self, id);

    const kind = self.program.typeOf(id);
    const ast = @import("../construction/ast.zig").borrow(std.meta.Child(@FieldType(Construction, "ast")), self);

    std.debug.assert(serial == self.serial and declarations == self.task_declarations.count());
    std.debug.assert(statements == self.builder.nodes.statements.tags.items.len and storage == self.reference_storage.items.len);

    const source: Construction = .{
        .mode = @fromBackingInt(@backingInt(resources.mode)),
        .ast = &ast,
        .value = @backingInt(value),
        .layout = @backingInt(resources.layout),
        .type_expr = if (resources.type_expr) |item| @backingInt(item) else 0,
        .storage_layout = if (resources.storage_layout) |item| @backingInt(item) else 0,
        .is_tuple = kind == .tuple,
        .arity = if (kind == .tuple) kind.tuple.len else 0,
        .capture = if (self.capture) |capture| &.{ .name = capture.name, .label = capture.label, .failure = @backingInt(capture.failure) } else null,
        .expression_base = @intCast(self.builder.nodes.expressions.tags.items.len),
        .statement_base = @intCast(self.builder.nodes.statements.tags.items.len),
        .serial = self.serial,
    };

    const input: Input = .{
        .construction = &source,
        .target = if (layout) |target| @backingInt(target) else null,
        .origin = self.state_active and self.state_plan.selected[@backingInt(id)],
    };

    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var memory = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const output = entry.executeIn(memory.allocator(), &input) catch |err| return @import("emission.zig").failure(err);

    return construction.publish(self, output);
}
