const std = @import("std");
const rx = @import("rx");
const zx = @import("zx");
const Prepared = @import("../prepare.zig");
const SourceMap = @import("../../source_map.zig");
const target = @import("../../call/target.zig");
const Self = @This();
pub const Kind = enum { input, output };
pub const Entry = struct { module: usize, kind: Kind, node: rx.ast.Node, name: []const u8, end: usize };

const Mapping = struct { module: usize, attribute: rx.ast.Attribute, start: usize, end: usize };

allocator: std.mem.Allocator,
text: std.ArrayList(u8) = .empty,
entries: std.ArrayList(Entry) = .empty,
mappings: std.ArrayList(Mapping) = .empty,
pub fn collect(self: *Self, modules: []const Prepared.Module) std.mem.Allocator.Error!void {
    for (modules, 0..) |module, index| {
        const children = module.source.node.children;

        if (children.len == 0) continue;
        if (std.mem.eql(u8, children[0].name, "Input")) try self.append(index, module.source.path, children[0], .input);
        if (std.mem.eql(u8, children[children.len - 1].name, "Output")) try self.append(index, module.source.path, children[children.len - 1], .output);
    }
}

fn append(self: *Self, module: usize, path: []const u8, node: rx.ast.Node, kind: Kind) std.mem.Allocator.Error!void {
    var digest: [32]u8 = undefined;

    std.crypto.hash.sha2.Sha256.hash(path, &digest, .{});

    const name = try std.fmt.allocPrint(self.allocator, "Rx{s}{s}", .{ if (kind == .input) "Input" else "Output", std.fmt.bytesToHex(digest, .lower) });

    try self.text.appendSlice(self.allocator, "export type ");
    try self.text.appendSlice(self.allocator, name);
    try self.text.appendSlice(self.allocator, " = ");

    if (target.optionalAttribute(node, "type")) |attribute| {
        try self.appendAttribute(module, attribute);
    } else {
        try self.text.appendSlice(self.allocator, "{ ");

        for (node.children) |field| {
            try self.appendAttribute(module, target.attribute(field, "name"));
            try self.text.appendSlice(self.allocator, ": ");
            try self.appendAttribute(module, target.attribute(field, "type"));
            try self.text.appendSlice(self.allocator, ", ");
        }

        try self.text.appendSlice(self.allocator, "}");
    }

    try self.text.append(self.allocator, '\n');
    try self.entries.append(self.allocator, .{ .module = module, .kind = kind, .node = node, .name = name, .end = self.text.items.len });
}

fn appendAttribute(self: *Self, module: usize, value: rx.ast.Attribute) std.mem.Allocator.Error!void {
    const start = self.text.items.len;

    try self.text.appendSlice(self.allocator, value.value);
    try self.mappings.append(self.allocator, .{ .module = module, .attribute = value, .start = start, .end = self.text.items.len });
}

pub fn valid(self: Self, program: zx.ast.Program) bool {
    if (program.imports.len != 0 or program.body != null or program.contracts.len != 0 or program.has_store or program.declarations.len != self.entries.items.len) return false;

    for (program.declarations, self.entries.items) |declaration, entry| {
        if (!std.mem.eql(u8, declaration.name.text, entry.name)) return false;
        if (target.optionalAttribute(entry.node, "type") != null) continue;
        if (declaration.value.* != .object or declaration.value.object.len != entry.node.children.len) return false;

        for (declaration.value.object, entry.node.children) |field, child| {
            if (!std.mem.eql(u8, field.name.text, target.attribute(child, "name").value)) return false;
        }
    }

    return true;
}

pub fn span(self: Self, source_map: SourceMap, offset: usize) zx.Span {
    for (self.mappings.items) |mapping| {
        if (offset < mapping.start or offset > mapping.end) continue;

        const location = rx.attributeLocation(mapping.attribute, offset - mapping.start) orelse mapping.attribute.value_location;
        const start = source_map.base(mapping.module) + location.offset;

        return .{ .start = start, .end = start };
    }

    for (self.entries.items) |entry| {
        if (offset < entry.end) {
            const start = source_map.base(entry.module) + entry.node.location.offset;

            return .{ .start = start, .end = start };
        }
    }

    const last = self.entries.items[self.entries.items.len - 1];
    const start = source_map.base(last.module) + last.node.location.offset;

    return .{ .start = start, .end = start };
}
