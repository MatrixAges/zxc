const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;

pub const Action = enum { Skip, Append, Entry, RecursiveEntry, Invalid };

pub fn select(allocator: std.mem.Allocator, entry: bool, stores: usize, function: ?*const ir.Function, id: ir.FunctionId) @import("../artifact/model.zig").Error!Action {
    if (comptime !@import("parser_options").generated_parser) {
        if (!entry) return if (stores != 0) .Invalid else if (function != null) .Append else .Skip;

        if (function) |value| {
            if (@import("../function_body.zig").calls(value.expressions, id)) return .RecursiveEntry;
        }

        return .Entry;
    }

    const generated = @import("generated_artifact_placement");
    const Input = std.meta.Child(generated.Input);
    const Calls = std.meta.Child(@FieldType(Input, "calls"));
    const expressions = if (entry) if (function) |body| &body.expressions else null else null;

    const calls: Calls = .{
        .kinds = if (expressions) |source| zx.columns.slice(@FieldType(Calls, "kinds"), source.kinds) else &.{},
        .payloads = if (expressions) |source| source.payloads else &.{},
        .calls = if (expressions) |source| source.call_functions else &.{},
        .id = @backingInt(id),
    };

    const input: Input = .{ .entry = entry, .stores = stores, .has_body = function != null, .calls = &calls };

    const result = zx.columns.invoke(generated.executeValue, allocator, &input) catch |err| switch (@as(anyerror, err)) {
        error.OutOfMemory => return error.OutOfMemory,
        else => return error.InvalidModule,
    };

    return switch (result) {
        .Skip => .Skip,
        .Append => .Append,
        .Entry => .Entry,
        .RecursiveEntry => .RecursiveEntry,
        .Invalid => .Invalid,
    };
}
