const std = @import("std");
const compiler = @import("root.zig");

pub const Options = struct {
    io: std.Io,
    sources: []const compiler.project.Source,
    project: compiler.project.Options,
    parse_cache: ?*compiler.project.ParseCache = null,
    semantic_cache: ?*compiler.project.SemanticCache = null,
    solver: ?[]const u8 = null,
    dependencies: ?*std.ArrayList([]const u8) = null,
    writer: *std.Io.Writer,
    type_output: ?*std.Io.Writer = null,
};

pub fn compile(allocator: std.mem.Allocator, options: Options) !compiler.Result {
    var analyzed = if (options.semantic_cache) |cache| try compiler.analyzeProjectIncremental(allocator, options.sources, options.project, cache) else if (options.parse_cache) |cache| try compiler.analyzeProjectWithCache(allocator, options.sources, options.project, cache) else try compiler.analyzeProject(allocator, options.sources, options.project);

    defer analyzed.deinit();

    if (analyzed.value == .diagnostic) return .{ .diagnostic = analyzed.value.diagnostic };

    const program = analyzed.value.ir;

    if (try compiler.validateIr(allocator, program)) |issue| return .{ .diagnostic = issue };

    if (options.dependencies) |dependencies| {
        for (program.native_modules) |module| try dependencies.append(allocator, try allocator.dupe(u8, module.import_name));
    }

    var requires_verification = program.contracts.len != 0 or options.solver != null;

    for (program.functions) |function| requires_verification = requires_verification or function.contracts.len != 0;

    if (requires_verification) {
        if (!try compiler.verification.check(options.io, allocator, program, options.sources, options.project.entry, .{ .solver = options.solver }, options.writer)) {
            return .{ .diagnostic = .{ .code = .contract, .span = .{ .start = 0, .end = 0 }, .message = "program verification did not succeed; code was not generated" } };
        }
    }

    if (program.native_modules.len != 0) {
        const writer = options.type_output orelse return .{ .diagnostic = .{ .code = .module, .span = .{ .start = 0, .end = 0 }, .message = "native modules require shared type output; use --out or build" } };
        const bundle = try @import("genz").zx.bundle(allocator, program);

        defer allocator.free(bundle.types);
        errdefer allocator.free(bundle.source);

        try writer.writeAll(bundle.types);

        return .{ .source = bundle.source };
    }

    if (requires_verification) return .{ .source = try @import("genz").zx.emit(allocator, program) };

    return .{ .source = compiler.zig.emit(allocator, program) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        error.InvalidIr, error.UnverifiedContracts, error.NativeRequiresBundle => return .{ .diagnostic = .{ .code = .contract, .span = .{ .start = 0, .end = 0 }, .message = "invalid or unverified project IR" } },
    } };
}
