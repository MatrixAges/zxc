const std = @import("std");
const ast = @import("dsl").ast;
pub const Target = enum { Module, Function, Store };
pub const Role = enum { Dependency, Call, TypeImport };

pub const Entry = struct {
    node: *const ast.Node,
    attribute: ?*const ast.Attribute = null,
    target: Target = .Module,
    role: Role = .Dependency,
    package_allowed: bool = false,
    graph: bool = false,
};

pub const Index = opaque {};

const Storage = struct {
    root: *const ast.Node,
    entries: []const Entry,
    attributes: []const ast.Attribute,
    flow: []const Fact,
    module_steps: usize,
    parallel_tasks: usize,
    source_extent: usize,
};

pub const Action = enum(u3) {
    unsupported,
    call,
    task,
    parallel,
    switch_flow,
    if_flow,
    result,
    declaration,
};

pub const Fact = packed struct(u32) {
    returns: bool,
    terminates: bool,
    unreachable_step: bool,
    declaration: bool,
    alternate: bool,
    action: Action,
    reverse_task_rank: u24,
};

pub const Flow = struct {
    base: [*]const ast.Node,
    facts: []const Fact,
    module_steps: usize,
    parallel_tasks: usize,
    pub const Operation = Action;

    pub fn get(self: Flow, node: *const ast.Node) Fact {
        const offset = @intFromPtr(node) - @intFromPtr(self.base);

        return self.facts[offset / @sizeOf(ast.Node)];
    }
    pub fn taskId(self: Flow, fact: Fact) ?usize {
        if (fact.reverse_task_rank == 0) return null;

        return self.parallel_tasks - fact.reverse_task_rank;
    }
};

pub fn flowForNode(index: *const Index, node: *const ast.Node) ?Flow {
    const storage: *const Storage = @ptrCast(@alignCast(index));

    if (storage.flow.len == 0 or !ast.sameStorage(node, storage.root)) return null;

    return .{
        .base = @ptrCast(storage.root),
        .facts = storage.flow,
        .module_steps = storage.module_steps,
        .parallel_tasks = storage.parallel_tasks,
    };
}

pub fn forNode(index: *const Index, node: *const ast.Node) ?[]const Entry {
    const storage: *const Storage = @ptrCast(@alignCast(index));

    return if (ast.sameStorage(node, storage.root)) storage.entries else null;
}

pub fn root(index: *const Index) *const ast.Node {
    const storage: *const Storage = @ptrCast(@alignCast(index));

    return storage.root;
}

pub fn sourceExtent(index: *const Index, node: *const ast.Node) ?usize {
    const storage: *const Storage = @ptrCast(@alignCast(index));

    return if (ast.sameStorage(node, storage.root)) storage.source_extent else null;
}

pub const Positions = struct {
    attributes: []const ast.Attribute,
    pub fn attributeAt(self: Positions, offset: usize) ?*const ast.Attribute {
        const end = std.sort.upperBound(ast.Attribute, self.attributes, offset, struct {
            fn compare(value: usize, attribute: ast.Attribute) std.math.Order {
                return std.math.order(value, attribute.value_location.offset);
            }
        }.compare);

        if (end == 0) return null;

        const attribute = &self.attributes[end - 1];

        if (offset - attribute.value_location.offset <= attribute.raw_value.?.len) return attribute;

        return null;
    }
};

pub fn positionsForNode(index: *const Index, node: *const ast.Node) ?Positions {
    const storage: *const Storage = @ptrCast(@alignCast(index));

    return if (ast.sameStorage(node, storage.root)) .{ .attributes = storage.attributes } else null;
}

// The XML parser admits at most 256 nested elements.
const xml_nesting_limit = 256;

pub fn build(comptime scan: anytype, allocator: std.mem.Allocator, temporary: std.mem.Allocator, source: []const u8, input: anytype, slots: []const u64, nodes: []const ast.Node, attributes: []const ast.Attribute, value_extent: usize) std.mem.Allocator.Error!*const Index {
    const Parameter = @typeInfo(@TypeOf(scan)).@"fn".param_types[1].?;
    const Input = if (@typeInfo(Parameter) == .pointer) std.meta.Child(Parameter) else Parameter;
    var storage: [xml_nesting_limit]u64 = undefined;
    const parents: []u64 = &storage;
    const project_flow = nodes[0].children.len != 0 and std.mem.eql(u8, nodes[0].name, "Module");
    const facts = try allocator.alloc(u32, if (project_flow) nodes.len else 0);

    const scan_input: Input = .{
        .source = source,
        .nodes = input.tree.nodes,
        .attributes = input.tree.attributes,
        .root = input.control.result,
        .parents = @ptrCast(&parents),
        .slots = slots,
        .facts = @ptrCast(&facts),
        .project_flow = project_flow,
    };

    const result = scan(temporary, if (@typeInfo(Parameter) == .pointer) &scan_input else scan_input) catch |err| switch (err) {
        error.OutOfMemory, error.Overflow => return error.OutOfMemory,
        else => unreachable,
    };

    const rows = result.references;
    const entries = try allocator.alloc(Entry, rows.len);

    for (rows, entries) |row, *entry| entry.* = .{
        .node = &nodes[@intCast(slots[@intCast(row.node)])],
        .attribute = if (row.attribute) |index| &attributes[@intCast(index)] else null,
        .target = @fromBackingInt(@intCast(@backingInt(row.target))),
        .role = @fromBackingInt(@intCast(@backingInt(row.role))),
        .package_allowed = row.package_allowed,
        .graph = row.graph,
    };

    const index = try allocator.create(Storage);

    index.* = .{
        .root = &nodes[0],
        .entries = entries,
        .attributes = attributes,
        .flow = @ptrCast(facts),
        .module_steps = @intCast(result.module_steps),
        .parallel_tasks = @intCast(result.parallel_tasks),
        .source_extent = @max(value_extent, @as(usize, @intCast(result.source_extent))),
    };

    return @ptrCast(index);
}
