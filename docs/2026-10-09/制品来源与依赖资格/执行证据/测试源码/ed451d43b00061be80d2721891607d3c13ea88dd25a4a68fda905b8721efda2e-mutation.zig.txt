const std = @import("std");
const f = @import("fixture.zig");

pub const Kind = enum { entry_path, function_path, entry_as_function, function_as_entry, native_body, function_end, function_max };

pub fn records(analysis: *f.compiler.AnalysisResult) ![]f.Record {
    const result = try analysis.arena.allocator().dupe(f.Record, analysis.modules);

    analysis.modules = result;

    return result;
}

pub fn source(analysis: *f.compiler.AnalysisResult, kind: Kind) !usize {
    const main = try f.index(analysis.*, f.main_path);
    const helper = try f.index(analysis.*, f.helper_path);
    const values = try records(analysis);
    const selected = if (kind == .entry_path or kind == .entry_as_function) main else helper;

    switch (kind) {
        .entry_path, .function_path => values[selected].path = "/project/different.zx",
        .entry_as_function => values[selected].body = values[helper].body,
        .function_as_entry => values[selected].body = .entry,
        .function_end => values[selected].body = .{ .function = @fromBackingInt(@intCast(analysis.value.ir.functions.count())) },
        .function_max => values[selected].body = .{ .function = @fromBackingInt(std.math.maxInt(u32)) },
        .native_body => {
            var found = false;

            for (analysis.value.ir.functions.native_modules, 0..) |module, id| {
                if (module == null) continue;

                values[selected].body = .{ .function = @fromBackingInt(@intCast(id)) };
                values[selected].path = analysis.value.ir.functions.files[id];
                found = true;

                break;
            }

            try std.testing.expect(found);
        },
    }

    return selected;
}

pub fn compiled(analysis: *f.compiler.AnalysisResult, selected: usize, position: usize) !void {
    const values = try records(analysis);
    const imports = try analysis.arena.allocator().dupe(@TypeOf(values[selected].imports[0]), values[selected].imports);

    values[selected].imports = imports;
    imports[position].target = .{ .compiled = .{ .instance = "dependency@1", .artifact = "dependency.zxlib", .name = "public" } };
}

pub fn unused(analysis: *f.compiler.AnalysisResult, selected: usize) !void {
    const main = try f.index(analysis.*, f.main_path);
    var dependency = analysis.modules[main].imports[0];
    dependency.target = .{ .compiled = .{ .instance = "unused@1", .artifact = "unused.zxlib", .name = "public" } };

    const values = try records(analysis);
    const imports = try analysis.arena.allocator().alloc(@TypeOf(dependency), values[selected].imports.len + 1);

    @memcpy(imports[0 .. imports.len - 1], values[selected].imports);

    imports[imports.len - 1] = dependency;
    values[selected].imports = imports;
}
