const std = @import("std");
const Columns = @import("columns.zig").Columns;

pub fn Rows(comptime Row: type) type {
    return struct {
        const Self = @This();
        const names = @typeInfo(Row).@"union".field_names;
        const Tag = std.meta.Tag(Row);

        const Payloads = blk: {
            var types: [names.len]type = undefined;

            for (names, &types) |name, *target| target.* = Columns(@FieldType(Row, name));

            break :blk @Struct(.auto, null, names, &types, &@splat(.{}));
        };
        tags: std.ArrayList(Tag) = .empty,
        offsets: std.ArrayList(u32) = .empty,
        payloads: Payloads,
        pub fn init() Self {
            var result: Self = .{ .payloads = undefined };

            inline for (names) |name| @field(result.payloads, name) = .init();

            return result;
        }
        pub fn append(self: *Self, allocator: std.mem.Allocator, value: Row) std.mem.Allocator.Error!u32 {
            if (self.tags.items.len >= std.math.maxInt(u32)) return error.OutOfMemory;

            const id: u32 = @intCast(self.tags.items.len);
            const tag = std.meta.activeTag(value);

            try self.tags.ensureUnusedCapacity(allocator, 1);
            try self.offsets.ensureUnusedCapacity(allocator, 1);

            switch (value) {
                inline else => |payload, selected| {
                    const items = &@field(self.payloads, @tagName(selected));
                    const index: u32 = @intCast(items.count());

                    try items.reserve(allocator, 1);

                    items.append(payload);
                    self.tags.appendAssumeCapacity(tag);
                    self.offsets.appendAssumeCapacity(index);
                },
            }

            return id;
        }
        pub fn get(self: *const Self, id: u32) Row {
            const offset = self.offsets.items[id];

            return switch (self.tags.items[id]) {
                inline else => |tag| @unionInit(Row, @tagName(tag), @field(self.payloads, @tagName(tag)).get(offset)),
            };
        }
    };
}
