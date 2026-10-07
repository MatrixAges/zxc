const std = @import("std");

pub fn columns(comptime Target: type, value: anytype) Target {
    @setEvalBranchQuota(100_000);

    const Source = @TypeOf(value);
    const names = @typeInfo(Target).@"struct".field_names;

    if (names.len != @typeInfo(Source).@"struct".field_names.len) @compileError("Incompatible column count");

    var result: Target = undefined;

    inline for (names) |name| {
        const Field = @FieldType(Target, name);
        const source = @field(value, name);

        @field(result, name) = slice(Field, source);
    }

    return result;
}

pub fn slice(comptime Target: type, source: anytype) Target {
    if (Target == @TypeOf(source)) return source;

    comptime compatible(Target, @TypeOf(source));

    const Child = @typeInfo(Target).pointer.child;

    return @as([*]const Child, @ptrCast(source.ptr))[0..source.len];
}

pub fn pointer(comptime Target: type, source: anytype) Target {
    if (Target == @TypeOf(source)) return source;

    comptime compatible(Target, @TypeOf(source));

    return @ptrCast(source);
}

fn compatible(comptime Target: type, comptime Source: type) void {
    if (Target == Source) return;
    if (@sizeOf(Target) != @sizeOf(Source) or @alignOf(Target) != @alignOf(Source)) @compileError("Incompatible column representation");

    const target = @typeInfo(Target);
    const source = @typeInfo(Source);

    if (target == .pointer and source == .pointer) {
        const left = target.pointer;
        const right = source.pointer;

        if ((left.size != .slice and left.size != .one) or left.size != right.size or left.sentinel_ptr != null or right.sentinel_ptr != null or !left.attrs.@"const" or !right.attrs.@"const" or !std.meta.eql(left.attrs, right.attrs)) @compileError("Incompatible column pointer");

        return compatible(left.child, right.child);
    }

    if (target == .@"struct" and source == .@"struct") {
        const names = target.@"struct".field_names;

        if (target.@"struct".layout != source.@"struct".layout or names.len != source.@"struct".field_names.len) @compileError("Incompatible column descriptor");

        inline for (names) |name| {
            if (!@hasField(Source, name)) @compileError("Incompatible column descriptor field");
            if (@offsetOf(Target, name) != @offsetOf(Source, name)) @compileError("Incompatible column descriptor offset");

            compatible(@FieldType(Target, name), @FieldType(Source, name));
        }

        return;
    }

    if (target != .@"enum" or source != .@"enum" or target.@"enum".tag_type != source.@"enum".tag_type) @compileError("Incompatible column enum representation");

    const expected = source.@"enum".field_names;
    const actual = target.@"enum".field_names;

    if (expected.len != actual.len) @compileError("Incompatible column enum count");

    inline for (expected, actual) |left, right| {
        if (!std.mem.eql(u8, left, right) or @backingInt(@field(Source, left)) != @backingInt(@field(Target, right))) @compileError("Incompatible column enum mapping");
    }
}
