const std = @import("std");
const generation = @import("compiler").zig.partition;
const Scanning = @import("scanning.zig");
const parallel = @import("../parallel.zig");
pub const File = @import("layout.zig").File;

const Exported = struct { callee: u32, variants: []const []const u8 };

/// Groups public entry closures into compilation units. Source builds retain ordinary calls throughout
/// each closure; only the top-level module crosses the static ABI. The initial seed keeps its hashed layout.
pub fn plan(io: std.Io, allocator: std.mem.Allocator, workspace: std.mem.Allocator, functions: []const File, top: []const File, count: u32) ![]File {
    const paths = try allocator.alloc([]const u8, functions.len);

    for (functions, paths) |function, *path| path.* = function.path;

    const scanner = try generation.Scanning.init(allocator, paths);
    const partitions = try allocator.alloc(u32, functions.len);

    for (functions, partitions) |function, *owner| owner.* = partition(function.path, count);

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

    var planned = try generation.demand.createSeed(workspace, .{
        .owners = partitions,
        .callees = callees,
        .variants = variants,
        .inline_names = scanning.inline_names,
        .top_callees = top_callees,
        .top_variants = top_variants,
        .count = count,
        .seed = !generation.groups.available,
    });

    defer planned.deinit();

    const scopes = planned.value.scopes;
    const exports = try allocator.alloc(Exported, planned.value.exports.callees.len);

    for (exports, planned.value.exports.callees, planned.value.exports.variants) |*row, callee, names| row.* = .{ .callee = callee, .variants = names };

    std.mem.sortUnstable(Exported, exports, SortByName{ .functions = functions }, SortByName.lessThan);

    const exported_ids = try allocator.alloc(u32, exports.len);

    for (exports, exported_ids) |row, *id| id.* = row.callee;

    var files: std.ArrayList(File) = .empty;

    if (generation.groups.available) {
        const sizes = try allocator.alloc(u64, functions.len);

        for (functions, sizes) |function, *size| size.* = @intCast(function.source.len);

        const grouped = try generation.groups.plan(allocator, .{ .callees = callees, .sizes = sizes, .roots = exported_ids, .partitions = count });

        for (exported_ids, grouped.owners) |root, owner| partitions[root] = @intCast(owner);

        for (grouped.members, 0..) |members, index| {
            for (members) |callee| try files.append(allocator, .{
                .path = try directory(allocator, @intCast(index), count, functions[callee].path),
                .source = functions[callee].source,
            });
        }
    } else {
        for (functions, partitions) |function, owner| try files.append(allocator, .{ .path = try directory(allocator, owner, count, function.path), .source = function.source });
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

    const roots = Roots{ .workspace = workspace, .functions = functions, .partitions = partitions, .exports = exports, .sources = try allocator.alloc([]const u8, count), .modules = try allocator.alloc([]const u8, count) };

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
    partitions: []const u32,
    exports: []const Exported,
    sources: [][]const u8,
    modules: [][]const u8,
    pub fn step(self: *const Roots, allocator: std.mem.Allocator, index: usize) !void {
        var entries: std.ArrayList(generation.Export) = .empty;
        var modules: std.ArrayList(generation.Module) = .empty;

        for (self.exports) |exported| {
            const callee = exported.callee;

            if (self.partitions[callee] != index) continue;

            const name = self.functions[callee].path;

            try modules.append(allocator, .{ .name = std.fs.path.stem(name), .file = name });
            for (exported.variants) |variant| try entries.append(allocator, .{ .file = name, .variant = variant });
        }

        self.sources[index] = try generation.exportsBacked(allocator, self.workspace, entries.items);
        self.modules[index] = try generation.rootBacked(allocator, self.workspace, modules.items, false);
    }
};

fn partition(name: []const u8, count: u32) u32 {
    return @intCast(std.hash.Wyhash.hash(0, name) % count);
}

fn directory(allocator: std.mem.Allocator, scope: u32, count: u32, name: []const u8) ![]const u8 {
    if (scope == count) return name;

    return std.fmt.allocPrint(allocator, "part_{d}/{s}", .{ scope, name });
}

const SortByName = struct {
    functions: []const File,
    pub fn lessThan(self: SortByName, left: Exported, right: Exported) bool {
        return std.mem.lessThan(u8, self.functions[left.callee].path, self.functions[right.callee].path);
    }
};
