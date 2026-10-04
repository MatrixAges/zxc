const std = @import("std");
const compiler = @import("compiler");
const ir = compiler.ir;
const wrap = @import("wrap.zig").wrap;

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);

    if (args.len != 3) return error.ExpectedSourceAndOutputDirectory;

    const source = try std.Io.Dir.cwd().readFileAlloc(init.io, args[1], allocator, .limited(1024 * 1024));
    var parsed = try compiler.parse(allocator, source, "update.zx");

    defer parsed.deinit();

    if (parsed.value != .parsed) return error.InvalidSource;

    var analyzed = try compiler.analyzeWithContext(allocator, parsed.value.parsed, .{
        .stores = &.{.{ .handle = "$store_v", .path = "store.orders.state", .type_name = "State" }},
    });

    defer analyzed.deinit();

    if (analyzed.value != .ir) return error.InvalidSource;

    const service = try wrap(allocator, analyzed.value.ir, "service.rx", 1, false);
    const program = try wrap(allocator, service, "entry.rx", 2, true);

    try std.Io.Dir.cwd().createDirPath(init.io, args[2]);

    const standalone = try compiler.zig.emit(allocator, program);
    const standalone_path = try std.fs.path.join(allocator, &.{ args[2], "standalone.zig" });

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = standalone_path, .data = standalone });

    analyzed.value = .{ .ir = program };

    var bundle = try compiler.zig.emitModules(allocator, &analyzed);

    defer bundle.deinit();

    const files = try allocator.alloc(compiler.zig.ModuleFile, bundle.modules.len + 1);

    @memcpy(files[0..bundle.modules.len], bundle.modules);

    files[bundle.modules.len] = bundle.entry;

    for (files) |file| {
        const path = try std.fmt.allocPrint(allocator, "{s}/{s}.zig", .{ args[2], file.name });

        try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = path, .data = file.source });
    }

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = try std.fs.path.join(allocator, &.{ args[2], "types.zig" }), .data = bundle.types });

    const Metadata = struct { name: []const u8, imports: []const []const u8 };
    const metadata = try allocator.alloc(Metadata, files.len);

    for (files, metadata) |file, *item| item.* = .{ .name = file.name, .imports = file.imports };
    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = try std.fs.path.join(allocator, &.{ args[2], "modules.json" }), .data = try std.json.Stringify.valueAlloc(allocator, metadata, .{ .whitespace = .indent_2 }) });
}
