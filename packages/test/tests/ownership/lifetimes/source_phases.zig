const std = @import("std");
const compiler = @import("compiler");
const report = @import("report.zig");
const generated = @import("loan_report");
const Input = std.meta.Child(generated.loan_report.Input);
const Output = generated.loan_report.Output;

pub fn run(allocator: std.mem.Allocator, program: compiler.ir.Program) !Output {
    return report.withInput(allocator, program, execute);
}

fn measured(counter: *std.testing.FailingAllocator, comptime name: []const u8, comptime stage: anytype, input: stage.Input) !stage.Output {
    const bytes = counter.allocated_bytes;
    const allocations = counter.alloc_index;
    const output = try stage.executeIn(counter.allocator(), input);

    std.debug.print("  phase {s}: allocations={d} requested_bytes={d}\n", .{ name, counter.alloc_index - allocations, counter.allocated_bytes - bytes });

    return output;
}

fn execute(allocator: std.mem.Allocator, input: *const Input) !Output {
    var counter = std.testing.FailingAllocator.init(allocator, .{});
    const linear = try measured(&counter, "collect", generated.loan_collect, input);

    try std.testing.expect(linear.supported);

    const last = try measured(&counter, "reads", generated.loan_reads, &.{
        .expressions = input.expressions,
        .bindings = linear.bindings,
        .result = linear.result,
    });

    const prepared: std.meta.Child(generated.loan_access.Input) = .{ .source = input, .linear = linear };
    const access = try measured(&counter, "access", generated.loan_access, &prepared);

    return measured(&counter, "plan", generated.loan_plan, &.{ .source = &prepared, .last = last, .access = access });
}
