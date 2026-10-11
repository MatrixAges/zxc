/// What is known about one list slot of a value: a `headered` buffer came from a growth allocation and carries the
/// header an append consults to extend it in place at its frontier; a `unique` buffer is mutable and no other live
/// value sees it, so its elements may be written in place.
pub const Level = packed struct(u2) {
    headered: bool,
    unique: bool,
    pub const none: Level = .{ .headered = false, .unique = false };
    pub const all: Level = .{ .headered = true, .unique = true };
    pub const fresh: Level = .{ .headered = false, .unique = true };

    pub fn join(left: Level, right: Level) Level {
        return .{ .headered = left.headered or right.headered, .unique = left.unique or right.unique };
    }
    pub fn meet(left: Level, right: Level) Level {
        return .{ .headered = left.headered and right.headered, .unique = left.unique and right.unique };
    }
    /// A summary level that background analyses may read while it is stored.
    pub fn load(value: *const Level) Level {
        return @bitCast(@as(u2, @truncate(@atomicLoad(u8, @as(*const u8, @ptrCast(value)), .monotonic))));
    }

    pub fn store(value: *Level, next: Level) void {
        @atomicStore(u8, @as(*u8, @ptrCast(value)), @as(u2, @bitCast(next)), .monotonic);
    }
};
