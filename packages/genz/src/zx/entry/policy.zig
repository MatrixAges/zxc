const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Lower = @import("../lower.zig");

pub fn base(self: *const Lower) std.meta.Child(@import("generated_public_entry_base").Output) {
    const entry = @import("generated_public_entry_base");
    const input: std.meta.Child(entry.Input) = .{ .tasks = self.entry_flags.tasks };
    var empty = std.heap.FixedBufferAllocator.init(&.{});
    const output = zx.columns.invoke(entry.executeValue, empty.allocator(), &input) catch unreachable;

    return zx.columns.view(std.meta.Child(entry.Output), output);
}

pub fn value(self: *const Lower) std.meta.Child(@import("generated_public_entry_policy").Output) {
    const entry = @import("generated_public_entry_policy");

    const input: std.meta.Child(entry.Input) = .{
        .tasks = self.entry_flags.tasks,
        .enabled = self.entry_flags.value,
        .type_only = self.program.type_only,
        .represented_input = self.state_plan.represented(self.program, self.program.input_type) or self.state_plan.inlineRows(self.program, self.program.input_type),
        .represented_output = self.state_plan.represented(self.program, self.program.output_type),
        .output_kind = @fromBackingInt(@intCast(self.program.types.kinds[@backingInt(self.program.output_type)])),
    };

    return select(input);
}

pub fn select(input: std.meta.Child(@import("generated_public_entry_policy").Input)) std.meta.Child(@import("generated_public_entry_policy").Output) {
    const entry = @import("generated_public_entry_policy");
    var empty = std.heap.FixedBufferAllocator.init(&.{});
    const output = zx.columns.invoke(entry.executeValue, empty.allocator(), &input) catch unreachable;

    return zx.columns.view(std.meta.Child(entry.Output), output);
}

pub fn allocator(tasks: bool) bool {
    const entry = @import("generated_public_entry_base");
    const input: std.meta.Child(entry.Input) = .{ .tasks = tasks };
    var empty = std.heap.FixedBufferAllocator.init(&.{});
    const output = zx.columns.invoke(entry.executeValue, empty.allocator(), &input) catch unreachable;

    return output.forward;
}

pub fn forwarded(self: *const Lower) ?ir.FunctionId {
    const entry = @import("generated_public_entry_forward");
    const Input = std.meta.Child(entry.Input);
    const Functions = std.meta.Child(@FieldType(Input, "functions"));
    const Facts = std.meta.Child(@FieldType(Input, "ownership"));
    const types = ir.TypeTable.borrow(std.meta.Child(@FieldType(Input, "types")), self.program.types);

    const functions: Functions = .{
        .input_types = self.program.functions.input_types,
        .output_types = self.program.functions.output_types,
        .stores = zx.columns.slice(@FieldType(Functions, "stores"), self.program.functions.stores),
    };

    const facts: Facts = .{
        .types = &types,
        .selected = self.state_plan.selected,
        .counts = self.slot_counts,
        .first = self.plan.slot_first,
        .transfers = self.plan.transfers,
    };

    const input: Input = .{
        .represented_output = self.state_plan.represented(self.program, self.program.output_type),
        .types = &types,
        .control = zx.columns.pointer(@FieldType(Input, "control"), self.program.body.control),
        .root = if (self.program.body.root) |id| @backingInt(id) else null,
        .expressions = zx.columns.pointer(@FieldType(Input, "expressions"), &self.program.expressions),
        .stores = self.program.stores.count(),
        .contracts = self.program.contracts.count(),
        .functions = &functions,
        .values = self.value_functions,
        .flags = @as([*]const u8, @ptrCast(self.plan.flags.ptr))[0..self.plan.flags.len],
        .ownership = &facts,
        .input_type = @backingInt(self.program.input_type),
        .output_type = @backingInt(self.program.output_type),
    };

    comptime std.debug.assert(@bitSizeOf(@import("../uniqueness/root.zig").Flags) == @bitSizeOf(u8));

    var empty = std.heap.FixedBufferAllocator.init(&.{});
    const output = zx.columns.invoke(entry.executeValue, empty.allocator(), &input) catch unreachable;

    return if (output) |id| @fromBackingInt(id) else null;
}
