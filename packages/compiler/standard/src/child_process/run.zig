const std = @import("std");

pub fn run(allocator: std.mem.Allocator, io: std.Io, options: std.process.RunOptions, input: []const u8) !std.process.RunResult {
    var child = try std.process.spawn(io, .{
        .argv = options.argv,
        .cwd = options.cwd,
        .environ_map = options.environ_map,
        .stdin = .pipe,
        .stdout = .pipe,
        .stderr = .pipe,
    });

    defer child.kill(io);

    var buffer: std.Io.File.MultiReader.Buffer(2) = undefined;
    var reader: std.Io.File.MultiReader = undefined;

    reader.init(allocator, io, buffer.toStreams(), &.{ child.stdout.?, child.stderr.? });
    defer reader.deinit();

    const Completion = union(enum) {
        written: @typeInfo(@TypeOf(writeInput)).@"fn".return_type.?,
        collected: @typeInfo(@TypeOf(collectOutput)).@"fn".return_type.?,
    };

    var completions: [2]Completion = undefined;
    var tasks = std.Io.Select(Completion).init(io, &completions);

    defer tasks.cancelDiscard();

    try tasks.concurrent(.written, writeInput, .{ io, child.stdin.?, input });

    child.stdin = null;

    try tasks.concurrent(.collected, collectOutput, .{ &reader, options });

    for (0..2) |_| {
        switch (try tasks.await()) {
            .written => |result| try result,
            .collected => |result| try result,
        }
    }

    const term = try child.wait(io);
    const stdout = try reader.toOwnedSlice(0);

    errdefer allocator.free(stdout);

    const stderr = try reader.toOwnedSlice(1);

    return .{ .term = term, .stdout = stdout, .stderr = stderr };
}

fn writeInput(io: std.Io, file: std.Io.File, input: []const u8) !void {
    defer file.close(io);

    try file.writeStreamingAll(io, input);
}

fn collectOutput(reader: *std.Io.File.MultiReader, options: std.process.RunOptions) !void {
    while (reader.fill(options.reserve_amount, options.timeout)) |_| {
        try checkLimits(reader, options);
    } else |err| switch (err) {
        error.EndOfStream => {},
        else => |failure| return failure,
    }

    try reader.checkAnyError();
    try checkLimits(reader, options);
}

fn checkLimits(reader: *std.Io.File.MultiReader, options: std.process.RunOptions) !void {
    if (options.stdout_limit.toInt()) |limit| {
        if (reader.reader(0).buffered().len > limit) return error.StreamTooLong;
    }

    if (options.stderr_limit.toInt()) |limit| {
        if (reader.reader(1).buffered().len > limit) return error.StreamTooLong;
    }
}
