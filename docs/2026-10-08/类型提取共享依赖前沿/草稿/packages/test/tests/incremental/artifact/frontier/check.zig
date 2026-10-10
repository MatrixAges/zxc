const std = @import("std");
const f = @import("fixture.zig");
const oracle = @import("oracle.zig");

pub fn run(args: f.Case) !void {
    var source_arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer source_arena.deinit();

    var analysis = try f.analyze(source_arena.allocator(), args);

    defer analysis.deinit();

    const index = try f.entry(analysis);
    const record = analysis.modules[index];
    var result = try f.artifact.extract(std.testing.allocator, &analysis, index);

    defer result.deinit();

    try oracle.check(std.testing.allocator, analysis.value.ir.types, record.exports, record.type_imports, result.value);
    try std.testing.expect(result.value.types.count() < analysis.value.ir.types.count());
}

pub fn detached(args: f.Case) !void {
    var expectations = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer expectations.deinit();

    var types: f.ir.TypeTable = undefined;
    var exports: []const f.ir.Export = undefined;
    var imports: []const f.ir.Export = undefined;
    const memory = expectations.allocator();

    var result = block: {
        var sources = std.heap.ArenaAllocator.init(std.testing.allocator);

        defer sources.deinit();

        var analysis = try f.analyze(sources.allocator(), args);

        defer analysis.deinit();

        const index = try f.entry(analysis);
        const record = analysis.modules[index];
        types = try f.ownedColumns(memory, analysis.value.ir.types);
        exports = try f.ownedExports(memory, record.exports);
        imports = try f.ownedExports(memory, record.type_imports);

        break :block try f.artifact.extract(std.testing.allocator, &analysis, index);
    };

    defer result.deinit();

    try oracle.check(std.testing.allocator, types, exports, imports, result.value);
}

pub fn independent(args: f.Case) !void {
    var sources = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer sources.deinit();

    var analysis = try f.analyze(sources.allocator(), args);

    defer analysis.deinit();

    const index = try f.entry(analysis);
    const record = analysis.modules[index];

    var second = block: {
        var first = try f.artifact.extract(std.testing.allocator, &analysis, index);

        defer first.deinit();

        var next = try f.artifact.extract(std.testing.allocator, &analysis, index);

        errdefer next.deinit();

        try oracle.check(std.testing.allocator, analysis.value.ir.types, record.exports, record.type_imports, first.value);

        break :block next;
    };

    defer second.deinit();

    try oracle.check(std.testing.allocator, analysis.value.ir.types, record.exports, record.type_imports, second.value);
}
