const std = @import("std");

pub const Sources = struct {
    program: std.Build.LazyPath,
    expression: std.Build.LazyPath,
    xml: std.Build.LazyPath,
    paths: std.Build.LazyPath,
    graph: std.Build.LazyPath,
    attribute_role: std.Build.LazyPath,
    attribute_content: std.Build.LazyPath,
    call_rule: std.Build.LazyPath,
    path_kind: std.Build.LazyPath,
    file_kind: std.Build.LazyPath,
    specifier: std.Build.LazyPath,
    integer: std.Build.LazyPath,
    native: std.Build.LazyPath,
    type_lookup: std.Build.LazyPath,
    semantic_abi: std.Build.LazyPath,
};

pub fn generate(b: *std.Build, optimize: std.builtin.OptimizeMode) Sources {
    const target = b.graph.host;
    const core = b.dependency("core", .{ .target = target, .optimize = optimize }).module("core");
    const dsl = b.dependency("dsl", .{ .target = target, .optimize = optimize }).module("dsl");
    const lint = b.dependency("lint", .{ .target = target, .optimize = optimize }).module("lint");

    const lexer = b.createModule(.{
        .root_source_file = b.path("bootstrap/lexer/lex.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "zx", .module = core }},
    });

    const seed = @import("compiler.zig").create(b, target, optimize, lexer, null);

    const rx = b.createModule(.{
        .root_source_file = b.path("src/rx/root.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{ .{ .name = "dsl", .module = dsl }, .{ .name = "frontend", .module = seed.frontend } },
    });

    const rx_options = b.addOptions();

    rx_options.addOption(bool, "generated_paths", false);
    rx_options.addOption(bool, "generated_graph", false);
    rx_options.addOption(bool, "generated_rules", false);
    rx.addOptions("rx_options", rx_options);

    const analysis = b.createModule(.{
        .root_source_file = b.path("src/rx/analysis/root.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "rx", .module = rx },
            .{ .name = "dsl", .module = dsl },
            .{ .name = "zx", .module = core },
            .{ .name = "frontend", .module = seed.frontend },
            .{ .name = "lint", .module = lint },
        },
    });

    const executable = b.addExecutable(.{ .name = "generate-parser", .root_module = b.createModule(.{
        .root_source_file = b.path("build/generate_parser.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{ .{ .name = "compiler", .module = seed.compiler }, .{ .name = "rx", .module = rx }, .{ .name = "rx_analysis", .module = analysis } },
    }) });

    executable.root_module.addAnonymousImport("semantic_integers", .{ .root_source_file = b.path("src/zx/analysis/semantic/native/integers.d.zx") });

    const run = b.addRunArtifact(executable);
    const root = b.path("src");

    run.addDirectoryArg2(root, .{});
    trackSources(b, run, root) catch @panic("unable to track RX and ZX parser sources");

    const program = run.addOutputFileArg("parser.zig");
    const expression = run.addOutputFileArg("expression.zig");
    const xml = run.addOutputFileArg("xml.zig");
    const paths = run.addOutputFileArg("paths.zig");
    const graph = run.addOutputFileArg("graph.zig");
    const attribute_role = run.addOutputFileArg("attribute_role.zig");
    const attribute_content = run.addOutputFileArg("attribute_content.zig");
    const call_rule = run.addOutputFileArg("call_rule.zig");
    const path_kind = run.addOutputFileArg("path_kind.zig");
    const file_kind = run.addOutputFileArg("file_kind.zig");
    const specifier = run.addOutputFileArg("specifier.zig");
    const integer = run.addOutputFileArg("integer.zig");
    const native = run.addOutputFileArg("native.zig");
    const type_lookup = run.addOutputFileArg("type_lookup.zig");
    const semantic_abi = run.addOutputFileArg("semantic_abi.zig");

    return .{ .program = program, .expression = expression, .xml = xml, .paths = paths, .graph = graph, .attribute_role = attribute_role, .attribute_content = attribute_content, .call_rule = call_rule, .path_kind = path_kind, .file_kind = file_kind, .specifier = specifier, .integer = integer, .native = native, .type_lookup = type_lookup, .semantic_abi = semantic_abi };
}

fn trackSources(b: *std.Build, run: *std.Build.Step.Run, root: std.Build.LazyPath) !void {
    var directory = try std.Io.Dir.cwd().openDir(b.graph.io, try b.root.joinString(b.allocator, "src"), .{ .iterate = true });

    defer directory.close(b.graph.io);

    var walker = try directory.walk(b.allocator);

    defer walker.deinit();
    b.dependOnDirectoryContents(root);

    var paths: std.ArrayList([]const u8) = .empty;

    while (try walker.next(b.graph.io)) |entry| {
        if (entry.kind == .directory) {
            b.dependOnDirectoryContents(root.path(b, entry.path));
        } else if (entry.kind == .file and (std.mem.endsWith(u8, entry.path, ".zx") or std.mem.endsWith(u8, entry.path, ".rx"))) {
            try paths.append(b.allocator, try b.allocator.dupe(u8, entry.path));
        }
    }

    std.mem.sort([]const u8, paths.items, {}, lessThan);

    for (paths.items) |path| run.addFileInput(root.path(b, path));
}

fn lessThan(_: void, left: []const u8, right: []const u8) bool {
    return std.mem.lessThan(u8, left, right);
}

pub fn modules(b: *std.Build, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode, source: Sources) @import("compiler.zig").ParserModules {
    const lookup = b.createModule(.{ .root_source_file = source.type_lookup, .target = target, .optimize = optimize });

    lookup.addImport("integers", b.createModule(.{ .root_source_file = b.path("src/zx/analysis/semantic/native/integers.zig"), .target = target, .optimize = optimize }));
    lookup.addImport("zxc_abi", b.createModule(.{ .root_source_file = source.semantic_abi, .target = target, .optimize = optimize }));

    return .{
        .type_lookup = lookup,
        .program = b.createModule(.{ .root_source_file = source.program, .target = target, .optimize = optimize }),
        .expression = b.createModule(.{ .root_source_file = source.expression, .target = target, .optimize = optimize }),
        .xml = b.createModule(.{ .root_source_file = source.xml, .target = target, .optimize = optimize }),
        .specifier = b.createModule(.{ .root_source_file = source.specifier, .target = target, .optimize = optimize }),
        .integer = b.createModule(.{ .root_source_file = source.integer, .target = target, .optimize = optimize }),
        .native = b.createModule(.{ .root_source_file = source.native, .target = target, .optimize = optimize }),
    };
}
