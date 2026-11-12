const std = @import("std");
const ast = @import("dsl").ast;
const Self = @This();

node: ast.Node,
pub const Attribute = struct {
    name: []const u8,
    offset: usize,
    value_offset: usize,
    raw: ?[]const u8,
    expression: bool,
};

pub fn name(self: Self) []const u8 {
    return self.node.name;
}

pub fn location(self: Self) ast.Location {
    return self.node.location;
}

pub fn attributeCount(self: Self) usize {
    return self.node.attributes.len;
}

pub fn attribute(self: Self, index: usize) Attribute {
    const item = self.node.attributes[index];

    return .{ .name = item.name, .offset = item.location.offset, .value_offset = item.value_location.offset, .raw = item.raw_value, .expression = item.kind == .expression };
}

pub fn childCount(self: Self) usize {
    return self.node.children.len;
}

pub fn children(self: Self) Children {
    return .{ .remaining = self.node.children };
}

pub fn whitespaceOnly(self: Self) bool {
    for (self.node.text) |text| {
        if (std.mem.trim(u8, text.value, " \t\r\n").len != 0) return false;
    }

    return true;
}

const Children = struct {
    remaining: []const ast.Node,
    pub fn next(self: *Children) ?Self {
        if (self.remaining.len == 0) return null;

        const node = self.remaining[0];

        self.remaining = self.remaining[1..];

        return .{ .node = node };
    }
};
