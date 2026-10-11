const std = @import("std");
const ir = @import("zx").ir;
const Level = @import("level.zig").Level;
const Basis = @import("basis.zig");
const Self = @This();

/// Per function: what every caller guarantees about each input list slot, what every return guarantees about each
/// output list slot, the list types the output can hold, and the list types the function may write in place.
/// `inputs` and `outputs` hold the properties some update downstream of each slot wants, so a growth copy pays off.
input: [][]Level,
output: [][]Level,
inputs: [][]Level,
outputs: [][]Level,
holds: []const []const ir.TypeId,
mutates: []const []const ir.TypeId,
pub fn create(allocator: std.mem.Allocator, program: ir.Program, basis: *const Basis) std.mem.Allocator.Error!Self {
    const slots = basis.slots;
    const count = program.functions.count();
    const input = try allocator.alloc([]Level, count);
    const output = try allocator.alloc([]Level, count);
    const inputs = try allocator.alloc([]Level, count);
    const outputs = try allocator.alloc([]Level, count);

    for (0..count) |index| {
        const function = program.functions.at(index);

        input[index] = try allocator.alloc(Level, slots.count(function.input_type));
        output[index] = try allocator.alloc(Level, slots.count(function.output_type));

        @memset(input[index], if (function.external == null) .all else .none);
        @memset(output[index], if (function.external == null) .all else .none);

        inputs[index] = try allocator.alloc(Level, input[index].len);
        outputs[index] = try allocator.alloc(Level, output[index].len);

        @memset(inputs[index], .none);
        @memset(outputs[index], .none);
    }

    return .{ .input = input, .output = output, .inputs = inputs, .outputs = outputs, .holds = basis.holds, .mutates = basis.mutates };
}

pub fn mayHold(self: Self, function: ir.FunctionId, list: ir.TypeId) bool {
    return std.mem.indexOfScalar(ir.TypeId, self.holds[@backingInt(function)], list) != null;
}

pub fn mayMutate(self: Self, function: ir.FunctionId, list: ir.TypeId) bool {
    return std.mem.indexOfScalar(ir.TypeId, self.mutates[@backingInt(function)], list) != null;
}

/// Optimistic facts for every body; inputs stay unknown unless every caller is a known call site.
pub fn reset(self: Self, program: ir.Program, known: []const bool) void {
    for (self.input, self.output, known, 0..) |input, output, callers, index| {
        const internal = program.functions.at(index).external == null;

        @memset(input, if (internal and callers) .all else .none);
        @memset(output, if (internal) .all else .none);
    }
}

pub fn clear(self: Self) void {
    for (self.input) |values| @memset(values, .none);
    for (self.output) |values| @memset(values, .none);
}

/// Forgets what updates downstream of each slot want, as `create` leaves it.
pub fn clearWants(self: Self) void {
    for (self.inputs) |values| @memset(values, .none);
    for (self.outputs) |values| @memset(values, .none);
}
