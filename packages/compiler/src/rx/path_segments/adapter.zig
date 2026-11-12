const std = @import("std");
const analyze = @import("generated_paths").executeValue;
const write = @import("generated_path_write").executeValue;
const Request = Input(analyze);
const Kind = @FieldType(Request, "kind");
const Error = error{ InvalidPath, OutOfMemory };

pub fn normalize(allocator: std.mem.Allocator, path: []const u8, kind: Kind, suffix: []const u8) Error![]const u8 {
    return resolve(allocator, &.{}, path, kind, suffix);
}

pub fn resolve(allocator: std.mem.Allocator, directory: []const u8, path: []const u8, kind: Kind, suffix: []const u8) Error![]const u8 {
    var empty = std.heap.FixedBufferAllocator.init(&.{});
    const request: Request = .{ .directory = directory, .path = path, .kind = kind, .suffix = suffix };

    const result = invoke(analyze, empty.allocator(), &request) catch |err| switch (@as(anyerror, err)) {
        error.Overflow, error.OutOfMemory => return error.OutOfMemory,
        else => unreachable,
    };

    if (!result.valid) return error.InvalidPath;

    const length = std.math.cast(usize, result.length) orelse return error.OutOfMemory;
    const output = try allocator.alloc(u8, length);

    const emit: Input(write) = .{
        .directory = directory,
        .path = path,
        .suffix = result.suffix,
        .attached = result.attached,
        .capacity = output.len,
        .target = @ptrCast(&output),
    };

    const completed = invoke(write, empty.allocator(), &emit) catch unreachable;

    std.debug.assert(completed.parents == 0 and completed.length == output.len);

    return output;
}

fn Input(comptime function: anytype) type {
    const Parameter = @typeInfo(@TypeOf(function)).@"fn".param_types[1].?;

    return if (@typeInfo(Parameter) == .pointer) std.meta.Child(Parameter) else Parameter;
}

inline fn invoke(comptime function: anytype, allocator: std.mem.Allocator, input: *const Input(function)) @typeInfo(@TypeOf(function)).@"fn".return_type.? {
    const Parameter = @typeInfo(@TypeOf(function)).@"fn".param_types[1].?;

    return function(allocator, if (@typeInfo(Parameter) == .pointer) input else input.*);
}
