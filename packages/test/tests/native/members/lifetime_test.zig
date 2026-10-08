const std = @import("std");
const f = @import("fixture.zig");
const batch = @import("batch.zig");

fn shared(program: f.compiler.ir.Program, depth: usize) !void {
    const first = program.functions.at(0);
    const prefix = first.external.?.member;

    for (1..program.functions.count()) |index| {
        const function = program.functions.at(index);
        const member = function.external.?.member;

        try std.testing.expect(first.file_name.ptr == function.file_name.ptr);
        try std.testing.expect(prefix.ptr != member.ptr);
        for (0..depth) |part| try std.testing.expect(prefix[part].ptr == member[part].ptr);
    }
}

test "native members share owned prefix bytes and retain independent path arrays" {
    var result = block: {
        var input = std.heap.ArenaAllocator.init(std.testing.allocator);

        defer input.deinit();

        const allocator = input.allocator();
        const declaration = try allocator.dupe(u8, batch.case.declaration);
        const path = try allocator.dupe(u8, batch.case.path);
        const parts = try allocator.alloc([]const u8, batch.case.namespace.len);

        for (batch.case.namespace, parts) |text, *part| part.* = try allocator.dupe(u8, text);

        var case = batch.case;

        case.declaration = declaration;
        case.path = path;
        case.namespace = parts;

        var value = try f.analyze(std.testing.allocator, case);

        errdefer value.deinit();
        @memset(declaration, 'x');
        @memset(path, 'x');
        for (parts) |part| @memset(@constCast(part), 'x');

        break :block value;
    };

    defer result.deinit();

    try std.testing.expect(result.value == .ir);
    try f.inspect(std.testing.allocator, result.value.ir, batch.case);
    try shared(result.value.ir, batch.case.namespace.len);
}

test "root namespace still shares the owned declaration file name" {
    var case = batch.case;
    case.namespace = &.{};

    var result = try f.analyze(std.testing.allocator, case);

    defer result.deinit();

    try std.testing.expect(result.value == .ir);
    try f.inspect(std.testing.allocator, result.value.ir, case);
    try shared(result.value.ir, 0);
}

test "native descriptor results survive release of an independent analysis" {
    var first = try f.analyze(std.testing.allocator, batch.case);
    var first_alive = true;

    defer if (first_alive) first.deinit();

    var second = try f.analyze(std.testing.allocator, batch.case);

    defer second.deinit();
    first.deinit();

    first_alive = false;

    try std.testing.expect(second.value == .ir);
    try f.inspect(std.testing.allocator, second.value.ir, batch.case);
    try shared(second.value.ir, batch.case.namespace.len);
}
