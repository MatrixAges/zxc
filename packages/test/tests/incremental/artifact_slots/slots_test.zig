const std = @import("std");
const compiler = @import("compiler");
const h = @import("check.zig");
const artifact = compiler.project.artifact;

test "entry artifact preserves store permissions and slot identities" {
    var analysis = try h.analyze(std.testing.allocator);

    defer analysis.deinit();

    var result = try artifact.extract(std.testing.allocator, &analysis, 1);

    defer result.deinit();

    try h.check(result.value);
}

test "ordinary helper artifact does not inherit entry capabilities" {
    var analysis = try h.analyze(std.testing.allocator);

    defer analysis.deinit();

    var result = try artifact.extract(std.testing.allocator, &analysis, 0);

    defer result.deinit();

    try std.testing.expect(result.value.function != null);
    try std.testing.expectEqual(@as(usize, 0), result.value.stores.len);
}

test "slot types use local ids after unrelated helper enum is omitted" {
    var analysis = try h.analyze(std.testing.allocator);

    defer analysis.deinit();

    var result = try artifact.extract(std.testing.allocator, &analysis, 1);

    defer result.deinit();

    try h.check(result.value);
    try std.testing.expect(analysis.value.ir.stores[0].type_id != result.value.stores[0].type_id);
    try std.testing.expectEqual(@as(usize, 0), result.value.nominal_types.len);
}

test "copied get and set nodes reference matching local slots" {
    var analysis = try h.analyze(std.testing.allocator);

    defer analysis.deinit();

    var result = try artifact.extract(std.testing.allocator, &analysis, 1);

    defer result.deinit();

    const module = result.value;
    var store_mask: u8 = 0;
    var writes: usize = 0;

    for (module.function.?.expressions) |expression| {
        switch (expression.value) {
            .store_get => |index| {
                try std.testing.expect(index < module.stores.len);
                try std.testing.expectEqual(module.stores[index].type_id, expression.type_id);
                store_mask |= @as(u8, 1) << @intCast(index);
            },
            else => {},
        }
    }

    for (module.function.?.body) |statement| {
        if (statement == .store_set) {
            try std.testing.expectEqual(@as(u32, 0), statement.store_set.slot);
            try std.testing.expect(@intFromEnum(statement.store_set.value) < module.function.?.expressions.len);
            writes += 1;
        }
    }

    try std.testing.expectEqual(@as(u8, 3), store_mask);
    try std.testing.expectEqual(@as(usize, 1), writes);
}

test "slot strings and object fields outlive original analysis mutation and release" {
    var result = blk: {
        var analysis = try h.analyze(std.testing.allocator);

        defer analysis.deinit();

        var extracted = try artifact.extract(std.testing.allocator, &analysis, 1);

        errdefer extracted.deinit();

        for (analysis.value.ir.stores) |slot| {
            @memset(@constCast(slot.path), 'x');
            @memset(@constCast(slot.handle), 'x');
        }


        for ([_]compiler.ir.TypeId{analysis.value.ir.stores[0].type_id}) |id| {
            const fields = analysis.value.ir.types[@intFromEnum(id)].object;

            for (fields) |field| @memset(@constCast(field.name), 'x');
        }

        break :blk extracted;
    };

    defer result.deinit();

    try h.check(result.value);
}
