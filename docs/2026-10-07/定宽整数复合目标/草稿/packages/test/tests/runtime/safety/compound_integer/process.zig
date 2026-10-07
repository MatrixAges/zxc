const std = @import("std");
const program = @import("program");
const Input = std.meta.Child(program.Input);
const Scalar = @FieldType(Input, "left");
var storage: [5]Scalar = undefined;
var request: Input = undefined;

pub const panic = std.debug.FullPanic(struct {
    fn fail(message: []const u8, _: ?usize) noreturn {
        std.debug.print("ZX_PANIC={s}\n", .{message});
        report();
        std.process.exit(86);
    }
}.fail);

fn report() void {
    std.debug.print("ZX_REQUEST={d},{d},{d},{d},{d},{d},{d}\n", .{ request.operation, request.left, request.right, request.rounds, request.selected, request.values.len, @intFromBool(@intFromPtr(request.values.ptr) == @intFromPtr(storage[1..].ptr)) });
    std.debug.print("ZX_INPUT={d},{d},{d},{d},{d}\n", .{ storage[0], storage[1], storage[2], storage[3], storage[4] });
}

pub fn main(init: std.process.Init) !void {
    const args = try init.minimal.args.toSlice(init.arena.allocator());

    if (args.len != 7) return error.InvalidArguments;

    const left = try std.fmt.parseInt(Scalar, args[2], 10);

    storage = .{ 7, left, 3, 9, 11 };

    request = .{
        .operation = try std.fmt.parseInt(u8, args[1], 10),
        .left = left,
        .right = try std.fmt.parseInt(Scalar, args[3], 10),
        .rounds = try std.fmt.parseInt(u8, args[4], 10),
        .selected = try std.fmt.parseInt(u64, args[5], 10),
        .values = storage[1..][0..if (std.mem.eql(u8, args[6], "true")) 0 else 3],
    };

    var arena = std.heap.ArenaAllocator.init(init.arena.allocator());

    defer arena.deinit();

    const output = program.execute(&arena, &request) catch |err| {
        std.debug.print("ZX_ERROR={t}\n", .{err});
        report();

        return;
    };

    std.debug.print("ZX_RESULT={d},{d},{d}\n", .{ output.scalar, output.field, output.rounds });

    for (output.values, output.original, output.mirror) |value, original, mirror| {
        std.debug.print("ZX_VALUE={d},{d},{d}\n", .{ value, original, mirror });
    }

    report();
}
