const std = @import("std");
const compiler = @import("compiler");
const Inputs = @import("../watch/inputs.zig");
const Self = @This();

allocator: std.mem.Allocator,
libraries: std.ArrayList(compiler.project.compiled.Library) = .empty,
owned: std.ArrayList(compiler.library.Result) = .empty,
failure_path: ?[]const u8 = null,
pub fn deinit(self: *Self) void {
    for (self.owned.items) |*library| library.deinit();

    self.owned.deinit(self.allocator);
    self.libraries.deinit(self.allocator);

    self.* = undefined;
}

pub fn add(self: *Self, io: std.Io, target: compiler.project.compiled.Target, project: compiler.project.Options, inputs: ?*Inputs) !void {
    self.failure_path = null;
    errdefer self.failure_path = target.artifact;

    for (self.libraries.items) |library| {
        if (!std.mem.eql(u8, library.instance, target.instance)) continue;
        if (!std.mem.eql(u8, library.artifact, target.artifact)) return error.ConflictingLibraryArtifact;

        return requireExport(library.exports, target.name);
    }

    if (inputs) |observed| try observed.add(io, target.artifact);
    try @import("../../package/source.zig").validateWithInputs(io, self.allocator, target.artifact, project.package_scopes, inputs);

    const bytes = try std.Io.Dir.cwd().readFileAlloc(io, target.artifact, self.allocator, .limited(64 * 1024 * 1024));

    defer self.allocator.free(bytes);

    if (inputs) |observed| try observed.record(io, target.artifact, bytes);

    var library = try compiler.library.codec.decode(self.allocator, bytes);

    errdefer library.deinit();

    try requireExport(library.exports, target.name);
    try self.libraries.ensureUnusedCapacity(self.allocator, 1);
    try self.owned.append(self.allocator, library);

    self.libraries.appendAssumeCapacity(.{ .instance = target.instance, .artifact = target.artifact, .program = library.program, .exports = library.exports, .nominal_types = library.nominal_types, .store_initializers = library.store_initializers });
}

fn requireExport(exports: []const compiler.library.Export, name: []const u8) error{MissingPublicModule}!void {
    for (exports) |exported| if (std.mem.eql(u8, exported.name, name)) return;

    return error.MissingPublicModule;
}
