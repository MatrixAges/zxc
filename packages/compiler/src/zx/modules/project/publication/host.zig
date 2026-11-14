const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const enabled = @import("parser_options").generated_parser;
const functions = @import("../../function_body.zig");

const Publication = if (enabled)
    @FieldType(@typeInfo(@TypeOf(@import("generated_project_body_publish").executeValue(undefined, undefined))).error_union.payload, "publication")

else
    enum { Types, Dependency, Entry };

pub const Plan = struct {
    id: ?ir.FunctionId,
    append: bool,
    body: @FieldType(@import("../../module_record.zig"), "body"),
    own_function: ?ir.FunctionId,
    ownership_count: ?usize,
    publish_artifact: bool,
};

const Request = struct {
    entry: bool,
    declared: bool,
    linked: usize,
    restored: ?*const @import("../../semantic_cache/restore.zig").Restored,
    check_ownership: bool,
    cache: bool,
};

pub fn module(program: *const ir.Program, request: Request) std.mem.Allocator.Error!Plan {
    const entry = request.entry;
    const declared = request.declared;
    const linked = request.linked;
    const restored = request.restored;
    const check_ownership = request.check_ownership;
    const recovered = if (restored) |value| value.recursive else null;

    if (comptime enabled) {
        const generated = @import("generated_project_body_publish");

        const input: std.meta.Child(generated.Input) = .{
            .type_only = program.type_only,
            .entry = entry,
            .declared = declared,
            .restored = restored != null,
            .restored_function = if (recovered) |id| @backingInt(id) else null,
            .check_ownership = check_ownership,
            .cache = request.cache,
            .linked_count = linked,
            .calls = program.expressions.call_functions,
        };

        var empty = std.heap.FixedBufferAllocator.init(&.{});

        const result = zx.columns.invoke(generated.executeValue, empty.allocator(), &input) catch |err| switch (@as(anyerror, err)) {
            error.OutOfMemory, error.IntegerOverflow, error.Overflow => return error.OutOfMemory,
            else => unreachable,
        };

        const id: ?ir.FunctionId = if (result.id) |value| @fromBackingInt(value) else null;

        return .{
            .id = id,
            .append = result.append,
            .body = body(result.publication, id),
            .own_function = if (result.own_function) |value| @fromBackingInt(value) else null,
            .ownership_count = if (result.ownership_count) |count| @intCast(count) else null,
            .publish_artifact = result.publish_artifact,
        };
    }

    const append = recovered == null and !program.type_only;
    const id = recovered orelse if (append) @as(ir.FunctionId, @fromBackingInt(@as(u32, @intCast(linked)))) else null;
    const recursive = !program.type_only and declared and if (restored != null) recovered != null else functions.calls(program.expressions, id.?);
    const publication: Publication = if (program.type_only) .Types else if (entry) .Entry else .Dependency;

    return .{
        .id = id,
        .append = append,
        .body = body(publication, id),
        .own_function = if (recursive) id else null,
        .ownership_count = if (restored == null and check_ownership) linked + @intFromBool(append) - @intFromBool(!program.type_only and !recursive) else null,
        .publish_artifact = request.cache and restored == null,
    };
}

fn body(publication: Publication, id: ?ir.FunctionId) @FieldType(@import("../../module_record.zig"), "body") {
    return switch (publication) {
        .Types => .types,
        .Entry => .entry,
        .Dependency => .{ .function = id.? },
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
