const std = @import("std");
const compiler = @import("compiler");
const view = compiler.zig.abi_view;
const Loaded = @import("project.zig").Loaded;

const Bundle = struct {
    types: []const u8,
    type_names: []const []const u8,
    native_modules: []const compiler.ir.NativeModule,
    modules: []const compiler.zig.ModuleFile,
};

pub const File = struct { module: []const u8, name: []const u8, path: []const u8, source: []const u8 };
pub const Result = struct { source: []const u8, views: []const File = &.{} };

pub fn create(allocator: std.mem.Allocator, bundle: compiler.zig.ModuleBundle, loaded: Loaded) !Result {
    return render(allocator, .{ .types = bundle.types, .type_names = bundle.type_names, .native_modules = bundle.native_modules, .modules = bundle.modules }, loaded);
}

pub fn createLibrary(allocator: std.mem.Allocator, bundle: compiler.zig.LibraryBundle, loaded: Loaded) !Result {
    return render(allocator, .{ .types = bundle.types, .type_names = bundle.type_names, .native_modules = bundle.native_modules, .modules = bundle.modules }, loaded);
}

fn render(allocator: std.mem.Allocator, bundle: Bundle, loaded: Loaded) !Result {
    var scoped = false;

    for (bundle.native_modules) |module| {
        if (module.identity != null) scoped = true;
    }

    if (!scoped) return .{ .source = bundle.types };

    var defaults: std.ArrayList(view.Alias) = .empty;
    var conflicts: std.StringHashMapUnmanaged(void) = .empty;
    var views: std.ArrayList(File) = .empty;

    for (bundle.native_modules) |module| {
        if (module.identity == null) try append(allocator, &defaults, &conflicts, .{ .name = module.specifier, .identity = module.key() });
    }

    for (loaded.project.package_scopes) |scope| {
        if (!std.mem.eql(u8, scope.root, loaded.project.root_dir)) continue;

        for (scope.native_interfaces) |entry| if (contains(bundle, entry.key())) {
            try append(allocator, &defaults, &conflicts, .{ .name = entry.specifier, .identity = entry.key() });
        };

        for (scope.externals) |entry| if (contains(bundle, entry.key())) {
            try append(allocator, &defaults, &conflicts, .{ .name = entry.specifier, .identity = entry.key() });
        };
    }

    for (loaded.config.native_modules) |module| {
        const configured = module.abi_aliases orelse continue;
        var aliases: std.ArrayList(view.Alias) = .empty;
        var is_root = false;

        for (loaded.native_settings) |setting| {
            if (std.mem.eql(u8, setting.name, module.name)) is_root = std.mem.eql(u8, setting.root, loaded.project.root_dir);
        }

        for (configured) |alias| {
            if (!contains(bundle, alias.specifier)) continue;

            const resolved = view.Alias{ .name = alias.name, .identity = alias.specifier };

            try aliases.append(allocator, resolved);
            if (is_root) try append(allocator, &defaults, &conflicts, resolved);
        }

        for (bundle.native_modules) |standard| {
            if (standard.identity != null) continue;

            var found = false;

            for (aliases.items) |alias| if (std.mem.eql(u8, alias.name, standard.specifier)) {
                if (!std.mem.eql(u8, alias.identity, standard.key())) return error.ConflictingNativeAbiAlias;

                found = true;

                break;
            };

            if (!found) try aliases.append(allocator, .{ .name = standard.specifier, .identity = standard.key() });
        }

        const name = try std.fmt.allocPrint(allocator, "zxc_abi_view_{s}", .{module.name});

        for (loaded.config.native_modules) |candidate| {
            if (std.mem.eql(u8, candidate.name, name)) return error.NativeModuleNameConflict;
        }

        for (bundle.modules) |candidate| {
            if (std.mem.eql(u8, candidate.name, name) or std.mem.eql(u8, candidate.name, module.name)) return error.NativeModuleNameConflict;
        }

        try views.append(allocator, .{ .module = module.name, .name = name, .path = try std.fmt.allocPrint(allocator, "abi_views/{s}.zig", .{name}), .source = try view.render(allocator, bundle.type_names, aliases.items, true) });
    }

    var aliases: std.ArrayList(view.Alias) = .empty;

    for (defaults.items) |alias| {
        if (!conflicts.contains(alias.name)) try aliases.append(allocator, alias);
    }

    const root_view = try view.render(allocator, &.{}, aliases.items, false);

    return .{ .source = try std.mem.concat(allocator, u8, &.{ bundle.types, "\n", root_view }), .views = try views.toOwnedSlice(allocator) };
}

fn contains(bundle: Bundle, identity: []const u8) bool {
    for (bundle.native_modules) |module| {
        if (std.mem.eql(u8, module.key(), identity)) return true;
    }

    return false;
}

fn append(allocator: std.mem.Allocator, aliases: *std.ArrayList(view.Alias), conflicts: *std.StringHashMapUnmanaged(void), value: view.Alias) !void {
    for (aliases.items) |previous| {
        if (!std.mem.eql(u8, previous.name, value.name)) continue;
        if (!std.mem.eql(u8, previous.identity, value.identity)) try conflicts.put(allocator, value.name, {});

        return;
    }

    try aliases.append(allocator, value);
}
