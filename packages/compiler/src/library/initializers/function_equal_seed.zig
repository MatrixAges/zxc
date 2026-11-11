const std = @import("std");
const ir = @import("zx").ir;

pub fn linked(left: *const ir.Function, right: *const ir.Function) bool {
    return equal(left, right);
}

pub fn source(left: *const ir.Function, right: *const ir.Function, mapping: []const ir.TypeId) bool {
    if (left.input_type != mapping[@backingInt(right.input_type)] or
        left.output_type != mapping[@backingInt(right.output_type)])

        return false;

    if (!mapped(left.symbols.types, right.symbols.types, mapping) or
        !mapped(left.expressions.types, right.expressions.types, mapping))

        return false;

    const body = if (right.body.root == null) ir.ControlBody{} else right.body;

    return equal(left.file_name, right.file_name) and
        left.store_mode == right.store_mode and
        left.output_ownership == right.output_ownership and

        equal(left.external, right.external) and
        equal(&left.stores, &right.stores) and
        equal(&left.contracts, &right.contracts) and
        equal(&left.body, &body) and
        equalFields(ir.SymbolTable, &left.symbols, &right.symbols, "types") and
        equalFields(ir.ExpressionTable, &left.expressions, &right.expressions, "types");
}

fn mapped(left: []const u32, right: []const u32, mapping: []const ir.TypeId) bool {
    if (left.len != right.len) return false;

    for (left, right) |actual, id| {
        if (actual != @backingInt(mapping[id])) return false;
    }

    return true;
}

fn equalFields(comptime T: type, left: *const T, right: *const T, comptime omitted: ?[]const u8) bool {
    if (std.meta.hasFn(T, "jsonStringify")) @compileError("Custom encodings need explicit equality");

    inline for (@typeInfo(T).@"struct".field_names) |name| {
        if (comptime omitted == null or !std.mem.eql(u8, omitted.?, name)) {
            if (!equal(@field(left, name), @field(right, name))) return false;
        }
    }

    return true;
}

fn equal(left: anytype, right: @TypeOf(left)) bool {
    @setEvalBranchQuota(100_000);

    const T = @TypeOf(left);

    return switch (@typeInfo(T)) {
        .bool, .int, .@"enum" => left == right,
        // IR validation establishes finite literals. Keep the sign of zero, as JSON does.
        .float => @as(@Int(.unsigned, @bitSizeOf(T)), @bitCast(left)) == @as(@Int(.unsigned, @bitSizeOf(T)), @bitCast(right)),
        .@"struct" => equalFields(T, &left, &right, null),
        .optional => if (left) |value| if (right) |other| equal(value, other) else false else right == null,
        .pointer => |pointer| switch (pointer.size) {
            .one => left == right or switch (@typeInfo(pointer.child)) {
                .@"struct" => equalFields(pointer.child, left, right, null),
                else => equal(left.*, right.*),
            },
            .slice => sameSlice(pointer.child, left, right),
            else => @compileError("Unsupported function field pointer"),
        },
        else => @compileError("Unsupported function field type"),
    };
}

fn sameSlice(comptime T: type, left: []const T, right: []const T) bool {
    if (left.len != right.len) return false;
    if (left.ptr == right.ptr) return true;
    if (@typeInfo(T) == .int) return std.mem.eql(T, left, right);

    for (left, right) |a, b| {
        if (!equal(a, b)) return false;
    }

    return true;
}
