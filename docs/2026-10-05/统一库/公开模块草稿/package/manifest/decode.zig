const std = @import("std");
const c = @import("yaml.zig").c;
const model = @import("model.zig");
const Decoder = @This();
pub const Error = error{ OutOfMemory, InvalidManifest };

allocator: std.mem.Allocator,
document: *c.yaml_document_t,
diagnostic: ?model.Diagnostic = null,
pub fn decode(self: *Decoder, root: *const c.yaml_node_t) Error!model.Manifest {
    const entries = try self.mapping(root);
    var result: model.Manifest = .{ .name = "", .version = "" };

    for (entries) |entry| {
        const key = try self.scalar(self.node(entry.key));
        const value = self.node(entry.value);

        if (std.mem.eql(u8, key, "name")) {
            result.name = try self.packageName(value);
        } else if (std.mem.eql(u8, key, "version")) {
            result.version = try self.scalar(value);
            _ = std.SemanticVersion.parse(result.version) catch return self.fail(value, "version must be a semantic version");
        } else if (std.mem.eql(u8, key, "entry")) {
            result.entry = try self.scalar(value);

            if (!std.mem.endsWith(u8, result.entry.?, ".zx") or !relativePath(result.entry.?)) {
                return self.fail(value, "entry must be a package-relative .zx file path");
            }
        } else if (std.mem.eql(u8, key, "exports")) {
            result.exports = try @import("exports.zig").decode(self, value);
        } else if (std.mem.eql(u8, key, "private")) {
            result.private = try self.boolean(value);
        } else if (std.mem.eql(u8, key, "dependencies")) {
            result.dependencies = try self.dependencies(value);
        } else if (std.mem.eql(u8, key, "dev_dependencies")) {
            result.dev_dependencies = try self.dependencies(value);
        } else if (std.mem.eql(u8, key, "workspace")) {
            result.workspace = try self.workspace(value);
        } else if (!try @import("native.zig").field(self, key, value, &result)) return self.fail(self.node(entry.key), "unknown pkg.yaml field");
    }

    if (result.entry != null and result.exports.len != 0) return self.fail(root, "entry and exports cannot both define the package public interface");
    if (result.name.len == 0) return self.fail(root, "pkg.yaml requires name");
    if (result.version.len == 0) return self.fail(root, "pkg.yaml requires version");

    return result;
}

fn dependencies(self: *Decoder, value: *const c.yaml_node_t) Error![]const model.Dependency {
    const entries = try self.mapping(value);
    const result = try self.allocator.alloc(model.Dependency, entries.len);

    for (entries, result) |entry, *dependency| {
        dependency.* = .{
            .name = try self.packageName(self.node(entry.key)),
            .requirement = try self.scalar(self.node(entry.value)),
        };
    }

    return result;
}

fn workspace(self: *Decoder, value: *const c.yaml_node_t) Error!model.Workspace {
    const entries = try self.mapping(value);
    var packages: ?[]const []const u8 = null;

    for (entries) |entry| {
        const key = try self.scalar(self.node(entry.key));

        if (!std.mem.eql(u8, key, "packages")) return self.fail(self.node(entry.key), "unknown workspace field");

        const list = self.node(entry.value);

        if (list.type != c.YAML_SEQUENCE_NODE) return self.fail(list, "workspace.packages must be a sequence");

        const items = list.data.sequence.items;
        const count = (@intFromPtr(items.top) - @intFromPtr(items.start)) / @sizeOf(c.yaml_node_item_t);
        const paths = try self.allocator.alloc([]const u8, count);

        for (paths, 0..) |*path, index| {
            const item = self.node(items.start[index]);

            path.* = try self.scalar(item);
            const pattern = if (path.*[0] == '!') path.*[1..] else path.*;

            if (!relativePath(pattern)) return self.fail(item, "workspace package patterns must stay inside the workspace");
        }

        packages = paths;
    }

    return .{ .packages = packages orelse return self.fail(value, "workspace requires packages") };
}

