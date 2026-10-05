const std = @import("std");
const zx_native_0 = @import("zxc_standard");
const zx_abi = @import("zxc_abi");
pub const Input = void;
pub const Output = void;
pub const consumes_input = false;
pub const requires_io = true;
pub const requires_process = false;
const zx_shape_0 = .{ .kind = .scalar, };
const zx_shape_1 = .{ .kind = .scalar, };
const zx_shape_2 = .{ .kind = .scalar, };
const zx_shape_3 = .{ .kind = .scalar, };
const zx_shape_4 = .{ .kind = .scalar, };
const zx_shape_5 = .{ .kind = .scalar, };
const zx_shape_6 = .{ .kind = .scalar, };
const zx_shape_7 = .{ .kind = .scalar, };
const zx_shape_8 = .{ .kind = .scalar, };
const zx_shape_9 = .{ .kind = .scalar, };
const zx_shape_10 = .{ .kind = .string, };
const zx_shape_11 = .{ .kind = .list, .child = zx_shape_10, };
const zx_shape_12 = .{ .kind = .optional, .child = zx_shape_10, };
const zx_shape_13 = .{ .kind = .list, .child = zx_shape_2, };
pub const input_shape = zx_shape_0;
pub const output_shape = zx_shape_0;

fn function_0(allocator: ((std).mem).Allocator, in: void, process: (((std).process).Init).Minimal) anyerror![]const []const u8 {
    _ = in;

    const native_result = (try ((zx_native_0).process).argv(allocator, process));

    return native_result;
}

fn function_1(allocator: ((std).mem).Allocator, in: []const u8, process: (((std).process).Init).Minimal) anyerror!?[]const u8 {
    const native_result = (try ((zx_native_0).process).getEnv(allocator, process, in));

    return native_result;
}

fn function_2(allocator: ((std).mem).Allocator, in: void, io: (std).Io) anyerror![]const u8 {
    _ = in;

    const native_result = (try ((zx_native_0).process).cwd(allocator, io));

    return native_result;
}

fn function_3(allocator: ((std).mem).Allocator, in: u64, io: (std).Io) anyerror![]const u8 {
    const native_result = (try ((zx_native_0).process).readStdin(allocator, io, in));

    return native_result;
}

fn function_4(allocator: ((std).mem).Allocator, in: u64, io: (std).Io) anyerror![]const u8 {
    const native_result = (try ((zx_native_0).process).readStdinText(allocator, io, in));

    return native_result;
}

fn function_5(allocator: ((std).mem).Allocator, in: []const u8, io: (std).Io) anyerror!void {
    const native_result = (try ((zx_native_0).process).writeStdout(io, in));

    _ = allocator;

    return native_result;
}

fn function_6(allocator: ((std).mem).Allocator, in: []const u8, io: (std).Io) anyerror!void {
    const native_result = (try ((zx_native_0).process).writeStdoutText(io, in));

    _ = allocator;

    return native_result;
}

fn function_7(allocator: ((std).mem).Allocator, in: []const u8, io: (std).Io) anyerror!void {
    const native_result = (try ((zx_native_0).process).writeStderr(io, in));

    _ = allocator;

    return native_result;
}

fn function_8(allocator: ((std).mem).Allocator, in: []const u8, io: (std).Io) anyerror!void {
    const native_result = (try ((zx_native_0).process).writeStderrText(io, in));

    _ = allocator;

    return native_result;
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: void, io: (std).Io) anyerror!void {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    _ = in;

    const value_1: []const []const u8 = block_6: {
        const operand_3 = @as([]const u8, "first\n");
        const operand_4 = @as([]const u8, "second\n");
        const operand_5 = @as([]const u8, "third\n");

        break :block_6 (try (allocator).dupe([]const u8, (&[_][]const u8{operand_3, operand_4, operand_5, })));
    };

    _ = block_2: {
        const operand_1 = value_1;

        for (operand_1) |value_2| {
            (try function_6(allocator, value_2, io));
        }

        break :block_2 {};
    };
}

