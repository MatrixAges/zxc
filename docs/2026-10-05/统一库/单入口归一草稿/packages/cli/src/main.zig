const std = @import("std");

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

    if (args.len > 1 and std.mem.eql(u8, args[1], "pkg")) {
        if (!try @import("package/command.zig").run(init.io, allocator, args[2..], init.environ_map, stdout, stderr)) {
            try stderr.flush();

            std.process.exit(1);
        }

        return;
    }

    if (args.len > 1 and std.mem.eql(u8, args[1], "check-rx")) {
        if (!try @import("cli/rx/check.zig").run(init.io, allocator, args[2..], stderr)) {
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

    if (options.watch) {
        try @import("cli/watch.zig").run(init.io, std.heap.page_allocator, options, init.environ_map, stdout, stderr);
    } else if (try @import("cli/compile.zig").run(.{ .io = init.io, .allocator = allocator, .options = options, .environment = init.environ_map, .stdout = stdout, .stderr = stderr }) != .success) {
        try stderr.flush();

        std.process.exit(1);
    }
}

fn usage(writer: *std.Io.Writer) std.Io.Writer.Error!void {
    try writer.writeAll("zxc pkg inspect|workspace|graph [pkg.yaml]\n");
    try writer.writeAll(@import("package/init.zig").usage);
    try writer.writeAll(@import("package/install.zig").usage);
    try writer.writeAll("Options for compile/build/verify/fpga: --no-cache --cache-stats\n");
    try writer.writeAll("zxc verify <pkg.yaml> [--solver z3] [--out query.smt2]: verify all declared public modules\n");
    try writer.writeAll("RX sequential Call.fn/Return: zxc <module.rx> [--out output.zig] or zxc build <module.rx> --out program; app build options apply; lib publishing uses build pkg.yaml --mode lib --out directory or a source entry\n");
    try writer.writeAll("zxc pkg index [index.json]\nzxc pkg resolve <name> <range> [index.json]\n");
    try writer.writeAll("zxc <source.zx> [--project pkg.yaml] [--out output.zig] [--solver z3]\nzxc build <source.zx> --out program [--mode app|lib] [--watch] [--project pkg.yaml] [--asm program.s] [--target triple] [--cpu features] [--optimize mode] [--solver z3]\nzxc fpga <source.zx> --out kernel.sv [--project pkg.yaml] [--solver z3] [--clocked]\nzxc verify <source.zx> [--project pkg.yaml] [--solver z3] [--out query.smt2]\nzxc fmt <source.zx> [--check | --write]\nzxc check-rx <module.rx> [module.rx ...]\nzxc check-rx --entry <module.rx|gateway.gateway.rx|state.store.rx> [--project pkg.yaml]\n");
}
