const std = @import("std");
const dsl = @import("dsl");
const modules = @import("modules.zig");

pub const Source = struct { path: []const u8, source: []const u8 };

pub const Result = struct {
    arena: std.heap.ArenaAllocator,
    parsed: []dsl.XmlResult,
    validated: ?modules.Result = null,
    value: union(enum) { data: []const modules.Module, diagnostic: modules.Diagnostic },
    pub fn deinit(self: *Result) void {
        if (self.validated) |*validated| validated.deinit();
        for (self.parsed) |*parsed| parsed.deinit();

        self.arena.deinit();

        self.* = undefined;
    }
};

pub fn parseModules(allocator: std.mem.Allocator, sources: []const Source) std.mem.Allocator.Error!Result {
    var arena = std.heap.ArenaAllocator.init(allocator);
    var parsed: std.ArrayList(dsl.XmlResult) = .empty;

    errdefer {
        for (parsed.items) |*item| item.deinit();

        arena.deinit();
    }

    const temporary = arena.allocator();
    const inputs = try temporary.alloc(modules.Source, sources.len);

    try parsed.ensureTotalCapacity(temporary, sources.len);

    for (sources, 0..) |source, index| {
        const item = try dsl.parseXml(allocator, source.source);

        parsed.appendAssumeCapacity(item);

        switch (item.value) {
            .diagnostic => |issue| return .{ .arena = arena, .parsed = parsed.items, .value = .{ .diagnostic = .{ .source_index = index, .issue = issue } } },
            .node => |node| inputs[index] = .{ .path = source.path, .node = node },
        }
    }

    const validated = try modules.validate(allocator, inputs);

    return .{ .arena = arena, .parsed = parsed.items, .validated = validated, .value = switch (validated.value) {
        .data => |data| .{ .data = data },
        .diagnostic => |issue| .{ .diagnostic = issue },
    } };
}
