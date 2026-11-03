/// What is known about one list slot of a value: a `headered` buffer came from a growth allocation and carries the
/// header an append consults to extend it in place at its frontier; a `unique` buffer is mutable and no other live
/// value sees it, so its elements may be written in place.
pub const Level = packed struct(u3) {
    headered: bool,
    unique: bool,
    deferred: bool = false,
    const generated = @import("genz_options").generated_analysis;
    const tables = @import("level/tables.zig");
    pub const none: Level = if (generated) tables.constant("None") else .{ .headered = false, .unique = false };
    pub const all: Level = if (generated) tables.constant("All") else .{ .headered = true, .unique = true };
    pub const fresh: Level = if (generated) tables.constant("Fresh") else .{ .headered = false, .unique = true };

    pub fn join(left: Level, right: Level) Level {
        if (generated) return tables.join[left.index()][right.index()];

        const headered = left.headered or right.headered;

        return .{ .headered = headered, .unique = left.unique or right.unique, .deferred = !headered and (left.deferred or right.deferred) };
    }
    pub fn meet(left: Level, right: Level) Level {
        if (generated) return tables.meet[left.index()][right.index()];

        const headered = left.headered and right.headered;

        return .{ .headered = headered, .unique = left.unique and right.unique, .deferred = !headered and (left.deferred or right.deferred or left.headered or right.headered) };
    }

    pub fn lacks(value: Level, want: Level) bool {
        if (generated) return tables.lacks[value.index()][want.index()];

        return (want.headered and !value.headered and !value.deferred) or (want.unique and !value.unique);
    }

    pub fn materialized(value: Level, want: Level, linear: bool) Level {
        if (generated) return tables.materialized[value.index()][@intFromBool(want.unique)][@intFromBool(linear)];
        if (want.unique) return .{ .headered = true, .unique = linear };

        return .{ .headered = value.headered, .unique = value.unique, .deferred = true };
    }
    pub fn written(value: Level) Level {
        if (generated) return tables.written[value.index()];

        return if (value.unique) value else .{ .headered = value.headered, .unique = true };
    }
    fn index(value: Level) u3 {
        return @bitCast(value);
    }
    /// A summary level that background analyses may read while it is stored.
    pub fn load(value: *const Level) Level {
        return @bitCast(@as(u3, @truncate(@atomicLoad(u8, @as(*const u8, @ptrCast(value)), .monotonic))));
    }

    pub fn store(value: *Level, next: Level) void {
        @atomicStore(u8, @as(*u8, @ptrCast(value)), @as(u3, @bitCast(next)), .monotonic);
    }
};
