const std = @import("std");
const zx = @import("zx");
const Order = @import("indexed_view/order.zig");

pub fn View(comptime Storage: type) type {
    return struct {
        const Self = @This();
        const has_declarations = @hasField(if (@typeInfo(Storage) == .pointer) @typeInfo(Storage).pointer.child else Storage, "declarations");
        pub const Ref = union(enum) { node: usize, enumeration: usize };
        const Declaration = struct { name: zx.ast.Name, value: Ref };
        const Field = struct { name: zx.ast.Name, value: Ref };
        source: []const u8,
        storage: Storage,
        order: Order,
        pub fn declarations(self: Self) Declarations {
            return .{ .view = self };
        }
        pub fn kind(self: Self, value: Ref) std.meta.Tag(zx.ast.Type) {
            return switch (value) {
                .enumeration => .enumeration,
                .node => |index| switch (self.storage.types.nodes[index].kind) {
                    .Named => .named,
                    .Object => .object,
                    .Optional => .optional,
                    .List => .list,
                    .Tuple => .tuple,
                    .Application => .application,
                },
            };
        }

        pub fn name(self: Self, value: Ref) zx.ast.Name {
            return self.named(self.storage.types.nodes[value.node].name);
        }
        pub fn child(self: Self, value: Ref) Ref {
            return .{ .node = @intCast(self.storage.types.nodes[value.node].child) };
        }

        pub fn fields(self: Self, value: Ref) Edges(true) {
            return .{ .view = self, .head = self.order.heads[value.node], .length = @intCast(self.storage.types.nodes[value.node].count) };
        }

        pub fn children(self: Self, value: Ref) Edges(false) {
            return .{ .view = self, .head = self.order.heads[value.node], .length = @intCast(self.storage.types.nodes[value.node].count) };
        }

        pub fn members(self: Self, value: Ref) Members {
            if (comptime !has_declarations) return .{ .view = self, .first = 0, .length = 0 };

            const declaration = self.storage.declarations[value.enumeration];

            return .{ .view = self, .first = @intCast(declaration.first), .length = @intCast(declaration.count) };
        }
        fn named(self: Self, position: anytype) zx.ast.Name {
            const span = zx.Span{ .start = @intCast(position.start), .end = @intCast(position.end) };

            return .{ .text = self.source[span.start..span.end], .span = span };
        }
        const Declarations = struct {
            view: Self,
            index: usize = 0,
            pub fn count(self: @This()) usize {
                if (comptime !has_declarations) return 0;

                return self.view.storage.declarations.len;
            }
            pub fn iterator(self: @This()) @This() {
                return self;
            }
            pub fn next(self: *@This()) ?Declaration {
                if (comptime !has_declarations) return null;
                if (self.index == self.count()) return null;

                const index = self.index;
                const declaration = self.view.storage.declarations[index];
                self.index += 1;

                return .{
                    .name = self.view.named(declaration.name),
                    .value = if (declaration.enumeration) .{ .enumeration = index } else .{ .node = @intCast(declaration.value) },
                };
            }
        };

        const Members = struct {
            view: Self,
            first: usize,
            length: usize,
            index: usize = 0,
            pub fn count(self: @This()) usize {
                return self.length;
            }
            pub fn iterator(self: @This()) @This() {
                return self;
            }
            pub fn next(self: *@This()) ?zx.ast.Name {
                if (comptime !has_declarations) return null;
                if (self.index == self.length) return null;

                const position = self.view.storage.members[self.first + self.index];

                self.index += 1;

                return self.view.named(position);
            }
        };

        fn Edges(comptime field: bool) type {
            return struct {
                view: Self,
                head: usize,
                length: usize,
                pub fn count(self: @This()) usize {
                    return self.length;
                }
                pub fn iterator(self: @This()) @This() {
                    return self;
                }
                pub fn next(self: *@This()) ?(if (field) Field else Ref) {
                    if (self.head == 0) return null;

                    const index = self.head - 1;
                    const edges = if (field) self.view.storage.types.fields else self.view.storage.types.items;
                    const links = if (field) self.view.order.fields else self.view.order.items;
                    const edge = edges[index];
                    self.head = links[index];
                    const value = Ref{ .node = @intCast(edge.value) };

                    return if (field) .{ .name = self.view.named(edge.name), .value = value } else value;
                }
            };
        }
    };
}
