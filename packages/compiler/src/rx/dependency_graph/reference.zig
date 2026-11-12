const std = @import("std");
const ast = @import("dsl").ast;
const generated = @import("rx_options").generated_graph;
pub const Cursor = @import("cursor.zig");
const model = @import("frontend").xml_references;
pub const Entry = model.Entry;
const Target = model.Target;
const Role = model.Role;

const SeedRule = struct {
    primary: []const u8 = "",
    fallback: []const u8 = "",
    target: Target = .Module,
    fallback_target: Target = .Module,
    role: Role = .Dependency,
    required: bool = false,
    package_allowed: bool = false,
    graph: bool = false,
};

const Rule = if (generated)
    @typeInfo(@TypeOf(@import("generated_rx_reference_rule").executeValue(undefined, undefined))).error_union.payload

else
    SeedRule;

const Selection = struct {
    attribute: *const ast.Attribute,
    target: @FieldType(Rule, "target"),
    role: @FieldType(Rule, "role"),
    package_allowed: bool,
    graph: bool,
};

const Result = union(enum) { skip, missing, selected: Selection };

pub const Iterator = struct {
    indexed: ?[]const Entry = null,
    fallback: Cursor = .{},
    pub fn reset(self: *Iterator, node: *const ast.Node, indexed: ?*const model.Index) void {
        self.indexed = if (indexed) |index| model.forNode(index, node) else null;

        if (self.indexed == null) self.fallback.reset(node);
    }

    pub fn deinit(self: *Iterator, allocator: std.mem.Allocator) void {
        self.fallback.deinit(allocator);
    }
    pub fn next(self: *Iterator, allocator: std.mem.Allocator, comptime graph_only: bool) std.mem.Allocator.Error!?Entry {
        if (self.indexed) |entries| {
            var end = entries.len;

            while (end != 0) {
                end -= 1;
                const entry = entries[end];

                if (graph_only and !entry.graph) continue;

                self.indexed = entries[0..end];

                return entry;
            }

            self.indexed = &.{};

            return null;
        }

        while (try self.fallback.next(allocator)) |node| {
            switch (find(node, graph_only)) {
                .skip => continue,
                .missing => return .{ .node = node },
                .selected => |selection| return .{
                    .node = node,
                    .attribute = selection.attribute,
                    .target = @fromBackingInt(@intCast(@backingInt(selection.target))),
                    .role = @fromBackingInt(@intCast(@backingInt(selection.role))),
                    .package_allowed = selection.package_allowed,
                    .graph = selection.graph,
                },
            }
        }

        return null;
    }
};

pub fn find(node: *const ast.Node, comptime graph_only: bool) Result {
    if (node.attributes.len == 0 and graph_only) return .skip;

    const rule = select(node.name, graph_only);

    if (rule.primary.len == 0) return .skip;

    if (attribute(node, rule.primary)) |value| return .{ .selected = .{
        .attribute = value,
        .target = rule.target,
        .role = rule.role,
        .package_allowed = rule.package_allowed,
        .graph = rule.graph,
    } };

    if (rule.fallback.len != 0) {
        if (attribute(node, rule.fallback)) |value| return .{ .selected = .{
            .attribute = value,
            .target = rule.fallback_target,
            .role = rule.role,
            .package_allowed = false,
            .graph = false,
        } };
    }

    return if (rule.required) .missing else .skip;
}

fn attribute(node: *const ast.Node, name: []const u8) ?*const ast.Attribute {
    for (node.attributes) |*item| {
        if (std.mem.eql(u8, item.name, name)) return item;
    }

    return null;
}

fn select(tag: []const u8, comptime graph_only: bool) Rule {
    if (comptime generated) {
        const execute = @import("generated_rx_reference_rule").executeValue;
        const Parameter = @typeInfo(@TypeOf(execute)).@"fn".param_types[1].?;
        var empty = std.heap.FixedBufferAllocator.init(&.{});

        const input: if (@typeInfo(Parameter) == .pointer) std.meta.Child(Parameter) else Parameter = .{
            .source = tag,
            .start = 0,
            .end = tag.len,
            .graph_only = graph_only,
        };

        return execute(empty.allocator(), if (@typeInfo(Parameter) == .pointer) &input else input) catch unreachable;
    }

    if (std.mem.eql(u8, tag, "Import")) return .{ .primary = "from", .required = true, .graph = true };

    if (std.mem.eql(u8, tag, "Call")) return .{
        .primary = "module",
        .fallback = if (graph_only) "" else "fn",
        .fallback_target = .Function,
        .role = .Call,
        .required = !graph_only,
        .package_allowed = true,
        .graph = true,
    };

    if (graph_only) return .{};
    if (std.mem.eql(u8, tag, "Module")) return .{ .primary = "fn", .target = .Function, .role = .Call };
    if (std.mem.eql(u8, tag, "Type")) return .{ .primary = "from", .target = .Function, .role = .TypeImport, .required = true, .package_allowed = true };
    if (std.mem.eql(u8, tag, "Store")) return .{ .primary = "from", .target = .Store };
    if (std.mem.eql(u8, tag, "Route")) return .{ .primary = "service", .required = true };

    return .{};
}
