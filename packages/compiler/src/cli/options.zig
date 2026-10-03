const std = @import("std");

pub const Options = struct {
    input: []const u8,
    output: ?[]const u8 = null,
    project: ?[]const u8 = null,
    formatting: bool = false,
    check: bool = false,
    write: bool = false,
    native: bool = false,
    mode: enum { app, lib } = .app,
    verifying: bool = false,
    fpga: bool = false,
    clocked: bool = false,
    assembly: ?[]const u8 = null,
    target: ?[]const u8 = null,
    cpu: ?[]const u8 = null,
    optimize: std.builtin.OptimizeMode = .ReleaseSafe,
    solver: ?[]const u8 = null,
};

pub fn parse(args: []const []const u8) error{InvalidArguments}!Options {
    if (args.len == 0) return error.InvalidArguments;

    const formatting = std.mem.eql(u8, args[0], "fmt");
    const native = std.mem.eql(u8, args[0], "build");
    const verifying = std.mem.eql(u8, args[0], "verify");
    const fpga = std.mem.eql(u8, args[0], "fpga");
    const input_index: usize = if (formatting or native or verifying or fpga) 1 else 0;

    if (args.len <= input_index or std.mem.startsWith(u8, args[input_index], "--")) return error.InvalidArguments;

    var options = Options{ .input = args[input_index], .formatting = formatting, .native = native, .verifying = verifying, .fpga = fpga };
    var optimized = false;
    var selected_mode = false;
    var index = input_index + 1;

    while (index < args.len) : (index += 1) {
        const argument = args[index];

        if (std.mem.eql(u8, argument, "--check") or std.mem.eql(u8, argument, "--write")) {
            if (!formatting or options.check or options.write) return error.InvalidArguments;

            options.check = std.mem.eql(u8, argument, "--check");
            options.write = !options.check;
        } else if (std.mem.eql(u8, argument, "--out") or std.mem.eql(u8, argument, "--project")) {
            if (formatting or index + 1 == args.len) return error.InvalidArguments;

            index += 1;

            if (std.mem.eql(u8, argument, "--out")) {
                if (options.output != null) return error.InvalidArguments;

                options.output = args[index];
            } else {
                if (options.project != null) return error.InvalidArguments;

                options.project = args[index];
            }
        } else if (std.mem.eql(u8, argument, "--clocked")) {
            if (!fpga or options.clocked) return error.InvalidArguments;

            options.clocked = true;
        } else if (std.mem.eql(u8, argument, "--mode")) {
            if (!native or selected_mode or index + 1 == args.len) return error.InvalidArguments;

            index += 1;
            options.mode = std.meta.stringToEnum(@TypeOf(options.mode), args[index]) orelse return error.InvalidArguments;
            selected_mode = true;
        } else if (std.mem.eql(u8, argument, "--solver")) {
            if (formatting or options.solver != null or index + 1 == args.len) return error.InvalidArguments;

            index += 1;
            options.solver = args[index];
        } else if (std.mem.eql(u8, argument, "--asm") or std.mem.eql(u8, argument, "--target") or std.mem.eql(u8, argument, "--cpu") or std.mem.eql(u8, argument, "--optimize")) {
            if (!native or index + 1 == args.len) return error.InvalidArguments;

            index += 1;

            if (std.mem.eql(u8, argument, "--asm")) {
                if (options.assembly != null) return error.InvalidArguments;

                options.assembly = args[index];
            } else if (std.mem.eql(u8, argument, "--target")) {
                if (options.target != null) return error.InvalidArguments;

                options.target = args[index];
            } else if (std.mem.eql(u8, argument, "--cpu")) {
                if (options.cpu != null) return error.InvalidArguments;

                options.cpu = args[index];
            } else {
                if (optimized) return error.InvalidArguments;

                options.optimize = std.meta.stringToEnum(std.builtin.OptimizeMode, args[index]) orelse return error.InvalidArguments;
                optimized = true;
            }
        } else return error.InvalidArguments;
    }

    if ((native or fpga) and options.output == null) return error.InvalidArguments;
    if (options.mode == .lib and (options.assembly != null or options.target != null or options.cpu != null or optimized)) return error.InvalidArguments;

    return options;
}
