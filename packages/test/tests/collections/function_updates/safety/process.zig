const std = @import("std");
const program = @import("program");
const probe = @import("probe");

var storage: [5]i64 = undefined;

pub const panic = std.debug.FullPanic(struct {
    fn fail(message: []const u8, _: ?usize) noreturn {
        std.debug.print("ZX_PANIC={s}\n", .{message});
        report();
        std.process.exit(86);
    }
}.fail);

fn report() void {
    for (probe.events[0..probe.calls]) |event| {
        std.debug.print("ZX_EVENT={t},{d},{d}\n", .{ event.stage, event.payload, event.sample });
    }

    std.debug.print("ZX_INPUT={d},{d},{d},{d},{d}\n", .{ storage[0], storage[1], storage[2], storage[3], storage[4] });
}

pub fn main(init: std.process.Init) !void {
    const args = try init.minimal.args.toSlice(init.arena.allocator());

    if (args.len != 10) return error.InvalidArguments;

    storage = .{ -1234567, try std.fmt.parseInt(i64, args[1], 10), 3, 9, 7654321 };
    const selected = try std.fmt.parseInt(usize, args[5], 10);
    const stage = if (std.mem.eql(u8, args[6], "none")) null else std.meta.stringToEnum(probe.Stage, args[6]) orelse return error.InvalidStage;
    const values = storage[1..][0..if (std.mem.eql(u8, args[9], "true")) 0 else 3];

    const input: std.meta.Child(program.Input) = .{
        .values = values,
        .delta = try std.fmt.parseInt(i64, args[2], 10),
        .outer = try std.fmt.parseInt(u64, args[3], 10),
        .inner = try std.fmt.parseInt(u64, args[4], 10),
        .selected = @intCast(selected),
        .enabled = std.mem.eql(u8, args[8], "true"),
    };

    var arena = std.heap.ArenaAllocator.init(init.arena.allocator());

    defer arena.deinit();
    probe.reset(.{ .stage = stage, .occurrence = try std.fmt.parseInt(usize, args[7], 10) }, selected);

    const output = program.execute(&arena, &input) catch |err| {
        std.debug.print("ZX_ERROR={t}\n", .{err});
        report();

        return;
    };

    std.debug.print("ZX_RESULT={d},{d}\n", .{ output.steps, output.seen });

    for (output.values, output.original, output.mirror) |value, original, mirror| {
        std.debug.print("ZX_VALUE={d},{d},{d}\n", .{ value, original, mirror });
    }

    report();
}
