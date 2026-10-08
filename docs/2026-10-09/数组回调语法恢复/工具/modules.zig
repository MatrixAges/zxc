const std = @import("std");
const compiler = @import("compiler");
const File = struct { name: []const u8, imports: []const []const u8 };

pub fn emit(init: std.process.Init, contract: anytype, directory: []const u8) !void {
    const allocator = init.arena.allocator();

    var source = compiler.AnalysisResult{
        .arena = std.heap.ArenaAllocator.init(allocator),
        .value = .{ .ir = contract.program },
        .nominal_types = contract.nominal_types,
        .store_initializers = contract.store_initializers,
    };

    defer source.deinit();

    var bundle = try compiler.zig.emitModules(allocator, &source);

    defer bundle.deinit();

    const files = try allocator.alloc(File, bundle.modules.len + 1);

    files[0] = .{ .name = bundle.entry.name, .imports = bundle.entry.imports };

    try write(init, directory, "zxc_abi.zig", bundle.types);
    try write(init, directory, try std.fmt.allocPrint(allocator, "{s}.zig", .{bundle.entry.name}), bundle.entry.source);

    for (bundle.modules, files[1..]) |module, *file| {
        file.* = .{ .name = module.name, .imports = module.imports };

        try write(init, directory, try std.fmt.allocPrint(allocator, "{s}.zig", .{module.name}), module.source);
    }

    const manifest = try std.json.Stringify.valueAlloc(allocator, .{ .entry = bundle.entry.name, .files = files }, .{ .whitespace = .indent_2 });

    try write(init, directory, "manifest.json", manifest);
}

fn write(init: std.process.Init, directory: []const u8, name: []const u8, source: []const u8) !void {
    const path = try std.fs.path.join(init.arena.allocator(), &.{ directory, name });

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = path, .data = source });
}
