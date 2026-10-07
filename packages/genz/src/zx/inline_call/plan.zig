const std = @import("std");
const ir = @import("zx").ir;
const Self = @This();

pub const limit = 4096;

program: ir.Program,
costs: []usize,
pub fn init(allocator: std.mem.Allocator, program: ir.Program) std.mem.Allocator.Error!Self {
    const facts = try @import("../value_call/analysis.zig").analyze(allocator, program);
    const costs = try allocator.alloc(usize, program.functions.len);
    var self = Self{ .program = program, .costs = costs };

    @memset(costs, 0);

    for (program.functions, 0..) |function, index| {
        if (!facts.pure[index] or function.external != null or function.stores.count() != 0 or function.contracts.len != 0) continue;
        if (primitive(program, function.input_type) and primitive(program, function.output_type)) continue;

        const input = program.typeOf(function.input_type);

        if (input == .scalar and input.scalar == .void) continue;
        if (!statements(function.body.block())) continue;

        var cost = function.expressions.count() + function.symbols.count() + 1;

        for (0..function.expressions.count()) |expression_index| {
            const expression = function.expressions.at(expression_index);

            if (expression.value == .call) {
                const child = @backingInt(expression.value.call.function);

                if (child >= index) {
                    cost = limit + 1;

                    break;
                }

                cost +|= costs[child];
            }
        }

        if (cost <= limit) self.costs[index] = cost;
    }

    return self;
}

pub fn accepts(self: Self, id: ir.FunctionId) bool {
    return self.costs[@backingInt(id)] != 0;
}

fn primitive(program: ir.Program, id: ir.TypeId) bool {
    return switch (program.typeOf(id)) {
        .scalar, .enumeration, .error_set, .native_reference => true,
        .optional => |child| primitive(program, child),
        else => false,
    };
}

fn statements(items: ir.Block) bool {
    for (0..items.len) |item_index| {
        const item = items.at(item_index);

        switch (item) {
            .constant, .evaluate, .destructure, .result => {},
            .branch => |branch| if (!statements(branch.yes) or !statements(branch.no)) return false,
            .switch_stmt => |selection| for (0..selection.cases.len) |case_index| {
                const case = selection.cases.at(case_index);

                if (!statements(case.body)) return false;
            },
            .parallel, .store_set => return false,
        }
    }

    return true;
}
