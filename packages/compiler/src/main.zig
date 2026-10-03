const std = @import("std");
const compiler = @import("compiler");
const zx = @import("zx");

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);
    var stdout_buffer: [4096]u8 = undefined;
    var stderr_buffer: [4096]u8 = undefined;
    var stdout_file = std.Io.File.Writer.init(.stdout(), init.io, &stdout_buffer);
    var stderr_file = std.Io.File.Writer.init(.stderr(), init.io, &stderr_buffer);
    const stdout = &stdout_file.interface;
    const stderr = &stderr_file.interface;

    defer stdout.flush() catch {};
    defer stderr.flush() catch {};

    if (args.len > 1 and std.mem.eql(u8, args[1], "check-rx")) {
        if (!try @import("application/check.zig").run(init.io, allocator, args[2..], stderr)) {
            try stderr.flush();

            std.process.exit(1);
        }

        return;
    }

    if (args.len == 2 and std.mem.eql(u8, args[1], "--help")) {
        try usage(stdout);

        return;
    }

    const options = @import("cli/options.zig").parse(args[1..]) catch {
        try usage(stderr);
        try stderr.flush();

        std.process.exit(1);
    };

    const input_path = options.input;

    const loaded = if (options.formatting) @import("cli/project.zig").Loaded{ .project = .{ .entry = input_path } } else @import("cli/project.zig").load(init.io, allocator, input_path, options.project) catch |err| {
        try stderr.print("{s}: {s}\n", .{ options.project orelse "zxc.json", @errorName(err) });
        try stderr.flush();

        std.process.exit(1);
    };

    const project = loaded.project;
    const source = try std.Io.Dir.cwd().readFileAlloc(init.io, input_path, allocator, .limited(16 * 1024 * 1024));
    const sources = if (options.formatting) &.{} else try @import("cli/sources.zig").read(init.io, allocator, source, project);

    if (options.verifying) {
        if (!try @import("cli/verify.zig").run(init.io, allocator, sources, project, options, stderr)) {
            try stderr.flush();

            std.process.exit(1);
        }

        return;
    }

    if (options.fpga) {
        if (!try @import("cli/fpga.zig").run(init.io, allocator, sources, project, options, stderr)) {
            try stderr.flush();

            std.process.exit(1);
        }

        return;
    }

    var type_output: std.Io.Writer.Allocating = .init(allocator);

    defer type_output.deinit();

    var dependencies: std.ArrayList([]const u8) = .empty;
    const result = if (options.formatting) try compiler.format(allocator, source, input_path) else try compiler.compileProjectVerified(allocator, .{ .io = init.io, .sources = sources, .project = project, .solver = options.solver, .writer = stderr, .dependencies = &dependencies, .type_output = if (options.native or options.output != null) &type_output.writer else null });

    defer result.deinit(allocator);

    switch (result) {
        .diagnostic => |issue| {
            const failed_source = if (issue.source_index) |index| sources[index].source else source;
            const failed_path = if (issue.source_index) |index| sources[index].path else input_path;
            const location = zx.source.locate(failed_source, issue.span.start);

            try stderr.print("{s}:{d}:{d}: {t}: {s}\n", .{ failed_path, location.line, location.column, issue.code, issue.message });
            try stderr.flush();

            std.process.exit(1);
        },
        .source => |text| {
            if (options.native) {
                const native_project = try @import("cli/standard.zig").resolve(init.io, allocator, loaded, dependencies.items);

                if (options.mode == .lib) {
                    try @import("cli/library.zig").run(init.io, allocator, text, type_output.written(), sources, options, native_project);
                } else if (!try @import("cli/build.zig").run(init.io, allocator, text, type_output.written(), options, native_project)) std.process.exit(1);
            } else if (options.check) {
                if (!std.mem.eql(u8, source, text)) {
                    try stderr.print("{s}: blank lines require formatting\n", .{input_path});
                    try stderr.flush();

                    std.process.exit(1);
                }
            } else if (options.write or options.output != null) {
                if (type_output.written().len != 0) {
                    const types_path = try std.fmt.allocPrint(allocator, "{s}.abi.zig", .{options.output.?});

                    try @import("cli/artifacts.zig").write(init.io, types_path, type_output.written());
                }

                try @import("cli/artifacts.zig").write(init.io, if (options.write) input_path else options.output.?, text);
            } else {
                try stdout.writeAll(text);
            }
        },
    }
}

fn usage(writer: *std.Io.Writer) std.Io.Writer.Error!void {
    try writer.writeAll("zxc <source.zx> [--project zxc.json] [--out output.zig] [--solver z3]\nzxc build <source.zx> --out program [--mode app|lib] [--project zxc.json] [--asm program.s] [--target triple] [--cpu features] [--optimize mode] [--solver z3]\nzxc fpga <source.zx> --out kernel.sv [--project zxc.json] [--solver z3] [--clocked]\nzxc verify <source.zx> [--project zxc.json] [--solver z3] [--out query.smt2]\nzxc fmt <source.zx> [--check | --write]\nzxc check-rx <module.rx> [module.rx ...]\nzxc check-rx --entry <module.rx|gateway.gateway.rx|state.store.rx> [--project zxc.json]\n");
}
