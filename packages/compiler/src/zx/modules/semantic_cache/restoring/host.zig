const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Record = @import("../../module_record.zig");
const FunctionImport = @import("../../function_import.zig");

pub fn dependencies(previous: []const Record.Import, current: []const Record.Import) bool {
    if (previous.len != current.len) return false;

    const generated = @import("generated_semantic_restore_dependency");
    const Input = std.meta.Child(generated.Input);
    const Row = std.meta.Child(@FieldType(Input, "previous"));

    for (previous, current) |*left, *right| {
        const a = dependency(Row, left);
        const b = dependency(Row, right);
        const input: Input = .{ .previous = &a, .current = &b };

        if (!check(generated, &input)) return false;
    }

    return true;
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

pub fn alias(previous: *const ir.Export, current: *const ir.Export, types: []const ir.TypeId) bool {
    const generated = @import("generated_semantic_restore_alias");

    const input: std.meta.Child(generated.Input) = .{
        .previous_name = previous.name,
        .current_name = current.name,
        .previous_type = @backingInt(previous.type_id),
        .current_type = @backingInt(current.type_id),
        .types = @ptrCast(types),
    };

    return check(generated, &input);
}

pub fn bind(previous: *const FunctionImport, current: *const FunctionImport, mapping: []?ir.FunctionId, types: []const ir.TypeId, current_count: usize) bool {
    const generated = @import("generated_semantic_restore_binding");
    const Input = std.meta.Child(generated.Input);
    const Binding = std.meta.Child(@FieldType(Input, "previous"));
    const left = binding(Binding, previous);
    const right = binding(Binding, current);

    const input: Input = .{
        .previous = &left,
        .current = &right,
        .mapping = @ptrCast(mapping),
        .types = @ptrCast(types),
        .current_count = current_count,
    };

    if (!check(generated, &input)) return false;
    if (previous.id) |id| mapping[@backingInt(id)] = current.id;

    return true;
}

fn binding(comptime Binding: type, value: *const FunctionImport) Binding {
    return .{
        .namespace = value.namespace,
        .name = value.name,
        .id = if (value.id) |id| @backingInt(id) else null,
        .input_type = if (value.input_type) |id| @backingInt(id) else null,
        .output_type = if (value.output_type) |id| @backingInt(id) else null,
        .intrinsic = if (value.intrinsic) |operation| @intFromEnum(operation) else null,
    };
}

pub fn sameSignature(previous: ir.Signature, current: ir.Signature, types: []const ir.TypeId) bool {
    const generated = @import("generated_semantic_restore_signature");
    const Input = std.meta.Child(generated.Input);
    const Signature = std.meta.Child(@FieldType(Input, "previous"));
    const left = signature(Signature, previous);
    const right = signature(Signature, current);
    const input: Input = .{ .previous = &left, .current = &right, .types = @ptrCast(types) };

    return check(generated, &input);
}

fn signature(comptime Signature: type, value: ir.Signature) Signature {
    return .{
        .file = value.file_name,
        .input_type = @backingInt(value.input_type),
        .output_type = @backingInt(value.output_type),
        .ownership = switch (value.output_ownership) {
            .copy => .Copy,
            .borrowed => .Borrowed,
            .owned => .Owned,
        },
    };
}

fn check(comptime generated: type, input: anytype) bool {
    var empty = std.heap.FixedBufferAllocator.init(&.{});

    return zx.columns.invoke(generated.executeValue, empty.allocator(), input) catch unreachable;
}
