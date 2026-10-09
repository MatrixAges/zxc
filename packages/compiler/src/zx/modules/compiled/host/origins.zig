const std = @import("std");
const Origins = @import("../../nominal_origins.zig");

pub fn copy(allocator: std.mem.Allocator, source: Origins.Table) std.mem.Allocator.Error!Origins {
    var result = Origins{ .allocator = allocator };

    inline for (@typeInfo(Origins.Storage).@"struct".field_names) |name| {
        const values = @field(source, name);
        const Child = std.meta.Elem(@TypeOf(values));
        const owned = try allocator.dupe(Child, values);

        if (comptime Child == []const u8) {
            for (owned) |*text| text.* = try allocator.dupe(u8, text.*);
        }

        @field(result.items, name) = .fromOwnedSlice(owned);
    }

    return result;
}
