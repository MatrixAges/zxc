const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Lower = @import("../lower.zig");
const Change = @import("../object_update.zig").Change;

pub fn match(lowering: *const Lower, id: ir.ExprId) ?Change {
    const generated = @import("generated_object_update_candidate");
    const Input = std.meta.Child(generated.Input);
    const program: *const ir.Program = &lowering.program;
    const types = ir.TypeTable.borrow(std.meta.Child(@FieldType(Input, "types")), program.types);
    const flags = lowering.plan.flags;

    comptime std.debug.assert(@sizeOf(std.meta.Child(@TypeOf(flags))) == @sizeOf(u8));

    const input: Input = .{
        .expressions = zx.columns.pointer(@FieldType(Input, "expressions"), &program.expressions),
        .types = &types,
        .symbol_types = program.symbols.types,
        .flags = @as([*]const u8, @ptrCast(flags.ptr))[0..flags.len],
        .selected = lowering.state_plan.selected,
        .borrowed = lowering.state_plan.borrowed,
        .id = @backingInt(id),
        .state_active = lowering.state_active,
        .iteration = lowering.iteration_value != null,
        .loop_fields = lowering.loop_fields != null,
        .cached = lowering.cache.contains(id),
    };

    var fixed = std.heap.FixedBufferAllocator.init(&.{});
    const result = zx.columns.invoke(generated.executeValue, fixed.allocator(), &input) catch unreachable;
    const candidate = result orelse return null;
    const eligible = @import("generated_object_update_eligible");
    const Argument = std.meta.Child(eligible.Input);
    const PublicChange = std.meta.Child(@FieldType(Argument, "change"));
    const change = zx.columns.view(PublicChange, candidate);

    const facts: Argument = .{
        .change = &change,
        .state_member = lowering.state_symbols.contains(@fromBackingInt(candidate.previous)),
        .stack_member = lowering.stack_symbols.contains(@fromBackingInt(candidate.previous)),
    };

    const selected = zx.columns.invoke(eligible.executeValue, fixed.allocator(), &facts) catch unreachable;
    const output = selected orelse return null;

    return .{
        .previous = @fromBackingInt(output.previous),
        .reference = @fromBackingInt(output.reference),
        .field = .{ .index = output.field_index, .value = @fromBackingInt(output.field_value) },
        .type_id = @fromBackingInt(output.type_id),
    };
}
