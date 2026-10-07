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

        if (Field == @TypeOf(source)) {
            @field(result, name) = source;
        } else {
            const TargetKind = @typeInfo(Field).pointer.child;
            const SourceKind = @typeInfo(@TypeOf(source)).pointer.child;

            comptime compatible(TargetKind, SourceKind);
            @field(result, name) = @as([*]const TargetKind, @ptrCast(source.ptr))[0..source.len];
        }
    }

    return result;
}

fn compatible(comptime Target: type, comptime Source: type) void {
    if (@typeInfo(Target).@"enum".tag_type != @typeInfo(Source).@"enum".tag_type or @sizeOf(Target) != @sizeOf(Source) or @alignOf(Target) != @alignOf(Source)) @compileError("Incompatible column enum representation");

    const expected = @typeInfo(Source).@"enum".field_names;
    const actual = @typeInfo(Target).@"enum".field_names;

    if (expected.len != actual.len) @compileError("Incompatible column enum count");

    inline for (expected, actual) |left, right| {
        if (!std.mem.eql(u8, left, right) or @backingInt(@field(Source, left)) != @backingInt(@field(Target, right))) @compileError("Incompatible column enum mapping");
    }
}
