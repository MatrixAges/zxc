const std = @import("std");
const frontend = @import("frontend");
const zx = @import("zx");
const target = @import("target.zig");
const compiled = frontend.project.compiled;
const wrapper = @import("compiled_wrapper.zig");

pub const Options = struct {
    owner: []const u8,
    call: @import("rx").ast.Node,
    project: frontend.project.Options,
    setter: ?target.Setter,
    selected: compiled.Target,
};

pub fn load(allocator: std.mem.Allocator, options: Options) std.mem.Allocator.Error!target.Value {
    const attribute = target.attribute(options.call, "module");
    const selected = options.selected;
    const libraries = options.project.compiled_libraries;

    const index = switch (try compiled.resolve.library(allocator, libraries, options.project.root_dir, selected)) {
        .found => |value| value,
        .conflict => return fail(allocator, options, "module", "compiled package instance has conflicting artifacts"),
        .missing => return fail(allocator, options, "module", "compiled library is missing from the input set"),
    };

    var functions: zx.ir.FunctionStorage = .{};
    var native_modules: zx.ir.NativeModuleStorage = try frontend.native_context.storage(allocator, options.project.context.native_modules);

    const loaded = compiled.load(allocator, .{
        .library = libraries[index],
        .types = options.project.context.types,
        .nominal_types = options.project.context.nominal_types,
        .functions = &functions,
        .native_modules = &native_modules,
        .selected = &.{.{ .name = selected.name, .module = selected.name }},
    }) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;
        if (err == error.MissingPublicModule) return fail(allocator, options, "module", "compiled package does not export the requested public module");

        return fail(allocator, options, "module", "compiled library cannot be linked to the shared type table");
    };

    const exported = loaded.exports[0];

    if (wrapper.reject(exported.function, &functions, options.setter != null)) |issue| return fail(allocator, options, issue.code, issue.message);

    const program = try wrapper.build(allocator, .{
        .file_name = try std.fmt.allocPrint(allocator, "rx.module:{s}", .{exported.path}),
        .offset = attribute.value_location.offset,
        .id = exported.function.?,
        .types = loaded.types,
        .functions = functions.view(),
        .native_modules = native_modules.view(),
    });

    if (try frontend.validateIr(allocator, program)) |issue| return fail(allocator, options, @tagName(issue.code), issue.message);

    return .{ .function = .{ .program = program, .nominal_types = loaded.nominal_types, .store_initializers = loaded.store_initializers } };
}

fn fail(allocator: std.mem.Allocator, options: Options, code: []const u8, message: []const u8) std.mem.Allocator.Error!target.Value {
    return target.failure(allocator, .{ .path = options.owner, .location = target.attribute(options.call, "module").value_location, .code = code, .message = message });
}
