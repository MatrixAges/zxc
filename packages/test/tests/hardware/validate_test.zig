const std = @import("std");
const compiler = @import("compiler");
const hardware = compiler.hardware;
const ir = hardware.ir;

const nodes = [_]ir.Node{
    .{ .sort = .{ .width = 8 }, .value = .{ .input = 0 } },
    .{ .sort = .{ .width = 1, .boolean = true }, .value = .{ .constant = 1 } },
    .{ .sort = .{ .width = 8 }, .value = .{ .binary = .{ .operator = .add, .left = @enumFromInt(0), .right = @enumFromInt(0) } } },
};

const input = ir.Port{ .name = "input_0", .path = "in", .sort = .{ .width = 8 }, .signed = false, .node = @enumFromInt(0) };
const output = ir.Port{ .name = "output_0", .path = "out", .sort = .{ .width = 8 }, .signed = false, .node = @enumFromInt(2) };
const Mutation = enum { zero_width, large_width, boolean_width, constant_overflow, forward_child, missing_child, wrong_binary, wrong_result, invalid_input, bad_input_name, bad_input_node, bad_output_name, bad_output_node, integer_safe, missing_safe, boolean_signed, select_condition, extension };

test "hardware accepts a typed topological module" {
    const module = ir.Module{ .nodes = &nodes, .inputs = &.{input}, .outputs = &.{output}, .safe = @enumFromInt(1) };

    try std.testing.expect(hardware.validate(module));
}

test "hardware validator and emitter reject malformed graph boundaries" {
    inline for (std.meta.tags(Mutation)) |mutation| {
        var changed = nodes;
        var inputs = [_]ir.Port{input};
        var outputs = [_]ir.Port{output};
        var module = ir.Module{ .nodes = &changed, .inputs = &inputs, .outputs = &outputs, .safe = @enumFromInt(1) };

        switch (mutation) {
            .zero_width => changed[0].sort.width = 0,
            .large_width => changed[0].sort.width = 257,
            .boolean_width => changed[1].sort.width = 2,
            .constant_overflow => changed[1].value.constant = 2,
            .forward_child => changed[2].value.binary.left = @enumFromInt(2),
            .missing_child => changed[2].value.binary.right = @enumFromInt(99),
            .wrong_binary => changed[2].value.binary.operator = .logical_and,
            .wrong_result => changed[2].sort.width = 16,
            .invalid_input => changed[0].value.input = 1,
            .bad_input_name => inputs[0].name = "input_1",
            .bad_input_node => inputs[0].node = @enumFromInt(99),
            .bad_output_name => outputs[0].name = "bad",
            .bad_output_node => outputs[0].node = @enumFromInt(99),
            .integer_safe => module.safe = @enumFromInt(0),
            .missing_safe => module.safe = @enumFromInt(99),
            .boolean_signed => outputs[0] = .{ .name = "output_0", .path = "out", .sort = .{ .width = 1, .boolean = true }, .signed = true, .node = @enumFromInt(1) },
            .select_condition => changed[2].value = .{ .select = .{ .condition = @enumFromInt(0), .yes = @enumFromInt(0), .no = @enumFromInt(0) } },
            .extension => changed[2].value = .{ .extend = .{ .operand = @enumFromInt(0), .signed = false, .extra = 1 } },
        }

        try std.testing.expect(!hardware.validate(module));
        try std.testing.expectError(error.InvalidHardwareIr, compiler.verilog.emit(std.testing.allocator, module, false));
        try std.testing.expectError(error.InvalidHardwareIr, compiler.verilog.emit(std.testing.allocator, module, true));
    }
}
