const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;

pub const borrow = @import("borrow.zig");

pub fn headers(left: *const ir.FunctionTable, right: *const ir.FunctionTable, start: usize, end: usize) bool {
    if (start == end) return true;

    const entry = @import("generated_ir_compare_header");
    const Input = std.meta.Child(entry.Input);
    const Pair = std.meta.Child(@FieldType(Input, "columns"));
    const View = std.meta.Child(@FieldType(Pair, "left"));
    const Native = std.meta.Child(@FieldType(Input, "native"));
    const NativeColumns = std.meta.Child(@FieldType(Native, "left"));
    var lhs: borrow.Header = undefined;
    var rhs: borrow.Header = undefined;

    lhs.borrowRange(.{left}, start, end);
    rhs.borrowRange(.{right}, start, end);

    const a = lhs.view(View);
    const b = rhs.view(View);
    const native_left = native(NativeColumns, left, start, end);
    const native_right = native(NativeColumns, right, start, end);

    const input: Input = .{
        .columns = &.{ .left = &a, .right = &b, .masks = &borrow.Header.masks },
        .native = &.{ .left = &native_left, .right = &native_right },
    };

    var fixed = std.heap.FixedBufferAllocator.init(&.{});

    return entry.executeIn(fixed.allocator(), &input) catch unreachable;
}

fn native(comptime View: type, table: *const ir.FunctionTable, start: usize, end: usize) View {
    var result: View = undefined;

    inline for (@typeInfo(View).@"struct".field_names) |name| {
        @field(result, name) = @field(table, name)[start..end];
    }

    return result;
}

pub fn bodies(left: *const ir.FunctionTable, right: *const ir.FunctionTable, start: usize, end: usize) bool {
    var fixed = std.heap.FixedBufferAllocator.init(&.{});
    const allocator = fixed.allocator();

    for (start..end) |row| {
        const a = .{ left.stores[row], left.symbols[row], left.expressions[row], left.control[row], left.contracts[row] };
        const b = .{ right.stores[row], right.symbols[row], right.expressions[row], right.control[row], right.contracts[row] };
        var shared = true;

        inline for (a, b) |x, y| shared = shared and x == y;

        if (shared) continue;
        if (!tables(borrow.Body, allocator, a, b)) return false;
        if (!contracts(allocator, a[4], b[4])) return false;
    }

    return true;
}

pub fn contracts(allocator: std.mem.Allocator, left: *const ir.ContractTable, right: *const ir.ContractTable) bool {
    if (left == right) return true;

    for (left.symbols, right.symbols, left.expressions, right.expressions) |left_symbols, right_symbols, left_expr, right_expr| {
        if (left_symbols == right_symbols and left_expr == right_expr) continue;
        if (!tables(borrow.Contract, allocator, .{ left_symbols, left_expr }, .{ right_symbols, right_expr })) return false;
    }

    return true;
}

fn tables(comptime Columns: type, allocator: std.mem.Allocator, left: anytype, right: @TypeOf(left)) bool {
    const entry = @import("generated_ir_compare_columns");
    const Input = std.meta.Child(entry.Input);
    const View = std.meta.Child(@FieldType(Input, "left"));
    var lhs: Columns = undefined;
    var rhs: Columns = undefined;

    lhs.borrow(left);
    rhs.borrow(right);

    const a = lhs.view(View);
    const b = rhs.view(View);
    const input: Input = .{ .left = &a, .right = &b, .masks = &Columns.masks };

    return entry.executeIn(allocator, &input) catch unreachable;
}
