const std = @import("std");

const Rule = struct {
    name: []const u8,
    seed_path: []const u8,
    root_path: []const u8,
};

const rules = [_]Rule{
    .{ .name = "naming", .seed_path = "bootstrap/naming.zig", .root_path = "src/naming/root.zig" },
    .{ .name = "length", .seed_path = "bootstrap/length.zig", .root_path = "src/length/root.zig" },
    .{ .name = "indentation_line", .seed_path = "bootstrap/indentation_line.zig", .root_path = "src/indentation/line/root.zig" },
    .{ .name = "spacing_boundary", .seed_path = "bootstrap/spacing_boundary.zig", .root_path = "src/spacing/boundary/root.zig" },
    .{ .name = "rx_bounds", .seed_path = "bootstrap/rx_bounds.zig", .root_path = "src/rx/bounds/root.zig" },
    .{ .name = "import_order", .seed_path = "bootstrap/import_order.zig", .root_path = "src/imports/order/root.zig" },
};

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const seed = b.option(bool, "seed", "Use the initial Zig lint implementations") orelse false;
    const generated = b.option(std.Build.LazyPath, "generated", "Generated RX/ZX lint directory");

    if (seed and generated != null) @panic("seed lint cannot use generated rules");
    if (!seed and generated == null) @panic("lint requires generated directory; seed is only for bootstrap");

    const module = b.addModule("lint", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "dsl", .module = b.dependency("dsl", .{ .target = target, .optimize = optimize }).module("dsl") },
            .{ .name = "zx", .module = b.dependency("core", .{ .target = target, .optimize = optimize }).module("core") },
        },
    });

    for (rules) |rule| {
        const rule_module = b.createModule(.{
            .root_source_file = b.path(if (seed) rule.seed_path else rule.root_path),
            .target = target,
            .optimize = optimize,
        });

        if (generated) |directory| {
            rule_module.addImport("generated", b.createModule(.{
                .root_source_file = directory.path(b, b.fmt("{s}.zig", .{rule.name})),
                .target = target,
                .optimize = optimize,
            }));
        }

        module.addImport(rule.name, rule_module);
    }

    const library = b.addLibrary(.{ .name = "zxc_lint", .root_module = module });

    b.installArtifact(library);
}
