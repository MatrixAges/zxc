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
    var references: rx.dependency_reference.Iterator = .{};

    defer pending.deinit(allocator);
    defer references.deinit(allocator);

    try pending.append(allocator, registered.get(entry) orelse return error.MissingParserEntry);

    while (pending.pop()) |index| {
        if (seen[index]) continue;

        seen[index] = true;

        const source = &sources[index];

        references.reset(&source.node, source.references);

        while (try references.next(allocator, true)) |selection| {
            const attribute = selection.attribute orelse continue;

            if (selection.package_allowed and rx.module_reference.isPackage(attribute.value, source.packages)) continue;

            const path = try rx.resolveModulePath(allocator, source.path, attribute.value);

            defer allocator.free(path);

            try pending.append(allocator, registered.get(path) orelse return error.MissingParserModule);
        }
    }

    var result: std.ArrayList(rx.ModuleSource) = .empty;

    for (sources, seen) |source, selected| if (selected) try result.append(allocator, source);

    return result.toOwnedSlice(allocator);
}
