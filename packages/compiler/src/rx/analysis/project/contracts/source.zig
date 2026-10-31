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
        for (module.source.node.children) |node| {
            if (!std.mem.eql(u8, node.name, "Args")) continue;
            try self.append(index, node, .input);
            try self.append(index, node, .output);
        }
    }
}

fn append(self: *Self, module: usize, node: rx.ast.Node, kind: Kind) std.mem.Allocator.Error!void {
    const name = try std.fmt.allocPrint(self.allocator, "Rx{s}{d}", .{ if (kind == .input) "Input" else "Output", module });

    try self.text.appendSlice(self.allocator, "export type ");
    try self.text.appendSlice(self.allocator, name);
    try self.text.appendSlice(self.allocator, " = ");
    try self.appendAttribute(module, target.attribute(node, if (kind == .input) "in" else "out"));
    try self.text.append(self.allocator, '\n');
    try self.entries.append(self.allocator, .{ .module = module, .kind = kind, .node = node, .name = name, .end = self.text.items.len });
}

fn appendAttribute(self: *Self, module: usize, value: rx.ast.Attribute) std.mem.Allocator.Error!void {
    const start = self.text.items.len;

    try self.text.appendSlice(self.allocator, value.value);
    try self.mappings.append(self.allocator, .{ .module = module, .attribute = value, .start = start, .end = self.text.items.len });
}

pub fn valid(self: Self, view: anytype) bool {
    const declarations = view.declarations();

    if (declarations.count() != self.entries.items.len) return false;

    var iterator = declarations.iterator();

    for (self.entries.items) |entry| {
        if (!std.mem.eql(u8, iterator.next().?.name.text, entry.name)) return false;
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
