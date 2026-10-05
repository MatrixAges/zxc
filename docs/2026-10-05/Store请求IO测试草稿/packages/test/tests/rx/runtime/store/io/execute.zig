const std = @import("std");
const State = @import("zxc_state");
const application = @import("application");
const Fixture = @import("fixture");

pub fn run(state: *State, value: application.Input, io: std.Io) !application.Output {
    var request = state.request();

    defer request.deinit();

    return request.execute(value, io);
}

pub fn input(fixture: *Fixture, path: []const u8, after_path: []const u8) !std.meta.Child(application.Input) {
    return .{ .path = try fixture.path(path), .after_path = try fixture.path(after_path), .max_bytes = 1024 };
}
