const std = @import("std");
const f = @import("fixture.zig");
const graph = @import("graph.zig");

fn strings(actual: []const []const u8, expected: []const []const u8) !void {
    try std.testing.expectEqual(expected.len, actual.len);
    for (actual, expected) |left, right| try std.testing.expectEqualStrings(right, left);
}

pub fn nominal(module: f.artifact.Module, ids: graph.Ids) !void {
    try std.testing.expectEqual(@as(usize, 2), module.nominal_types.count());

    var nodes: usize = 0;
    var modes: usize = 0;

    for (0..module.nominal_types.count()) |index| {
        const item = module.nominal_types.at(index);

        if (std.mem.eql(u8, item.name, "Node")) {
            nodes += 1;

            try std.testing.expectEqual(ids.node, item.type_id);
            try std.testing.expectEqual(.native, std.meta.activeTag(item.origin));
            try std.testing.expectEqualStrings("fixture@1", item.origin.native);
        } else {
            modes += 1;

            try std.testing.expectEqualStrings("Mode", item.name);
            try std.testing.expectEqual(ids.mode, item.type_id);
            try std.testing.expectEqual(.source, std.meta.activeTag(item.origin));
            try std.testing.expectEqualStrings("/project/types.zx", item.origin.source);
        }
    }

    try std.testing.expectEqual(@as(usize, 1), nodes);
    try std.testing.expectEqual(@as(usize, 1), modes);
}

pub fn native(module: f.artifact.Module, node: f.ir.TypeId) !void {
    try std.testing.expectEqual(@as(usize, 1), module.native_modules.count());

    const value = module.native_modules.at(0);

    try std.testing.expectEqualStrings("zig:host", value.specifier);
    try std.testing.expectEqualStrings("fixture@1", value.identity.?);
    try std.testing.expectEqualStrings("fixture@1", value.key());
    try std.testing.expectEqualStrings("host", value.import_name);
    try strings(value.type_namespace, &.{ "owned", "api" });
    try std.testing.expectEqual(@as(usize, 1), value.types.count());
    try std.testing.expectEqualStrings("Node", value.types.at(0).name);
    try std.testing.expectEqual(node, value.types.at(0).type_id);
}

pub fn dependencies(module: f.artifact.Module) !void {
    const entry = std.mem.eql(u8, module.path, "/project/main.zx");

    try std.testing.expectEqual(@as(usize, if (entry) 3 else 1), module.dependencies.len);

    var native_count: usize = 0;
    var noise_count: usize = 0;
    var types_count: usize = 0;

    for (module.dependencies) |item| {
        if (std.mem.eql(u8, item.specifier, "zig:host")) {
            native_count += 1;

            try std.testing.expectEqual(.native, std.meta.activeTag(item.target));
            try std.testing.expectEqualStrings("fixture@1", item.identity.?);
            try strings(item.names, if (entry) &.{"native"} else &.{"Node"});
        } else if (std.mem.eql(u8, item.specifier, "./noise")) {
            noise_count += 1;

            try std.testing.expectEqual(.source, std.meta.activeTag(item.target));
            try std.testing.expectEqualStrings("/project/noise.zx", item.target.source);
            try std.testing.expectEqual(null, item.identity);
            try strings(item.names, &.{"noise"});
        } else {
            types_count += 1;

            try std.testing.expectEqualStrings("./types", item.specifier);
            try std.testing.expectEqual(.source, std.meta.activeTag(item.target));
            try std.testing.expectEqualStrings("/project/types.zx", item.target.source);
            try std.testing.expectEqual(null, item.identity);
            try strings(item.names, &.{ "Request", "Response" });
        }
    }

    try std.testing.expectEqual(@as(usize, 1), native_count);
    try std.testing.expectEqual(@as(usize, if (entry) 1 else 0), noise_count);
    try std.testing.expectEqual(@as(usize, if (entry) 1 else 0), types_count);
}

pub fn functions(module: f.artifact.Module, node: f.ir.TypeId) !void {
    try std.testing.expectEqual(@as(usize, 3), module.functions.len);
    try std.testing.expectEqual(@as(usize, 3), module.function_imports.len);

    var external_count: usize = 0;
    var source_count: usize = 0;

    for (module.function_imports) |binding| {
        try std.testing.expect(@backingInt(binding.id) < module.functions.len);

        const signature = module.functions[@backingInt(binding.id)];

        try std.testing.expectEqual(binding.input_type, signature.input_type);
        try std.testing.expectEqual(binding.output_type, signature.output_type);
        try std.testing.expect(!(if (signature.external) |value| value.expand_tuple else false));

        if (signature.external) |value| {
            external_count += 1;
            const identity = std.mem.eql(u8, binding.name, "identity");
            const name: []const u8 = if (identity) "identity" else "compute";
            const type_id = if (identity) node else f.scalar(.u64);

            try std.testing.expectEqualStrings(name, binding.name);
            try std.testing.expectEqualStrings("native", binding.namespace.?);
            try std.testing.expectEqualStrings("host.d.zx", signature.file_name);
            try std.testing.expectEqual(type_id, binding.input_type);
            try std.testing.expectEqual(type_id, binding.output_type);
            try std.testing.expectEqual(@as(u32, 0), @backingInt(value.module));
            try strings(value.member, &.{ "owned", "api", name });
            try std.testing.expectEqualStrings(name, value.export_name.?);
            try std.testing.expectEqualStrings(name, value.exportName());
            try std.testing.expect(!value.allocator_argument and !value.io_argument and !value.process_argument and !value.expand_tuple);
            try std.testing.expectEqual(!identity, value.fallible);
            try std.testing.expectEqual(!identity, value.concurrent);
            try std.testing.expectEqual(@as(usize, 1), value.input.?.names.len);

            if (identity) {
                try std.testing.expectEqualStrings("Node", value.input.?.names[0].?);
                try std.testing.expectEqual(null, value.errors);
            } else {
                try std.testing.expectEqual(null, value.input.?.names[0]);
                try strings(value.errors.?, &.{"NativeFailure"});
            }
        } else {
            source_count += 1;

            try std.testing.expectEqualStrings("noise", binding.name);
            try std.testing.expectEqual(null, binding.namespace);
            try std.testing.expectEqualStrings("/project/noise.zx", signature.file_name);
            try std.testing.expectEqual(f.scalar(.u64), binding.input_type);
            try std.testing.expectEqual(f.scalar(.u64), binding.output_type);
        }
    }

    try std.testing.expectEqual(@as(usize, 2), external_count);
    try std.testing.expectEqual(@as(usize, 1), source_count);
}
