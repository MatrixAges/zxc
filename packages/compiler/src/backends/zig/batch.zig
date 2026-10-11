const std = @import("std");
const ir = @import("zx").ir;
const genz = @import("genz");
const generating = genz.zx.modules;
const fingerprint = @import("fingerprint.zig");
const Cache = @import("cache.zig");
const Self = @This();

backing: std.mem.Allocator,
program: ir.Program,
names: generating.Names,
analysis: generating.Analysis.Owned,
fresh: []const genz.zx.buffer_call.fresh.Paths,
cache: ?*Cache,
pub fn create(backing: std.mem.Allocator, program: ir.Program, names: generating.Names, cache: ?*Cache) std.mem.Allocator.Error!Self {
    var analysis = try generating.Analysis.create(backing, program);

    errdefer analysis.deinit();

    const fresh = if (cache != null) try freshOutputs(backing, analysis.arena.allocator(), program, analysis.value) else &.{};

    return .{ .backing = backing, .program = program, .names = names, .analysis = analysis, .fresh = fresh, .cache = cache };
}

pub fn deinit(self: *Self) void {
    self.analysis.deinit();

    self.* = undefined;
}

pub const Lookup = struct { name: []const u8, key: [32]u8, source: ?[]const u8 };

pub fn emit(self: *const Self, owned: std.mem.Allocator, unit: generating.Unit) generating.Error![]const u8 {
    if (self.cache == null) return self.generate(owned, self.backing, unit);

    var scratch = std.heap.ArenaAllocator.init(self.backing);

    defer scratch.deinit();

    const found = try self.lookup(scratch.allocator(), unit);

    if (found.source) |source| return owned.dupe(u8, source);

    const source = try self.generate(owned, self.backing, unit);

    errdefer owned.free(source);

    try self.remember(found, source);

    return source;
}

/// Cache identity and cached source of one unit; names and keys live in `scratch`.
pub fn lookup(self: *const Self, scratch: std.mem.Allocator, unit: generating.Unit) generating.Error!Lookup {
    const name = switch (unit) {
        .function => |id| self.names.functions[@backingInt(id)],
        .entry, .types => try std.fmt.allocPrint(scratch, "{s}:{s}", .{ @tagName(unit), self.program.file_name }),
    };

    const key = try fingerprint.createAnalyzed(scratch, self.program, self.names, unit, self.analysis.value, self.fresh);
    const source = if (self.cache) |store| try store.get(name, key) else null;

    return .{ .name = name, .key = key, .source = source };
}

/// Pure generation of one unit; threads may share a batch when each passes its own `owned` and a thread-safe `backing`.
pub fn generate(self: *const Self, owned: std.mem.Allocator, backing: std.mem.Allocator, unit: generating.Unit) generating.Error![]const u8 {
    return generating.analyzed(owned, backing, self.program, self.names, unit, self.analysis.value);
}

pub fn remember(self: *const Self, found: Lookup, source: []const u8) std.mem.Allocator.Error!void {
    const store = self.cache orelse return;
    store.generated += 1;

    try store.put(found.name, found.key, source);
}

fn freshOutputs(backing: std.mem.Allocator, owned: std.mem.Allocator, program: ir.Program, analysis: generating.Analysis) std.mem.Allocator.Error![]const genz.zx.buffer_call.fresh.Paths {
    const fresh = genz.zx.buffer_call.fresh;
    const result = try owned.alloc(fresh.Paths, program.functions.count());
    const facts = fresh.Facts{ .program = program, .pure = analysis.value.pure, .allocated = analysis.allocated };

    for (result, 0..) |*selected, index| {
        var scratch = std.heap.ArenaAllocator.init(backing);

        defer scratch.deinit();

        const paths = try fresh.paths(facts, scratch.allocator(), @fromBackingInt(@intCast(index)));
        const saved = try owned.alloc([]const u32, paths.len);

        for (paths, saved) |path, *target| target.* = try owned.dupe(u32, path);

        selected.* = saved;
    }

    return result;
}
