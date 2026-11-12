const std = @import("std");

pub const Location = struct {
    offset: usize,
    line: usize,
    column: usize,
};

pub const Attribute = struct {
    kind: enum { string, expression } = .string,
    name: []const u8,
    value: []const u8,
    location: Location,
    value_location: Location,
    raw_value: ?[]const u8 = null,
};

pub const Text = struct {
    value: []const u8,
    location: Location,
};

pub const Node = struct {
    name: []const u8,
    location: Location,
    attributes: []const Attribute = &.{},
    children: []const Node = &.{},
    text: []const Text = &.{},
};

pub fn sameStorage(left: *const Node, right: *const Node) bool {
    return left.name.ptr == right.name.ptr and left.name.len == right.name.len and
        left.children.ptr == right.children.ptr and left.children.len == right.children.len and
        left.attributes.ptr == right.attributes.ptr and left.attributes.len == right.attributes.len and
        left.text.ptr == right.text.ptr and left.text.len == right.text.len and
        std.meta.eql(left.location, right.location);
}

pub fn view(node: anytype) if (@TypeOf(node) == Node) View else @TypeOf(node) {
    return if (@TypeOf(node) == Node) .{ .node = node } else node;
}

pub fn childAt(input: anytype, index: usize) @TypeOf(view(input)).Child {
    const node = view(input);

    if (comptime @TypeOf(node) == View) return node.node.children[index];

    var children = node.children();

    for (0..index) |_| _ = children.next().?;

    return children.next().?;
}

pub const View = struct {
    node: Node,
    pub const Child = Node;

    pub fn name(self: View) []const u8 {
        return self.node.name;
    }

    pub fn location(self: View) Location {
        return self.node.location;
    }

    pub fn attributeCount(self: View) usize {
        return self.node.attributes.len;
    }

    pub fn schemaAttribute(self: View, index: usize) Attribute {
        return self.node.attributes[index];
    }

    pub fn childCount(self: View) usize {
        return self.node.children.len;
    }

    pub fn children(self: View) Children {
        return .{ .remaining = self.node.children };
    }

    pub fn unexpectedText(self: View) ?Location {
        for (self.node.text) |text| {
            if (std.mem.trim(u8, text.value, " \t\r\n").len != 0) return text.location;
        }

        return null;
    }

    const Children = struct {
        remaining: []const Node,
        pub fn next(self: *Children) ?Node {
            if (self.remaining.len == 0) return null;

            const node = self.remaining[0];

            self.remaining = self.remaining[1..];

            return node;
        }
    };
};
