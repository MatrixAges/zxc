const std = @import("std");
const zx = @import("zx");
const options = @import("genz_options");
pub const available = if (@hasDecl(options, "partition_groups")) options.partition_groups else options.generated_analysis;

pub const Input = struct {
    callees: []const []const u32,
    sizes: []const u64,
    roots: []const u32,
    partitions: u32,
};

pub const Plan = struct {
    owners: []const u64,
    members: []const []const u32,
};

pub fn plan(allocator: std.mem.Allocator, graph: Input) std.mem.Allocator.Error!Plan {
    if (!available) unreachable;

    const generated = @import("generated_partition_groups");
    const Fields = std.meta.Child(generated.Input);

    const input: Fields = .{
        .callees = graph.callees,
        .sizes = graph.sizes,
        .roots = graph.roots,
        .partitions = graph.partitions,
    };

    const output = zx.columns.invoke(generated.executeValue, allocator, &input) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => std.debug.panic("partition grouping failed: {s}", .{@errorName(err)}),
    };

    return .{ .owners = output.owners, .members = output.members };
}
