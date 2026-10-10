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

pub fn emit(self: *const Self, owned: std.mem.Allocator, unit: generating.Unit) generating.Error![]const u8 {
    const store = self.cache orelse return generating.analyzed(owned, self.backing, self.program, self.names, unit, self.analysis.value);
    var scratch = std.heap.ArenaAllocator.init(self.backing);

    defer scratch.deinit();

    const temporary = scratch.allocator();

    const name = switch (unit) {
        .function => |id| self.names.functions[@backingInt(id)],
        .entry, .types => try std.fmt.allocPrint(temporary, "{s}:{s}", .{ @tagName(unit), self.program.file_name }),
    };

    const key = try fingerprint.createAnalyzed(temporary, self.program, self.names, unit, self.analysis.value, self.fresh);

    if (try store.get(name, key)) |source| return owned.dupe(u8, source);

    const source = try generating.analyzed(owned, self.backing, self.program, self.names, unit, self.analysis.value);

    errdefer owned.free(source);

    store.generated += 1;

    try store.put(name, key, source);

    return source;
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
