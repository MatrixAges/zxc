const std = @import("std");
const zx = @import("zx");
const generated = @import("parser_options").generated_parser;
const indexing = if (generated) @import("generated_partition_scan_index") else void;
const Index = if (generated) std.meta.Child(indexing.Output) else zx.bytes.Map(u32);
const Self = @This();
pub const References = struct { callees: []const u32, variants: []const []const u8 };
pub const Result = struct { references: References, inline_names: []const []const u8 };
pub const Error = std.mem.Allocator.Error || error{ UnterminatedImport, UnsupportedFunctionReference, MissingFunctionFile };

index: Index,
pub fn init(allocator: std.mem.Allocator, paths: []const []const u8) Error!Self {
    if (comptime !generated) {
        var index: Index = .empty;

        try index.ensureTotalCapacity(allocator, @intCast(paths.len));
        for (paths, 0..) |path, position| index.putAssumeCapacity(path, @intCast(position));

        return .{ .index = index };
    }

    const output = indexing.executeValue(allocator, paths) catch |err| return failure(err);

    return .{ .index = zx.columns.view(Index, output) };
}

pub fn references(self: *const Self, allocator: std.mem.Allocator, source: []const u8) Error!References {
    if (comptime !generated) return @import("scanning_seed.zig").references(allocator, source, &self.index);

    const entry = @import("generated_partition_references");
    const Input = std.meta.Child(entry.Input);
    const input: Input = .{ .source = source, .index = &self.index };
    const output = entry.executeValue(allocator, &input) catch |err| return failure(err);

    try valid(output.status);

    return .{ .callees = output.callees, .variants = output.variants };
}

pub fn scan(self: *const Self, allocator: std.mem.Allocator, source: []const u8) Error!Result {
    if (comptime !generated) return .{
        .references = try @import("scanning_seed.zig").references(allocator, source, &self.index),
        .inline_names = try @import("scanning_seed.zig").inlineNames(allocator, source),
    };

    const entry = @import("generated_partition_scan");
    const Input = std.meta.Child(entry.Input);
    const input: Input = .{ .source = source, .index = &self.index };
    const output = entry.executeValue(allocator, &input) catch |err| return failure(err);

    try valid(output.references.status);

    return .{ .references = .{ .callees = output.references.callees, .variants = output.references.variants }, .inline_names = output.inline_names };
}

fn valid(status: anytype) Error!void {
    return switch (status) {
        .Valid => {},
        .UnterminatedImport => error.UnterminatedImport,
        .UnsupportedFunctionReference => error.UnsupportedFunctionReference,
        .MissingFunctionFile => error.MissingFunctionFile,
    };
}

fn failure(err: anyerror) Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => @panic("invalid partition scan input"),
    };
}
