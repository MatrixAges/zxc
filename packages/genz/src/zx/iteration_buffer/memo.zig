const std = @import("std");
const ir = @import("zx").ir;
const Lower = @import("../lower.zig");
const analysis = @import("analysis.zig");
const Self = @This();
const Key = struct { expressions: usize, count: usize, body: ir.ExprId, path: []const usize };

const Context = struct {
    pub fn hash(_: @This(), key: Key) u64 {
        var value = std.hash.Wyhash.init(key.expressions);

        value.update(std.mem.asBytes(&key.count));
        value.update(std.mem.asBytes(&key.body));
        value.update(std.mem.sliceAsBytes(key.path));

        return value.final();
    }

    pub fn eql(_: @This(), left: Key, right: Key) bool {
        return left.expressions == right.expressions and left.count == right.count and left.body == right.body and std.mem.eql(usize, left.path, right.path);
    }
};

entries: std.HashMapUnmanaged(Key, ?analysis.Result, Context, std.hash_map.default_max_load_percentage) = .empty,
readers: ?[]const bool = null,
/// Loop buffer discovery reads only the lowered body, the loop path and fixed call summaries, so every variant of one body shares it.
pub fn discover(lowering: *Lower, iteration: ir.Iteration, path: []const usize) Lower.Error!?analysis.Result {
    const self = &lowering.iteration_analyses;
    const key = Key{ .expressions = @intFromPtr(lowering.program.expressions.kinds.ptr), .count = lowering.program.expressions.count(), .body = iteration.body, .path = path };

    if (self.entries.get(key)) |found| return found;

    const result = try analysis.analyzeWithCalls(lowering.allocator, lowering.workspace, lowering.program, iteration, path, .{ .selected = &.{}, .summaries = lowering.buffer_functions, .readers = try self.functionReaders(lowering), .discover = true });

    try self.entries.put(lowering.allocator, .{ .expressions = key.expressions, .count = key.count, .body = key.body, .path = try lowering.allocator.dupe(usize, path) }, result);

    return result;
}

/// Pure functions whose output cannot alias a list buffer.
pub fn functionReaders(self: *Self, lowering: *Lower) Lower.Error![]const bool {
    if (self.readers) |found| return found;

    const program = lowering.program;
    const found = try lowering.allocator.alloc(bool, program.functions.count());

    for (found, 0..) |*reader, index| {
        reader.* = index < lowering.pure_functions.len and lowering.pure_functions[index] and @import("../buffer_call/analysis/flow.zig").detached(program, program.functions.at(index).output_type);
    }

    self.readers = found;

    return found;
}
