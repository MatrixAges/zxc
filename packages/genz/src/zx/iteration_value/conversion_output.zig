const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const node = @import("../../node.zig");
const Context = @import("root.zig");
const Lower = @import("../lower.zig");

pub fn lower(context: *Context, id: ir.TypeId, value: node.ExpressionId) Lower.Error!node.ExpressionId {
    const self = context.lowering;
    const root_layout = try self.layoutExpr(id);
    const planner = @import("generated_conversion_plan");
    const PlanInput = std.meta.Child(planner.Input);
    const types = ir.TypeTable.borrow(std.meta.Child(@FieldType(PlanInput, "types")), self.program.types);

    const request: PlanInput = .{
        .types = &types,
        .layouts = zx.columns.slice(@FieldType(PlanInput, "layouts"), self.layout_types),
        .root = @backingInt(id),
        .inline_lists = context.inline_lists,
    };

    var fixed = std.heap.FixedBufferAllocator.init(&.{});
    const operation = zx.columns.invoke(@import("generated_conversion_operation").executeValue, fixed.allocator(), &request) catch unreachable;

    if (operation == .Value) return value;

    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var buffered = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const plan = planner.executeIn(buffered.allocator(), &request) catch |err| switch (@as(anyerror, err)) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => return error.OutOfMemory,
        else => unreachable,
    };

    const generated = @import("generated_conversion_output");
    const Input = std.meta.Child(generated.Input);
    const Source = std.meta.Child(@FieldType(Input, "source"));
    const layouts = try buffered.allocator().alloc(u32, plan.types.len);
    const elements = try buffered.allocator().alloc(u32, plan.types.len);
    const modes = try buffered.allocator().alloc(std.meta.Child(@FieldType(Input, "modes")), plan.types.len);
    const type_exprs = try buffered.allocator().alloc(u32, plan.types.len);
    const storage_layouts = try buffered.allocator().alloc(u32, plan.types.len);
    const policy = @import("generated_construction_policy");
    const Policy = std.meta.Child(policy.Input);
    const serial = self.serial;
    const declarations = context.declarations.items.len;
    const storage = self.reference_storage.items.len;

    for (plan.types, plan.kinds, 0..) |type_id, kind, index| {
        const selected: ir.TypeId = @fromBackingInt(type_id);
        const layout = if (index == 0) root_layout else try self.layoutExpr(selected);

        if (kind == .Buffer) unreachable;

        layouts[index] = @backingInt(if (kind == .Optional) try self.typeExpr(selected) else layout);
        elements[index] = 0;
        modes[index] = .Heap;
        type_exprs[index] = 0;
        storage_layouts[index] = 0;

        if (kind == .Object or kind == .Tuple) {
            const flags: Policy = .{
                .active = self.state_active,
                .selected = if (self.state_active) self.state_plan.selected[type_id] else false,
                .borrowed = type_id < self.state_plan.borrowed.len and self.state_plan.borrowed[type_id],
            };

            const mode = zx.columns.invoke(policy.executeValue, fixed.allocator(), &flags) catch unreachable;

            modes[index] = @fromBackingInt(@backingInt(mode));
            type_exprs[index] = if (mode == .Heap) @backingInt(try self.typeExpr(selected)) else 0;
            storage_layouts[index] = if (mode == .Reference) @backingInt(try @import("../types.zig").get(self, self.state_layouts, selected)) else 0;
        }
    }

    std.debug.assert(serial == self.serial and declarations == context.declarations.items.len and storage == self.reference_storage.items.len);

    const ast = @import("../construction/ast.zig").borrow(std.meta.Child(@FieldType(Input, "ast")), self);

    const source: Source = .{
        .plan = plan,
        .layouts = layouts,
        .elements = elements,
        .value = @backingInt(value),
        .capture = if (self.capture) |capture| &.{ .name = capture.name, .label = capture.label, .failure = @backingInt(capture.failure) } else null,
        .expression_base = @intCast(self.builder.nodes.expressions.tags.items.len),
        .statement_base = @intCast(self.builder.nodes.statements.tags.items.len),
        .field_base = @intCast(self.builder.nodes.field_columns.count()),
        .serial = self.serial,
    };

    const input: Input = .{
        .source = &source,
        .modes = modes,
        .ast = &ast,
        .type_exprs = type_exprs,
        .storage_layouts = storage_layouts,
    };

    const output = generated.executeIn(buffered.allocator(), &input) catch |err| switch (@as(anyerror, err)) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => return error.OutOfMemory,
        else => unreachable,
    };

    if (!output.result.valid) return error.OutOfMemory;

    const result = try @import("conversion_emission.zig").apply(context, output.result);
    const view = @import("../../node/view.zig");
    const prefix = view.join(output.storage.*, output.result.variables.*);

    try @import("../construction/apply.zig").flat(self, &self.reference_storage, &prefix);

    return result;
}
