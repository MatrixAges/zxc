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
pub fn check(trace: *Trace, lane: Lane, allocator: std.mem.Allocator) Error!bool {
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
            .symbols = try State.Symbols.init(allocator, program.symbols.count()),
            .cached = try State.Cached.init(allocator, program.expressions.count()),
            .calls = .{ .selected = lane.calls, .summaries = trace.summaries, .readers = trace.readers },
            .loops = lane.iterations,
        },
        .output = output,
    };

    try self.state.symbols.set(allocator, 0, try self.state.seed(program.input_type, input));

    var results: std.ArrayList(statements.Result) = .empty;

    if (!try statements.evaluate(&self.state, program.body.block(), &results) or !self.state.valid) return false;
    for (results.items) |result| if (!facts.retains(result.value, self.output, result.version)) return false;

    return results.items.len != 0;
}
