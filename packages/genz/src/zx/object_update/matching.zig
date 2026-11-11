const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Lower = @import("../lower.zig");
const Change = @import("../object_update.zig").Change;

pub const Plan = struct { change: Change, positions: []const u32 };

pub fn match(lowering: *const Lower, scratch: std.mem.Allocator, id: ir.ExprId, evaluated: bool) Lower.Error!?Plan {
    const generated = @import("generated_object_update_candidate");
    const Input = std.meta.Child(generated.Input);
    const program: *const ir.Program = &lowering.program;
    const types = ir.TypeTable.borrow(std.meta.Child(@FieldType(Input, "types")), program.types);
    const flags = lowering.plan.flags;

    comptime std.debug.assert(@sizeOf(std.meta.Child(@TypeOf(flags))) == @sizeOf(u8));

    const cache = lowering.cache.view(std.meta.Child(@FieldType(Input, "cache")));
    const state_members = lowering.state_symbols.view(std.meta.Child(@FieldType(Input, "state_members")));
    const stack_members = lowering.stack_symbols.view(std.meta.Child(@FieldType(Input, "stack_members")));

    const input: Input = .{
        .expressions = zx.columns.pointer(@FieldType(Input, "expressions"), &program.expressions),
        .types = &types,
        .state_members = &state_members,
        .stack_members = &stack_members,
        .symbol_types = program.symbols.types,
        .flags = @as([*]const u8, @ptrCast(flags.ptr))[0..flags.len],
        .selected = lowering.state_plan.selected,
        .borrowed = lowering.state_plan.borrowed,
        .id = @backingInt(id),
        .state_active = lowering.state_active,
        .iteration = lowering.iteration_value != null,
        .loop_fields = lowering.loop_fields != null,
        .evaluated = evaluated,
        .cache = &cache,
    };

    const result = zx.columns.invoke(generated.executeValue, scratch, &input) catch |err| switch (err) {
        error.OutOfMemory, error.Overflow, error.IntegerOverflow => return error.OutOfMemory,
        else => unreachable,
    };

    const output = result orelse return null;

    return .{
        .change = .{
            .previous = @fromBackingInt(output.previous),
            .reference = @fromBackingInt(output.reference),
            .field = .{ .index = output.field_index, .value = @fromBackingInt(output.field_value) },
            .type_id = @fromBackingInt(output.type_id),
            .object = id,
        },
        .positions = output.positions,
    };
}
