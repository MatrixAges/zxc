const std = @import("std");
const windows = std.os.windows;
const Self = @This();
const kill_on_job_close = 0x2000;
const extended_limit_information = 9;

child: std.process.Child,
job: windows.HANDLE,
pub fn start(io: std.Io, argv: []const []const u8, environment: *const std.process.Environ.Map) !Self {
    const job = CreateJobObjectW(null, null) orelse return error.CreateJobFailed;

    errdefer windows.CloseHandle(job);

    var limits = std.mem.zeroes(Limits);

    limits.basic.flags = kill_on_job_close;

    if (SetInformationJobObject(job, extended_limit_information, &limits, @sizeOf(Limits)) == 0) return error.ConfigureJobFailed;

    var child = try std.process.spawn(io, .{ .argv = argv, .environ_map = environment, .stdin = .ignore, .start_suspended = true });

    errdefer child.kill(io);

    if (AssignProcessToJobObject(job, child.id.?) == 0) return error.AssignJobFailed;
    if (ResumeThread(child.thread_handle) == std.math.maxInt(u32)) return error.ResumeProcessFailed;

    return .{ .child = child, .job = job };
}

pub fn finished(self: *Self) !bool {
    return switch (WaitForSingleObject(self.child.id.?, 0)) {
        0 => true,
        258 => false,
        else => error.ProcessWaitFailed,
    };
}

pub fn stop(self: *Self, io: std.Io) !std.process.Child.Term {
    const protection = io.swapCancelProtection(.blocked);
    defer _ = io.swapCancelProtection(protection);

    windows.CloseHandle(self.job);

    return self.child.wait(io);
}

const Limits = extern struct {
    basic: extern struct {
        process_time: i64,
        job_time: i64,
        flags: u32,
        minimum_working_set: usize,
        maximum_working_set: usize,
        active_processes: u32,
        affinity: usize,
        priority_class: u32,
        scheduling_class: u32,
    },
    io: [6]u64,
    process_memory: usize,
    job_memory: usize,
    peak_process_memory: usize,
    peak_job_memory: usize,
};

extern "kernel32" fn CreateJobObjectW(?*anyopaque, ?[*:0]const u16) callconv(.winapi) ?windows.HANDLE;
extern "kernel32" fn SetInformationJobObject(windows.HANDLE, c_int, *const anyopaque, u32) callconv(.winapi) c_int;
extern "kernel32" fn AssignProcessToJobObject(windows.HANDLE, windows.HANDLE) callconv(.winapi) c_int;
extern "kernel32" fn ResumeThread(windows.HANDLE) callconv(.winapi) u32;
extern "kernel32" fn WaitForSingleObject(windows.HANDLE, u32) callconv(.winapi) u32;