pub fn mapping(self: *Decoder, value: *const c.yaml_node_t) Error![]const c.yaml_node_pair_t {
    if (value.type != c.YAML_MAPPING_NODE) return self.fail(value, "expected a YAML mapping");

    const pairs = value.data.mapping.pairs;
    const count = (@intFromPtr(pairs.top) - @intFromPtr(pairs.start)) / @sizeOf(c.yaml_node_pair_t);
    const entries = if (count == 0) &.{} else pairs.start[0..count];
    var seen: std.StringHashMap(void) = .init(self.allocator);

    defer seen.deinit();

    for (entries) |entry| {
        const key_node = self.node(entry.key);
        const key = try self.scalar(key_node);
        const item = try seen.getOrPut(key);

        if (item.found_existing) return self.fail(key_node, "duplicate YAML mapping key");
    }

    return entries;
}

fn packageName(self: *Decoder, value: *const c.yaml_node_t) Error![]const u8 {
    const name = try self.scalar(value);

    if (!@import("pkgs").validName(name)) return self.fail(value, "invalid package name; use lowercase name or @scope/name");

    return name;
}

pub fn scalar(self: *Decoder, value: *const c.yaml_node_t) Error![]const u8 {
    if (value.type != c.YAML_SCALAR_NODE or !std.mem.eql(u8, std.mem.span(value.tag), "tag:yaml.org,2002:str")) return self.fail(value, "expected a string scalar");

    const bytes = value.data.scalar.value[0..value.data.scalar.length];

    if (bytes.len == 0 or std.mem.indexOfScalar(u8, bytes, 0) != null) return self.fail(value, "empty strings and NUL are not allowed in this field");

    return self.allocator.dupe(u8, bytes);
}

pub fn boolean(self: *Decoder, value: *const c.yaml_node_t) Error!bool {
    if (value.type != c.YAML_SCALAR_NODE or value.data.scalar.style != c.YAML_PLAIN_SCALAR_STYLE) {
        return self.fail(value, "expected an unquoted boolean");
    }

    const tag = std.mem.span(value.tag);

    if (!std.mem.eql(u8, tag, "tag:yaml.org,2002:str") and !std.mem.eql(u8, tag, "tag:yaml.org,2002:bool")) {
        return self.fail(value, "expected a boolean");
    }

    const text = value.data.scalar.value[0..value.data.scalar.length];

    return if (std.mem.eql(u8, text, "true")) true else if (std.mem.eql(u8, text, "false")) false else self.fail(value, "expected true or false");
}

pub fn strings(self: *Decoder, value: *const c.yaml_node_t) Error![]const []const u8 {
    const items = try self.sequence(value);
    const result = try self.allocator.alloc([]const u8, items.len);

    for (items, result) |item, *text| text.* = try self.scalar(self.node(item));

    return result;
}

pub fn sequence(self: *Decoder, value: *const c.yaml_node_t) Error![]const c.yaml_node_item_t {
    if (value.type != c.YAML_SEQUENCE_NODE) return self.fail(value, "expected a sequence");

    const items = value.data.sequence.items;
    const count = (@intFromPtr(items.top) - @intFromPtr(items.start)) / @sizeOf(c.yaml_node_item_t);

    return if (count == 0) &.{} else items.start[0..count];
}

pub fn node(self: Decoder, index: c_int) *const c.yaml_node_t {
    return c.yaml_document_get_node(self.document, index);
}

pub fn fail(self: *Decoder, value: *const c.yaml_node_t, message: []const u8) Error {
    self.diagnostic = .{ .line = value.start_mark.line + 1, .column = value.start_mark.column + 1, .message = message };

    return error.InvalidManifest;
}

pub fn relativePath(path: []const u8) bool {
    if (path.len == 0 or path[0] == '/' or std.mem.indexOfAny(u8, path, "\\:\x00") != null) return false;

    var parts = std.mem.splitScalar(u8, path, '/');

    while (parts.next()) |part| {
        if (std.mem.eql(u8, part, "..")) return false;
    }

    return true;
}
