const std = @import("std");
const project = @import("frontend").project;

pub fn dependencies(options: project.Options, owner: []const u8) []const project.Package {
    if (options.package_scopes.len == 0) return options.packages;

    const index = project.package_scope.owner(options.package_scopes, owner) orelse return &.{};

    return options.package_scopes[index].packages;
}

pub fn isPackage(reference: []const u8, packages: []const project.Package) bool {
    for (packages) |package| {
        if (std.mem.eql(u8, package.specifier, reference)) return true;
    }

    return false;
}
