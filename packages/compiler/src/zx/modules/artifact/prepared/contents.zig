const std = @import("std");
const zx = @import("zx");
const Record = @import("../../module_record.zig");
const Error = @import("../model.zig").Error;
const generated = @import("generated_artifact_dependency_record");
const Input = std.meta.Child(generated.Input);

pub fn dependencies(allocator: std.mem.Allocator, source: []const Record.Import) Error![]const Record.Import {
    const result = try allocator.alloc(Record.Import, source.len);

    for (source, result) |*borrowed, *owned| {
        const input: Input = .{
            .specifier = borrowed.specifier,
            .identity = borrowed.identity,
            .names = borrowed.names,
            .source_names = borrowed.source_names,
            .path = if (borrowed.target == .source) borrowed.target.source else null,
        };

        const row = zx.columns.invoke(generated.executeValue, allocator, &input) catch |err| switch (@as(anyerror, err)) {
            error.OutOfMemory => return error.OutOfMemory,
            else => return error.InvalidModule,
        };

        owned.* = borrowed.*;
        owned.specifier = row.specifier;
        owned.identity = row.identity;
        owned.names = row.names;
        owned.source_names = row.source_names;

        if (row.path) |path| owned.target = .{ .source = path };
    }

    return result;
}
