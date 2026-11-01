/// What is known about one list slot of a value: a `headered` buffer came from a growth allocation and carries the
/// header an append consults to extend it in place at its frontier; a `unique` buffer is mutable and no other live
/// value sees it, so its elements may be written in place.
pub const Level = packed struct(u3) {
    headered: bool,
    unique: bool,
    deferred: bool = false,
    pub const none: Level = .{ .headered = false, .unique = false };
    pub const all: Level = .{ .headered = true, .unique = true };
    pub const fresh: Level = .{ .headered = false, .unique = true };

    pub fn join(left: Level, right: Level) Level {
        const headered = left.headered or right.headered;

        return .{ .headered = headered, .unique = left.unique or right.unique, .deferred = !headered and (left.deferred or right.deferred) };
    }
    pub fn meet(left: Level, right: Level) Level {
        const headered = left.headered and right.headered;

        return .{ .headered = headered, .unique = left.unique and right.unique, .deferred = !headered and (left.deferred or right.deferred or left.headered or right.headered) };
    }
    /// A summary level that background analyses may read while it is stored.
    pub fn load(value: *const Level) Level {
        return @bitCast(@as(u3, @truncate(@atomicLoad(u8, @as(*const u8, @ptrCast(value)), .monotonic))));
    }

    pub fn store(value: *Level, next: Level) void {
        @atomicStore(u8, @as(*u8, @ptrCast(value)), @as(u3, @bitCast(next)), .monotonic);
    }
};
