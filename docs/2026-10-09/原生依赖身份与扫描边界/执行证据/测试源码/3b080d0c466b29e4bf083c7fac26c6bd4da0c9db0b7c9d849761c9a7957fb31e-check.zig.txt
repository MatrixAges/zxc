const std = @import("std");
const f = @import("fixture.zig");
const types = @import("types.zig");

pub fn module(analysis: f.compiler.AnalysisResult, index: usize, value: f.artifact.Module) !void {
    try std.testing.expect(value.functions.validStructure());

    const record = analysis.modules[index];
    const program = analysis.value.ir;

    try std.testing.expectEqualStrings(record.path, value.path);
    try std.testing.expectEqualSlices(u8, &record.source_digest, &value.source_digest);
    try std.testing.expectEqual(record.function_imports.len, value.function_imports.len);
    try std.testing.expectEqual(@as(usize, 3), value.functions.count());
    try std.testing.expectEqual(record.imports.len, value.dependencies.len);

    for (record.imports, value.dependencies) |original, copy| {
        try std.testing.expectEqual(original.kind, copy.kind);
        try std.testing.expectEqualStrings(original.specifier, copy.specifier);
        try std.testing.expectEqualStrings(original.target.source, copy.target.source);
    }

    for (record.function_imports, value.function_imports, 0..) |original, copied, position| {
        try std.testing.expectEqualStrings(original.name, copied.name);
        try std.testing.expectEqual(original.namespace != null, copied.namespace != null);
        if (original.namespace) |name| try std.testing.expectEqualStrings(name, copied.namespace.?);

        const global = program.functions.at(@backingInt(original.id));
        const local = value.functions.at(@backingInt(copied.id));

        try std.testing.expectEqualStrings(global.file_name, local.file_name);
        try types.same(program.types, original.input_type, value.types, copied.input_type);
        try types.same(program.types, original.output_type, value.types, copied.output_type);
        try std.testing.expectEqual(copied.input_type, local.input_type);
        try std.testing.expectEqual(copied.output_type, local.output_type);

        for (record.function_imports[0..position], value.function_imports[0..position]) |prior, mapped| {
            try std.testing.expectEqual(prior.id == original.id, mapped.id == copied.id);
        }
    }

    const expected = try f.local(value, "first");
    var calls: usize = 0;

    for (0..value.function.?.expressions.count()) |position| {
        const expression = value.function.?.expressions.at(position);

        if (expression.value == .call) {
            try std.testing.expectEqual(expected, expression.value.call.function);

            calls += 1;
        }
    }

    try std.testing.expectEqual(@as(usize, if (record.function_imports.len == 4) 2 else 1), calls);
}
