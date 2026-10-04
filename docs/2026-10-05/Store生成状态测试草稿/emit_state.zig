const std = @import("std");
const compiler = @import("compiler");
const Contract = @import("rx_analysis").module.Contract;

pub fn write(init: std.process.Init, contract: Contract, directory: []const u8) !void {
    const allocator = init.arena.allocator();
    var analyzed = compiler.AnalysisResult{ .arena = std.heap.ArenaAllocator.init(allocator), .value = .{ .ir = contract.program }, .nominal_types = contract.nominal_types };

    defer analyzed.deinit();

    var bundle = try compiler.zig.emitModules(allocator, &analyzed);

    defer bundle.deinit();

    var initializers: std.ArrayList(compiler.zig.store_initializers.Initializer) = .empty;

    for (contract.store_definitions) |definition| for (definition.objects) |object| {
        try initializers.append(allocator, .{
            .identity = try std.fmt.allocPrint(allocator, "store.{s}:{s}", .{ definition.source_path, object.name }),
            .schema_version = definition.version,
            .program = object.initial,
        });
    };

    try compiler.zig.store_initializers.append(&bundle, .{ .analysis = &analyzed, .initializers = initializers.items });
    try compiler.zig.state.append(&bundle, .{ .analysis = &analyzed });
    if (!std.mem.eql(u8, bundle.state_module orelse return error.MissingState, "zxc_state")) return error.UnexpectedState;

    try std.Io.Dir.cwd().createDirPath(init.io, directory);
    try save(init, directory, "application.zig", bundle.entry.source);
    try save(init, directory, "types.zig", bundle.types);

    const Module = struct { name: []const u8, imports: []const []const u8 };
    const modules = try allocator.alloc(Module, bundle.modules.len + 1);

    modules[0] = .{ .name = bundle.entry.name, .imports = bundle.entry.imports };

    for (bundle.modules, modules[1..]) |file, *module| {
        try save(init, directory, try std.fmt.allocPrint(allocator, "{s}.zig", .{file.name}), file.source);
        module.* = .{ .name = file.name, .imports = file.imports };
    }

    try save(init, directory, "modules.json", try std.json.Stringify.valueAlloc(allocator, modules, .{}));
}

fn save(init: std.process.Init, directory: []const u8, name: []const u8, source: []const u8) !void {
    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = try std.fs.path.join(init.arena.allocator(), &.{ directory, name }), .data = source });
}
