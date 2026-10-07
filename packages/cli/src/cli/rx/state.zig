const std = @import("std");
const compiler = @import("compiler");
const Prepared = @import("analyze.zig").Result;

pub fn append(bundle: *compiler.zig.ModuleBundle, prepared: *const Prepared, cache: ?*compiler.zig.GenerationCache) !void {
    const allocator = bundle.arena.allocator();
    const program = prepared.analysis.value.ir;

    if (program.stores.count() == 0) return;

    var initializers: std.ArrayList(compiler.zig.store_initializers.Initializer) = .empty;

    for (prepared.store_definitions) |definition| for (definition.objects) |object| {
        const identity = try std.fmt.allocPrint(allocator, "store.{s}:{s}", .{ definition.source_path, object.name });

        const needed = for (program.stores.paths) |path| {
            if (std.mem.eql(u8, path, identity)) break true;
        } else false;

        if (!needed) continue;
        try initializers.append(allocator, .{ .identity = identity, .schema_version = definition.version, .program = object.initial });
    };

    try compiler.zig.store_initializers.append(bundle, .{ .analysis = &prepared.analysis, .initializers = initializers.items, .cache = cache });
    try compiler.zig.state.append(bundle, .{ .analysis = &prepared.analysis, .cache = cache });
}
