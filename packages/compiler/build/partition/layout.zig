const std = @import("std");
const generation = @import("compiler").zig.partition;
const Scanning = @import("scanning.zig");
const parallel = @import("../parallel.zig");
pub const File = struct { path: []const u8, source: []const u8 };
const Variants = std.ArrayList([]const u8);
const Demands = std.AutoArrayHashMapUnmanaged(u32, Variants);
const Copies = std.AutoArrayHashMapUnmanaged(u32, void);

/// Groups public entry closures into compilation units. Source builds retain ordinary calls throughout
/// each closure; only the top-level module crosses the static ABI. The initial seed keeps its hashed layout.
pub fn plan(io: std.Io, allocator: std.mem.Allocator, functions: []const File, top: []const File, count: u32) ![]File {
    var indices: @import("compiler").bytes.Map(u32) = .empty;

    try indices.ensureTotalCapacity(allocator, @intCast(functions.len));
    for (functions, 0..) |function, index| indices.putAssumeCapacity(function.path, @intCast(index));

    const partitions = try allocator.alloc(u32, functions.len);

    for (functions, partitions) |function, *owner| owner.* = partition(function.path, count);

    const arenas = try parallel.Arenas.init(io, allocator, functions.len);

    defer arenas.deinit();

    const scanning = try Scanning.run(allocator, arenas, functions, &indices);

    var scopes = Scopes{
        .allocator = allocator,
        .partitions = partitions,
        .references = scanning.references,
        .inline_names = scanning.inline_names,
        .stubs = try allocator.alloc(Demands, count + 1),
        .copies = try allocator.alloc(Copies, count + 1),
    };

    @memset(scopes.stubs, .empty);
    @memset(scopes.copies, .empty);

    if (!generation.groups.available) {
        for (partitions, scanning.references) |owner, references| try scopes.demand(owner, references);
    }

    for (top) |file| try scopes.demand(count, try Scanning.scan(allocator, file.source, &indices));

    var exports = scopes.exports;
    var files: std.ArrayList(File) = .empty;

    exports.sortUnstable(SortByName{ .keys = exports.keys(), .functions = functions });

    if (generation.groups.available) {
        const callees = try allocator.alloc([]const u32, functions.len);
        const sizes = try allocator.alloc(u64, functions.len);

        for (scanning.references, functions, callees, sizes) |references, function, *row, *size| {
            const ids = try allocator.alloc(u32, references.len);

            for (references, ids) |reference, *id| id.* = reference.callee;

            row.* = ids;
            size.* = @intCast(function.source.len);
        }

        const grouped = try generation.groups.plan(allocator, .{ .callees = callees, .sizes = sizes, .roots = exports.keys(), .partitions = count });

        for (exports.keys(), grouped.owners) |root, owner| partitions[root] = @intCast(owner);

        for (grouped.members, 0..) |members, index| {
            for (members) |callee| try files.append(allocator, .{
                .path = try directory(allocator, @intCast(index), count, functions[callee].path),
                .source = functions[callee].source,
            });
        }
    } else {
        for (functions, partitions) |function, owner| try files.append(allocator, .{ .path = try directory(allocator, owner, count, function.path), .source = function.source });
    }

    for (scopes.copies, 0..) |copies, index| {
        for (copies.keys()) |callee| try files.append(allocator, .{ .path = try directory(allocator, @intCast(index), count, functions[callee].path), .source = functions[callee].source });
    }

    for (scopes.stubs, 0..) |scope, index| {
        for (scope.keys(), scope.values()) |callee, variants| {
            if (scopes.copies[index].contains(callee)) continue;

            const function = functions[callee];

            try files.append(allocator, .{
                .path = try directory(allocator, @intCast(index), count, function.path),
                .source = try generation.stub(allocator, function.path, variants.items, index == count),
            });
        }
    }

    const roots = Roots{ .functions = functions, .partitions = partitions, .exports = &exports, .sources = try allocator.alloc([]const u8, count), .modules = try allocator.alloc([]const u8, count) };

    try parallel.each(arenas, count, &roots);

    for (roots.sources, 0..) |source, index| {
        try files.append(allocator, .{ .path = try std.fmt.allocPrint(allocator, "part_{d}/root.zig", .{index}), .source = try allocator.dupe(u8, source) });
        try files.append(allocator, .{ .path = try std.fmt.allocPrint(allocator, "part_{d}/functions.zig", .{index}), .source = try allocator.dupe(u8, roots.modules[index]) });
    }

    return files.items;
}

/// The root of each partition, exporting its functions called from outside it in name order.
const Roots = struct {
    functions: []const File,
    partitions: []const u32,
    exports: *const Demands,
    sources: [][]const u8,
    modules: [][]const u8,
    pub fn step(self: *const Roots, allocator: std.mem.Allocator, index: usize) !void {
        var entries: std.ArrayList(generation.Export) = .empty;
        var modules: std.ArrayList(generation.Module) = .empty;

        for (self.exports.keys(), self.exports.values()) |callee, variants| {
            if (self.partitions[callee] != index) continue;

            const name = self.functions[callee].path;

            try modules.append(allocator, .{ .name = std.fs.path.stem(name), .file = name });
            for (variants.items) |variant| try entries.append(allocator, .{ .file = name, .variant = variant });
        }

        self.sources[index] = try generation.exports(allocator, entries.items);
        self.modules[index] = try generation.root(allocator, modules.items, false);
    }
};

fn partition(name: []const u8, count: u32) u32 {
    return @intCast(std.hash.Wyhash.hash(0, name) % count);
}

fn directory(allocator: std.mem.Allocator, scope: u32, count: u32, name: []const u8) ![]const u8 {
    if (scope == count) return name;

    return std.fmt.allocPrint(allocator, "part_{d}/{s}", .{ scope, name });
}

/// Functions are referred to by their index in the planned function list.
const Scopes = struct {
    allocator: std.mem.Allocator,
    partitions: []const u32,
    references: []const []const Scanning.Reference,
    inline_names: []const []const []const u8,
    stubs: []Demands,
    copies: []Copies,
    exports: Demands = .empty,
    /// Records every call from `scope` into a function owned by another scope.
    fn demand(self: *Scopes, scope: u32, calls: []const Scanning.Reference) !void {
        for (calls) |call| {
            if (self.partitions[call.callee] == scope) continue;

            const seed_import = !generation.groups.available and self.references[call.callee].len <= 1;

            if (seed_import or inlined(self.inline_names[call.callee], call.variant)) {
                if ((try self.copies[scope].getOrPut(self.allocator, call.callee)).found_existing) continue;
                try self.demand(scope, self.references[call.callee]);

                continue;
            }

            try add(self.allocator, &self.stubs[scope], call.callee, call.variant);
            try add(self.allocator, &self.exports, call.callee, call.variant);
        }
    }
};

fn inlined(names: []const []const u8, variant: []const u8) bool {
    for (names) |name| if (std.mem.eql(u8, name, variant)) return true;

    return false;
}

fn add(allocator: std.mem.Allocator, demands: *Demands, callee: u32, variant: []const u8) !void {
    const entry = try demands.getOrPut(allocator, callee);

    if (!entry.found_existing) entry.value_ptr.* = .empty;
    for (entry.value_ptr.items) |known| if (std.mem.eql(u8, known, variant)) return;
    try entry.value_ptr.append(allocator, variant);
}

const SortByName = struct {
    keys: []const u32,
    functions: []const File,
    pub fn lessThan(self: SortByName, left: usize, right: usize) bool {
        return std.mem.lessThan(u8, self.functions[self.keys[left]].path, self.functions[self.keys[right]].path);
    }
};
