const std = @import("std");
const rx = @import("rx");
const Kind = enum { call, import };

const Expected = union(enum) {
    paths: []const []const u8,
    failure: struct { owner: usize, reference: bool, message: []const u8 },
};

pub fn check(paths: []const []const u8, owner: ?usize, kind: Kind, reference: ?[]const u8, expected: Expected) !void {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const allocator = arena.allocator();
    const sources = try allocator.alloc(rx.ModuleSource, paths.len);
    const element = if (kind == .import) "Import" else "Call";
    const key = if (kind == .import) "from" else "module";

    for (sources, paths, 0..) |*source, path, index| {
        source.* = .{ .path = path, .node = .{ .name = "Module", .location = point(index, false) } };

        if (owner != null and owner.? == index) {
            const attributes = try allocator.alloc(rx.ast.Attribute, if (kind == .import) 1 else 2);
            attributes[0] = attribute(key, reference.?, index);

            if (kind == .call) attributes[1] = attribute("in", "$in", index);

            source.node.children = try allocator.dupe(rx.ast.Node, &.{.{
                .name = element,
                .location = point(index, false),
                .attributes = attributes,
            }});
        }
    }

    var result = try rx.validateModules(std.testing.allocator, sources);

    defer result.deinit();

    switch (expected) {
        .paths => |normalized| {
            try std.testing.expect(result.value == .data);
            try std.testing.expectEqual(normalized.len, result.value.data.len);
            for (normalized, result.value.data) |path, module| try std.testing.expectEqualStrings(path, module.path);
        },
        .failure => |failure| {
            try std.testing.expect(result.value == .diagnostic);

            const diagnostic = result.value.diagnostic;
            const issue = diagnostic.issue;

            try std.testing.expectEqual(failure.owner, diagnostic.source_index);
            try std.testing.expectEqual(.context, issue.code);
            try std.testing.expectEqualStrings(failure.message, issue.message);
            try std.testing.expectEqualStrings(if (failure.reference) element else "Module", issue.element);
            try std.testing.expectEqualDeep(point(failure.owner, failure.reference), issue.location);

            if (failure.reference) {
                try std.testing.expectEqualStrings(key, issue.attribute.?);
            } else {
                try std.testing.expect(issue.attribute == null);
            }
        },
    }
}

fn point(owner: usize, reference: bool) rx.ast.Location {
    const column: usize = if (reference) 21 else 1;

    return .{ .offset = owner * 100 + column - 1, .line = owner + 1, .column = column };
}

fn attribute(name: []const u8, value: []const u8, owner: usize) rx.ast.Attribute {
    return .{ .name = name, .value = value, .location = point(owner, false), .value_location = point(owner, true) };
}
