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
cache: ?*Cache,
pub fn create(backing: std.mem.Allocator, program: ir.Program, names: generating.Names, cache: ?*Cache) std.mem.Allocator.Error!Self {
    return createExported(backing, program, names, cache, &.{});
}

/// A batch whose `exported` functions the host also calls directly.
pub fn createExported(backing: std.mem.Allocator, program: ir.Program, names: generating.Names, cache: ?*Cache, exported: []const ir.FunctionId) std.mem.Allocator.Error!Self {
    return .{ .backing = backing, .program = program, .names = names, .analysis = try generating.Analysis.createExported(backing, program, exported), .cache = cache };
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

    const key = try fingerprint.createAnalyzed(scratch, self.program, self.names, unit, self.analysis.value);
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
