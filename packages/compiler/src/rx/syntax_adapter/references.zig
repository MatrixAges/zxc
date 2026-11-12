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

const Storage = struct { root: *const ast.Node, entries: []const Entry };

pub fn forNode(index: *const Index, node: *const ast.Node) ?[]const Entry {
    const storage: *const Storage = @ptrCast(@alignCast(index));

    return if (ast.sameStorage(node, storage.root)) storage.entries else null;
}

pub fn root(index: *const Index) *const ast.Node {
    const storage: *const Storage = @ptrCast(@alignCast(index));

    return storage.root;
}

// The XML parser admits at most 256 nested elements.
const xml_nesting_limit = 256;

pub fn build(comptime scan: anytype, allocator: std.mem.Allocator, temporary: std.mem.Allocator, source: []const u8, input: anytype, slots: []const u64, nodes: []const ast.Node, attributes: []const ast.Attribute) std.mem.Allocator.Error!*const Index {
    const Parameter = @typeInfo(@TypeOf(scan)).@"fn".param_types[1].?;
    const Input = if (@typeInfo(Parameter) == .pointer) std.meta.Child(Parameter) else Parameter;
    var storage: [xml_nesting_limit]u64 = undefined;
    const parents: []u64 = &storage;

    const scan_input: Input = .{
        .source = source,
        .nodes = input.tree.nodes,
        .attributes = input.tree.attributes,
        .root = input.control.result,
        .parents = @ptrCast(&parents),
    };

    const rows = scan(temporary, if (@typeInfo(Parameter) == .pointer) &scan_input else scan_input) catch |err| switch (err) {
        error.OutOfMemory, error.Overflow => return error.OutOfMemory,
        else => unreachable,
    };

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

    index.* = .{ .root = &nodes[0], .entries = entries };

    return @ptrCast(index);
}
