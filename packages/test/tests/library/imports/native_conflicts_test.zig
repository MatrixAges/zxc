const std = @import("std");
const compiler = @import("compiler");
const native = @import("native_fixture.zig");
const variant = @import("native_conflicts/graph.zig");
const Table = compiler.project.artifact.type_link.Table;
const Route = enum { options, destination };

fn load(allocator: std.mem.Allocator, library: compiler.project.compiled.Library, route: Route, table: *Table, functions: *compiler.ir.FunctionStorage, natives: *compiler.ir.NativeModuleStorage) !compiler.project.compiled.Loaded {
    return switch (route) {
        .options => compiler.project.compiled.load(allocator, .{
            .library = library,
            .types = table.items.view(),
            .nominal_types = table.origins.items.view(),
            .functions = functions,
            .native_modules = natives,
        }),
        .destination => compiler.project.compiled.loadInto(allocator, library, .{
            .types = &table.items,
            .origins = &table.origins,
            .functions = functions,
            .native_modules = natives,
        }),
    };
}

fn snapshot(allocator: std.mem.Allocator, table: Table, functions: compiler.ir.FunctionStorage, natives: compiler.ir.NativeModuleStorage) ![]const u8 {
    return std.json.Stringify.valueAlloc(allocator, .{
        .types = table.items.view(),
        .origins = table.origins.items.view(),
        .functions = functions.view(),
        .native_modules = natives.view(),
    }, .{});
}

fn check(change: variant.Change) !void {
    var library = try native.library();

    defer library.deinit();

    for (std.enums.values(Route)) |route| {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

        defer arena.deinit();

        const allocator = arena.allocator();
        const original = try variant.graph(allocator, &library, .none);
        const conflict = try variant.graph(allocator, &library, change);
        var table = try Table.init(allocator);
        var functions: compiler.ir.FunctionStorage = .{};
        var natives: compiler.ir.NativeModuleStorage = .{};
        const first = try load(allocator, original, route, &table, &functions, &natives);

        try std.testing.expectEqual(@as(usize, 1), natives.count());
        try std.testing.expect(!std.mem.eql(u8, original.program.native_modules.at(0).key(), natives.view().at(0).key()));

        if (route == .options) {
            table.items = .{};

            inline for (@typeInfo(compiler.ir.TypeStorage).@"struct".field_names) |name| {
                try @field(table.items, name).appendSlice(allocator, @field(first.types, name));
            }

            try table.origins.seed(first.types, first.nominal_types);
        }

        const repeated = try load(allocator, original, route, &table, &functions, &natives);

        try std.testing.expectEqual(@as(usize, 1), natives.count());
        try std.testing.expectEqualDeep(table.items.view(), repeated.types);
        try std.testing.expectEqualDeep(table.origins.items.view(), repeated.nominal_types);

        const before = try snapshot(allocator, table, functions, natives);

        try std.testing.expectError(error.ConflictingInterface, load(allocator, conflict, route, &table, &functions, &natives));
        try std.testing.expectEqualStrings(before, try snapshot(allocator, table, functions, natives));
    }
}

test "compiled native repeated identity rejects equal length namespace changes" {
    try check(.namespace_content);
}

test "compiled native repeated identity rejects namespace length changes" {
    try check(.namespace_length);
}

test "compiled native repeated identity rejects binding name changes" {
    try check(.binding_name);
}

test "compiled native repeated identity rejects remapped binding type changes" {
    try check(.binding_type);
}
