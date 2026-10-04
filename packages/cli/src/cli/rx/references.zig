const std = @import("std");
const rx = @import("rx");

pub fn collect(allocator: std.mem.Allocator, queue: *std.ArrayList([]const u8), owner: []const u8, root: rx.ast.Node, writer: *std.Io.Writer) !bool {
    var nodes: std.ArrayList(rx.ast.Node) = .empty;

    defer nodes.deinit(allocator);

    try nodes.append(allocator, root);

    while (nodes.pop()) |node| {
        const store = std.mem.eql(u8, node.name, "Store");
        var key: ?[]const u8 = if (std.mem.eql(u8, node.name, "Import") or store) "from" else if (std.mem.eql(u8, node.name, "Call") or std.mem.eql(u8, node.name, "Route")) "service" else null;

        if (std.mem.eql(u8, node.name, "Call")) for (node.attributes) |attribute| {
            if (std.mem.eql(u8, attribute.name, "fn")) key = "fn";
        };

        if (key) |name| for (node.attributes) |attribute| {
            if (!std.mem.eql(u8, attribute.name, name)) continue;

            const path = (if (store) rx.resolveStorePath(allocator, owner, attribute.value) else if (std.mem.eql(u8, name, "fn")) rx.resolveFunctionPath(allocator, owner, attribute.value) else rx.resolveModulePath(allocator, owner, attribute.value)) catch |err| {
                if (err == error.OutOfMemory) return err;
                try writer.print("{s}:{d}:{d}: {s} reference escapes the project root or is invalid\n", .{ owner, attribute.value_location.line, attribute.value_location.column, if (store) "Store" else "module" });

                return false;
            };

            var found = false;

            for (queue.items) |existing| {
                if (std.mem.eql(u8, existing, path)) {
                    found = true;

                    break;
                }
            }

            if (!found) try queue.append(allocator, path);
        };

        var index = node.children.len;

        while (index > 0) {
            index -= 1;

            try nodes.append(allocator, node.children[index]);
        }
    }

    return true;
}
