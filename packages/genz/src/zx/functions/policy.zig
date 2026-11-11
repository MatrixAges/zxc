const std = @import("std");
const zx = @import("zx");
const Lower = @import("../lower.zig");
const generated = @import("genz_options").generated_analysis;
const Mode = struct { enter: bool, bind_input: bool, value_output: bool };

pub fn value(self: *const Lower) Mode {
    if (!generated) return seed(self);

    const entry = @import("generated_function_value_mode");
    const program = &self.program;
    const queries = self.state_plan.queries;

    const input: std.meta.Child(entry.Input) = .{
        .input = @fromBackingInt(@backingInt(queries[@backingInt(program.input_type)])),
        .output = @fromBackingInt(@backingInt(queries[@backingInt(program.output_type)])),
        .kinds = program.types.kinds,
        .first = program.types.first,
        .output_type = @backingInt(program.output_type),
        .state_active = self.state_active,
        .public_value = self.public_value_output,
    };

    var memory = std.heap.FixedBufferAllocator.init(&.{});
    const result = zx.columns.invoke(entry.executeValue, memory.allocator(), &input) catch unreachable;

    return zx.columns.view(Mode, result);
}

pub fn allowsAllocation(errors: ?[]const []const u8) bool {
    if (!generated) {
        const names = errors orelse return true;

        for (names) |name| {
            if (std.mem.eql(u8, name, "OutOfMemory")) return true;
        }

        return false;
    }

    const entry = @import("generated_function_allocation");
    const input: std.meta.Child(entry.Input) = .{ .errors = errors };
    var memory = std.heap.FixedBufferAllocator.init(&.{});

    return zx.columns.invoke(entry.executeValue, memory.allocator(), &input) catch unreachable;
}

fn seed(self: *const Lower) Mode {
    const program = self.program;
    const represented_output = self.state_plan.represented(program, program.output_type);
    const enter = represented_output or self.state_plan.represented(program, program.input_type) or self.state_plan.inlineRows(program, program.input_type);
    const output = program.typeOf(program.output_type);
    var payload = output;

    while (payload == .optional) payload = program.typeOf(payload.optional);

    return .{
        .enter = enter,
        .bind_input = (enter or self.state_active) and !self.public_value_output,
        .value_output = payload != .native_reference and (!enter or represented_output or (output != .object and output != .tuple)),
    };
}
