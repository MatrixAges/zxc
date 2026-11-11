const std = @import("std");
const zx = @import("zx");
const Module = @import("../artifact/model.zig").Module;
pub const Error = @import("graph/seed.zig").Error;

pub const Plan = struct {
    order: []const usize,
    paths: []const []const u8 = &.{},
    buckets: []const ?u32 = &.{},
    offsets: []const u64 = &.{},
    targets: []const u64 = &.{},
    pub fn sources(self: Plan, row: usize) []const u64 {
        return self.targets[@intCast(self.offsets[row])..@intCast(self.offsets[row + 1])];
    }
};

pub fn prepare(allocator: std.mem.Allocator, modules: []const Module, entry: []const u8) Error!Plan {
    if (comptime !@import("parser_options").generated_parser) return .{ .order = try @import("graph/seed.zig").order(allocator, modules, entry) };

    const paths = try allocator.alloc([]const u8, modules.len);
    const offsets = try allocator.alloc(u64, modules.len + 1);
    var targets: std.ArrayList([]const u8) = .empty;

    for (modules, paths, offsets[0..modules.len]) |*module, *path, *offset| {
        path.* = module.path;
        offset.* = targets.items.len;

        for (module.dependencies) |dependency| {
            if (dependency.target == .source) try targets.append(allocator, dependency.target.source);
        }
    }

    offsets[modules.len] = targets.items.len;

    const generated = @import("generated_artifact_graph");
    const Input = std.meta.Child(generated.Input);
    const input: Input = .{ .paths = paths, .targets = targets.items, .offsets = offsets, .entry = entry };

    const plan = zx.columns.invoke(generated.executeValue, allocator, &input) catch |err| switch (@as(anyerror, err)) {
        error.OutOfMemory => return error.OutOfMemory,
        else => return error.InvalidModule,
    };

    switch (plan.status) {
        .Invalid => return error.InvalidModule,
        .Missing => return error.MissingModule,
        .Cycle => return error.CyclicDependency,
        .Ready => {},
    }

    const rows = plan.order[0..@intCast(plan.count)];

    return .{
        .order = try rowsAsIndices(allocator, rows),
        .paths = paths,
        .buckets = plan.buckets,
        .offsets = offsets,
        .targets = plan.targets,
    };
}

fn rowsAsIndices(allocator: std.mem.Allocator, rows: []const u64) std.mem.Allocator.Error![]const usize {
    if (comptime @sizeOf(usize) == @sizeOf(u64)) return @ptrCast(rows);

    const result = try allocator.alloc(usize, rows.len);

    for (rows, result) |row, *index| index.* = @intCast(row);

    return result;
}
