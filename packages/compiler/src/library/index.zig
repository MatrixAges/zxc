const std = @import("std");
const generated = @import("parser_options").generated_parser;
const Self = @This();
const Claim = if (generated) StateCall(@import("generated_library_index_claim").executeState) else void;
const State = if (generated) @FieldType(Claim.Input, "index") else std.StringHashMapUnmanaged(u32);
const Error = std.mem.Allocator.Error || error{ InvalidModule, DuplicateExport, InvalidAnalysis };

state: State = if (generated) .{
    .keys = .{ .items = &.{}, .storage = .plain },
    .values = .{ .items = &.{}, .storage = .plain },
    .buckets = .{ .items = &.{}, .storage = .plain },
} else .empty,
pub fn admit(self: *Self, allocator: std.mem.Allocator, name: []const u8, row: usize, analyzed: bool) Error!void {
    if (!generated) {
        if (name.len == 0 or std.mem.indexOfScalar(u8, name, 0) != null or !std.unicode.utf8ValidateSlice(name)) return error.InvalidModule;
        if (try self.register(allocator, name, row) != null) return error.DuplicateExport;
        if (!analyzed) return error.InvalidAnalysis;

        return;
    }

    const Admission = StateCall(@import("generated_library_export_admission").executeState);

    const result = Admission.run(allocator, .{
        .index = self.state,
        .name = name,
        .row = std.math.cast(u32, row) orelse return error.OutOfMemory,
        .analyzed = analyzed,
    }) catch |err| return failure(err);

    self.state = result.index;

    return switch (result.status) {
        .Accepted => {},
        .InvalidName => error.InvalidModule,
        .Duplicate => error.DuplicateExport,
        .InvalidAnalysis => error.InvalidAnalysis,
    };
}

pub fn register(self: *Self, allocator: std.mem.Allocator, key: []const u8, row: usize) std.mem.Allocator.Error!?u32 {
    const id = std.math.cast(u32, row) orelse return error.OutOfMemory;

    if (!generated) {
        const entry = try self.state.getOrPut(allocator, key);

        if (entry.found_existing) return entry.value_ptr.*;

        entry.value_ptr.* = id;

        return null;
    }

    const result = Claim.run(allocator, .{
        .index = self.state,
        .key = .{ .items = key, .storage = .plain },
        .value = id,
    }) catch |err| return failure(err);

    self.state = result.index;

    return result.previous;
}

fn StateCall(comptime execute: anytype) type {
    const function = @typeInfo(@TypeOf(execute)).@"fn";
    const Parameter = function.param_types[1].?;
    const indirect = @typeInfo(Parameter) == .pointer;

    return struct {
        pub const Input = if (indirect) std.meta.Child(Parameter) else Parameter;

        pub fn run(allocator: std.mem.Allocator, input: Input) function.return_type.? {
            return execute(allocator, if (indirect) &input else input);
        }
    };
}

fn failure(err: anyerror) std.mem.Allocator.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => unreachable,
    };
}
