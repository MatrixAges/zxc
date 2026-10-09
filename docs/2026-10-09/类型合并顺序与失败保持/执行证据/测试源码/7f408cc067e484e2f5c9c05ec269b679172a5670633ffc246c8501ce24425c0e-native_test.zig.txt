const std = @import("std");
const f = @import("fixture.zig");
const native = @import("native_fixture.zig");
const compiler = f.compiler;

test "compiled native public aliases share one rebound module and enum" {
    var value = try native.library();

    defer value.deinit();

    var result = try native.analyze(&value, false);

    defer result.deinit();

    try std.testing.expect(result.value == .ir);

    const program = result.value.ir;

    try std.testing.expectEqual(@as(usize, 1), program.native_modules.count());

    const module = program.native_modules.at(0);

    try std.testing.expectEqualStrings("zig:choice", module.specifier);
    try std.testing.expect(!std.mem.eql(u8, "choice", module.import_name));
    try std.testing.expect(!std.mem.eql(u8, "zig:choice", module.key()));

    const fields = program.types.get(program.input_type).object;

    try std.testing.expectEqual(fields.at(0).type_id, fields.at(1).type_id);
    try std.testing.expect(try compiler.validateIr(std.testing.allocator, program) == null);
}

test "compiled native distinct instances isolate module keys import names and enums" {
    var value = try native.library();

    defer value.deinit();

    var result = try native.analyze(&value, true);

    defer result.deinit();

    try std.testing.expect(result.value == .ir);

    const program = result.value.ir;

    try std.testing.expectEqual(@as(usize, 2), program.native_modules.count());

    const left = program.native_modules.at(0);
    const right = program.native_modules.at(1);

    try std.testing.expect(!std.mem.eql(u8, left.key(), right.key()));
    try std.testing.expect(!std.mem.eql(u8, left.import_name, right.import_name));

    const fields = program.types.get(program.input_type).object;

    try std.testing.expect(fields.at(0).type_id != fields.at(1).type_id);
    try std.testing.expect(try compiler.validateIr(std.testing.allocator, program) == null);

    var bundle = try compiler.zig.emitModules(std.testing.allocator, &result);

    defer bundle.deinit();

    try std.testing.expectEqual(@as(usize, 2), bundle.native_modules.count());
    try std.testing.expectEqualDeep(program.native_modules.at(0).identity, bundle.native_modules.at(0).identity);
    try std.testing.expectEqualDeep(program.native_modules.at(1).identity, bundle.native_modules.at(1).identity);
}

test "compiled rebound native output owns descriptors after library and analysis release" {
    var bundle = block: {
        var value = try native.library();

        defer value.deinit();

        var analyzed = try native.analyze(&value, true);

        defer analyzed.deinit();

        try std.testing.expect(analyzed.value == .ir);

        break :block try compiler.zig.emitModules(std.testing.allocator, &analyzed);
    };

    defer bundle.deinit();

    try std.testing.expectEqual(@as(usize, 2), bundle.native_modules.count());

    for (0..bundle.native_modules.count()) |module_row| {
        const module = bundle.native_modules.at(module_row);

        try std.testing.expectEqualStrings("zig:choice", module.specifier);
        try std.testing.expect(std.mem.indexOf(u8, bundle.types, module.key()) != null);
        try std.testing.expect(std.mem.startsWith(u8, module.import_name, "library_native_"));
    }
}
