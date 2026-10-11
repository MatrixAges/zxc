const std = @import("std");

pub fn rows(comptime View: type, source: anytype) View {
    @setEvalBranchQuota(100_000);

    comptime var count: usize = 2;

    inline for (@typeInfo(@TypeOf(source.payloads)).@"struct".field_names) |name| count += comptime columnCount(@FieldType(@TypeOf(source.payloads), name));

    if (@typeInfo(View).@"struct".field_names.len != count) @compileError("AST row view has a different column count");

    var result: View = undefined;

    result.tags = slice(@FieldType(View, "tags"), source.tags.items);
    result.offsets = source.offsets.items;

    inline for (@typeInfo(@TypeOf(source.payloads)).@"struct".field_names) |name| {
        fill(&result, name, &@field(source.payloads, name));
    }

    return result;
}

pub fn members(comptime View: type, source: anytype) View {
    if (comptime @typeInfo(View).@"struct".field_names.len != columnCount(@typeInfo(@TypeOf(source)).pointer.child)) @compileError("AST member view has a different column count");

    var result: View = undefined;

    fill(&result, "", source);

    return result;
}

fn fill(target: anytype, comptime prefix: []const u8, source: anytype) void {
    const Source = @typeInfo(@TypeOf(source)).pointer.child;
    const Target = @typeInfo(@TypeOf(target)).pointer.child;

    if (@hasField(Source, "fields")) {
        inline for (@typeInfo(@TypeOf(source.fields)).@"struct".field_names) |name| {
            fill(target, if (prefix.len == 0) name else prefix ++ "_" ++ name, &@field(source.fields, name));
        }
    } else if (@typeInfo(@TypeOf(source.values.items)).pointer.child != void) {
        @field(target.*, prefix) = slice(@FieldType(Target, prefix), source.values.items);
    }
}

fn slice(comptime Target: type, source: anytype) Target {
    const From = @typeInfo(@TypeOf(source)).pointer.child;
    const To = @typeInfo(Target).pointer.child;

    comptime compatible(From, To);

    return @as([*]const To, @ptrCast(source.ptr))[0..source.len];
}

fn columnCount(comptime Column: type) usize {
    if (!@hasField(Column, "fields")) return if (@typeInfo(@FieldType(@FieldType(Column, "values"), "items")).pointer.child == void) 0 else 1;

    const Fields = @FieldType(Column, "fields");
    var count: usize = 0;

    for (@typeInfo(Fields).@"struct".field_names) |name| count += columnCount(@FieldType(Fields, name));

    return count;
}

fn compatible(comptime From: type, comptime To: type) void {
    if (From == To) return;
    if (@sizeOf(From) != @sizeOf(To) or @alignOf(From) != @alignOf(To)) @compileError("AST column layout does not match the generated view");

    const source = @typeInfo(From);
    const target = @typeInfo(To);

    if (source == .pointer and target == .pointer and source.pointer.size == .slice and target.pointer.size == .slice) return compatible(source.pointer.child, target.pointer.child);
    if (source == .optional and target == .optional) return compatible(source.optional.child, target.optional.child);
    if (source == .@"enum" and target == .int and source.@"enum".mode == .nonexhaustive and source.@"enum".tag_type == To) return;
    if (source != .@"enum" or target != .@"enum" or source.@"enum".tag_type != target.@"enum".tag_type) @compileError("AST column types do not share a representation");

    const left = source.@"enum".field_names;
    const right = target.@"enum".field_names;

    if (left.len != right.len) @compileError("AST enum view has a different member count");

    for (left, right) |before, after| {
        if (!std.mem.eql(u8, pascal(before), after) or @backingInt(@field(From, before)) != @backingInt(@field(To, after))) @compileError("AST enum view has a different member mapping");
    }
}

fn pascal(comptime source: []const u8) []const u8 {
    comptime var result: []const u8 = "";
    comptime var upper = true;

    inline for (source) |byte| {
        if (byte == '_') {
            upper = true;
        } else {
            result = result ++ &[_]u8{if (upper) comptime std.ascii.toUpper(byte) else byte};
            upper = false;
        }
    }

    return result;
}
