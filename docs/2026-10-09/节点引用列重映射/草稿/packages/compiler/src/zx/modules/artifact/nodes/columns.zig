const std = @import("std");

pub fn own(allocator: std.mem.Allocator, source: anytype, replacements: anytype) std.mem.Allocator.Error!@TypeOf(source) {
    @setEvalBranchQuota(100_000);

    const Table = @TypeOf(source);
    var result: Table = undefined;

    inline for (@typeInfo(Table).@"struct".field_names) |name| {
        if (comptime @hasField(@TypeOf(replacements), name)) {
            @field(result, name) = @field(replacements, name);
        } else {
            const values = @field(source, name);
            const Child = @typeInfo(@TypeOf(values)).pointer.child;
            const owned = try allocator.dupe(Child, values);

            if (comptime Child == []const u8) {
                for (owned) |*text| text.* = try allocator.dupe(u8, text.*);
            }

            @field(result, name) = owned;
        }
    }

    return result;
}
