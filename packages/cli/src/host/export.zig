const std = @import("std");
const builtin = @import("builtin");

/// The CLI entry as a C-callable symbol of its own object. It builds its own process context the way
/// `std.start` does, so the I/O implementation and every error it returns stay in this compilation unit
/// (error values are numbered per unit).
export fn zxc_host_main(minimal: *const std.process.Init.Minimal) callconv(.c) u8 {
    const checked = builtin.mode == .debug or builtin.mode == .safe;
    var safe_allocator: std.heap.SafeAllocator = .init(std.heap.page_allocator, .{});

    defer if (checked) {
        _ = safe_allocator.deinit();
    };

    const gpa = if (checked) safe_allocator.allocator() else std.heap.c_allocator;
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);

    defer arena.deinit();

    var threaded: std.Io.Threaded = .init(gpa, .{ .argv0 = .init(minimal.args), .environ = minimal.environ });

    defer threaded.deinit();

    var environ_map = std.process.Environ.createMap(minimal.environ, gpa) catch |err| std.process.fatal("failed to parse environment variables: {t}", .{err});

    defer environ_map.deinit();

    const preopens = std.process.Preopens.init(arena.allocator()) catch |err| std.process.fatal("failed to init preopens: {t}", .{err});

    @import("main").main(.{
        .minimal = minimal.*,
        .arena = &arena,
        .gpa = gpa,
        .io = threaded.io(),
        .environ_map = &environ_map,
        .preopens = preopens,
    }) catch |err| {
        std.log.err("{t}", .{err});

        if (@errorReturnTrace()) |trace| std.debug.dumpErrorReturnTrace(trace);

        return 1;
    };

    return 0;
}
