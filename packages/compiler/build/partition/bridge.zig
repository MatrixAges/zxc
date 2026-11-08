//! Calls between separately compiled partitions of generated functions. A partition exports a C-callable
//! entry for each function other partitions use; callers reach it through a forwarder with the original
//! signature. Arguments and results travel by pointer, errors as their position in the declared error set.
const std = @import("std");

pub fn exportAs(comptime function: anytype, comptime symbol: []const u8) void {
    const F = @TypeOf(function);

    const Entry = struct {
        fn call(arguments: *const Arguments(F), result: *Payload(F)) callconv(.c) u16 {
            const value = invoke(function, arguments);

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

pub fn import(comptime F: type, comptime symbol: []const u8) ForwardType(F) {
    return forwarder(F, symbol, null);
}

pub fn importComptime(comptime function: anytype, comptime symbol: []const u8) ForwardType(@TypeOf(function)) {
    return forwarder(@TypeOf(function), symbol, function);
}

fn Forward(comptime F: type, comptime symbol: []const u8, comptime implementation: anytype) type {
    const parameters = @typeInfo(F).@"fn".param_types;

    return struct {
        const entry = @extern(*const fn (*const Arguments(F), *Payload(F)) callconv(.c) u16, .{ .name = symbol });

        inline fn forward(arguments: *const Arguments(F)) Return(F) {
            if (@inComptime()) {
                if (comptime @TypeOf(implementation) == @TypeOf(null)) @compileError("runtime partition entry used at comptime");

                return invoke(implementation, arguments);
            }

            var result: Payload(F) = undefined;
            const status = entry(arguments, &result);

            switch (@typeInfo(Return(F))) {
                .error_union => |union_info| if (status != 0) return failure(union_info.error_set, status),
                else => {},
            }

            return result;
        }

        inline fn take0() Return(F) {
            return forward(&Arguments(F){});
        }

        inline fn take1(a: parameters[0].?) Return(F) {
            return forward(&Arguments(F){&a});
        }

        inline fn take2(a: parameters[0].?, b: parameters[1].?) Return(F) {
            return forward(&Arguments(F){ &a, &b });
        }

        inline fn take3(a: parameters[0].?, b: parameters[1].?, c: parameters[2].?) Return(F) {
            return forward(&Arguments(F){ &a, &b, &c });
        }

        inline fn take4(a: parameters[0].?, b: parameters[1].?, c: parameters[2].?, d: parameters[3].?) Return(F) {
            return forward(&Arguments(F){ &a, &b, &c, &d });
        }

        inline fn take5(a: parameters[0].?, b: parameters[1].?, c: parameters[2].?, d: parameters[3].?, e: parameters[4].?) Return(F) {
            return forward(&Arguments(F){ &a, &b, &c, &d, &e });
        }

        inline fn take6(a: parameters[0].?, b: parameters[1].?, c: parameters[2].?, d: parameters[3].?, e: parameters[4].?, f: parameters[5].?) Return(F) {
            return forward(&Arguments(F){ &a, &b, &c, &d, &e, &f });
        }
    };
}

fn ForwardType(comptime F: type) type {
    const forward = Forward(F, "", null);

    return @TypeOf(switch (@typeInfo(F).@"fn".param_types.len) {
        0 => forward.take0,
        1 => forward.take1,
        2 => forward.take2,
        3 => forward.take3,
        4 => forward.take4,
        5 => forward.take5,
        6 => forward.take6,
        else => @compileError("partition forwarders take at most six parameters"),
    });
}

fn forwarder(comptime F: type, comptime symbol: []const u8, comptime implementation: anytype) ForwardType(F) {
    const forward = Forward(F, symbol, implementation);

    return switch (@typeInfo(F).@"fn".param_types.len) {
        0 => forward.take0,
        1 => forward.take1,
        2 => forward.take2,
        3 => forward.take3,
        4 => forward.take4,
        5 => forward.take5,
        6 => forward.take6,
        else => @compileError("partition forwarders take at most six parameters"),
    };
}

/// The bridge borrows each existing parameter for the synchronous call. Packing parameter values here
/// would duplicate large value-layout descriptors before crossing the compilation-unit boundary.
fn Arguments(comptime F: type) type {
    const parameters = @typeInfo(F).@"fn".param_types;
    var fields: [parameters.len]type = undefined;

    for (parameters, &fields) |parameter, *field| field.* = *const parameter.?;

    return @Tuple(&fields);
}

inline fn invoke(comptime function: anytype, arguments: *const Arguments(@TypeOf(function))) Return(@TypeOf(function)) {
    return switch (@typeInfo(@TypeOf(function)).@"fn".param_types.len) {
        0 => function(),
        1 => function(arguments.@"0".*),
        2 => function(arguments.@"0".*, arguments.@"1".*),
        3 => function(arguments.@"0".*, arguments.@"1".*, arguments.@"2".*),
        4 => function(arguments.@"0".*, arguments.@"1".*, arguments.@"2".*, arguments.@"3".*),
        5 => function(arguments.@"0".*, arguments.@"1".*, arguments.@"2".*, arguments.@"3".*, arguments.@"4".*),
        6 => function(arguments.@"0".*, arguments.@"1".*, arguments.@"2".*, arguments.@"3".*, arguments.@"4".*, arguments.@"5".*),
        else => @compileError("partition forwarders take at most six parameters"),
    };
}

/// The panic handler of a partition's root. Each partition is its own compilation unit, and Zig's default handler
/// would compile its stack trace support (DWARF and Mach-O symbol loading, threaded I/O) into every one; this one
/// hands the message to the executable's handler, which `exportPanic` defines once.
pub const Panic = std.debug.FullPanic(forwardPanic);

fn forwardPanic(message: []const u8, first_trace_address: ?usize) noreturn {
    @branchHint(.cold);
    zxc_partition_panic(message.ptr, message.len, first_trace_address orelse @returnAddress());
}

extern fn zxc_partition_panic(message: [*]const u8, length: usize, first_trace_address: usize) callconv(.c) noreturn;

/// Defines the handler partitions forward their panics to; the shared top level of the generated tree calls it,
/// so the executable linking the partitions has it exactly once.
pub fn exportPanic() void {
    @export(&handlePanic, .{ .name = "zxc_partition_panic" });
}

fn handlePanic(message: [*]const u8, length: usize, first_trace_address: usize) callconv(.c) noreturn {
    std.lang.panic.call(message[0..length], first_trace_address);
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
    inline for (comptime orderedErrors(E), 1..) |name, index| {
        if (err == @field(E, name)) return index;
    }

    unreachable;
}

fn failure(comptime E: type, status: u16) E {
    inline for (comptime orderedErrors(E), 1..) |name, index| {
        if (status == index) return @field(E, name);
    }

    unreachable;
}

fn orderedErrors(comptime E: type) [@typeInfo(E).error_set.error_names.?.len][]const u8 {
    @setEvalBranchQuota(std.math.maxInt(u32));

    const source = @typeInfo(E).error_set.error_names.?;
    var names: [source.len][]const u8 = undefined;

    for (source, &names) |name, *target| target.* = name;

    std.mem.sort([]const u8, &names, {}, struct {
        fn lessThan(_: void, left: []const u8, right: []const u8) bool {
            return std.mem.lessThan(u8, left, right);
        }
    }.lessThan);

    return names;
}
