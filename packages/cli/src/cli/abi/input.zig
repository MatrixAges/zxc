const std = @import("std");
const compiler = @import("compiler");
const plan = compiler.zig.bundle_abi;
const Loaded = @import("../project.zig").Loaded;

pub fn create(allocator: std.mem.Allocator, modules: compiler.ir.NativeModuleTable, files: []const compiler.zig.ModuleFile, loaded: Loaded) std.mem.Allocator.Error!plan.Input {
    const module_bindings = try allocator.create(plan.Bindings);
    module_bindings.* = .{ .specifiers = modules.specifiers, .identities = modules.identities };
    const scopes = try allocator.alloc(*const plan.Scope, loaded.project.package_scopes.len);

    for (loaded.project.package_scopes, scopes) |source, *target| {
        const scope = try allocator.create(plan.Scope);
        scope.* = .{ .root = source.root, .interfaces = try bindings(allocator, source.native_interfaces), .externals = try bindings(allocator, source.externals) };
        target.* = scope;
    }

    const natives = try allocator.alloc(*const plan.Native, loaded.config.native_modules.len);

    for (loaded.config.native_modules, natives) |source, *target| {
        const native = try allocator.create(plan.Native);
        native.* = .{ .name = source.name, .aliases = if (source.abi_aliases) |items| try aliases(allocator, items) else null };
        target.* = native;
    }

    const Settings = std.meta.Child(@FieldType(plan.Input, "settings"));
    const settings = try allocator.create(Settings);
    const names = try allocator.alloc([]const u8, loaded.native_settings.len);
    const roots = try allocator.alloc([]const u8, loaded.native_settings.len);

    for (loaded.native_settings, names, roots) |source, *name, *root| {
        name.* = source.name;
        root.* = source.root;
    }

    settings.* = .{ .names = names, .roots = roots };

    const file_names = try allocator.alloc([]const u8, files.len);

    for (files, file_names) |source, *target| target.* = source.name;

    return .{ .modules = module_bindings, .root = loaded.project.root_dir, .scopes = scopes, .natives = natives, .settings = settings, .files = file_names };
}

fn bindings(allocator: std.mem.Allocator, source: anytype) std.mem.Allocator.Error!*const plan.Bindings {
    const names = try allocator.alloc([]const u8, source.len);
    const identities = try allocator.alloc(?[]const u8, source.len);

    for (source, names, identities) |entry, *name, *identity| {
        name.* = entry.specifier;
        identity.* = entry.identity;
    }

    const result = try allocator.create(plan.Bindings);

    result.* = .{ .specifiers = names, .identities = identities };

    return result;
}

fn aliases(allocator: std.mem.Allocator, source: anytype) std.mem.Allocator.Error!plan.Aliases {
    const result = try allocator.alloc(*const plan.Alias, source.len);

    for (source, result) |entry, *target| {
        const alias = try allocator.create(plan.Alias);
        alias.* = .{ .name = entry.name, .identity = entry.specifier };
        target.* = alias;
    }

    return result;
}
