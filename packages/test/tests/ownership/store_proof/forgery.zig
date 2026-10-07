const std = @import("std");
const compiler = @import("compiler");

pub fn check(allocator: std.mem.Allocator, library: *compiler.library.Result, original_bytes: []const u8) !void {
    const marker_end = std.mem.indexOfScalar(u8, original_bytes, '\n').? + 1;
    const marker = original_bytes[0..marker_end];
    const control_bytes = try @import("envelope.zig").create(allocator, library, marker);

    defer allocator.free(control_bytes);

    var control = try compiler.library.codec.decode(allocator, control_bytes);

    defer control.deinit();

    try std.testing.expect(try compiler.validateIr(allocator, try control.module(0)) == null);

    const original = library.program.functions;
    const ownership = try allocator.dupe(compiler.ir.SymbolTable.Ownership, original.ownership);

    defer allocator.free(ownership);

    library.program.functions.ownership = ownership;
    defer library.program.functions = original;
    var changed: usize = 0;

    for (0..original.count()) |index| {
        const function = original.at(index);

        if (!std.mem.eql(u8, std.fs.path.basename(function.file_name), "make.zx")) continue;
        try std.testing.expectEqual(.borrowed, function.output_ownership);

        ownership[index] = .Owned;
        changed += 1;
    }

    try std.testing.expectEqual(@as(usize, 1), changed);
    try std.testing.expect(try compiler.validateIr(allocator, library.program) != null);

    var analysis = compiler.AnalysisResult{
        .arena = std.heap.ArenaAllocator.init(allocator),
        .value = .{ .ir = try library.module(0) },
        .nominal_types = library.nominal_types,
    };

    defer analysis.deinit();

    if (compiler.library.link(allocator, &.{.{ .name = "forged", .analysis = &analysis }})) |value| {
        var unexpected = value;

        unexpected.deinit();

        return error.ExpectedInvalidLink;
    } else |err| {
        if (err == error.OutOfMemory) return err;

        try std.testing.expectEqual(error.InvalidIr, err);
    }

    if (compiler.zig.emit(allocator, library.program)) |source| {
        allocator.free(source);

        return error.ExpectedInvalidIr;
    } else |err| {
        if (err == error.OutOfMemory) return err;

        try std.testing.expectEqual(error.InvalidIr, err);
    }

    if (compiler.library.codec.encode(allocator, library)) |bytes| {
        allocator.free(bytes);

        return error.ExpectedInvalidLibrary;
    } else |err| {
        if (err == error.OutOfMemory) return err;

        try std.testing.expectEqual(error.InvalidLibrary, err);
    }

    const forged = try @import("envelope.zig").create(allocator, library, marker);

    defer allocator.free(forged);

    if (compiler.library.codec.decode(allocator, forged)) |value| {
        var unexpected = value;

        unexpected.deinit();

        return error.ExpectedInvalidArchive;
    } else |err| {
        if (err == error.OutOfMemory) return err;

        try std.testing.expectEqual(error.InvalidLibrary, err);
    }
}
