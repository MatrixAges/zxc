const std = @import("std");
const ir = @import("zx").ir;
const Unit = @import("root.zig");
const Self = @This();
pub const Error = std.mem.Allocator.Error || error{ExpansionLimit};

unit: *Unit,
source: []const ir.Expression,
selected: ?[]const bool,
ids: []?ir.ExprId,
symbol_offset: usize,
pub fn init(unit: *Unit, symbols: ir.SymbolTable, expressions: []const ir.Expression, selected: ?[]const bool) Error!Self {
    const offset = unit.symbols.count();
    const ids = try unit.allocator.alloc(?ir.ExprId, expressions.len);

    @memset(ids, null);
    for (0..symbols.count()) |index| try unit.symbols.append(unit.allocator, symbols.at(index));

    return .{ .unit = unit, .source = expressions, .selected = selected, .ids = ids, .symbol_offset = offset };
}

pub fn expression(self: *Self, id: ir.ExprId) Error!ir.ExprId {
    if (self.ids[@backingInt(id)]) |mapped| return mapped;
    if (self.unit.depth == 128) return error.ExpansionLimit;

    self.unit.depth += 1;
    defer self.unit.depth -= 1;

    var item = self.source[@backingInt(id)];
    const selected = if (self.selected) |flags| flags[@backingInt(id)] else true;

    const result = if (selected and item.value == .call and self.unit.plan.accepts(item.value.call.function)) blk: {
        const call = item.value.call;
        const argument = try self.expression(call.argument);
        const function = self.unit.plan.program.functions[@backingInt(call.function)];
        var child = try init(self.unit, function.symbols, function.expressions, null);
        const returned = try @import("block.zig").lower(&child, function.body, null, function.output_type, item.span);
        const input: ir.SymbolId = @fromBackingInt(@intCast(child.symbol_offset));

        if (self.unit.costs.items[@backingInt(returned)] > @import("plan.zig").limit) return error.ExpansionLimit;

        break :blk try @import("block.zig").bind(&child, .{ .symbol = input, .value = argument }, returned, item.type_id, item.span);
    } else blk: {
        item.value = try self.value(@TypeOf(item.value), item.value);

        break :blk try self.unit.append(item);
    };

    self.ids[@backingInt(id)] = result;

    return result;
}

pub fn value(self: *Self, comptime T: type, source: T) Error!T {
    if (T == ir.ExprId) return self.expression(source);
    if (T == ir.SymbolId) return @fromBackingInt(@intCast(self.symbol_offset + @backingInt(source)));

    return switch (@typeInfo(T)) {
        .@"struct" => |info| blk: {
            var result = source;

            inline for (info.field_names) |name| @field(result, name) = try self.value(@FieldType(T, name), @field(source, name));

            break :blk result;
        },
        .@"union" => |info| blk: {
            inline for (info.field_names) |name| if (std.mem.eql(u8, @tagName(source), name)) {
                break :blk @unionInit(T, name, try self.value(@FieldType(T, name), @field(source, name)));
            };

            unreachable;
        },
        .optional => |info| if (source) |child| try self.value(info.child, child) else null,
        .pointer => |info| blk: {
            if (info.size != .slice or info.child == u8) break :blk source;

            const result = try self.unit.allocator.alloc(info.child, source.len);

            for (source, result) |item, *mapped| mapped.* = try self.value(info.child, item);

            break :blk result;
        },
        else => source,
    };
}
