const std = @import("std");
const dsl = @import("dsl");
const flow = @import("flow.zig");
const paths = @import("paths.zig");
const graph = @import("module_graph.zig");

pub const Source = struct {
    path: []const u8,
    node: dsl.ast.Node,
    packages: []const @import("frontend").project.Package = &.{},
};

pub const Module = struct {
    path: []const u8,
    data: flow.Module.Data,
};

pub const Diagnostic = struct {
    source_index: usize,
    issue: dsl.Diagnostic,
};

pub const Result = struct {
    arena: std.heap.ArenaAllocator,
    dependency_order: []const usize = &.{},
    value: union(enum) {
        data: []const Module,
        diagnostic: Diagnostic,
    },
    pub fn deinit(self: *Result) void {
        self.arena.deinit();

        self.* = undefined;
    }
};

pub fn validate(allocator: std.mem.Allocator, sources: []const Source) std.mem.Allocator.Error!Result {
    var arena = std.heap.ArenaAllocator.init(allocator);

    errdefer arena.deinit();

    var reporter: dsl.Reporter = .{};
    var source_index: usize = 0;

    const data = decode(arena.allocator(), sources, &source_index, &reporter) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return .{ .arena = arena, .value = .{ .diagnostic = .{ .source_index = source_index, .issue = reporter.diagnostic.? } } };
    };

    return .{ .arena = arena, .dependency_order = data.dependency_order, .value = .{ .data = data.modules } };
}

const Decoded = struct { modules: []const Module, dependency_order: []const usize };

fn decode(allocator: std.mem.Allocator, sources: []const Source, source_index: *usize, reporter: *dsl.Reporter) dsl.Error!Decoded {
    const data = try allocator.alloc(Module, sources.len);

    for (sources, 0..) |source, index| {
        source_index.* = index;

        const path = paths.normalize(allocator, source.path) catch |err| {
            if (err == error.OutOfMemory) return error.OutOfMemory;

            return fail(source.node, "Module registration requires a project relative .rx file path inside the project root", reporter);
        };

        for (data[0..index]) |previous| {
            if (std.mem.eql(u8, previous.path, path)) return fail(source.node, "Module file path is already registered", reporter);
        }

        data[index] = .{ .path = path, .data = try flow.Module.decode(allocator, source.node, reporter, {}) };
    }

    const order = try graph.validate(allocator, sources, data, source_index, reporter);

    return .{ .modules = data, .dependency_order = order };
}

fn fail(node: dsl.ast.Node, message: []const u8, reporter: *dsl.Reporter) dsl.Error {
    return reporter.fail(.{ .code = .context, .location = node.location, .element = node.name, .message = message });
}
