const std = @import("std");

/// Borrows raw storage without copying. Consumers mask unused bits of narrow packed fields.
pub fn view(comptime Target: type, source: anytype) Target {
    @setEvalBranchQuota(100_000);

    const Source = @TypeOf(source);

    if (Target == Source) return source;

    const target = @typeInfo(Target);

    if (target == .@"struct") {
        var result: Target = undefined;

        inline for (target.@"struct".field_names) |name| {
            @field(result, name) = if (comptime std.mem.eql(u8, name, "zx_origin")) null else view(@FieldType(Target, name), @field(source, name));
        }

        return result;
    }

    comptime compatible(Target, Source);

    if (target == .pointer) {
        if (target.pointer.size == .slice) return @as([*]const target.pointer.child, @ptrCast(source.ptr))[0..source.len];

        return @ptrCast(source);
    }

    if (@typeInfo(Source) == .@"enum") return @backingInt(source);
    if (target == .int and @typeInfo(Source) == .int) return @intCast(source);

    return @as(@typeInfo(Source).@"struct".backing_integer.?, @bitCast(source));
}

fn compatible(comptime Target: type, comptime Source: type) void {
    if (Target == Source) return;
    if (@sizeOf(Target) != @sizeOf(Source) or @alignOf(Target) != @alignOf(Source)) @compileError("Incompatible storage representation: " ++ @typeName(Source) ++ " -> " ++ @typeName(Target));

    const target = @typeInfo(Target);
    const source = @typeInfo(Source);

    if (target == .int and source == .int and target.int.bits == source.int.bits and target.int.signedness == source.int.signedness) return;

    if (target == .pointer and source == .pointer) {
        const left = target.pointer;
        const right = source.pointer;

        if ((left.size != .slice and left.size != .one) or left.size != right.size or left.sentinel_ptr != null or right.sentinel_ptr != null or !left.attrs.@"const" or !right.attrs.@"const" or !std.meta.eql(left.attrs, right.attrs)) @compileError("Storage views require matching read-only pointers");

        return compatible(left.child, right.child);
    }

    if (target == .@"struct" and source == .@"struct") {
        const names = target.@"struct".field_names;

        if (target.@"struct".layout != source.@"struct".layout or names.len != source.@"struct".field_names.len) @compileError("Incompatible storage descriptor");

        inline for (names) |name| {
            if (!@hasField(Source, name)) @compileError("Incompatible storage descriptor field");
            if (@offsetOf(Target, name) != @offsetOf(Source, name)) @compileError("Incompatible storage descriptor offset");
            if (target.@"struct".layout == .@"packed" and @bitOffsetOf(Target, name) != @bitOffsetOf(Source, name)) @compileError("Incompatible storage descriptor bit offset");

            compatible(@FieldType(Target, name), @FieldType(Source, name));
        }

        return;
    }

    if (target == .int and source == .@"enum" and Source != Target) {
        if (Target == source.@"enum".tag_type) return;
    }

    if (target == .int and target.int.signedness == .unsigned and target.int.bits == @sizeOf(Source) * 8 and source == .@"struct" and source.@"struct".layout == .@"packed") {
        const backing = @typeInfo(source.@"struct".backing_integer.?).int;

        if (backing.signedness == .unsigned and backing.bits <= target.int.bits) return;
    }

    @compileError("Incompatible storage scalar");
}
