const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Record = @import("../../module_record.zig");
const FunctionImport = @import("../../function_import.zig");
const batch_size = @import("../../package_scope.zig").lookup_batch_size;

pub fn dependencies(previous: []const Record.Import, current: []const Record.Import) bool {
    const rule = @import("generated_semantic_restore_dependencies");
    const Input = std.meta.Child(rule.Input);

    return compare(rule, previous, current, Input{ .previous = &.{}, .current = &.{} }, dependency);
}

fn dependency(comptime Row: type, value: *const Record.Import) Row {
    const target = &value.target;
    const compiled = if (target.* == .compiled) &target.compiled else null;

    return .{
        .specifier = value.specifier,
        .identity = value.identity orelse value.specifier,
        .names = value.names,
        .source_names = if (value.source_names.len == 0) value.names else value.source_names,
        .kind = @intFromEnum(value.kind),
        .exported = value.exported,
        .wildcard = value.wildcard,
        .target = @intFromEnum(std.meta.activeTag(target.*)),
        .path = switch (target.*) {
            .source => |path| path,
            .compiled => |artifact| artifact.artifact,
            else => "",
        },
        .instance = if (compiled) |artifact| artifact.instance else "",
        .member = if (compiled) |artifact| artifact.name else "",
    };
}

pub fn aliases(previous: []const ir.Export, current: []const ir.Export, types: []const ir.TypeId) bool {
    const rule = @import("generated_semantic_restore_alias");
    const Input = std.meta.Child(rule.Input);

    return compare(rule, previous, current, Input{ .previous = &.{}, .current = &.{}, .types = @ptrCast(types) }, alias);
}

fn alias(comptime Row: type, value: *const ir.Export) Row {
    return .{ .name = value.name, .type_id = @backingInt(value.type_id) };
}

pub fn bindings(previous: []const FunctionImport, current: []const FunctionImport, mapping: []?ir.FunctionId, types: []const ir.TypeId, current_count: usize) bool {
    const rule = @import("generated_semantic_restore_bindings");
    const Input = std.meta.Child(rule.Input);

    const input: Input = .{
        .previous = &.{},
        .current = &.{},
        .mapping = @ptrCast(mapping),
        .target = @ptrCast(&mapping),
        .types = @ptrCast(types),
        .current_count = current_count,
    };

    return compare(rule, previous, current, input, binding);
}

fn compare(comptime rule: type, previous: anytype, current: @TypeOf(previous), context: anytype, comptime view: anytype) bool {
    if (previous.len != current.len) return false;

    const Row = std.meta.Child(std.meta.Child(@FieldType(@TypeOf(context), "previous")));
    var input = context;
    var left: [batch_size]Row = undefined;
    var right: [batch_size]Row = undefined;
    var left_view: [batch_size]*const Row = undefined;
    var right_view: [batch_size]*const Row = undefined;
    var offset: usize = 0;

    while (offset < previous.len) {
        const count = @min(batch_size, previous.len - offset);
        const end = offset + count;

        for (previous[offset..end], current[offset..end], left[0..count], right[0..count], left_view[0..count], right_view[0..count]) |*a, *b, *l, *r, *p, *q| {
            l.* = view(Row, a);
            r.* = view(Row, b);
            p.* = l;
            q.* = r;
        }

        input.previous = left_view[0..count];
        input.current = right_view[0..count];

        if (!check(rule, @as(*const @TypeOf(input), &input))) return false;

        offset = end;
    }

    return true;
}

fn binding(comptime Row: type, value: *const FunctionImport) Row {
    return value.borrow(Row);
}

fn check(comptime rule: type, input: anytype) bool {
    var empty = std.heap.FixedBufferAllocator.init(&.{});

    return zx.columns.invoke(rule.executeValue, empty.allocator(), input) catch unreachable;
}
