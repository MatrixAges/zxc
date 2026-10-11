const std = @import("std");

pub fn Columns(comptime Value: type) type {
    if (@typeInfo(Value) != .@"struct") return Scalar(Value);

    const names = @typeInfo(Value).@"struct".field_names;

    const Fields = blk: {
        var types: [names.len]type = undefined;

        for (names, &types) |name, *target| target.* = Columns(@FieldType(Value, name));

        break :blk @Struct(.auto, null, names, &types, &@splat(.{}));
    };

    return struct {
        const Self = @This();
        fields: Fields,
        pub fn init() Self {
            var result: Self = undefined;

            inline for (names) |name| @field(result.fields, name) = .init();

            return result;
        }
        pub fn reserve(self: *Self, allocator: std.mem.Allocator, additional: usize) std.mem.Allocator.Error!void {
            inline for (names) |name| try @field(self.fields, name).reserve(allocator, additional);
        }

        pub fn append(self: *Self, value: Value) void {
            inline for (names) |name| @field(self.fields, name).append(@field(value, name));
        }
        pub fn get(self: *const Self, index: usize) Value {
            var result: Value = undefined;

            inline for (names) |name| @field(result, name) = @field(self.fields, name).get(index);

            return result;
        }
        pub fn count(self: *const Self) usize {
            return @field(self.fields, names[0]).count();
        }
    };
}

fn Scalar(comptime Value: type) type {
    return struct {
        const Self = @This();

        values: std.ArrayList(Value) = .empty,
        pub fn init() Self {
            return .{};
        }
        pub fn reserve(self: *Self, allocator: std.mem.Allocator, additional: usize) std.mem.Allocator.Error!void {
            try self.values.ensureUnusedCapacity(allocator, additional);
        }

        pub fn append(self: *Self, value: Value) void {
            self.values.appendAssumeCapacity(value);
        }

        pub fn get(self: *const Self, index: usize) Value {
            return self.values.items[index];
        }
        pub fn count(self: *const Self) usize {
            return self.values.items.len;
        }
    };
}
