const std = @import("std");
const store = @import("store_fixture");
pub const compiler = @import("compiler");
pub const Mode = enum { single, duplicate, version_conflict, value_conflict, omitted };
pub const identity = "store.state.store.rx:counter";

pub fn library(allocator: std.mem.Allocator, mode: Mode) !compiler.library.Result {
    var inferred = try store.infer("state.store.rx", "u64");

    defer inferred.deinit();

    const contract = inferred.value.contract;
    const definition = contract.store_definitions[0];
    const initial = compiler.library.Initializer{ .identity = identity, .schema_version = definition.version, .program = definition.objects[0].initial };
    var changed = initial;
    const integers = try std.testing.allocator.dupe(u64, initial.program.expressions.integers);

    defer std.testing.allocator.free(integers);

    if (mode == .version_conflict) changed.schema_version += 1;

    if (mode == .value_conflict) {
        for (integers) |*integer| integer.* += 1;

        changed.program.expressions.integers = integers;
    }

    var analyzed = compiler.AnalysisResult{ .arena = std.heap.ArenaAllocator.init(std.testing.allocator), .value = .{ .ir = contract.program }, .nominal_types = contract.nominal_types };

    defer analyzed.deinit();

    const inputs = [_]compiler.library.Input{
        .{ .name = "left", .analysis = &analyzed, .initializers = if (mode == .omitted) &.{} else &.{initial} },
        .{ .name = "right", .analysis = &analyzed, .initializers = &.{changed} },
    };

    return compiler.library.link(allocator, inputs[0..if (mode == .single or mode == .omitted) @as(usize, 1) else 2]);
}

pub fn check(value: *const compiler.library.Result, count: usize) !void {
    try std.testing.expectEqual(count, value.store_initializers.len);

    for (value.store_initializers) |initial| {
        const function = value.program.functions[@backingInt(initial.function)];

        try std.testing.expectEqual(@as(u32, 1), initial.schema_version);
        try std.testing.expectEqual(.void, value.program.typeOf(function.input_type).scalar);
        try std.testing.expect(value.program.typeOf(function.output_type) == .object);

        var matched = false;

        for (value.program.functions) |owner| for (0..owner.stores.count()) |store_index| {
            const slot = owner.stores.at(store_index);

            if (!std.mem.eql(u8, slot.path, initial.identity)) continue;
            try std.testing.expectEqual(slot.type_id, function.output_type);

            matched = true;
        };

        try std.testing.expect(matched);

        var literal_found = false;

        for (0..function.expressions.count()) |expression_index| {
            const expression = function.expressions.at(expression_index);

            if (expression.value == .integer) {
                try std.testing.expectEqual(@as(u64, 3), expression.value.integer);

                literal_found = true;
            }
        }

        try std.testing.expect(literal_found);
    }
}

pub fn envelope(text: []const u8, legacy: bool) ![]u8 {
    var digest: [32]u8 = undefined;

    std.crypto.hash.sha2.Sha256.hash(text, &digest, .{});

    return std.fmt.allocPrint(std.testing.allocator, "zxc.library.v{d}\n{s}\n{s}", .{ @as(u8, if (legacy) 1 else 2), std.fmt.bytesToHex(digest, .lower), text });
}

pub fn payload(bytes: []const u8) []const u8 {
    const first = std.mem.indexOfScalar(u8, bytes, '\n').?;
    const second = first + 1 + std.mem.indexOfScalar(u8, bytes[first + 1 ..], '\n').?;

    return bytes[second + 1 ..];
}
