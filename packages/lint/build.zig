const std = @import("std");

const Rule = struct {
    name: []const u8,
    seed_path: []const u8,
    root_path: []const u8,
};

const rules = [_]Rule{
    .{ .name = "attribute_required", .seed_path = "src/layout/attribute_required.zig", .root_path = "src/layout/attribute_required.zig" },
    .{ .name = "layout_rule", .seed_path = "src/layout/rule.zig", .root_path = "src/layout/rule.zig" },
    .{ .name = "naming", .seed_path = "bootstrap/naming.zig", .root_path = "src/naming/root.zig" },
    .{ .name = "length", .seed_path = "bootstrap/length.zig", .root_path = "src/length/root.zig" },
    .{ .name = "indentation_line", .seed_path = "bootstrap/indentation_line.zig", .root_path = "src/indentation/line/root.zig" },
    .{ .name = "spacing_boundary", .seed_path = "bootstrap/spacing_boundary.zig", .root_path = "src/spacing/boundary/root.zig" },
    .{ .name = "rx_bounds", .seed_path = "bootstrap/rx_bounds.zig", .root_path = "src/rx/bounds/root.zig" },
    .{ .name = "import_order", .seed_path = "bootstrap/import_order.zig", .root_path = "src/imports/order/root.zig" },
    .{ .name = "loop_postfix", .seed_path = "bootstrap/loop_postfix.zig", .root_path = "src/loop/postfix.zig" },
    .{ .name = "yaml_gap", .seed_path = "bootstrap/yaml_gap.zig", .root_path = "src/configuration/yaml/gap/root.zig" },
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

        if (seed and (std.mem.eql(u8, rule.name, "layout_rule") or std.mem.eql(u8, rule.name, "attribute_required"))) {
            rule_module.addImport("generated", b.createModule(.{
                .root_source_file = b.path(if (std.mem.eql(u8, rule.name, "layout_rule")) "bootstrap/layout.zig" else "bootstrap/attribute_required.zig"),
                .target = target,
                .optimize = optimize,
            }));
        }

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
