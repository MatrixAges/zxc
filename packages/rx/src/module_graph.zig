const std = @import("std");
const dsl = @import("dsl");
const checks = @import("checks.zig");
const paths = @import("paths.zig");
const modules = @import("modules.zig");
const State = enum { unseen, visiting, done };

const Graph = struct {
    allocator: std.mem.Allocator,
    sources: []const modules.Source,
    entries: []const modules.Module,
    states: []State,
    reporter: *dsl.Reporter,
    source_index: *usize,
    fn visit(self: *Graph, index: usize) dsl.Error!void {
        if (self.states[index] == .done) return;

        self.states[index] = .visiting;

        try self.walk(index, self.sources[index].node);

        self.states[index] = .done;
    }

    fn walk(self: *Graph, owner: usize, node: dsl.ast.Node) dsl.Error!void {
        const key: ?[]const u8 = if (std.mem.eql(u8, node.name, "Import")) "from" else if (std.mem.eql(u8, node.name, "Call") and checks.attribute(node, "service") != null) "service" else null;

        if (key) |attribute| {
            const path = paths.resolve(self.allocator, self.entries[owner].path, checks.attribute(node, attribute).?) catch |err| {
                if (err == error.OutOfMemory) return error.OutOfMemory;

                return self.fail(owner, node, attribute, "Module reference escapes the project root or is not a valid module path");
            };

            defer self.allocator.free(path);

            const target = self.findModule(path) orelse return self.fail(owner, node, attribute, "Referenced module file is not registered");

            if (self.states[target] == .visiting) return self.fail(owner, node, attribute, "Reference creates a circular module dependency");
            try self.visit(target);
        }

        for (node.children) |child| try self.walk(owner, child);
    }
    fn findModule(self: Graph, path: []const u8) ?usize {
        for (self.entries, 0..) |entry, index| {
            if (std.mem.eql(u8, entry.path, path)) return index;
        }

        return null;
    }
    fn fail(self: *Graph, owner: usize, node: dsl.ast.Node, attribute: []const u8, message: []const u8) dsl.Error {
        self.source_index.* = owner;

        return checks.fail(node, attribute, message, self.reporter);
    }
};

pub fn validate(allocator: std.mem.Allocator, sources: []const modules.Source, entries: []const modules.Module, source_index: *usize, reporter: *dsl.Reporter) dsl.Error!void {
    const states = try allocator.alloc(State, sources.len);

    defer allocator.free(states);

    @memset(states, .unseen);

    var graph = Graph{ .allocator = allocator, .sources = sources, .entries = entries, .states = states, .source_index = source_index, .reporter = reporter };

    for (sources, 0..) |_, index| try graph.visit(index);
}
