const std = @import("std");
const ir = @import("zx").ir;
const Binding = @import("frontend").expressions.Binding;
const Module = @import("module.zig");
const Flow = @import("program/flow.zig");

pub fn select(allocator: std.mem.Allocator, bindings: []const Binding, calls: []const Module.Call, body: []const Flow.Step) std.mem.Allocator.Error![]const Binding {
    var captures: std.ArrayList(Binding) = .empty;

    for (bindings) |binding| {
        var used = steps(body, binding.name);

        for (calls) |call| used = used or reads(call.argument, binding.name);
        if (used) try captures.append(allocator, binding);
    }

    return captures.items;
}

fn reads(program: ir.Program, name: []const u8) bool {
    for (program.body) |statement| {
        if (statement != .constant) break;

        const symbol = statement.constant.symbol;
        const value = program.expression(statement.constant.value);

        if (value.value != .tuple_field or !std.mem.eql(u8, program.symbols[@intFromEnum(symbol)].name, name)) continue;

        const environment = program.expression(value.value.tuple_field.target);

        if (environment.value != .reference or @intFromEnum(environment.value.reference) != 0) continue;

        for (program.expressions) |expression| {
            if (expression.value == .reference and expression.value.reference == symbol) return true;
        }
    }

    return false;
}

fn steps(body: []const Flow.Step, name: []const u8) bool {
    for (body) |step| switch (step) {
        .result => |program| if (reads(program, name)) return true,
        .task => |nested| if (steps(nested, name)) return true,
        .selection => |selection| {
            if (reads(selection.subject, name)) return true;

            for (selection.cases) |case| {
                if (case.value) |value| if (reads(value, name)) return true;
                if (steps(case.body, name)) return true;
            }
        },
        .call, .parallel => {},
    };

    return false;
}
