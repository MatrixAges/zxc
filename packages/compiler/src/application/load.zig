const std = @import("std");
const rx = @import("rx");

pub fn load(io: std.Io, allocator: std.mem.Allocator, entry: []const u8, config_path: ?[]const u8, writer: *std.Io.Writer) !?[]const rx.TextSource {
    const root = try std.Io.Dir.cwd().realPathFileAlloc(io, ".", allocator);
    const gateway_entry = std.mem.endsWith(u8, entry, ".gateway.rx");
    const store_entry = std.mem.endsWith(u8, entry, ".store.rx");

    const first = (if (gateway_entry) rx.normalizeGatewayPath(allocator, entry) else if (store_entry) rx.normalizeStorePath(allocator, entry) else rx.resolveModulePath(allocator, "entry.rx", entry)) catch |err| {
        if (err == error.OutOfMemory) return err;
        try writer.print("{s}: invalid RX entry path\n", .{entry});

        return null;
    };

    var queue: std.ArrayList([]const u8) = .empty;
    var sources: std.ArrayList(rx.TextSource) = .empty;
    var physical: std.StringHashMap([]const u8) = .init(allocator);

    try queue.append(allocator, first);

    var index: usize = 0;

    while (index < queue.items.len) : (index += 1) {
        const path = queue.items[index];

        const real = std.Io.Dir.cwd().realPathFileAlloc(io, path, allocator) catch |err| {
            try writer.print("{s}: {s}\n", .{ path, @errorName(err) });

            return null;
        };

        const relative = try std.fs.path.relative(allocator, root, null, root, real);

        if (std.fs.path.isAbsolute(relative) or std.mem.eql(u8, relative, "..") or std.mem.startsWith(u8, relative, "../") or std.mem.startsWith(u8, relative, "..\\")) {
            try writer.print("{s}: physical module file escapes the project root\n", .{path});

            return null;
        }

        if (physical.get(real)) |previous| {
            try writer.print("{s}: physical module file is already registered as {s}\n", .{ path, previous });

            return null;
        }

        try physical.put(real, path);

        const source = std.Io.Dir.cwd().readFileAlloc(io, real, allocator, .limited(16 * 1024 * 1024)) catch |err| {
            try writer.print("{s}: {s}\n", .{ path, @errorName(err) });

            return null;
        };

        if (std.mem.endsWith(u8, path, ".zx")) {
            if (!try @import("function.zig").validate(io, allocator, path, source, config_path, writer)) return null;

            continue;
        }

        var parsed = try rx.parseXml(allocator, source);

        defer parsed.deinit();

        if (parsed.value == .diagnostic) {
            try report(writer, path, parsed.value.diagnostic);

            return null;
        }

        var checked = try rx.validate(allocator, path, parsed.value.node);

        defer checked.deinit();

        if (checked.value == .diagnostic) {
            try report(writer, path, checked.value.diagnostic);

            return null;
        }

        if (!std.mem.endsWith(u8, path, ".gateway.rx") and !std.mem.endsWith(u8, path, ".store.rx")) {
            try sources.append(allocator, .{ .path = path, .source = source });
        }

        if (!try collect(allocator, &queue, path, parsed.value.node, writer)) return null;
    }

    return try sources.toOwnedSlice(allocator);
}

fn collect(allocator: std.mem.Allocator, queue: *std.ArrayList([]const u8), owner: []const u8, root: rx.ast.Node, writer: *std.Io.Writer) !bool {
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

fn report(writer: *std.Io.Writer, path: []const u8, issue: rx.Diagnostic) !void {
    try writer.print("{s}:{d}:{d}: {t}: {s}\n", .{ path, issue.location.line, issue.location.column, issue.code, issue.message });
}
