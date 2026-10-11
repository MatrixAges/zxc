//! Calls between separately compiled partitions of generated functions. A partition exports a C-callable
//! entry for each function other partitions use; callers reach it through a forwarder with the original
//! signature. Arguments and results travel by pointer, errors as their position in the declared error set.
const std = @import("std");

pub fn exportAs(comptime function: anytype, comptime symbol: []const u8) void {
    const F = @TypeOf(function);
    const Entry = struct {
        fn call(arguments: *const std.meta.ArgsTuple(F), result: *Payload(F)) callconv(.c) u16 {
            const value = @call(.auto, function, arguments.*);

            switch (@typeInfo(Return(F))) {
                .error_union => |union_info| {
                    result.* = value catch |err| return code(union_info.error_set, err);

                    return 0;
                },
                else => {
                    result.* = value;

                    return 0;
                },
            }
        }
    };

    @export(&Entry.call, .{ .name = symbol });
}

pub fn import(comptime F: type, comptime symbol: []const u8) F {
    const parameters = @typeInfo(F).@"fn".param_types;
    const Forward = struct {
        const entry = @extern(*const fn (*const std.meta.ArgsTuple(F), *Payload(F)) callconv(.c) u16, .{ .name = symbol });

        fn forward(arguments: std.meta.ArgsTuple(F)) Return(F) {
            var result: Payload(F) = undefined;
            const status = entry(&arguments, &result);

            switch (@typeInfo(Return(F))) {
                .error_union => |union_info| if (status != 0) return failure(union_info.error_set, status),
                else => {},
            }

            return result;
        }

        fn take0() Return(F) {
            return forward(.{});
        }

        fn take1(a: parameters[0].?) Return(F) {
            return forward(.{a});
        }

        fn take2(a: parameters[0].?, b: parameters[1].?) Return(F) {
            return forward(.{ a, b });
        }

        fn take3(a: parameters[0].?, b: parameters[1].?, c: parameters[2].?) Return(F) {
            return forward(.{ a, b, c });
        }

        fn take4(a: parameters[0].?, b: parameters[1].?, c: parameters[2].?, d: parameters[3].?) Return(F) {
            return forward(.{ a, b, c, d });
        }

        fn take5(a: parameters[0].?, b: parameters[1].?, c: parameters[2].?, d: parameters[3].?, e: parameters[4].?) Return(F) {
            return forward(.{ a, b, c, d, e });
        }

        fn take6(a: parameters[0].?, b: parameters[1].?, c: parameters[2].?, d: parameters[3].?, e: parameters[4].?, f: parameters[5].?) Return(F) {
            return forward(.{ a, b, c, d, e, f });
        }
    };

    return switch (parameters.len) {
        0 => Forward.take0,
        1 => Forward.take1,
        2 => Forward.take2,
        3 => Forward.take3,
        4 => Forward.take4,
        5 => Forward.take5,
        6 => Forward.take6,
        else => @compileError("partition forwarders take at most six parameters"),
    };
}

fn Return(comptime F: type) type {
    return @typeInfo(F).@"fn".return_type.?;
}

fn Payload(comptime F: type) type {
    return switch (@typeInfo(Return(F))) {
        .error_union => |union_info| union_info.payload,
        else => Return(F),
    };
}

fn code(comptime E: type, err: E) u16 {
    inline for (@typeInfo(E).error_set.error_names.?, 1..) |name, index| {
        if (err == @field(E, name)) return index;
    }

    unreachable;
}

fn failure(comptime E: type, status: u16) E {
    inline for (@typeInfo(E).error_set.error_names.?, 1..) |name, index| {
        if (status == index) return @field(E, name);
    }

    unreachable;
}
