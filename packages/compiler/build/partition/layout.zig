const std = @import("std");
const generation = @import("compiler").zig.partition;
const Scanning = @import("scanning.zig");
const parallel = @import("../parallel.zig");

pub const File = struct { path: []const u8, source: []const u8 };

/// Groups public entry closures into compilation units. Source builds retain ordinary calls throughout
/// each closure; only the top-level module crosses the static ABI. The initial seed keeps its hashed layout.
pub fn plan(io: std.Io, allocator: std.mem.Allocator, workspace: std.mem.Allocator, functions: []const File, top: []const File, count: u32) ![]File {
    if (comptime !generation.groups.available or !generation.layout.available) return @import("layout_seed.zig").plan(io, allocator, workspace, functions, top, count);

    const paths = try allocator.alloc([]const u8, functions.len);

    for (functions, paths) |function, *path| path.* = function.path;

    const scanner = try generation.Scanning.init(allocator, paths);
    const arenas = try parallel.Arenas.init(io, allocator, functions.len);

    defer arenas.deinit();

    const scanning = try Scanning.run(allocator, arenas, functions, &scanner);
    const callees = try allocator.alloc([]const u32, functions.len);
    const variants = try allocator.alloc([]const []const u8, functions.len);

    for (scanning.references, callees, variants) |reference, *ids, *names| {
        ids.* = reference.callees;
        names.* = reference.variants;
    }

    const top_callees = try allocator.alloc([]const u32, top.len);
    const top_variants = try allocator.alloc([]const []const u8, top.len);

    for (top, top_callees, top_variants) |file, *ids, *names| {
        const reference = try scanner.references(allocator, file.source);
        ids.* = reference.callees;
        names.* = reference.variants;
    }

    const sizes = try allocator.alloc(u64, functions.len);

    for (functions, sizes) |function, *size| size.* = @intCast(function.source.len);

    var planned = try generation.layout.create(workspace, .{
        .paths = paths,
        .sizes = sizes,
        .callees = callees,
        .variants = variants,
        .inline_names = scanning.inline_names,
        .top_callees = top_callees,
        .top_variants = top_variants,
        .count = count,
    });

    defer planned.deinit();

    const scopes = planned.value.scopes;
    var files: std.ArrayList(File) = .empty;

    for (planned.value.members, 0..) |members, index| {
        for (members) |callee| try files.append(allocator, .{
            .path = try directory(allocator, @intCast(index), count, functions[callee].path),
            .source = functions[callee].source,
        });
    }

    for (scopes, 0..) |scope, index| {
        for (scope.copies) |callee| try files.append(allocator, .{ .path = try directory(allocator, @intCast(index), count, functions[callee].path), .source = functions[callee].source });
    }

    for (scopes, 0..) |scope, index| {
        for (scope.stubs.callees, scope.stubs.variants) |callee, names| {
            const function = functions[callee];

            try files.append(allocator, .{
                .path = try directory(allocator, @intCast(index), count, function.path),
                .source = try generation.stubBacked(allocator, workspace, function.path, names, index == count),
            });
        }
    }

    const roots = Roots{ .workspace = workspace, .functions = functions, .plans = planned.value.roots, .sources = try allocator.alloc([]const u8, count), .modules = try allocator.alloc([]const u8, count) };

    try parallel.each(arenas, count, &roots);

    for (roots.sources, 0..) |source, index| {
        try files.append(allocator, .{ .path = try std.fmt.allocPrint(allocator, "part_{d}/root.zig", .{index}), .source = try allocator.dupe(u8, source) });
        try files.append(allocator, .{ .path = try std.fmt.allocPrint(allocator, "part_{d}/functions.zig", .{index}), .source = try allocator.dupe(u8, roots.modules[index]) });
    }

    return files.items;
}

/// The root of each partition, exporting its functions called from outside it in name order.
const Roots = struct {
    workspace: std.mem.Allocator,
    functions: []const File,
    plans: []const generation.layout.Root,
    sources: [][]const u8,
    modules: [][]const u8,
    pub fn step(self: *const Roots, allocator: std.mem.Allocator, index: usize) !void {
        var entries: std.ArrayList(generation.Export) = .empty;
        var modules: std.ArrayList(generation.Module) = .empty;
        const selected = self.plans[index];

        for (selected.callees) |callee| {
            const name = self.functions[callee].path;

            try modules.append(allocator, .{ .name = std.fs.path.stem(name), .file = name });
        }

        for (selected.entries, selected.variants) |callee, variant| try entries.append(allocator, .{ .file = self.functions[callee].path, .variant = variant });

        self.sources[index] = try generation.exportsBacked(allocator, self.workspace, entries.items);
        self.modules[index] = try generation.rootBacked(allocator, self.workspace, modules.items, false);
    }
};

fn directory(allocator: std.mem.Allocator, scope: u32, count: u32, name: []const u8) ![]const u8 {
    if (scope == count) return name;

    return std.fmt.allocPrint(allocator, "part_{d}/{s}", .{ scope, name });
}
