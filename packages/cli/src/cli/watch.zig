const std = @import("std");
const compile = @import("compile.zig");
const Options = @import("options.zig").Options;
const Inputs = @import("watch/inputs.zig");
const Snapshot = @import("watch/snapshot.zig");
const Attempt = @import("watch/attempt.zig");
const Process = @import("watch/process.zig");

pub fn run(io: std.Io, allocator: std.mem.Allocator, options: Options, environment: *const std.process.Environ.Map, stdout: *std.Io.Writer, stderr: *std.Io.Writer) !void {
    var application = Process{ .allocator = allocator };

    defer application.deinit(io);

    var last_success: ?Snapshot = null;
    var baseline: ?Snapshot = null;
    var backend_arena = std.heap.ArenaAllocator.init(allocator);
    var backend_paths: []const []const u8 = &.{};
    var previous_message: []const u8 = &.{};
    var status: compile.Status = .retry;

    defer if (last_success) |*snapshot| snapshot.deinit();
    defer if (baseline) |*snapshot| snapshot.deinit();
    defer backend_arena.deinit();
    defer allocator.free(previous_message);

    try stderr.print("zxc watch: watching {s}\n", .{options.input});
    try stderr.flush();

    while (true) {
        if (options.run and @import("watch/interrupt.zig").requested()) return;

        if (baseline) |snapshot| {
            if (try wait(io, allocator, snapshot, status, stderr, &application)) {
                allocator.free(previous_message);

                previous_message = &.{};
            }
        }

        var arena = std.heap.ArenaAllocator.init(allocator);

        defer arena.deinit();

        const temporary = arena.allocator();
        var inputs = try Inputs.init(io, allocator);

        defer inputs.deinit();

        var attempt = Attempt{ .allocator = temporary, .inputs = &inputs, .previous_backend = backend_paths };
        var diagnostics: std.Io.Writer.Allocating = .init(temporary);

        status = compile.run(.{ .io = io, .allocator = temporary, .options = options, .environment = environment, .stdout = stdout, .stderr = &diagnostics.writer, .watch = &attempt }) catch |err| failed: {
            if (err == error.OutOfMemory or err == error.Canceled) return err;

            try diagnostics.writer.print("{s}: {s}\n", .{ options.input, @errorName(err) });

            break :failed .failed;
        };

        if (attempt.backend_paths) |paths| {
            var next = std.heap.ArenaAllocator.init(allocator);

            errdefer next.deinit();

            const owned = try next.allocator().alloc([]const u8, paths.len);

            for (paths, owned) |path, *copy| copy.* = try next.allocator().dupe(u8, path);

            backend_arena.deinit();

            backend_arena = next;
            backend_paths = owned;
        }

        const message = diagnostics.written();
        const key = if (status == .backend_failed) try @import("watch/diagnostics.zig").key(temporary, message) else message;

        if (!std.mem.eql(u8, key, previous_message)) {
            const owned = try allocator.dupe(u8, key);

            allocator.free(previous_message);

            previous_message = owned;

            try stderr.writeAll(message);
        }

        if (status == .success) {
            const next = try inputs.observed(allocator);

            if (last_success) |*snapshot| snapshot.deinit();

            last_success = next;

            try stderr.print("zxc watch: built {s}\n", .{options.output.?});

            if (options.run) {
                if (@import("watch/interrupt.zig").requested()) return;
                try stderr.flush();
                try stdout.flush();

                application.restart(io, options, environment) catch |err| {
                    if (err == error.OutOfMemory or err == error.Canceled) return err;
                    try stderr.print("zxc watch: application start: {s}\n", .{@errorName(err)});
                };
            }
        } else if (last_success) |snapshot| {
            for (snapshot.entries) |entry| {
                (if (entry.directory_entries) inputs.addDirectory(io, entry.path) else inputs.add(io, entry.path)) catch |err| {
                    if (err == error.OutOfMemory or err == error.Canceled) return err;
                };
            }
        }

        const next = try inputs.observed(allocator);

        if (baseline) |*snapshot| snapshot.deinit();

        baseline = next;

        try stderr.flush();
        try stdout.flush();
    }
}

fn wait(io: std.Io, allocator: std.mem.Allocator, baseline: Snapshot, status: compile.Status, stderr: *std.Io.Writer, application: *Process) !bool {
    if (status == .retry) {
        try std.Io.sleep(io, .fromMilliseconds(200), .awake);

        return false;
    }

    var polls: usize = 0;
    var previous_error: ?anyerror = null;

    while (true) {
        try std.Io.sleep(io, .fromMilliseconds(500), .awake);
        if (@import("watch/interrupt.zig").requested()) return error.Canceled;
        try application.poll(io, stderr);

        polls += 1;

        var current = baseline.refresh(io, allocator) catch |err| {
            if (err == error.OutOfMemory or err == error.Canceled) return err;

            if (if (previous_error) |previous| previous != err else true) {
                try stderr.print("zxc watch: input scan: {s}\n", .{@errorName(err)});
                try stderr.flush();
            }

            previous_error = err;

            continue;
        };

        defer current.deinit();

        if (!baseline.same(current)) return true;
        if (status == .backend_failed and polls >= 4) return false;

        previous_error = null;
    }
}
