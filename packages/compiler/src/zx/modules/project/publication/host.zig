const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const enabled = @import("parser_options").generated_parser;
const functions = @import("../../function_body.zig");

const Publication = if (enabled)
    @FieldType(@typeInfo(@TypeOf(@import("generated_project_body_publish").executeValue(undefined, undefined))).error_union.payload, "publication")

else
    enum { Types, Dependency, Entry, RecursiveDependency, RecursiveEntry };

pub const Plan = struct {
    id: ?ir.FunctionId,
    append: bool,
    publication: Publication,
};

pub fn module(program: *const ir.Program, entry: bool, declared: bool, linked: usize, restored: ?*const @import("../../semantic_cache/restore.zig").Restored) std.mem.Allocator.Error!Plan {
    const recovered = if (restored) |value| value.recursive else null;

    if (comptime enabled) {
        const generated = @import("generated_project_body_publish");

        const input: std.meta.Child(generated.Input) = .{
            .type_only = program.type_only,
            .entry = entry,
            .declared = declared,
            .restored = restored != null,
            .restored_function = if (recovered) |id| @backingInt(id) else null,
            .linked_count = linked,
            .calls = program.expressions.call_functions,
        };

        var empty = std.heap.FixedBufferAllocator.init(&.{});

        const result = zx.columns.invoke(generated.executeValue, empty.allocator(), &input) catch |err| switch (@as(anyerror, err)) {
            error.OutOfMemory, error.IntegerOverflow, error.Overflow => return error.OutOfMemory,
            else => unreachable,
        };

        return .{
            .id = if (result.id) |id| @fromBackingInt(id) else null,
            .append = result.append,
            .publication = result.publication,
        };
    }

    const append = recovered == null and !program.type_only;
    const id = recovered orelse if (append) @as(ir.FunctionId, @fromBackingInt(@as(u32, @intCast(linked)))) else null;
    const recursive = !program.type_only and declared and if (restored != null) recovered != null else functions.calls(program.expressions, id.?);

    const publication: Publication = if (program.type_only) .Types else if (entry)
        if (recursive) .RecursiveEntry else .Entry

    else if (recursive) .RecursiveDependency else .Dependency;

    return .{
        .id = id,
        .append = append,
        .publication = publication,
    };
}

pub const Entry = struct {
    forward: ?ir.FunctionId,
    visible_count: usize,
};

pub fn finalize(program: *const ir.Program, own: ?ir.FunctionId, linked: usize, entry_type_only: bool) Entry {
    if (comptime enabled) {
        const generated = @import("generated_project_entry_publish");

        const input: std.meta.Child(generated.Input) = .{
            .type_only = entry_type_only,
            .own = if (own) |id| @backingInt(id) else null,
            .linked_count = linked,
            .calls = program.expressions.call_functions,
        };

        var empty = std.heap.FixedBufferAllocator.init(&.{});
        const result = zx.columns.invoke(generated.executeValue, empty.allocator(), &input) catch unreachable;

        return .{
            .forward = if (result.forward) |id| @fromBackingInt(id) else null,
            .visible_count = @intCast(result.visible_count),
        };
    }

    const recursive = if (own) |id| functions.calls(program.expressions, id) else false;
    const count = linked - @intFromBool(!entry_type_only and !recursive);

    return .{ .forward = if (recursive) own else null, .visible_count = count };
}
