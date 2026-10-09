const std = @import("std");
const f = @import("fixture.zig");
const Detached = @import("detached.zig");
const types = @import("types.zig");

fn entry(values: []const f.artifact.Module) !f.artifact.Module {
    for (values) |value| {
        if (std.mem.eql(u8, value.path, "/project/main.zx")) return value;
    }

    return error.MissingFixtureEntry;
}

test "artifact alias names dependency paths and enum origins outlive source analysis" {
    var detached = try Detached.init(std.testing.allocator, f.orderings[0], true);

    defer detached.deinit();

    const value = try entry(&detached.values);

    try std.testing.expectEqualStrings("/project/main.zx", value.function.?.file_name);
    try std.testing.expectEqual(@as(usize, 4), value.dependencies.len);
    try std.testing.expectEqual(@as(usize, 4), value.function_imports.len);
    try std.testing.expectEqual(try f.local(value, "first"), try f.local(value, "twin"));
    try std.testing.expectEqualStrings("/project/first.zx", value.functions[@backingInt(try f.local(value, "first"))].file_name);
    try std.testing.expectEqualStrings("/project/second.zx", value.functions[@backingInt(try f.local(value, "second"))].file_name);
    try std.testing.expectEqualStrings("/project/noise.zx", value.nominal_types.at(0).origin.source);
    try std.testing.expectEqualStrings("Noise", value.nominal_types.at(0).name);

    for ([_][]const u8{ "noise", "first", "second", "first" }, value.dependencies) |name, dependency| {
        const specifier = try std.fmt.allocPrint(std.testing.allocator, "./{s}", .{name});

        defer std.testing.allocator.free(specifier);

        try std.testing.expectEqualStrings(specifier, dependency.specifier);
        try std.testing.expect(dependency.target == .source);
    }
}

test "detached artifacts relink valid shared alias calls across every module ordering" {
    for (f.orderings) |ordering| {
        var detached = try Detached.init(std.testing.allocator, ordering, true);

        defer detached.deinit();

        for (0..detached.values.len) |shift| {
            var values: [4]f.artifact.Module = undefined;

            for (&values, 0..) |*value, index| value.* = detached.values[(index + shift) % detached.values.len];

            var linked = try f.artifact.linker.link(std.testing.allocator, &values, "/project/main.zx");

            defer linked.deinit();

            try std.testing.expectEqual(null, try f.compiler.validateIr(std.testing.allocator, linked.program));

            const original = try entry(&detached.values);

            try types.same(original.types, original.function.?.input_type, linked.program.types, linked.program.input_type);
            try types.same(original.types, original.function.?.output_type, linked.program.types, linked.program.output_type);

            var calls: usize = 0;

            for (0..linked.program.expressions.count()) |position| {
                const expression = linked.program.expressions.at(position);

                if (expression.value == .call) {
                    const target = linked.program.functions.at(@backingInt(expression.value.call.function));

                    try std.testing.expectEqualStrings("/project/first.zx", target.file_name);

                    calls += 1;
                }
            }

            try std.testing.expectEqual(@as(usize, 2), calls);
        }
    }
}
