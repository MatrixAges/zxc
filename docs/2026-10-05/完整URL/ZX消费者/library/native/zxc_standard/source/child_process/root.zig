const std = @import("std");
const api = @import("zxc_abi").native.@"std:child_process";
const Arguments = @import("options.zig");
pub const TerminationKind = api.TerminationKind;
pub const EnvironmentEntry = api.EnvironmentEntry;
pub const Options = api.Options;
pub const InputOptions = api.InputOptions;
pub const Result = api.Result;

pub fn spawnSync(allocator: std.mem.Allocator, io: std.Io, input: Options) !Result {
    return execute(allocator, io, input, null);
}

pub fn spawnSyncWithInput(allocator: std.mem.Allocator, io: std.Io, input: InputOptions) !Result {
    return execute(allocator, io, input.options, input.input);
}

fn execute(allocator: std.mem.Allocator, io: std.Io, input: Options, bytes: ?[]const u8) !Result {
    var arguments = try Arguments.init(allocator, input);

    defer arguments.deinit();

    const result = try allocator.create(api.spawnSync.OutputValue);

    errdefer allocator.destroy(result);

    const options: std.process.RunOptions = .{
        .argv = arguments.argv,
        .cwd = if (input.cwd) |cwd| .{ .path = cwd } else .inherit,
        .environ_map = if (arguments.environment) |*environment| environment else null,
        .stdout_limit = .limited64(input.max_stdout_bytes),
        .stderr_limit = .limited64(input.max_stderr_bytes),
    };

    const captured = if (bytes) |data|
        try @import("run.zig").run(allocator, io, options, data)
    else
        try std.process.run(allocator, io, options);

    errdefer allocator.free(captured.stdout);
    errdefer allocator.free(captured.stderr);

    if (captured.stdout.len > input.max_stdout_bytes or captured.stderr.len > input.max_stderr_bytes) return error.StreamTooLong;

    result.* = .{
        .stdout = captured.stdout,
        .stderr = captured.stderr,
        .kind = switch (captured.term) {
            .exited => .Exited,
            .signal => .Signal,
            .stopped => .Stopped,
            .unknown => .Unknown,
        },
        .code = switch (captured.term) {
            .exited => |code| code,
            .signal, .stopped => |signal| @intFromEnum(signal),
            .unknown => |code| code,
        },
    };

    return result;
}
