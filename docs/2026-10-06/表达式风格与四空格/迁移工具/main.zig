const std = @import("std");
const frontend = @import("frontend");
const Collect = @import("collect.zig");
const rewrite = @import("rewrite.zig").rewrite;

pub fn main(init: std.process.Init) !void {
    const args = try init.minimal.args.toSlice(init.arena.allocator());
    const write = args.len > 1 and std.mem.eql(u8, args[1], "--write");
    var failures: usize = 0;

    for (args[if (write) @as(usize, 2) else 1..]) |path| {
        migrate(init, path, write) catch |err| {
            std.debug.print("{s}: {s}\n", .{ path, @errorName(err) });

            failures += 1;
        };
    }

    if (failures != 0) return error.IncompleteMigration;
}

fn migrate(init: std.process.Init, path: []const u8, write: bool) !void {
    var arena = std.heap.ArenaAllocator.init(init.gpa);

    defer arena.deinit();

    const allocator = arena.allocator();
    const source = try std.Io.Dir.cwd().readFileAlloc(init.io, path, allocator, .unlimited);
    var parsed = try frontend.parse(allocator, source, path);

    defer parsed.deinit();

    if (parsed.value == .diagnostic) return error.InvalidSource;

    var collect = Collect{ .allocator = allocator };

    try collect.program(parsed.value.parsed.ast);

    var count: usize = 0;

    for (collect.items.items) |candidate| count += @intFromBool(candidate.nested);
    if (count == 0) return;

    const changed = try rewrite(allocator, source, parsed.value.parsed.lexed.tokens, collect.items.items);
    var verified = try frontend.parse(allocator, changed, path);

    defer verified.deinit();

    if (verified.value == .diagnostic) {
        const issue = verified.value.diagnostic;

        std.debug.print("{s}:{d}: {s}\n", .{ path, issue.span.start, issue.message });

        return error.InvalidRewrite;
    }

    var remaining = Collect{ .allocator = allocator };

    try remaining.program(verified.value.parsed.ast);
    for (remaining.items.items) |candidate| if (candidate.nested) return error.RemainingNestedConditional;
    if (write) try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = path, .data = changed });

    std.debug.print("{s}: {d}\n", .{ path, count });
}
