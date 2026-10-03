const std = @import("std");
const dsl = @import("dsl");
const checks = @import("checks.zig");
const paths = @import("paths.zig");
const modules = @import("modules.zig");
const State = enum { unseen, visiting, done };

const Frame = struct {
    owner: usize,
    node: *const dsl.ast.Node,
    child_index: usize = 0,
    entered: bool = false,
    root: bool = false,
};

const Graph = struct {
    allocator: std.mem.Allocator,
    sources: []const modules.Source,
    entries: []const modules.Module,
    states: []State,
    reporter: *dsl.Reporter,
    source_index: *usize,
    fn visit(self: *Graph, index: usize) dsl.Error!void {
        if (self.states[index] == .done) return;

        var frames: std.ArrayList(Frame) = .empty;

        defer frames.deinit(self.allocator);

        try self.enterModule(index, &frames);

        while (frames.items.len > 0) {
            const frame = &frames.items[frames.items.len - 1];

            if (!frame.entered) {
                frame.entered = true;

                if (try self.target(frame.owner, frame.node.*)) |next| {
                    try self.enterModule(next, &frames);

                    continue;
                }
            }

            if (frame.child_index < frame.node.children.len) {
                const child = &frame.node.children[frame.child_index];
                const owner = frame.owner;
                frame.child_index += 1;

                try frames.append(self.allocator, .{ .owner = owner, .node = child });

                continue;
            }

            if (frame.root) self.states[frame.owner] = .done;

            _ = frames.pop();
        }
    }

    fn enterModule(self: *Graph, index: usize, frames: *std.ArrayList(Frame)) dsl.Error!void {
        self.states[index] = .visiting;

        try frames.append(self.allocator, .{ .owner = index, .node = &self.sources[index].node, .root = true });
    }

    fn target(self: *Graph, owner: usize, node: dsl.ast.Node) dsl.Error!?usize {
        const key: ?[]const u8 = if (std.mem.eql(u8, node.name, "Import")) "from" else if (std.mem.eql(u8, node.name, "Call") and checks.attribute(node, "service") != null) "service" else null;

        if (key) |attribute| {
            const path = paths.resolve(self.allocator, self.entries[owner].path, checks.attribute(node, attribute).?) catch |err| {
                if (err == error.OutOfMemory) return error.OutOfMemory;

                return self.fail(owner, node, attribute, "Module reference escapes the project root or is not a valid module path");
            };

            defer self.allocator.free(path);

            const index = self.findModule(path) orelse return self.fail(owner, node, attribute, "Referenced module file is not registered");

            if (self.states[index] == .visiting) return self.fail(owner, node, attribute, "Reference creates a circular module dependency");

            return if (self.states[index] == .done) null else index;
        }

        return null;
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
