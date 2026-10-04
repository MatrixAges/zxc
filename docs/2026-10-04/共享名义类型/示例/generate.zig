const std = @import("std");
const compiler = @import("compiler");

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);

    const sources = [_]compiler.project.Source{
        .{ .path = "types.zx", .source = @embedFile("types.zx") },
        .{ .path = "main.zx", .source = @embedFile("main.zx") },
    };

    var settings: ?compiler.ir.TypeId = null;

    var cold = block: {
        var provider = try compiler.analyzeProject(std.heap.page_allocator, &sources, .{ .entry = "types.zx", .root_dir = args[1] });

        defer provider.deinit();

        if (provider.value == .diagnostic) return error.InvalidProvider;

        for (provider.value.ir.exports) |item| {
            if (std.mem.eql(u8, item.name, "Settings")) settings = item.type_id;
        }

        break :block try compiler.analyzeProject(std.heap.page_allocator, &sources, .{
            .entry = "main.zx",
            .root_dir = args[1],
            .context = .{ .types = provider.value.ir.types, .nominal_types = provider.nominal_types, .contexts = &.{.{ .id = "settings", .type_id = settings.? }} },
        });
    };

    defer cold.deinit();

    if (cold.value == .diagnostic) {
        std.debug.print("{s}\n", .{cold.value.diagnostic.message});

        return error.InvalidEntry;
    }

    var cache = compiler.project.SemanticCache.init(std.heap.page_allocator);

    defer cache.deinit();

    const options = compiler.project.Options{
        .entry = "main.zx",
        .root_dir = args[1],
        .context = .{ .types = cold.value.ir.types, .nominal_types = cold.nominal_types, .contexts = &.{.{ .id = "settings", .type_id = settings.? }} },
    };

    var first = try compiler.project.analyzeIncremental(std.heap.page_allocator, &sources, options, &cache);

    defer first.deinit();

    var warm = try compiler.project.analyzeIncremental(std.heap.page_allocator, &sources, options, &cache);

    defer warm.deinit();

    if (first.value == .diagnostic or warm.value == .diagnostic) return error.InvalidCachedEntry;
    if (try compiler.validateIr(allocator, warm.value.ir) != null) return error.InvalidIr;

    const bundle = try compiler.zig.emitBundle(allocator, warm.value.ir);

    defer bundle.deinit(allocator);

    try std.Io.Dir.cwd().createDirPath(init.io, args[2]);
    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = try std.fs.path.join(allocator, &.{ args[2], "program.zig" }), .data = bundle.source });
    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = try std.fs.path.join(allocator, &.{ args[2], "abi.zig" }), .data = bundle.types });

    const record = try std.json.Stringify.valueAlloc(allocator, .{
        .cold_nominal_count = cold.nominal_types.len,
        .first_nominal_count = first.nominal_types.len,
        .warm_nominal_count = warm.nominal_types.len,
        .cold_output = @intFromEnum(cold.value.ir.output_type),
        .warm_output = @intFromEnum(warm.value.ir.output_type),
        .analyzed = cache.analyzed,
        .reused = cache.reused,
        .origin = warm.nominal_types[0].origin,
    }, .{ .whitespace = .indent_2 });

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = try std.fs.path.join(allocator, &.{ args[2], "result.json" }), .data = record });
}
