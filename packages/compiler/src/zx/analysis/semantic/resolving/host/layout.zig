const std = @import("std");

pub fn borrow(comptime T: type, values: anytype) T {
    @setEvalBranchQuota(100_000);
    comptime compatible(T, @TypeOf(values));

    return @ptrCast(values);
}

fn compatible(comptime Target: type, comptime Source: type) void {
    if (Target == Source) return;
    if (@sizeOf(Target) != @sizeOf(Source) or @alignOf(Target) != @alignOf(Source)) @compileError("type source ABI size or alignment differs");

    const target = @typeInfo(Target);
    const source = @typeInfo(Source);

    if (std.meta.activeTag(target) != std.meta.activeTag(source)) @compileError("type source ABI representation differs");

    switch (target) {
        .optional => |optional| compatible(optional.child, source.optional.child),
        .pointer => |pointer| {
            if (pointer.size != source.pointer.size or !std.meta.eql(pointer.attrs, source.pointer.attrs) or pointer.sentinel_ptr != null or source.pointer.sentinel_ptr != null) @compileError("type source ABI pointer shape differs");

            compatible(pointer.child, source.pointer.child);
        },
        .@"struct" => |structure| {
            if (structure.field_names.len != source.@"struct".field_names.len) @compileError("type source ABI field count differs");

            for (structure.field_names) |name| {
                if (!@hasField(Source, name)) @compileError("type source ABI field is missing");
                if (@offsetOf(Target, name) != @offsetOf(Source, name)) @compileError("type source ABI field offset differs");

                compatible(@FieldType(Target, name), @FieldType(Source, name));
            }
        },
        .@"enum" => |enumeration| {
            compatible(enumeration.tag_type, source.@"enum".tag_type);

            if (enumeration.field_names.len != source.@"enum".field_names.len) @compileError("type source ABI enum count differs");

            for (enumeration.field_names) |name| {
                if (!@hasField(Source, name)) @compileError("type source ABI enum member is missing");
                if (@backingInt(@field(Target, name)) != @backingInt(@field(Source, name))) @compileError("type source ABI enum value differs");
            }
        },
        else => @compileError("type source ABI leaf type differs"),
    }
}
