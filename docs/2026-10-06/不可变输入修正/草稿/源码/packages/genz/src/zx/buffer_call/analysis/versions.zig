const std = @import("std");
const ir = @import("zx").ir;
const Trace = @import("trace.zig");
const Lane = @import("flow.zig").Lane;
const State = @import("../../iteration_buffer/analysis.zig");
const facts = @import("../../iteration_buffer/fact.zig");
const Self = @This();
const Error = std.mem.Allocator.Error;

state: State,
output: []const usize,
pub fn check(trace: *Trace, lane: Lane) Error!bool {
    var arena = std.heap.ArenaAllocator.init(trace.allocator);

    defer arena.deinit();

    const allocator = arena.allocator();
    var program = trace.program;
    program.input_type = trace.function.input_type;
    program.output_type = trace.function.output_type;
    program.symbols = trace.function.symbols;
    program.expressions = trace.function.expressions;
    program.body = trace.function.body;

    const input = try allocator.alloc(usize, lane.input.len);
    const output = try allocator.alloc(usize, lane.output.len);

    for (lane.input, input) |part, *value| value.* = part;
    for (lane.output, output) |part, *value| value.* = part;

    var self = Self{
        .state = .{
            .allocator = allocator,
            .program = program,
            .symbols = try allocator.alloc(facts.Value, program.symbols.len),
            .cached = try allocator.alloc(?facts.Value, program.expressions.len),
            .calls = .{ .selected = lane.calls, .summaries = trace.summaries, .readers = trace.readers },
        },
        .output = output,
    };

    @memset(self.state.symbols, .none);
    @memset(self.state.cached, null);

    self.state.symbols[0] = try self.state.seed(program.input_type, input);

    return try self.block(program.body) and self.state.valid;
}

fn block(self: *Self, statements: []const ir.Statement) Error!bool {
    for (statements) |statement| {
        if (!self.state.valid) return true;

        switch (statement) {
            .evaluate => |id| _ = try self.state.expression(id),
            .constant => |binding| self.state.symbols[@backingInt(binding.symbol)] = try self.state.expression(binding.value),
            .destructure => |binding| {
                const value = try self.state.expression(binding.value);

                for (binding.symbols, 0..) |symbol, index| if (symbol) |id| {
                    self.state.symbols[@backingInt(id)] = facts.field(value, @intCast(index));
                };
            },
            .result => |id| {
                const value = if (id) |value| try self.state.expression(value) else facts.Value.none;
                self.state.valid = self.state.valid and self.state.retains(value, self.output);

                return true;
            },
            .branch => |branch| {
                self.state.observe(try self.state.expression(branch.condition));

                const before = try self.state.snapshot();
                const yes_returns = try self.block(branch.yes);
                const yes = try self.state.snapshot();

                self.state.restore(before);

                const no_returns = try self.block(branch.no);

                if (yes_returns and no_returns) return true;
                if (!yes_returns and no_returns) self.state.restore(yes);
                if (!yes_returns and !no_returns) _ = try self.state.join(yes, .none, .none);
            },
            .switch_stmt => |selection| {
                self.state.observe(try self.state.expression(selection.subject));

                const before = try self.state.snapshot();
                var combined: ?@TypeOf(before) = if (selection.exhaustive) null else before;

                for (selection.cases) |case| {
                    self.state.restore(before);

                    if (try self.block(case.body)) continue;
                    if (combined) |previous| _ = try self.state.join(previous, .none, .none);

                    combined = try self.state.snapshot();
                }

                if (combined) |remaining| self.state.restore(remaining) else return true;
            },
            .store_set, .parallel => {
                self.state.valid = false;

                return true;
            },
        }
    }

    return false;
}
