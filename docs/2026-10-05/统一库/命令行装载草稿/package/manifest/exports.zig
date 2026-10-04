const std = @import("std");
const Decoder = @import("decode.zig");
const model = @import("model.zig");
const c = @import("yaml.zig").c;

pub fn decode(decoder: *Decoder, node: *const c.yaml_node_t) Decoder.Error![]const model.Export {
    const entries = try decoder.mapping(node);

    if (entries.len == 0) return decoder.fail(node, "exports must declare at least one public module");

    const result = try decoder.allocator.alloc(model.Export, entries.len);

    for (entries, result) |entry, *item| {
        const key = decoder.node(entry.key);
        const value = decoder.node(entry.value);
        const path = try decoder.scalar(key);

        if (!valid(path)) return decoder.fail(key, "export paths must be . or ./ followed by explicit module path segments");

        if (value.type == c.YAML_MAPPING_NODE) {
            const fields = try decoder.mapping(value);

            if (fields.len != 1 or !std.mem.eql(u8, try decoder.scalar(decoder.node(fields[0].key)), "module")) return decoder.fail(value, "compiled exports require exactly one module field");

            item.* = .{ .path = path, .module = try decoder.scalar(decoder.node(fields[0].value)) };

            continue;
        }

        const source = try decoder.scalar(value);

        if (!Decoder.relativePath(source)) return decoder.fail(value, "export implementation must stay inside the package");

        item.* = .{ .path = path, .source = source };
    }

    return result;
}

fn valid(path: []const u8) bool {
    if (std.mem.eql(u8, path, ".")) return true;
    if (!std.mem.startsWith(u8, path, "./")) return false;

    var segments = std.mem.splitScalar(u8, path[2..], '/');

    while (segments.next()) |segment| {
        if (segment.len == 0) return false;

        for (segment) |byte| {
            if (!std.ascii.isAlphanumeric(byte) and byte != '_' and byte != '-') return false;
        }
    }

    return true;
}
