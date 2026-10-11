//! A generator that stays resident between builds. The first build runs the generator as usual and leaves a copy of
//! it serving requests on a Unix socket in the cache directory; later builds hand their request to that copy, which
//! keeps the parsed modules and cached sources in memory instead of reading and parsing them again. A copy built from
//! another executable, or idle for `idle_limit`, exits. A request the resident copy cannot finish is run again here,
//! so its diagnostics reach the build. `ZXC_RESIDENT_GENERATOR=0` turns this off.
const std = @import("std");
const Resident = @import("state.zig");
const generator = @import("../generate_parser.zig");
const Request = generator.Request;

const socket_name = "generator.sock";
const idle_limit = std.Io.Duration.fromSeconds(15 * 60);
/// Seconds a build waits for the resident generator before generating itself; a cold generation takes a few.
const reply_limit = 120;

const Status = enum(u8) { done, failed, stale, declined };

/// Runs `request`, through the resident generator when one serves this executable.
pub fn run(init: std.process.Init, request: Request) !void {
    const allocator = init.arena.allocator();
    const enabled = !disabled(init.environ_map);

    if (enabled) if (try forward(init.io, allocator, request)) |summary| return print(init.io, summary);

    var resident = try Resident.init(init.io, init.gpa);
    const summary = try generator.generate(init.io, allocator, &resident, request);

    resident.persist();
    try print(init.io, summary);

    if (enabled) start(init, allocator, request.cache) catch {};
}

/// Serves requests on the socket in `cache` until idle for `idle_limit` or asked by another executable.
pub fn serve(init: std.process.Init, cache: []const u8) !void {
    const io = init.io;
    const path = try socketPath(init.arena.allocator(), cache);
    const address = std.Io.net.UnixAddress.init(path) catch return;

    std.Io.Dir.cwd().deleteFile(io, path) catch {};

    var server = address.listen(io, .{}) catch return;

    defer server.deinit(io);

    var resident = try Resident.init(io, init.gpa);
    const identity = try Identity.own(io, init.arena.allocator());
    var watch = Watch{ .io = io, .path = path, .resident = &resident, .last = std.Io.Timestamp.now(io, .awake) };

    _ = try std.Thread.spawn(.{}, Watch.run, .{&watch});

    while (true) {
        const stream = server.accept(io) catch continue;

        defer stream.close(io);

        const status = answer(io, &resident, identity, stream) catch .failed;

        watch.last = std.Io.Timestamp.now(io, .awake);

        if (status == .stale) {
            std.Io.Dir.cwd().deleteFile(io, path) catch {};
            std.process.exit(0);
        }
    }
}

/// Reads one request, runs it, and replies with its status and summary.
fn answer(io: std.Io, resident: *Resident, identity: Identity, stream: std.Io.net.Stream) !Status {
    const allocator = resident.requestAllocator();

    defer resident.endRequest();

    var input_buffer: [4096]u8 = undefined;
    var output_buffer: [4096]u8 = undefined;
    var reader = stream.reader(io, &input_buffer);
    var writer = stream.writer(io, &output_buffer);
    const incoming = &reader.interface;
    const caller = Identity{ .size = try incoming.takeInt(u64, .little), .mtime = try incoming.takeInt(i128, .little), .path = try text(incoming, allocator) };
    const cwd = try text(incoming, allocator);
    const request = Request{ .manifest = try text(incoming, allocator), .output = try text(incoming, allocator), .cache = try text(incoming, allocator), .partitions = try incoming.takeInt(u32, .little) };
    const here = try std.process.currentPathAlloc(io, allocator);
    var summary: []const u8 = "";

    const status: Status = if (!identity.eql(caller)) .stale else if (!std.mem.eql(u8, cwd, here)) .declined else done: {
        summary = generator.generate(io, allocator, resident, request) catch break :done .failed;

        break :done .done;
    };

    try writer.interface.writeByte(@intFromEnum(status));
    try field(&writer.interface, summary);
    try writer.interface.flush();

    return status;
}

