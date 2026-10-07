const std = @import("std");

pub fn Native(comptime Payload: type) type {
    return struct {
        pub const Event = struct { marker: u8, score: u64, length: usize, present: bool };
        pub var calls: usize = 0;
        pub var failure: usize = 0;
        pub var oom_calls: ?usize = null;
        pub var oom_failures: usize = 0;
        pub var events: [65536]Event = undefined;

        pub fn reset(fail_at: usize) void {
            calls = 0;
            failure = fail_at;
            oom_calls = null;
        }
        fn checksum(payload: anytype) u64 {
            const Type = @TypeOf(payload);

            if (@typeInfo(Type) == .optional) return if (payload) |value| checksum(value) else 0;

            var total: u64 = 0;

            for (payload, 0..) |value, index| {
                const part = if (@typeInfo(@TypeOf(value)) == .pointer) 257 * value.len + checksum(value) else value;

                total += @as(u64, @intCast(index + 1)) * part;
            }

            return total;
        }
        fn note(marker: u8, payload: Payload) error{NativeFailure}!u64 {
            const optional = @typeInfo(Payload) == .optional;
            const present = if (optional) payload != null else true;
            const length = if (optional) if (payload) |value| value.len else 0 else payload.len;
            const score = checksum(payload);
            events[calls] = .{ .marker = marker, .score = score, .length = length, .present = present };
            calls += 1;

            if (calls == failure) return error.NativeFailure;

            return score;
        }
        pub fn first(payload: Payload) error{NativeFailure}!u64 {
            return try note(1, payload) + 1;
        }

        pub fn echo(payload: Payload) error{NativeFailure}!Payload {
            _ = try note(2, payload);

            return payload;
        }
        pub fn second(payload: Payload) error{NativeFailure}!u64 {
            return try note(3, payload) + 3;
        }
        pub fn allocated(allocator: std.mem.Allocator, payload: Payload) error{ NativeFailure, OutOfMemory }!u64 {
            const score = try note(4, payload);

            const value = allocator.alloc(u64, 64) catch |err| {
                oom_calls = calls;
                oom_failures += 1;

                return err;
            };

            value[0] = score + 4;

            return value[0];
        }
    };
}
