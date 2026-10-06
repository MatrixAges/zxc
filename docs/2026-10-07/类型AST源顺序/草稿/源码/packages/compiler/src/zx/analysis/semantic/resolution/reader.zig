const std = @import("std");
const zx = @import("zx");

pub fn Reader(comptime Native: type, comptime Program: type, comptime Expression: type, comptime Declaration: type) type {
    return union(enum) {
        const Self = @This();
        pub const Ref = union(enum) { native: *const zx.ast.Type, node: usize, enumeration: usize };
        pub const Entry = struct { name: zx.ast.Name, value: Ref };

        native: Native,
        program: Program,
        expression: Expression,
        declaration: Declaration,
        pub fn declarationCount(self: Self) usize {
            return switch (self) {
                inline else => |view| view.declarations().count(),
            };
        }

        pub fn declarationAt(self: Self, index: usize) Entry {
            return switch (self) {
                .native => |view| .{ .name = view.items[index].name, .value = .{ .native = view.items[index].value } },
                .expression => unreachable,
                inline .program, .declaration => |view| blk: {
                    const item = view.storage.declarations[index];

                    break :blk .{
                        .name = spanName(view.source, item.name),
                        .value = if (item.enumeration) .{ .enumeration = index } else .{ .node = @intCast(item.value) },
                    };
                },
            };
        }

        pub fn kind(self: Self, value: Ref) std.meta.Tag(zx.ast.Type) {
            return switch (self) {
                inline else => |view| view.kind(convert(@TypeOf(view), value)),
            };
        }

        pub fn name(self: Self, value: Ref) zx.ast.Name {
            return switch (self) {
                inline else => |view| view.name(convert(@TypeOf(view), value)),
            };
        }

        pub fn child(self: Self, value: Ref) Ref {
            return switch (self) {
                inline else => |view| reference(view.child(convert(@TypeOf(view), value))),
            };
        }

        pub fn count(self: Self, value: Ref, comptime field: bool) usize {
            return switch (self) {
                inline else => |view| if (field) view.fields(convert(@TypeOf(view), value)).count() else view.children(convert(@TypeOf(view), value)).count(),
            };
        }

        pub fn firstPosition(self: Self, value: Ref, comptime field: bool) usize {
            return switch (self) {
                inline else => |view| blk: {
                    const sequence = if (field) view.fields(convert(@TypeOf(view), value)) else view.children(convert(@TypeOf(view), value));
                    var positions = sequence.positions();

                    break :blk if (positions.next()) |index| index + 1 else 0;
                },
            };
        }

        pub fn nextPosition(self: Self, value: Ref, position: usize, comptime field: bool) usize {
            std.debug.assert(position != 0);

            return switch (self) {
                .native => if (position < self.count(value, field)) position + 1 else 0,
                inline else => |view| @intCast(if (field) view.storage.type_order.fields[position - 1] else view.storage.type_order.items[position - 1]),
            };
        }

        pub fn fieldAt(self: Self, value: Ref, position: usize) Entry {
            std.debug.assert(position != 0);

            return switch (self) {
                inline else => |view| blk: {
                    const item = view.fields(convert(@TypeOf(view), value)).atPosition(position - 1);

                    break :blk .{ .name = item.name, .value = reference(item.value) };
                },
            };
        }

        pub fn childAt(self: Self, value: Ref, position: usize) Ref {
            std.debug.assert(position != 0);

            return switch (self) {
                inline else => |view| reference(view.children(convert(@TypeOf(view), value)).atPosition(position - 1)),
            };
        }

        pub fn memberCount(self: Self, value: Ref) usize {
            return switch (self) {
                inline else => |view| view.members(convert(@TypeOf(view), value)).count(),
            };
        }

        pub fn memberAt(self: Self, value: Ref, index: usize) zx.ast.Name {
            return switch (self) {
                .native => value.native.enumeration[index],
                .expression => unreachable,
                inline .program, .declaration => |view| blk: {
                    const item = view.storage.declarations[value.enumeration];
                    const first: usize = @intCast(item.first);

                    break :blk spanName(view.source, view.storage.members[first + index]);
                },
            };
        }

        pub fn reference(value: anytype) Ref {
            if (@TypeOf(value) == Native.Ref) return .{ .native = value };

            return switch (value) {
                .node => |index| .{ .node = index },
                .enumeration => |index| .{ .enumeration = index },
            };
        }

        fn convert(comptime View: type, value: Ref) View.Ref {
            if (View == Native) return value.native;

            return switch (value) {
                .native => unreachable,
                .node => |index| .{ .node = index },
                .enumeration => |index| .{ .enumeration = index },
            };
        }

        fn spanName(source: []const u8, position: anytype) zx.ast.Name {
            const span = zx.Span{ .start = @intCast(position.start), .end = @intCast(position.end) };

            return .{ .text = source[span.start..span.end], .span = span };
        }
    };
}
