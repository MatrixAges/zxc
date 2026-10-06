const std = @import("std");
const ast = @import("zx").ast;
const Self = @This();
pub const Ref = *const ast.Type;

items: []const ast.Declaration,
pub fn declarations(self: Self) Sequence(ast.Declaration) {
    return .{ .items = self.items };
}

pub fn kind(_: Self, value: Ref) std.meta.Tag(ast.Type) {
    return std.meta.activeTag(value.*);
}

pub fn name(_: Self, value: Ref) ast.Name {
    return switch (value.*) {
        .named => |item| item,
        .application => |item| item.name,
        else => unreachable,
    };
}

pub fn child(_: Self, value: Ref) Ref {
    return switch (value.*) {
        .optional, .list => |item| item,
        .application => |item| item.argument,
        else => unreachable,
    };
}

pub fn fields(_: Self, value: Ref) Sequence(ast.TypeField) {
    return .{ .items = value.object };
}

pub fn children(_: Self, value: Ref) Sequence(Ref) {
    return .{ .items = value.tuple };
}

pub fn members(_: Self, value: Ref) Sequence(ast.Name) {
    return .{ .items = value.enumeration };
}

fn Sequence(comptime Item: type) type {
    return struct {
        items: []const Item,
        pub fn count(self: @This()) usize {
            return self.items.len;
        }
        pub fn atPosition(self: @This(), index: usize) Item {
            return self.items[index];
        }

        pub fn positions(self: @This()) Positions {
            return .{ .len = self.items.len };
        }
        const Positions = struct {
            len: usize,
            index: usize = 0,
            pub fn next(self: *@This()) ?usize {
                if (self.index == self.len) return null;

                const index = self.index;

                self.index += 1;

                return index;
            }
        };
        pub fn iterator(self: @This()) Iterator {
            return .{ .items = self.items };
        }
        const Iterator = struct {
            items: []const Item,
            index: usize = 0,
            pub fn next(self: *Iterator) ?Item {
                if (self.index == self.items.len) return null;

                const item = self.items[self.index];

                self.index += 1;

                return item;
            }
        };
    };
}
