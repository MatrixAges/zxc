const std = @import("std");
const ir = @import("zx").ir;
const project = @import("frontend").project;
const view = @import("genz").zx.modules.abi_view;

pub fn render(allocator: std.mem.Allocator, modules: []const ir.NativeModule, options: project.Options) ![]u8 {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const temporary = arena.allocator();
    var aliases: std.ArrayList(view.Alias) = .empty;
    var scoped = false;

    for (modules) |module| {
        if (module.identity != null) scoped = true;
    }

    if (!scoped) return allocator.dupe(u8, "");

    for (modules) |module| {
        if (module.identity == null) try aliases.append(temporary, .{ .name = module.specifier, .identity = module.key() });
    }

    var interfaces = options.native_interfaces;
    var externals = options.externals;

    for (options.package_scopes) |scope| {
        if (!std.mem.eql(u8, scope.root, options.root_dir)) continue;

        interfaces = scope.native_interfaces;
        externals = scope.externals;

        break;
    }

    for (interfaces) |entry| {
        if (contains(modules, entry.key())) try aliases.append(temporary, .{ .name = entry.specifier, .identity = entry.key() });
    }

    for (externals) |entry| {
        if (contains(modules, entry.key())) try aliases.append(temporary, .{ .name = entry.specifier, .identity = entry.key() });
    }

    var unique: std.ArrayList(view.Alias) = .empty;

    for (aliases.items, 0..) |alias, index| {
        var repeated = false;
        var conflicting = false;

        for (aliases.items, 0..) |other, other_index| {
            if (!std.mem.eql(u8, alias.name, other.name)) continue;
            if (!std.mem.eql(u8, alias.identity, other.identity)) conflicting = true;
            if (other_index < index) repeated = true;
        }

        if (!repeated and !conflicting) try unique.append(temporary, alias);
    }

    return view.render(allocator, &.{}, unique.items, false);
}

fn contains(modules: []const ir.NativeModule, identity: []const u8) bool {
    for (modules) |module| {
        if (std.mem.eql(u8, module.key(), identity)) return true;
    }

    return false;
}
