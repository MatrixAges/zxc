const std = @import("std");
const dsl = @import("dsl");
const flow = @import("flow.zig");
const paths = @import("paths.zig");
const graph = @import("module_graph.zig");
const references = @import("frontend").xml_references;
const generated_graph = @import("rx_options").generated_graph;
pub const Registry = if (generated_graph) @import("frontend").project.source_index.Map else void;
pub const IndexedFlow = references.Flow;
pub const ValidatedSchema = opaque {};

pub const Source = struct {
    path: []const u8,
    node: dsl.ast.Node,
    packages: []const @import("frontend").project.Package = &.{},
    references: ?*const references.Index = null,
    schema: ?*const ValidatedSchema = null,
    pub fn indexedReferences(self: *const Source) ?[]const references.Entry {
        const index = self.references orelse return null;

        return references.forNode(index, &self.node);
    }
    pub fn indexedFlow(self: *const Source) ?IndexedFlow {
        const index = self.references orelse return null;

        return references.flowForNode(index, &self.node);
    }
    pub fn indexedExtent(self: *const Source) ?usize {
        const index = self.references orelse return null;

        return references.sourceExtent(index, &self.node);
    }
    pub fn indexedPositions(self: *const Source) ?references.Positions {
        const index = self.references orelse return null;

        return references.positionsForNode(index, &self.node);
    }
};

pub fn markIndexedSchema(source: *Source) void {
    const index = source.references orelse return;

    markSchema(source, references.root(index));
}

// The witness borrows the immutable root of a successfully decoded Module.
pub fn markSchema(source: *Source, node: *const dsl.ast.Node) void {
    if (dsl.ast.sameStorage(&source.node, node)) source.schema = @ptrCast(node);
}

fn hasSchema(source: *const Source) bool {
    const schema = source.schema orelse return false;
    const node: *const dsl.ast.Node = @ptrCast(@alignCast(schema));

    return dsl.ast.sameStorage(&source.node, node);
}

pub const Module = struct {
    path: []const u8,
    data: flow.Module.Data,
};

pub const Diagnostic = struct {
    source_index: usize,
    issue: dsl.Diagnostic,
};

pub const Result = Outcome(Module);
pub const PathsResult = Outcome([]const u8);

fn Outcome(comptime Item: type) type {
    return struct {
        arena: std.heap.ArenaAllocator,
        dependency_order: []const usize = &.{},
        value: union(enum) {
            data: []const Item,
            diagnostic: Diagnostic,
        },
        pub fn deinit(self: *@This()) void {
            self.arena.deinit();

            self.* = undefined;
        }
    };
}

pub fn validate(allocator: std.mem.Allocator, sources: []const Source) std.mem.Allocator.Error!Result {
    return validateAs(Module, allocator, sources);
}

pub fn validatePaths(allocator: std.mem.Allocator, sources: []const Source) std.mem.Allocator.Error!PathsResult {
    return validateAs([]const u8, allocator, sources);
}

fn validateAs(comptime Item: type, allocator: std.mem.Allocator, sources: []const Source) std.mem.Allocator.Error!Outcome(Item) {
    var arena = std.heap.ArenaAllocator.init(allocator);

    errdefer arena.deinit();

    var reporter: dsl.Reporter = .{};
    var source_index: usize = 0;
    var buffer: [512]u8 align(@alignOf(u64)) = undefined;
    var scratch = std.heap.BufferFirstAllocator.init(&buffer, allocator);
    var registry: Registry = if (comptime generated_graph) try Registry.init(scratch.allocator(), sources.len) else {};

    defer if (comptime generated_graph) registry.deinit(scratch.allocator());

    const owned = arena.allocator();
    const normalized = try owned.alloc([]const u8, sources.len);
    const data = if (Item == Module) try owned.alloc(Module, sources.len) else normalized;
    var schemas = std.heap.ArenaAllocator.init(allocator);

    defer schemas.deinit();

    const order = decode(Item, data, normalized, owned, allocator, schemas.allocator(), &registry, sources, &source_index, &reporter) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return .{ .arena = arena, .value = .{ .diagnostic = .{ .source_index = source_index, .issue = reporter.diagnostic.? } } };
    };

    return .{ .arena = arena, .dependency_order = order, .value = .{ .data = data } };
}

fn decode(comptime Item: type, data: []Item, normalized: [][]const u8, allocator: std.mem.Allocator, temporary: std.mem.Allocator, schemas: std.mem.Allocator, registry: *Registry, sources: []const Source, source_index: *usize, reporter: *dsl.Reporter) dsl.Error![]const usize {
    for (sources, 0..) |source, index| {
        source_index.* = index;

        const path = paths.normalize(allocator, source.path) catch |err| {
            if (err == error.OutOfMemory) return error.OutOfMemory;

            return fail(source.node, "Module registration requires a project relative .rx file path inside the project root", reporter);
        };

        if (comptime generated_graph) {
            if (!registry.claim(index, path)) return fail(source.node, "Module file path is already registered", reporter);
        } else {
            for (normalized[0..index]) |previous| {
                if (std.mem.eql(u8, previous, path)) return fail(source.node, "Module file path is already registered", reporter);
            }
        }

        normalized[index] = path;

        if (Item == Module) {
            data[index] = .{ .path = path, .data = try flow.Module.decode(allocator, source.node, reporter, {}) };
        } else if (!hasSchema(&source)) {
            _ = try flow.Module.decode(schemas, source.node, reporter, {});
        }
    }

    return graph.validate(allocator, temporary, registry, sources, normalized, source_index, reporter);
}

fn fail(node: dsl.ast.Node, message: []const u8, reporter: *dsl.Reporter) dsl.Error {
    return reporter.fail(.{ .code = .context, .location = node.location, .element = node.name, .message = message });
}
