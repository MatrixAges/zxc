const std = @import("std");
const ir = @import("zx").ir;
const Children = @import("../inline_call/children.zig");
const Self = @This();
const Error = std.mem.Allocator.Error;

allocator: std.mem.Allocator,
program: ir.Program,
projected: []bool,
observed: []bool,
bindings: []?ir.ExprId,
pending: std.ArrayList(ir.ExprId) = .empty,
pub fn symbols(allocator: std.mem.Allocator, program: ir.Program) Error![]const bool {
    var self = Self{
        .allocator = allocator,
        .program = program,
        .projected = try allocator.alloc(bool, program.symbols.count()),
        .observed = try allocator.alloc(bool, program.expressions.count()),
        .bindings = try allocator.alloc(?ir.ExprId, program.symbols.count()),
    };

    defer allocator.free(self.observed);
    defer allocator.free(self.bindings);
    defer self.pending.deinit(allocator);
    @memset(self.projected, true);
    @memset(self.observed, false);
    @memset(self.bindings, null);

    for (0..program.expressions.count()) |index| {
        const value = program.expressions.at(index).value;

        switch (value) {
            .field, .tuple_field, .reference => {},
            .conditional => |branch| try self.observe(branch.condition),
            .match_expr => |selection| {
                if (selection.subject) |subject| try self.observe(subject);
                for (0..selection.arms.len) |position| try self.observe(selection.arms.at(position).condition);
            },
            .scope => |scope| {
                try self.observe(scope.result);

                for (0..scope.bindings.len) |position| {
                    const binding = scope.bindings.at(position);

                    if (binding.symbol) |symbol| try self.bind(symbol, binding.value) else try self.observe(binding.value);
                }
            },
            else => {
                const children = Children.init(value);

                for (0..children.len) |position| try self.observe(children.at(position));

                if (value == .task) for (value.task.captures) |symbol| {
                    self.projected[@backingInt(symbol)] = false;
                };
            },
        }
    }

    const control = program.body.control;

    for (control.constant_symbols, control.constant_values) |symbol, value| try self.bind(@fromBackingInt(symbol), @fromBackingInt(value));

    inline for (.{ "evaluations", "parallel_values", "destructure_values", "branch_conditions", "selection_subjects", "setter_values" }) |name| {
        for (@field(control, name)) |value| try self.observe(@fromBackingInt(value));
    }

    inline for (.{ "case_values", "results" }) |name| {
        for (@field(control, name)) |value| if (value) |id| try self.observe(@fromBackingInt(id));
    }

    for (self.projected, self.bindings) |projected, binding| {
        if (!projected) if (binding) |value| try self.observe(value);
    }

    while (self.pending.pop()) |id| switch (program.expression(id).value) {
        .reference => |symbol| {
            self.projected[@backingInt(symbol)] = false;

            if (self.bindings[@backingInt(symbol)]) |binding| try self.observe(binding);
        },
        .conditional => |branch| {
            try self.observe(branch.yes);
            try self.observe(branch.no);
        },
        .match_expr => |selection| {
            try self.observe(selection.fallback);
            for (0..selection.arms.len) |position| try self.observe(selection.arms.at(position).result);
        },
        .scope => |scope| try self.observe(scope.result),
        else => {},
    };

    return self.projected;
}

fn observe(self: *Self, id: ir.ExprId) Error!void {
    if (self.observed[@backingInt(id)]) return;

    self.observed[@backingInt(id)] = true;

    try self.pending.append(self.allocator, id);
}

fn bind(self: *Self, symbol: ir.SymbolId, value: ir.ExprId) Error!void {
    if (self.bindings[@backingInt(symbol)]) |previous| {
        self.projected[@backingInt(symbol)] = false;

        try self.observe(previous);
        try self.observe(value);
    } else self.bindings[@backingInt(symbol)] = value;
}