/// Hands `request` to the resident generator; null when none answers for this executable and directory.
fn forward(io: std.Io, allocator: std.mem.Allocator, request: Request) !?[]const u8 {
    const path = try socketPath(allocator, request.cache);
    const address = std.Io.net.UnixAddress.init(path) catch return null;
    const stream = address.connect(io) catch return null;

    defer stream.close(io);

    // A resident generator that stops answering must not hold up the build: past the limit the request runs here.
    for ([_]u32{ std.c.SO.RCVTIMEO, std.c.SO.SNDTIMEO }) |option| {
        const limit = std.c.timeval{ .sec = reply_limit, .usec = 0 };

        std.posix.setsockopt(stream.socket.handle, std.c.SOL.SOCKET, option, std.mem.asBytes(&limit)) catch return null;
    }

    const identity = try Identity.own(io, allocator);
    var input_buffer: [4096]u8 = undefined;
    var output_buffer: [4096]u8 = undefined;
    var writer = stream.writer(io, &output_buffer);
    var reader = stream.reader(io, &input_buffer);
    const outgoing = &writer.interface;

    outgoing.writeInt(u64, identity.size, .little) catch return null;
    outgoing.writeInt(i128, identity.mtime, .little) catch return null;

    for ([_][]const u8{ identity.path, try std.process.currentPathAlloc(io, allocator), request.manifest, request.output, request.cache }) |value| field(outgoing, value) catch return null;

    outgoing.writeInt(u32, request.partitions, .little) catch return null;
    outgoing.flush() catch return null;

    const status = std.enums.fromInt(Status, reader.interface.takeByte() catch return null) orelse return null;
    const summary = text(&reader.interface, allocator) catch return null;

    return if (status == .done) summary else null;
}

/// Starts a resident copy of this executable for later builds, detached from the build that started it.
fn start(init: std.process.Init, allocator: std.mem.Allocator, cache: []const u8) !void {
    const executable = try std.process.executablePathAlloc(init.io, allocator);
    var environ = try init.environ_map.clone(allocator);

    // The build runner reads this process's progress pipe until every holder closes it, so the copy must not inherit it.
    if (environ.get("ZIG_PROGRESS")) |descriptor| {
        _ = std.c.fcntl(try std.fmt.parseInt(std.c.fd_t, descriptor, 10), std.c.F.SETFD, @as(c_int, std.c.FD_CLOEXEC));
        _ = environ.swapRemove("ZIG_PROGRESS");
    }

    _ = try std.process.spawn(init.io, .{
        .argv = &.{ executable, "--serve", cache },
        .environ_map = &environ,
        .stdin = .ignore,
        .stdout = .ignore,
        .stderr = .ignore,
        .pgid = 0,
    });
}

/// Ends the resident generator once no request has arrived for `idle_limit`.
const Watch = struct {
    io: std.Io,
    path: []const u8,
    resident: *Resident,
    last: std.Io.Timestamp,

    fn run(self: *Watch) void {
        while (true) {
            self.io.sleep(.fromSeconds(30), .awake) catch {};

            if (self.last.durationTo(std.Io.Timestamp.now(self.io, .awake)).nanoseconds < idle_limit.nanoseconds) continue;

            std.Io.Dir.cwd().deleteFile(self.io, self.path) catch {};
            self.resident.persist();
            std.process.exit(0);
        }
    }
};

/// The executable a generator runs from; a rebuilt generator differs in size or modification time.
const Identity = struct {
    path: []const u8,
    size: u64,
    mtime: i128,

    fn own(io: std.Io, allocator: std.mem.Allocator) !Identity {
        const path = try std.process.executablePathAlloc(io, allocator);
        const stat = try std.Io.Dir.cwd().statFile(io, path, .{});

        return .{ .path = path, .size = stat.size, .mtime = stat.mtime.nanoseconds };
    }

    fn eql(self: Identity, other: Identity) bool {
        return self.size == other.size and self.mtime == other.mtime and std.mem.eql(u8, self.path, other.path);
    }
};

fn socketPath(allocator: std.mem.Allocator, cache: []const u8) ![]const u8 {
    return std.fs.path.join(allocator, &.{ cache, socket_name });
}

fn disabled(environ: *const std.process.Environ.Map) bool {
    const value = environ.get("ZXC_RESIDENT_GENERATOR") orelse return false;

    return std.mem.eql(u8, value, "0");
}

fn print(io: std.Io, summary: []const u8) !void {
    try std.Io.File.stdout().writeStreamingAll(io, summary);
}

fn field(writer: *std.Io.Writer, value: []const u8) !void {
    try writer.writeInt(u32, @intCast(value.len), .little);
    try writer.writeAll(value);
}

fn text(reader: *std.Io.Reader, allocator: std.mem.Allocator) ![]const u8 {
    const length = try reader.takeInt(u32, .little);

    return reader.readAlloc(allocator, length);
}
