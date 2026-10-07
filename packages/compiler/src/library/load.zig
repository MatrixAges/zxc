const std = @import("std");
const frontend = @import("frontend");
const ir = @import("zx").ir;
const model = @import("root.zig");
pub const Export = struct { name: []const u8, module: []const u8 };

pub fn load(allocator: std.mem.Allocator, input: frontend.project.compiled.Library, selected: []const Export) !model.Result {
    var arena = std.heap.ArenaAllocator.init(allocator);

    errdefer arena.deinit();

    const owned = arena.allocator();
    var functions: ir.FunctionStorage = .{};
    var native_modules: std.ArrayList(ir.NativeModule) = .empty;

    const imported = try frontend.project.compiled.load(owned, .{
        .library = input,
        .types = .{},
        .nominal_types = .{},
        .functions = &functions,
        .native_modules = &native_modules,
    });

    const exports = try owned.alloc(model.Export, selected.len);

    for (selected, exports) |selection, *exported| {
        const found = for (imported.exports) |candidate| {
            if (std.mem.eql(u8, candidate.name, selection.module)) break candidate;
        } else return error.MissingPublicModule;

        exported.* = found;
        exported.name = try owned.dupe(u8, selection.name);
    }

    const result = model.Result{
        .arena = arena,
        .program = .{
            .file_name = "library",
            .types = imported.types,
            .input_type = @fromBackingInt(@intCast(@backingInt(ir.Scalar.void))),
            .output_type = @fromBackingInt(@intCast(@backingInt(ir.Scalar.void))),
            .symbols = .{},
            .expressions = .{},
            .body = .{},
            .functions = functions.view(),
            .native_modules = native_modules.items,
            .type_only = true,
        },
        .exports = exports,
        .nominal_types = imported.nominal_types,
        .store_initializers = imported.store_initializers,
    };

    try @import("validate.zig").validate(allocator, &result);

    return result;
}
