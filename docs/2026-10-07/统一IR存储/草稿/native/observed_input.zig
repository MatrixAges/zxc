const std = @import("std");
const ir = @import("zx").ir;
const model = @import("model.zig");
const Storage = @import("storage.zig");

pub fn block(allocator: std.mem.Allocator, storage: *Storage, expected: *std.ArrayList(bool), source: []const ir.Statement) error{ OutOfMemory, InvalidBlock }!u32 {
    const values = try allocator.alloc(model.Statement, source.len);

    for (source, values) |statement, *value| value.* = switch (statement) {
        .evaluate => |item| .{ .evaluate = @backingInt(item) },
        .constant => |item| .{ .constant = .{ .symbol = @backingInt(item.symbol), .value = @backingInt(item.value) } },
        .parallel => |items| blk: {
            const invocations = try allocator.alloc(model.Invocation, items.len);

            for (items, invocations) |item, *invocation| invocation.* = .{ .symbol = if (item.symbol) |symbol| @backingInt(symbol) else null, .value = @backingInt(item.value) };

            break :blk .{ .parallel = invocations };
        },
        .destructure => |item| blk: {
            const symbols = try allocator.alloc(?u32, item.symbols.len);

            for (item.symbols, symbols) |symbol, *id| id.* = if (symbol) |present| @backingInt(present) else null;

            break :blk .{ .destructure = .{ .symbols = symbols, .value = @backingInt(item.value) } };
        },
        .branch => |item| .{ .branch = .{ .condition = @backingInt(item.condition), .yes = try block(allocator, storage, expected, item.yes), .no = try block(allocator, storage, expected, item.no) } },
        .switch_stmt => |item| blk: {
            const cases = try allocator.alloc(model.Case, item.cases.len);

            for (item.cases, cases) |case, *selected| selected.* = .{ .value = if (case.value) |expression| @backingInt(expression) else null, .body = try block(allocator, storage, expected, case.body) };

            break :blk .{ .selection = .{ .subject = @backingInt(item.subject), .cases = cases, .exhaustive = item.exhaustive } };
        },
        .store_set => |item| .{ .store_set = .{ .slot = item.slot, .value = @backingInt(item.value) } },
        .result => |item| .{ .result = if (item) |present| @backingInt(present) else null },
    };

    const id = try storage.appendBlock(allocator, values);

    try expected.append(allocator, ir.terminates(source));

    return id;
}
