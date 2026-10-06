const std = @import("std");
const compiler = @import("compiler");
const f = @import("fixture.zig");

test "records are unique reachable modules in dependency completion order" {
    var result = try f.analyze(std.testing.allocator);

    defer result.deinit();

    try f.check(result);
    try std.testing.expectEqual(@as(usize, 2), result.value.ir.functions.len);
}

test "module bodies identify type entry and correct surviving function ids" {
    var result = try f.analyze(std.testing.allocator);

    defer result.deinit();

    try f.check(result);
    try std.testing.expect(result.modules[0].body == .types);
    try std.testing.expect(result.modules[3].body == .entry);

    for (result.modules[1..3]) |record| {
        try std.testing.expect(record.body == .function);

        const function = result.value.ir.functions[@intFromEnum(record.body.function)];

        try std.testing.expectEqualStrings(record.path, function.file_name);
    }
}

test "direct imports preserve source order kind names target and exact range" {
    var result = try f.analyze(std.testing.allocator);

    defer result.deinit();

    try f.check(result);

    const imports = result.modules[3].imports;

    try std.testing.expectEqual(@as(usize, 3), imports.len);

    var offset: usize = 0;

    for ([_][]const u8{ "helper", "Mode", "unused" }, [_][]const u8{ "helper", "shared", "unused" }, imports) |binding, target, dependency| {
        const specifier = try std.fmt.allocPrint(std.testing.allocator, "./{s}", .{target});
        const path = try std.fmt.allocPrint(std.testing.allocator, "/project/{s}.zx", .{target});

        defer std.testing.allocator.free(specifier);
        defer std.testing.allocator.free(path);

        try std.testing.expectEqualStrings(specifier, dependency.specifier);
        try std.testing.expectEqual(@as(usize, 1), dependency.names.len);
        try std.testing.expectEqualStrings(binding, dependency.names[0]);
        try std.testing.expect(dependency.target == .source);
        try std.testing.expectEqualStrings(path, dependency.target.source);

        const end = std.mem.indexOfScalarPos(u8, f.main, offset, '\n').?;

        try std.testing.expectEqual(offset, dependency.span.start);
        try std.testing.expectEqual(end, dependency.span.end);

        offset = end + 1;
    }

    try std.testing.expectEqual(.function, imports[0].kind);
    try std.testing.expectEqual(.enumeration, imports[1].kind);
    try std.testing.expectEqual(.function, imports[2].kind);
    try std.testing.expectEqual(.type_only, result.modules[1].imports[0].kind);
    try std.testing.expectEqualStrings("Count", result.modules[1].imports[0].names[0]);
}

test "pure type exports retain enum and scalar ids from final type table" {
    var result = try f.analyze(std.testing.allocator);

    defer result.deinit();

    try f.check(result);

    const exports = result.modules[0].exports;

    try std.testing.expectEqual(@as(usize, 2), exports.len);

    var found: usize = 0;

    for (exports) |item| {
        const value = result.value.ir.types[@intFromEnum(item.type_id)];

        if (std.mem.eql(u8, item.name, "Mode")) {
            try std.testing.expect(value == .enumeration);
            try std.testing.expectEqualStrings("First", value.enumeration.members[0]);
            try std.testing.expectEqualStrings("Second", value.enumeration.members[1]);

            found += 1;
        } else if (std.mem.eql(u8, item.name, "Count")) {
            try std.testing.expectEqual(.u64, value.scalar);

            found += 1;
        }
    }

    try std.testing.expectEqual(@as(usize, 2), found);
}

test "module digests correspond to each exact source rather than entry source" {
    var result = try f.analyze(std.testing.allocator);

    defer result.deinit();

    try f.check(result);

    for ([_][]const u8{ f.shared, f.helper, f.unused, f.main }, result.modules) |source, record| {
        var digest: [32]u8 = undefined;

        std.crypto.hash.sha2.Sha256.hash(source, &digest, .{});

        try std.testing.expectEqualSlices(u8, &digest, &record.source_digest);
    }
}

test "pure type entry has types body and no phantom function" {
    var result = try compiler.project.analyze(std.testing.allocator, &f.sources, .{ .entry = "shared.zx", .root_dir = "/project" });

    defer result.deinit();

    try std.testing.expect(result.value.ir.type_only);
    try std.testing.expectEqual(@as(usize, 1), result.modules.len);
    try std.testing.expect(result.modules[0].body == .types);
    try std.testing.expectEqual(@as(usize, 0), result.value.ir.functions.len);
}

test "records remain readable after parse cache destruction" {
    var result = blk: {
        var cache = compiler.project.ParseCache{ .allocator = std.testing.allocator };

        defer cache.deinit();

        break :blk try compiler.project.analyzeWithCache(std.testing.allocator, &f.sources, .{ .entry = "main.zx", .root_dir = "/project" }, &cache);
    };

    defer result.deinit();

    try f.check(result);
    try std.testing.expectEqualStrings("./shared", result.modules[1].imports[0].specifier);
    try std.testing.expectEqualStrings("Count", result.modules[1].imports[0].names[0]);
    try std.testing.expectEqualStrings("/project/shared.zx", result.modules[1].imports[0].target.source);
    try std.testing.expect(try compiler.validateIr(std.testing.allocator, result.value.ir) == null);
}
