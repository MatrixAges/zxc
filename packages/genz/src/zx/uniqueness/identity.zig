const std = @import("std");
const ir = @import("zx").ir;
const Basis = @import("basis.zig");
const Hash = std.crypto.hash.Blake3;
const Self = @This();

/// Content digests of what body analyses read besides the facts they exchange: the program shape every body shares
/// (types, function signatures, the basis) and each body itself. Source spans are left out, so moving code without
/// changing it keeps its digest.
hash: Hash = .init(.{}),
pub fn program(value: ir.Program, basis: *const Basis) [32]u8 {
    var self = Self{};

    self.bytes("zxc.uniqueness.program.v1");
    self.write(value.types);
    self.write(value.functions.count());

    for (0..value.functions.count()) |index| {
        const function = value.functions.at(index);

        self.write(.{ .input_type = function.input_type, .output_type = function.output_type, .external = function.external != null });
    }

    self.write(basis.holds);
    self.write(basis.mutates);

    return self.finish();
}

/// A body within `shared`, the digest of its program shape.
pub fn body(shared: [32]u8, symbols: ir.SymbolTable, expressions: ir.ExpressionTable, block: ir.Block, input_type: ir.TypeId, output_type: ir.TypeId) [32]u8 {
    var self = Self{};

    self.hash.update(&shared);
    self.write(.{ .symbols = symbols, .expressions = expressions, .block = block, .input_type = input_type, .output_type = output_type });

    return self.finish();
}

fn finish(self: *Self) [32]u8 {
    var result: [32]u8 = undefined;

    self.hash.final(&result);

    return result;
}

fn write(self: *Self, value: anytype) void {
    const T = @TypeOf(value);

    if (T == @FieldType(ir.ExpressionRow, "span")) return;
    if (T == ir.ControlBody) return self.write(value.block());

    if (T == ir.Block or T == @FieldType(ir.StatementRow, "parallel") or T == @FieldType(@FieldType(ir.StatementRow, "destructure"), "symbols") or T == @FieldType(@FieldType(ir.StatementRow, "switch_stmt"), "cases")) {
        self.write(value.len);

        for (0..value.len) |index| self.write(value.at(index));

        return;
    }

    if (T == ir.ExpressionTable or T == ir.SymbolTable or T == ir.TypeTable) {
        self.write(value.count());

        for (0..value.count()) |index| self.write(value.at(index));

        return;
    }

    switch (@typeInfo(T)) {
        .@"struct" => |info| inline for (info.field_names) |field| self.write(@field(value, field)),
        .@"union" => switch (value) {
            inline else => |payload, tag| {
                self.bytes(@tagName(tag));
                self.write(payload);
            },
        },
        .@"enum" => self.write(@backingInt(value)),
        .optional => {
            self.write(value != null);

            if (value) |child| self.write(child);
        },
        .pointer => |info| {
            if (info.size != .slice) @compileError("uniqueness identities require value data");
            if (info.child == u8) return self.bytes(value);

            self.write(value.len);

            for (value) |item| self.write(item);
        },
        .bool => self.hash.update(&.{@intFromBool(value)}),
        .int => {
            var encoded: [8]u8 = undefined;

            std.mem.writeInt(u64, &encoded, @as(u64, @truncate(@as(u128, @bitCast(@as(i128, value))))), .little);
            self.hash.update(&encoded);
        },
        .float => self.write(@as(@Int(.unsigned, @bitSizeOf(T)), @bitCast(value))),
        .void => {},
        else => @compileError("unsupported uniqueness identity field"),
    }
}

fn bytes(self: *Self, value: []const u8) void {
    self.write(value.len);
    self.hash.update(value);
}
