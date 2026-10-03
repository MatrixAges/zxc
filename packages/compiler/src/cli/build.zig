const std = @import("std");
const Options = @import("options.zig").Options;
const Loaded = @import("project.zig").Loaded;
const artifacts = @import("artifacts.zig");

pub fn run(io: std.Io, allocator: std.mem.Allocator, source: []const u8, types: []const u8, options: Options, loaded: Loaded) !bool {
    const configuration = try std.json.Stringify.valueAlloc(allocator, .{ .options = options, .project = loaded }, .{});
    const directory = try artifacts.prepare(io, allocator, source, types, configuration);
    var arguments: std.ArrayList([]const u8) = .empty;

    try arguments.appendSlice(allocator, &.{ "zig", "build-exe", try std.fmt.allocPrint(allocator, "-femit-bin={s}", .{options.output.?}) });
    if (std.fs.path.dirname(options.output.?)) |parent| try std.Io.Dir.cwd().createDirPath(io, parent);

    if (options.assembly) |assembly| {
        if (std.fs.path.dirname(assembly)) |parent| try std.Io.Dir.cwd().createDirPath(io, parent);
        try arguments.append(allocator, try std.fmt.allocPrint(allocator, "-femit-asm={s}", .{assembly}));
    }

    for (loaded.config.libraries) |library| try arguments.append(allocator, try std.fmt.allocPrint(allocator, "-l{s}", .{library}));
    for (loaded.config.library_paths) |path| try arguments.appendSlice(allocator, &.{ "-L", try std.fs.path.resolve(allocator, &.{ loaded.project.root_dir, path }) });

    for (loaded.config.native_modules) |module| {
        if (module.header != null) {
            try arguments.append(allocator, "-lc");

            break;
        }
    }

    try settings(allocator, &arguments, options);
    try arguments.appendSlice(allocator, &.{ "--dep", "application", try std.fmt.allocPrint(allocator, "-Mroot={s}/main.zig", .{directory}) });
    try settings(allocator, &arguments, options);
    try arguments.appendSlice(allocator, &.{ "--dep", "zxc_abi" });
    for (loaded.config.native_modules) |module| try arguments.appendSlice(allocator, &.{ "--dep", module.name });
    try arguments.append(allocator, try std.fmt.allocPrint(allocator, "-Mapplication={s}/program.zig", .{directory}));

    for (loaded.config.native_modules) |module| {
        try settings(allocator, &arguments, options);
        try arguments.appendSlice(allocator, &.{ "--dep", "zxc_abi" });
        for (module.dependencies) |dependency| try arguments.appendSlice(allocator, &.{ "--dep", dependency });
        for (loaded.config.include_paths) |path| try arguments.appendSlice(allocator, &.{ "-I", try std.fs.path.resolve(allocator, &.{ loaded.project.root_dir, path }) });

        const path = if (module.path) |path| try std.fs.path.resolve(allocator, &.{ loaded.project.root_dir, path }) else blk: {
            const path = try std.fmt.allocPrint(allocator, "{s}/native/{s}.zig", .{ directory, module.name });
            const text = try std.fmt.allocPrint(allocator, "pub const c = @cImport({{ @cInclude(\"{f}\"); }});\n", .{std.zig.fmtString(module.header.?)});

            try artifacts.write(io, path, text);

            break :blk path;
        };

        try arguments.append(allocator, try std.fmt.allocPrint(allocator, "-M{s}={s}", .{ module.name, path }));
    }

    try settings(allocator, &arguments, options);
    try arguments.append(allocator, try std.fmt.allocPrint(allocator, "-Mzxc_abi={s}/abi.zig", .{directory}));

    const manifest = try std.json.Stringify.valueAlloc(allocator, arguments.items, .{ .whitespace = .indent_2 });

    try artifacts.write(io, try std.fs.path.join(allocator, &.{ directory, "command.json" }), manifest);

    var child = try std.process.spawn(io, .{ .argv = arguments.items });
    const termination = try child.wait(io);

    return termination == .exited and termination.exited == 0;
}

fn settings(allocator: std.mem.Allocator, arguments: *std.ArrayList([]const u8), options: Options) !void {
    try arguments.appendSlice(allocator, &.{ "-O", @tagName(options.optimize) });
    if (options.target) |target| try arguments.appendSlice(allocator, &.{ "-target", target });
    if (options.cpu) |cpu| try arguments.appendSlice(allocator, &.{ "-mcpu", cpu });
}
