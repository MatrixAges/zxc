const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const node = @import("../../node.zig");
const view = @import("../../node/view.zig");
const Lower = @import("../lower.zig");
pub const generated = @import("genz_options").generated_analysis;

pub const Observation = struct {
    evaluation: []const ir.ExprId,
    prior: []const u64,
    references: []const node.ExpressionId,
};

pub fn bind(self: *Lower, scratch: std.mem.Allocator, body: *std.ArrayList(node.Statement), names: []const []const u8, values: []const u32) Lower.Error!void {
    if (names.len == 0) return;

    const entry = @import("generated_aggregate_operand_bindings");
    const input: std.meta.Child(entry.Input) = .{ .names = names, .values = values };

    try emit(self, scratch, body, entry, &input);
}

pub fn retire(self: *Lower, scratch: std.mem.Allocator, body: *std.ArrayList(node.Statement), observation: Observation) Lower.Error!void {
    if (observation.evaluation.len == 0) return;

    if (!generated) {
        for (observation.evaluation, observation.prior, observation.references) |item, prior, reference| {
            if (self.cache_reads[@backingInt(item)] == prior) try body.append(self.allocator, .{ .discard = reference });
        }

        return;
    }

    const entry = @import("generated_aggregate_operand_retirement");
    const Input = std.meta.Child(entry.Input);

    const input: Input = .{
        .evaluation = view.slice(@FieldType(Input, "evaluation"), observation.evaluation),
        .prior = observation.prior,
        .reads = self.cache_reads,
        .references = view.slice(@FieldType(Input, "references"), observation.references),
    };

    try emit(self, scratch, body, entry, &input);
}

fn emit(self: *Lower, scratch: std.mem.Allocator, body: *std.ArrayList(node.Statement), comptime entry: type, input: *const std.meta.Child(entry.Input)) Lower.Error!void {
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var memory = std.heap.BufferFirstAllocator.init(&buffer, scratch);
    const output = zx.columns.invoke(entry.executeValue, memory.allocator(), input) catch |err| return failure(err);
    const statements = zx.columns.view(std.meta.Child(entry.Output), output);

    if (statements.tags.len == 0) return;
    @import("../../node/import_statements.zig").appendBorrowingText(self.allocator, body, &statements) catch |err| return failure(err);
}

fn failure(err: anyerror) Lower.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => unreachable,
    };
}
