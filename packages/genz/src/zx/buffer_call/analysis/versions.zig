const std = @import("std");
const Trace = @import("trace.zig");
const Lane = @import("flow.zig").Lane;
const State = @import("../../iteration_buffer/analysis.zig");
const facts = @import("../../iteration_buffer/fact.zig");
const statements = @import("../../iteration_buffer/statements.zig");
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
            .loops = lane.iterations,
        },
        .output = output,
    };

    @memset(self.state.symbols, .none);
    @memset(self.state.cached, null);

    self.state.symbols[0] = try self.state.seed(program.input_type, input);
    var results: std.ArrayList(statements.Result) = .empty;

    if (!try statements.evaluate(&self.state, program.body, &results) or !self.state.valid) return false;
    for (results.items) |result| if (!facts.retains(result.value, self.output, result.version)) return false;

    return results.items.len != 0;
}
