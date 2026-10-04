const std = @import("std");
const ir = @import("compiler").ir;

pub fn wrap(allocator: std.mem.Allocator, child: ir.Program, name: []const u8, repetitions: usize, spare: bool) !ir.Program {
    const span: @FieldType(ir.Symbol, "span") = .{ .start = 0, .end = 0 };
    const functions = try allocator.alloc(ir.Function, child.functions.len + 1);

    @memcpy(functions[0..child.functions.len], child.functions);

    functions[child.functions.len] = .{
        .file_name = child.file_name,
        .stores = child.stores,
        .store_mode = child.store_mode,
        .input_type = child.input_type,
        .output_type = child.output_type,
        .symbols = child.symbols,
        .expressions = child.expressions,
        .body = child.body,
    };

    const stores = try allocator.alloc(ir.StoreSlot, child.stores.len + @intFromBool(spare));
    const mapping = try allocator.alloc(u32, child.stores.len);

    if (spare) stores[0] = .{ .path = "store.orders.spare", .type_id = child.stores[0].type_id };

    @memcpy(stores[@intFromBool(spare)..], child.stores);

    for (mapping, 0..) |*slot, index| slot.* = @intCast(index + @intFromBool(spare));

    const symbols = try allocator.alloc(ir.Symbol, repetitions + 1);
    const expressions = try allocator.alloc(ir.Expression, repetitions + 3);
    const body = try allocator.alloc(ir.Statement, repetitions + 1);

    symbols[0] = .{ .name = "in", .type_id = child.input_type, .span = span };
    expressions[0] = .{ .type_id = child.input_type, .span = span, .value = .{ .reference = @enumFromInt(0) } };

    for (0..repetitions) |index| {
        const id = index + 1;
        symbols[id] = .{ .name = try std.fmt.allocPrint(allocator, "result_{d}", .{index}), .type_id = child.output_type, .span = span };
        expressions[id] = .{ .type_id = child.output_type, .span = span, .value = .{ .call = .{ .function = @enumFromInt(child.functions.len), .argument = @enumFromInt(0), .stores = mapping } } };
        body[index] = .{ .constant = .{ .symbol = @enumFromInt(id), .value = @enumFromInt(id) } };
    }

    const state_index = repetitions + 1;
    const state_type = child.stores[0].type_id;
    var count_index: u32 = undefined;

    for (child.typeOf(state_type).object, 0..) |field, index| if (std.mem.eql(u8, field.name, "count")) {
        count_index = @intCast(index);
    };

    expressions[state_index] = .{ .type_id = state_type, .span = span, .value = .{ .store_get = mapping[0] } };
    expressions[state_index + 1] = .{ .type_id = child.output_type, .span = span, .value = .{ .field = .{ .target = @enumFromInt(state_index), .index = count_index } } };
    body[repetitions] = .{ .result = @enumFromInt(state_index + 1) };

    return .{
        .file_name = name,
        .types = child.types,
        .input_type = child.input_type,
        .output_type = child.output_type,
        .symbols = symbols,
        .expressions = expressions,
        .body = body,
        .exports = child.exports,
        .stores = stores,
        .store_mode = .orchestration,
        .functions = functions,
    };
}
