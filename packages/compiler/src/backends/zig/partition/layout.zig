const std = @import("std");
const zx = @import("zx");
const demand = @import("demand.zig");
pub const available = @import("parser_options").generated_parser;

pub const Input = struct {
    paths: []const []const u8,
    sizes: []const u64,
    callees: []const []const u32,
    variants: []const []const []const u8,
    inline_names: []const []const []const u8,
    top_callees: []const []const u32,
    top_variants: []const []const []const u8,
    count: u32,
};

pub const Root = struct { callees: []const u32, entries: []const u32, variants: []const []const u8 };
pub const Plan = struct { members: []const []const u32, scopes: []const demand.Scope, roots: []const Root };

pub const Owned = struct {
    arena: std.heap.ArenaAllocator,
    value: Plan,
    pub fn deinit(self: *@This()) void {
        self.arena.deinit();

        self.* = undefined;
    }
};

pub fn create(workspace: std.mem.Allocator, input: Input) std.mem.Allocator.Error!Owned {
    if (comptime !available) unreachable;

    var arena = std.heap.ArenaAllocator.init(workspace);

    errdefer arena.deinit();

    const allocator = arena.allocator();
    const entry = @import("generated_partition_layout");
    const Fields = std.meta.Child(entry.Input);

    const fields: Fields = .{
        .paths = input.paths,
        .sizes = input.sizes,
        .callees = input.callees,
        .variants = input.variants,
        .inline_names = input.inline_names,
        .top_callees = input.top_callees,
        .top_variants = input.top_variants,
        .count = input.count,
    };

    const output = zx.columns.invoke(entry.executeValue, allocator, &fields) catch |err| return failure(err);
    const scopes = try allocator.alloc(demand.Scope, output.scopes.len);
    const roots = try allocator.alloc(Root, output.roots.len);

    for (output.scopes, scopes) |source, *scope| scope.* = .{
        .copies = source.copies,
        .stubs = .{ .callees = source.stubs.callees, .variants = source.stubs.variants },
    };

    for (output.roots, roots) |source, *root| root.* = .{ .callees = source.callees, .entries = source.entries, .variants = source.variants };

    return .{ .arena = arena, .value = .{ .members = output.members, .scopes = scopes, .roots = roots } };
}

fn failure(err: anyerror) std.mem.Allocator.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => @panic("invalid partition layout input"),
    };
}
