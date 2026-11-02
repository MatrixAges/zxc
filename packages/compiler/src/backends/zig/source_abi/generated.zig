const std = @import("std");
const ir = @import("zx").ir;
const project = @import("frontend").project;
const view = @import("genz").zx.modules.abi_view;
const generated = @import("generated_source_abi");
const Input = std.meta.Child(generated.Input);
const Bindings = std.meta.Child(@FieldType(Input, "modules"));
const Sources = std.meta.Child(@FieldType(Input, "sources"));

pub fn render(allocator: std.mem.Allocator, modules: ir.NativeModuleTable, options: project.Options) ![]u8 {
    var arena = std.heap.ArenaAllocator.init(allocator);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var buffered = std.heap.BufferFirstAllocator.init(&buffer, arena.allocator());

    defer arena.deinit();

    const temporary = buffered.allocator();
    const scoped = @import("generated_source_abi_scoped");

    const has_scoped = scoped.executeIn(temporary, modules.identities) catch |err| switch (@as(anyerror, err)) {
        error.OutOfMemory => return error.OutOfMemory,
        else => unreachable,
    };

    if (!has_scoped) return allocator.dupe(u8, "");

    const roots = try temporary.alloc([]const u8, options.package_scopes.len);

    for (options.package_scopes, roots) |scope, *root| root.* = scope.root;

    const planner = @import("generated_source_abi_plan");

    const selected = planner.executeIn(temporary, &.{ .identities = modules.identities, .roots = roots, .root = options.root_dir }) catch |err| switch (@as(anyerror, err)) {
        error.OutOfMemory => return error.OutOfMemory,
        else => unreachable,
    };

    std.debug.assert(selected.scoped);

    const configured = if (selected.scope) |index| options.package_scopes[index] else project.PackageScope{
        .root = options.root_dir,
        .packages = &.{},
        .native_interfaces = options.native_interfaces,
        .externals = options.externals,
    };

    const module_bindings: Bindings = .{ .specifiers = modules.specifiers, .identities = modules.identities };

    const input: Input = .{
        .modules = &module_bindings,
        .sources = try sources(temporary, configured.native_interfaces, configured.externals),
    };

    const output = generated.executeIn(temporary, &input) catch |err| switch (err) {
        error.OutOfMemory, error.Overflow => return error.OutOfMemory,
        else => unreachable,
    };

    const aliases = try temporary.alloc(view.Alias, output.len);

    for (output, aliases) |alias, *target| target.* = .{ .name = alias.name, .identity = alias.identity };

    return view.render(allocator, &.{}, aliases, false);
}

fn sources(allocator: std.mem.Allocator, interfaces: []const project.NativeInterface, externals: []const project.External) std.mem.Allocator.Error!*const Sources {
    const value = try allocator.create(Sources);
    value.* = .{ .interfaces = try bindings(allocator, interfaces), .externals = try bindings(allocator, externals) };

    return value;
}

fn bindings(allocator: std.mem.Allocator, values: anytype) std.mem.Allocator.Error!*const Bindings {
    const specifiers = try allocator.alloc([]const u8, values.len);
    const identities = try allocator.alloc(?[]const u8, values.len);

    for (values, specifiers, identities) |value, *specifier, *identity| {
        specifier.* = value.specifier;
        identity.* = value.identity;
    }

    const result = try allocator.create(Bindings);

    result.* = .{ .specifiers = specifiers, .identities = identities };

    return result;
}
