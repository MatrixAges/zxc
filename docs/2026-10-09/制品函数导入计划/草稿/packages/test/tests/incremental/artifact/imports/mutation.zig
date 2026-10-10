const std = @import("std");
const f = @import("fixture.zig");

pub const Mutation = enum { id, input, output, input_range, output_range, alias_input, alias_output };

pub fn apply(analysis: *f.compiler.AnalysisResult, index: usize, mutation: Mutation) !void {
    const allocator = analysis.arena.allocator();
    const records = try allocator.dupe(@TypeOf(analysis.modules[0]), analysis.modules);
    const imports = try allocator.dupe(@TypeOf(records[index].function_imports[0]), records[index].function_imports);

    records[index].function_imports = imports;
    analysis.modules = records;
    const alias = mutation == .alias_input or mutation == .alias_output;
    var selected: ?usize = null;

    for (imports, 0..) |item, position| {
        if (std.mem.eql(u8, item.name, if (alias) "twin" else "first")) selected = position;
    }

    const item = &imports[selected orelse return error.MissingFixtureImport];

    switch (mutation) {
        .id => item.id = @fromBackingInt(@intCast(analysis.value.ir.functions.count())),
        .input, .alias_input => item.input_type = @fromBackingInt(@backingInt(f.ir.Scalar.i64)),
        .output, .alias_output => item.output_type = @fromBackingInt(@backingInt(f.ir.Scalar.bool)),
        .input_range => item.input_type = @fromBackingInt(@intCast(analysis.value.ir.types.count())),
        .output_range => item.output_type = @fromBackingInt(@intCast(analysis.value.ir.types.count())),
    }

    try std.testing.expectEqual(null, try f.compiler.validateIr(std.testing.allocator, analysis.value.ir));
}
