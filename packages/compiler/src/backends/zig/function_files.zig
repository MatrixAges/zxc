const std = @import("std");
const zx = @import("zx");
const File = @import("modules.zig").File;
const initialize = @import("generated_function_files_initialize");
const registration = @import("generated_function_files_register");
const State = @typeInfo(@typeInfo(@TypeOf(initialize.executeState)).@"fn".return_type.?).error_union.payload;
const Self = @This();
pub const Error = std.mem.Allocator.Error || error{ConflictingFunction};

state: State,
allocator: std.mem.Allocator,
pub fn create(allocator: std.mem.Allocator) Error!Self {
    return .{ .state = initialize.executeState(allocator, .{}) catch |err| return failure(err), .allocator = allocator };
}

pub fn register(self: *Self, files: []const File, candidate: *const File) Error!bool {
    const Input = @typeInfo(@TypeOf(registration.executeState)).@"fn".param_types[1].?;
    const Files = @FieldType(Input, "files");

    const input: Input = .{
        .registry = self.state,
        .files = .{ .items = zx.columns.slice(@FieldType(Files, "items"), files), .storage = .plain },
        .candidate = .{
            .imports = .{ .items = candidate.imports, .storage = .plain },
            .name = .{ .items = candidate.name, .storage = .plain },
            .source = .{ .items = candidate.source, .storage = .plain },
        },
    };

    self.state = registration.executeState(self.allocator, input) catch |err| return failure(err);

    return switch (self.state.status) {
        .Append => true,
        .Reuse => false,
        .Conflict => error.ConflictingFunction,
    };
}

fn failure(err: anyerror) std.mem.Allocator.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => unreachable,
    };
}
