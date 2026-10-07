const std = @import("std");
const f = @import("fixture.zig");
const graph = @import("graph.zig");
const metadata = @import("metadata.zig");

test "real entry artifact closes every type tag and preserves shared children" {
    var analysis = try f.analyze(std.testing.allocator);

    defer analysis.deinit();

    const index = try f.moduleIndex(analysis, "/project/main.zx");
    var result = try f.artifact.extract(std.testing.allocator, &analysis, index);

    defer result.deinit();

    const module = result.value;

    _ = try graph.check(module.types, module.function.?.input_type, module.function.?.output_type);

    var kinds: std.EnumSet(std.meta.Tag(f.ir.Type)) = .empty;

    for (0..module.types.count()) |position| kinds.insert(std.meta.activeTag(module.types.at(position)));
    try std.testing.expectEqual(@as(usize, 9), kinds.count());
    try std.testing.expectEqualSlices(u8, &analysis.modules[index].source_digest, &module.source_digest);
    try std.testing.expectEqual(@as(usize, 0), module.stores.count());
}

test "earlier noise declaration shifts enum and composite local ids" {
    var analysis = try f.analyze(std.testing.allocator);

    defer analysis.deinit();

    const index = try f.moduleIndex(analysis, "/project/main.zx");
    const global = try graph.check(analysis.value.ir.types, analysis.value.ir.input_type, analysis.value.ir.output_type);
    var result = try f.artifact.extract(std.testing.allocator, &analysis, index);

    defer result.deinit();

    const local = try graph.check(result.value.types, result.value.function.?.input_type, result.value.function.?.output_type);

    try std.testing.expectEqual(try f.nominalId(analysis, "Mode"), global.mode);
    try std.testing.expect(global.mode != local.mode);
    try std.testing.expect(global.record != local.record);
    try std.testing.expect(global.pair != local.pair);
    try std.testing.expect(global.values != local.values);
    try std.testing.expect(global.saved != local.saved);
    try std.testing.expect(result.value.types.count() < analysis.value.ir.types.count());

    for (0..result.value.types.count()) |position| {
        const value = result.value.types.at(position);

        if (value == .enumeration) try std.testing.expect(!std.mem.eql(u8, value.enumeration.name, "Noise"));
    }
}

test "pure type artifact keeps source graph and excludes entry task types" {
    var analysis = try f.analyze(std.testing.allocator);

    defer analysis.deinit();

    var result = try f.artifact.extract(std.testing.allocator, &analysis, try f.moduleIndex(analysis, "/project/types.zx"));

    defer result.deinit();

    const module = result.value;
    const ids = try graph.check(module.types, try graph.exported(module, "Request"), try graph.exported(module, "Response"));

    try std.testing.expectEqualStrings("/project/types.zx", module.path);
    try std.testing.expectEqual(@as(usize, 4), module.exports.len);
    try std.testing.expectEqual(ids.mode, try graph.exported(module, "Mode"));
    try std.testing.expectEqual(ids.record, try graph.exported(module, "Record"));
    try std.testing.expect(module.function == null);
    try std.testing.expectEqual(@as(usize, 0), module.functions.len);
    try std.testing.expectEqual(@as(usize, 0), module.function_imports.len);
    try std.testing.expectEqual(@as(usize, 1), module.type_imports.len);
    try std.testing.expectEqualStrings("Node", module.type_imports[0].name);
    try std.testing.expectEqual(ids.node, module.type_imports[0].type_id);

    for (0..module.types.count()) |position| {
        const value = module.types.at(position);

        try std.testing.expect(value != .task and value != .error_set);
    }

    try metadata.nominal(module, ids);
    try metadata.native(module, ids.node);
    try metadata.dependencies(module);
}

test "task captures and native call signatures use local artifact references" {
    var result = try detached("/project/main.zx");

    defer result.deinit();

    const ids = try graph.check(result.value.types, result.value.function.?.input_type, result.value.function.?.output_type);

    try graph.task(result.value);
    try metadata.functions(result.value, ids.node);
}

test "entry artifact owns native descriptors origins and checked imports after analysis release" {
    var result = try detached("/project/main.zx");

    defer result.deinit();

    const module = result.value;
    const ids = try graph.check(module.types, try graph.exported(module, "Input"), try graph.exported(module, "Output"));

    try std.testing.expectEqualStrings("/project/main.zx", module.path);
    try std.testing.expectEqualStrings("/project/main.zx", module.function.?.file_name);
    try std.testing.expectEqual(@as(usize, 2), module.exports.len);
    try std.testing.expectEqual(@as(usize, 2), module.type_imports.len);
    try std.testing.expectEqualStrings("Request", module.type_imports[0].name);
    try std.testing.expectEqualStrings("Response", module.type_imports[1].name);
    try std.testing.expectEqual(module.function.?.input_type, module.type_imports[0].type_id);
    try std.testing.expectEqual(module.function.?.output_type, module.type_imports[1].type_id);
    try metadata.nominal(module, ids);
    try metadata.native(module, ids.node);
    try metadata.dependencies(module);
    try metadata.functions(module, ids.node);
    try graph.task(module);
}

test "pure type artifact owns graph and native metadata after analysis release" {
    var result = try detached("/project/types.zx");

    defer result.deinit();

    const module = result.value;
    const ids = try graph.check(module.types, try graph.exported(module, "Request"), try graph.exported(module, "Response"));

    try metadata.nominal(module, ids);
    try metadata.native(module, ids.node);
    try metadata.dependencies(module);
    try std.testing.expectEqualStrings("Node", module.type_imports[0].name);
    try std.testing.expectEqual(ids.node, module.type_imports[0].type_id);
}

test "missing required native nominal origin rejects real analysis extraction" {
    try rejected(.missing_node, error.MissingNominalOrigin);
}

test "duplicate required native nominal origin rejects real analysis extraction" {
    try rejected(.duplicate_node, error.InvalidModule);
}

test "wrong required native nominal name rejects real analysis extraction" {
    try rejected(.wrong_node_name, error.InvalidModule);
}

test "missing unneeded noise origin does not reject entry extraction" {
    var analysis = try f.analyze(std.testing.allocator);

    defer analysis.deinit();

    try f.mutate(&analysis, .missing_noise);

    var result = try f.artifact.extract(std.testing.allocator, &analysis, try f.moduleIndex(analysis, "/project/main.zx"));

    defer result.deinit();

    const ids = try graph.check(result.value.types, result.value.function.?.input_type, result.value.function.?.output_type);

    try metadata.nominal(result.value, ids);
    try graph.task(result.value);
}

fn detached(path: []const u8) !f.artifact.Result {
    var analysis = try f.analyze(std.testing.allocator);

    defer analysis.deinit();

    return f.artifact.extract(std.testing.allocator, &analysis, try f.moduleIndex(analysis, path));
}

fn rejected(mutation: f.Mutation, expected: anyerror) !void {
    var analysis = try f.analyze(std.testing.allocator);

    defer analysis.deinit();

    try f.mutate(&analysis, mutation);
    try std.testing.expectError(expected, f.artifact.extract(std.testing.allocator, &analysis, try f.moduleIndex(analysis, "/project/main.zx")));
}
