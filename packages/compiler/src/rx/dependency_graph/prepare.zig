const std = @import("std");
const dsl = @import("dsl");
const generated = @import("generated_graph");
const dependency = @import("reference.zig");
const module_reference = @import("../module_reference.zig");
const modules = @import("../modules.zig");
const paths = @import("../paths.zig");
const Parameter = @typeInfo(@TypeOf(generated.executeValue)).@"fn".param_types[1].?;
const Input = if (@typeInfo(Parameter) == .pointer) std.meta.Child(Parameter) else Parameter;
const Issue = @typeInfo(@FieldType(Input, "issues")).pointer.child;
const Link = struct { node: *const dsl.ast.Node, attribute: *const dsl.ast.Attribute };
const Result = struct { input: Input, links: []const Link };

pub fn build(allocator: std.mem.Allocator, registered: *const modules.Registry, sources: []const modules.Source, entries: []const modules.Module) std.mem.Allocator.Error!Result {
    const offsets = try allocator.alloc(u64, sources.len + 1);
    var targets: std.ArrayList(u64) = .empty;
    var issues: std.ArrayList(Issue) = .empty;
    var links: std.ArrayList(Link) = .empty;
    var references: dependency.Iterator = .{};

    defer references.deinit(allocator);

    for (sources, 0..) |*source, owner| {
        offsets[owner] = targets.items.len;

        references.reset(&source.node, source.references);

        while (try references.next(allocator, true)) |selection| {
            const attribute = selection.attribute orelse unreachable;
            const value = attribute.value;

            if (selection.package_allowed and module_reference.isPackage(value, source.packages)) continue;

            const target = try resolve(allocator, registered, entries[owner].path, value);

            try targets.append(allocator, target.index);
            try issues.append(allocator, target.issue);
            try links.append(allocator, .{ .node = selection.node, .attribute = attribute });
        }
    }

    offsets[sources.len] = targets.items.len;

    return .{ .input = .{ .offsets = offsets, .targets = targets.items, .issues = issues.items, .root = null, .roots = null, .ranked = false }, .links = links.items };
}

fn resolve(allocator: std.mem.Allocator, registered: *const modules.Registry, owner: []const u8, reference: []const u8) std.mem.Allocator.Error!struct { index: u64 = 0, issue: Issue = .None } {
    const path = paths.resolve(allocator, owner, reference) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        error.InvalidPath => return .{ .issue = .InvalidPath },
    };

    defer allocator.free(path);

    return if (registered.get(path)) |index| .{ .index = index } else .{ .issue = .Missing };
}
