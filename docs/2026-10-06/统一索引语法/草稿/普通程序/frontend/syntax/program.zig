const std = @import("std");
const zx = @import("zx");
const Order = @import("program/order.zig");
const Header = zx.syntax.header;

pub fn View(comptime Storage: type) type {
    return struct {
        const Self = @This();
        pub const TypeView = @import("../../analysis/types/indexed_view.zig").View(Storage);
        pub const Model = @import("program/model.zig").Model(Self);

        source: []const u8,
        storage: Storage,
        order: Order,
        types: TypeView,
        pub fn init(allocator: std.mem.Allocator, source: []const u8, storage: Storage) std.mem.Allocator.Error!Self {
            return .{
                .source = source,
                .storage = storage,
                .order = try Order.create(allocator, storage),
                .types = .{
                    .source = source,
                    .storage = storage,
                    .order = try @import("../../analysis/types/indexed_view/order.zig").create(allocator, storage.types),
                },
            };
        }
        pub fn program(self: *const Self) Model.Program {
            return .{
                .body = if (self.storage.body) |index| self.block(index) else null,
                .contracts = .{ .context = self, .first = 0, .len = self.storage.contracts.len },
                .consumes_input = self.storage.consumes_input,
                .has_store = self.storage.has_store,
            };
        }

        pub fn expression(self: *const Self, index: u64) Model.Expression {
            const id: usize = @intCast(index);

            return .{ .context = self, .index = id, .span = Header.span(self.storage.expressions.nodes[id].span) };
        }
        pub fn block(self: *const Self, index: u64) Model.Block {
            const id: usize = @intCast(index);
            const node = self.storage.blocks.blocks[id];

            return .{
                .span = Header.span(node.span),
                .statements = .{ .context = self, .first = self.order.blocks[id], .len = @intCast(node.count) },
            };
        }
        pub fn typeValue(self: *const Self, index: u64) Model.Type {
            return .{ .view = &self.types, .ref = .{ .node = @intCast(index) } };
        }
        pub fn text(self: *const Self, span: anytype) []const u8 {
            return self.source[@intCast(span.start)..@intCast(span.end)];
        }
        pub fn name(self: *const Self, span: anytype) zx.ast.Name {
            return .{ .text = self.text(span), .span = Header.span(span) };
        }
    };
}
