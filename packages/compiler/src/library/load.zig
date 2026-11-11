const std = @import("std");
const frontend = @import("frontend");
const ir = @import("zx").ir;
const model = @import("root.zig");
pub const Export = frontend.project.compiled.PublicReference;

pub fn load(allocator: std.mem.Allocator, input: frontend.project.compiled.Library, selected: []const Export) !model.Result {
    var arena = std.heap.ArenaAllocator.init(allocator);

    errdefer arena.deinit();

    const owned = arena.allocator();
    var functions: ir.FunctionStorage = .{};
    var native_modules: ir.NativeModuleStorage = .{};

    const imported = try frontend.project.compiled.load(owned, .{
        .library = input,
        .types = .{},
        .nominal_types = .{},
        .functions = &functions,
        .native_modules = &native_modules,
        .selected = selected,
    });

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
            .native_modules = native_modules.view(),
            .type_only = true,
        },
        .exports = imported.exports,
        .nominal_types = imported.nominal_types,
        .store_initializers = imported.store_initializers,
    };

    try @import("validate.zig").validate(allocator, &result);

    return result;
}
