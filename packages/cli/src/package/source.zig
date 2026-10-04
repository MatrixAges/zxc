const std = @import("std");
const compiler = @import("compiler");
const Inputs = @import("../cli/watch/inputs.zig");

pub fn validate(io: std.Io, allocator: std.mem.Allocator, path: []const u8, scopes: []const compiler.project.PackageScope) !void {
    return validateWithInputs(io, allocator, path, scopes, null);
}

pub fn validateWithInputs(io: std.Io, allocator: std.mem.Allocator, path: []const u8, scopes: []const compiler.project.PackageScope, inputs: ?*Inputs) !void {
    if (scopes.len == 0) return;

    const owner = compiler.project.package_scope.owner(scopes, path) orelse return error.UndeclaredPackageSource;
    const real = try std.Io.Dir.cwd().realPathFileAlloc(io, path, allocator);

    if (!std.mem.eql(u8, real, path)) return error.PackageSourceMustUsePhysicalPath;

    var directory = std.fs.path.dirname(path).?;

    while (!std.mem.eql(u8, directory, scopes[owner].root)) {
        const manifest = try std.fs.path.join(allocator, &.{ directory, "pkg.yaml" });

        if (inputs) |observed| try observed.add(io, manifest);

        if (std.Io.Dir.cwd().access(io, manifest, .{})) {
            return error.SourceBelongsToUndeclaredPackage;
        } else |err| {
            if (err != error.FileNotFound) return err;
        }

        directory = std.fs.path.dirname(directory) orelse return error.UndeclaredPackageSource;
    }
}
