const std = @import("std");
pub const records = @import("records.zig");
pub const f = records.f;

pub fn module(analysis: f.compiler.AnalysisResult, selected: usize, value: f.artifact.Module, expected: []const []const u8) !void {
    try std.testing.expectEqualDeep(analysis.modules[selected].imports, value.dependencies);
    try std.testing.expectEqualStrings(analysis.modules[selected].path, value.path);
    try std.testing.expect(value.types.validStructure());
    try std.testing.expectEqual(expected.len, value.native_modules.count());
    try std.testing.expectEqual(analysis.modules[selected].body != .types, value.function != null);
    if (value.function == null) try std.testing.expectEqual(@as(usize, 0), value.functions.count());

    for (expected) |key| {
        var found: usize = 0;

        for (0..value.native_modules.count()) |position| {
            const actual = value.native_modules.at(position);

            if (!std.mem.eql(u8, key, actual.key())) continue;

            found += 1;

            var original_count: usize = 0;

            for (0..analysis.value.ir.native_modules.count()) |old_position| {
                const original = analysis.value.ir.native_modules.at(old_position);

                if (!std.mem.eql(u8, key, original.key())) continue;

                original_count += 1;

                try std.testing.expectEqualDeep(original, actual);
            }

            try std.testing.expectEqual(@as(usize, 1), original_count);
        }

        try std.testing.expectEqual(@as(usize, 1), found);
    }

    const imports = analysis.modules[selected].function_imports;
    var unique: usize = 0;

    try std.testing.expectEqual(imports.len, value.function_imports.len);

    for (imports, value.function_imports, 0..) |original, actual, position| {
        var seen = false;

        for (imports[0..position]) |prior| seen = seen or prior.id == original.id;
        if (!seen) unique += 1;
        try std.testing.expect(@backingInt(actual.id) < value.functions.count());
        try std.testing.expectEqualStrings(original.name, actual.name);
        try std.testing.expectEqualDeep(original.namespace, actual.namespace);

        const before = analysis.value.ir.functions.at(@backingInt(original.id));
        const after = value.functions.at(@backingInt(actual.id));

        try std.testing.expectEqualStrings(before.file_name, after.file_name);
        try std.testing.expectEqual(actual.input_type, after.input_type);
        try std.testing.expectEqual(actual.output_type, after.output_type);
    }

    try std.testing.expectEqual(unique, value.functions.count());

    for (0..value.functions.count()) |position| {
        const actual = value.functions.at(position);

        if (actual.external) |external| {
            try std.testing.expect(@backingInt(external.module) < value.native_modules.count());

            var found: usize = 0;

            for (0..analysis.value.ir.functions.count()) |old_position| {
                const original = analysis.value.ir.functions.at(old_position);

                if (!std.mem.eql(u8, original.file_name, actual.file_name) or original.external == null) continue;

                found += 1;
                const before = analysis.value.ir.native_modules.at(@backingInt(original.external.?.module));
                const after = value.native_modules.at(@backingInt(external.module));

                try std.testing.expectEqualStrings(before.key(), after.key());
            }

            try std.testing.expectEqual(@as(usize, 1), found);
        }
    }
}

pub fn accepted(analysis: *const f.compiler.AnalysisResult, selected: usize, expected: []const []const u8) !void {
    const before = try f.snapshot(analysis.*);

    defer std.testing.allocator.free(before);

    var result = try f.artifact.extract(std.testing.allocator, analysis, selected);

    defer result.deinit();

    try module(analysis.*, selected, result.value, expected);
    try f.unchanged(before, analysis.*);
}

pub fn rejected(analysis: *const f.compiler.AnalysisResult, selected: usize) !void {
    try std.testing.expectEqual(null, try f.compiler.validateIr(std.testing.allocator, analysis.value.ir));

    const before = try f.snapshot(analysis.*);

    defer std.testing.allocator.free(before);

    try std.testing.expectError(error.InvalidModule, f.artifact.extract(std.testing.allocator, analysis, selected));
    try f.unchanged(before, analysis.*);
}
