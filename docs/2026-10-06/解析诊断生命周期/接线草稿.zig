    const lifetime_driver = b.addExecutable(.{ .name = "diagnostic-lifetime-driver", .root_module = b.createModule(.{
        .root_source_file = .{ .cwd_relative = "/Users/xiewendao/Documents/MatrixAges/zxc/docs/2026-10-06/解析诊断生命周期/diagnostic_driver.zig" },
        .target = b.graph.host,
        .optimize = optimize,
        .imports = &.{.{ .name = "compiler", .module = module }},
    }) });

    b.step("diagnostic-lifetime", "Inspect diagnostic ownership through public compiler APIs").dependOn(&b.addRunArtifact(lifetime_driver).step);
