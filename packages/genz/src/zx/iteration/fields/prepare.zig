const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const node = @import("../../../node.zig");
const Lower = @import("../../lower.zig");
const Context = @import("root.zig");

pub fn prepare(self: *Lower, iteration: ir.Iteration, type_id: ir.TypeId, body: *std.ArrayList(node.Statement), seed: node.ExpressionId) Lower.Error!?Context {
    if (comptime !@import("genz_options").generated_analysis) return null;
    if (self.loop_fields != null or self.iteration_value != null or self.capture != null) return null;
    if (self.program.typeOf(type_id) != .object) return null;

    const fields = self.program.typeOf(type_id).object;

    if (fields.len < 2) return null;

    var scratch = std.heap.ArenaAllocator.init(self.workspace);

    defer scratch.deinit();

    const candidates = try scratch.allocator().alloc(bool, fields.len);

    for (candidates, 0..) |*candidate, index| candidate.* = worthwhile(self, fields.at(index).type_id);
    if (std.mem.indexOfScalar(bool, candidates, true) == null) return null;

    const generated = @import("generated_loop_fields");
    const Input = std.meta.Child(generated.Input);

    const input: Input = .{
        .expressions = zx.columns.pointer(@FieldType(Input, "expressions"), &@as(*const ir.Program, &self.program).expressions),
        .symbol_types = zx.columns.slice(@FieldType(Input, "symbol_types"), self.program.symbols.types),
        .parameter = @backingInt(iteration.parameter),
        .condition_parameter = @backingInt(iteration.condition_parameter),
        .body = @backingInt(iteration.body),
        .condition = @backingInt(iteration.condition),
        .state_type = @backingInt(type_id),
        .field_count = fields.len,
        .candidates = candidates,
    };

    const plan = generated.executeValue(scratch.allocator(), &input) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => unreachable,
    };

    if (!plan.valid) return null;

    const borrowed = try self.allocator.alloc(bool, fields.len);
    var changed = false;

    for (borrowed, 0..) |*value, index| {
        value.* = !plan.mutable[index] and candidates[index];
        changed = changed or plan.mutable[index];
    }

    for (plan.states, 0..) |selected, index| {
        const id: ir.ExprId = @fromBackingInt(@intCast(index));
        const flags = self.plan.get(id);

        if (selected and (self.cache.contains(id) or flags.normalize or flags.renew)) return null;

        const origin = plan.origins[index];

        if (origin != std.math.maxInt(u32) and (flags.normalize or flags.renew)) borrowed[origin] = false;
    }

    if (!changed or std.mem.indexOfScalar(bool, borrowed, true) == null) return null;

    const items = try self.allocator.alloc(node.Field, fields.len + 1);

    for (items[0..fields.len], 0..) |*item, index| {
        const field = fields.at(index);
        const field_type = try self.typeExpr(field.type_id);

        item.* = .{ .name = field.name, .value = if (borrowed[index]) try self.builder.expression(.{ .const_pointer = field_type }) else field_type };
    }

    items[fields.len] = .{
        .name = try @import("../../state_value/origin.zig").name(self, type_id),
        .value = try self.builder.expression(.{ .optional_type = try @import("../../types.zig").get(self, self.abi_types, type_id) }),
        .default_value = try self.builder.expression(.null_value),
    };

    const name = try self.fresh("loop_fields");

    try body.append(self.allocator, .{ .constant = .{ .name = name, .value = try self.builder.expression(.{ .struct_type = items }) } });

    return .{
        .states = try self.allocator.dupe(bool, plan.states),
        .symbols = try self.allocator.dupe(bool, plan.symbols),
        .borrowed = borrowed,
        .type_id = type_id,
        .layout = try self.builder.identifier(name),
        .seed = seed,
    };
}

fn worthwhile(self: *const Lower, id: ir.TypeId) bool {
    return switch (self.program.typeOf(id)) {
        .list => true,
        .scalar => |kind| kind == .string,
        .optional => |child| worthwhile(self, child),
        .object => |fields| self.state_plan.selected[@backingInt(id)] and fields.len != 0,
        .tuple => |fields| self.state_plan.selected[@backingInt(id)] and fields.len != 0,
        else => false,
    };
}
