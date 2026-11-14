const std = @import("std");
const ir = @import("zx").ir;
const comparison = @import("frontend").compare_ir;
const projection = comparison.borrow;
const generated = @import("parser_options").generated_parser;

pub fn matches(left: *const ir.Function, right: *const ir.Function, left_version: u32, right_version: u32, mapping: ?[]const ir.TypeId) bool {
    if (!generated) {
        const seed = @import("function_equal_seed.zig");

        if (left_version != right_version) return false;

        return if (mapping) |map| seed.source(left, right, map) else seed.linked(left, right);
    }

    const entry = @import("generated_library_initializer_compare");
    const Input = std.meta.Child(entry.Input);
    const Pair = std.meta.Child(@FieldType(Input, "header"));
    const Header = std.meta.Child(@FieldType(Pair, "left"));
    const Native = std.meta.Child(@typeInfo(@FieldType(Header, "native")).optional.child);
    const Types = std.meta.Child(@FieldType(Input, "types"));
    const Ids = std.meta.Child(@FieldType(Types, "symbols"));
    const Columns = std.meta.Child(@FieldType(Input, "columns"));
    const map = if (mapping) |values| @as([*]const u32, @ptrCast(values.ptr))[0..values.len] else null;
    const left_native = if (left.external) |value| native(Native, value) else null;
    const right_native = if (right.external) |value| native(Native, value) else null;
    const left_header = header(Header, left, left_version, if (left_native != null) &left_native.? else null);
    const right_header = header(Header, right, right_version, if (right_native != null) &right_native.? else null);
    const headers: Pair = .{ .left = &left_header, .right = &right_header, .mapping = map };
    const symbols = ids(Ids, left.symbols.types, right.symbols.types);
    const expressions = ids(Ids, left.expressions.types, right.expressions.types);
    const types: Types = .{ .symbols = &symbols, .expressions = &expressions, .mapping = map };
    const right_control = if (mapping != null and right.body.root == null) &ir.ControlTable{} else right.body.control;
    var left_columns: projection.Function = undefined;
    var right_columns: projection.Function = undefined;

    left_columns.borrow(.{ &left.stores, &left.symbols, &left.expressions, left.body.control, &left.contracts });
    right_columns.borrow(.{ &right.stores, &right.symbols, &right.expressions, right_control, &right.contracts });

    const input_left = left_columns.view(std.meta.Child(@FieldType(Columns, "left")));
    const input_right = right_columns.view(std.meta.Child(@FieldType(Columns, "right")));
    const columns: Columns = .{ .left = &input_left, .right = &input_right, .masks = &projection.Function.masks };
    const input: Input = .{ .header = &headers, .types = &types, .columns = &columns };
    var fixed = std.heap.FixedBufferAllocator.init(&.{});

    if (!(entry.executeIn(fixed.allocator(), &input) catch unreachable)) return false;

    return comparison.contracts(fixed.allocator(), &left.contracts, &right.contracts);
}

fn header(comptime Target: type, value: *const ir.Function, version: u32, external: @FieldType(Target, "native")) Target {
    return .{
        .version = version,
        .name = value.file_name,
        .transaction = value.store_mode == .transaction,
        .ownership = switch (value.output_ownership) {
            .copy => .Copy,
            .borrowed => .Borrowed,
            .owned => .Owned,
        },
        .input_type = @backingInt(value.input_type),
        .output_type = @backingInt(value.output_type),
        .root = if (value.body.root) |root| @backingInt(root) else null,
        .native = external,
    };
}

fn native(comptime Target: type, value: ir.External) Target {
    return .{
        .module_id = @backingInt(value.module),
        .member = value.member,
        .export_name = value.export_name,
        .allocator = value.allocator_argument,
        .io = value.io_argument,
        .process = value.process_argument,
        .tuple = value.expand_tuple,
        .fallible = value.fallible,
        .concurrent = value.concurrent,
        .input = if (value.input) |input| input.names else null,
        .errors = value.errors,
    };
}

fn ids(comptime Target: type, left: []const u32, right: []const u32) Target {
    return .{ .left = left, .right = right, .left_bytes = std.mem.sliceAsBytes(left), .right_bytes = std.mem.sliceAsBytes(right) };
}
