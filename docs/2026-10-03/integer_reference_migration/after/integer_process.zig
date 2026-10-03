const std = @import("std");
const program = @import("program");

pub const panic = std.debug.FullPanic(struct {
    fn fail(message: []const u8, _: ?usize) noreturn {
        std.debug.print("ZX_PANIC={s}\n", .{message});
        std.process.exit(86);
    }
}.fail);

pub fn main(init: std.process.Init) !void {
    const args = try init.minimal.args.toSlice(init.arena.allocator());

    if (args.len != 4) return error.InvalidArguments;

    const Scalar = @FieldType(@typeInfo(program.Input).pointer.child, "left");

    const input: program.Input = &.{
        .operation = try std.fmt.parseInt(u8, args[1], 10),
        .left = try std.fmt.parseInt(Scalar, args[2], 10),
        .right = try std.fmt.parseInt(Scalar, args[3], 10),
    };

    var arena = std.heap.ArenaAllocator.init(init.arena.allocator());

    defer arena.deinit();
    std.debug.print("ZX_EXECUTE\n", .{});

    const output = try program.execute(&arena, input);

    std.debug.print("ZX_RESULT={d}\n", .{output});
}
