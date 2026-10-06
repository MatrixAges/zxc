const std = @import("std");
const rx = @import("rx");

pub fn reachable(allocator: std.mem.Allocator, sources: []const rx.ModuleSource, entry: []const u8) ![]const rx.ModuleSource {
    var registered: std.StringHashMapUnmanaged(usize) = .empty;

    defer registered.deinit(allocator);

    for (sources, 0..) |source, index| try registered.put(allocator, source.path, index);

    const seen = try allocator.alloc(bool, sources.len);

    defer allocator.free(seen);

    @memset(seen, false);

    var pending: std.ArrayList(usize) = .empty;
    var nodes: std.ArrayList(*const rx.ast.Node) = .empty;

    defer pending.deinit(allocator);
    defer nodes.deinit(allocator);

    try pending.append(allocator, registered.get(entry) orelse return error.MissingParserEntry);

    while (pending.pop()) |index| {
        if (seen[index]) continue;

        seen[index] = true;

        const source = &sources[index];

        try nodes.append(allocator, &source.node);

        while (nodes.pop()) |node| {
            const key: ?[]const u8 = if (std.mem.eql(u8, node.name, "Import")) "from" else if (std.mem.eql(u8, node.name, "Call")) "module" else null;

            if (key) |name| for (node.attributes) |attribute| {
                if (!std.mem.eql(u8, attribute.name, name)) continue;
                if (std.mem.eql(u8, name, "module") and rx.module_reference.isPackage(attribute.value, source.packages)) continue;

                const path = try rx.resolveModulePath(allocator, source.path, attribute.value);

                defer allocator.free(path);

                try pending.append(allocator, registered.get(path) orelse return error.MissingParserModule);
            };

            for (node.children) |*child| try nodes.append(allocator, child);
        }
    }

    var result: std.ArrayList(rx.ModuleSource) = .empty;

    for (sources, seen) |source, selected| if (selected) try result.append(allocator, source);

    return result.toOwnedSlice(allocator);
}
