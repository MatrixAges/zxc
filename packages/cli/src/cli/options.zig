const std = @import("std");

pub const Options = struct {
    input: []const u8,
    output: ?[]const u8 = null,
    project: ?[]const u8 = null,
    formatting: bool = false,
    linting: bool = false,
    semantic_lint: bool = false,
    workspace_lint: bool = false,
    config_kind: ?@import("configuration/kind.zig").Kind = null,
    check: bool = false,
    write: bool = false,
    native: bool = false,
    mode: enum { app, lib } = .app,
    host: enum { process, node } = .process,
    node_library: ?[]const u8 = null,
    result: enum { json, discard } = .json,
    verifying: bool = false,
    fpga: bool = false,
    clocked: bool = false,
    assembly: ?[]const u8 = null,
    target: ?[]const u8 = null,
    cpu: ?[]const u8 = null,
    optimize: std.builtin.OptimizeMode = .safe,
    solver: ?[]const u8 = null,
    cache: bool = true,
    cache_stats: bool = false,
    watch: bool = false,
    run: bool = false,
    run_args: []const []const u8 = &.{},
};

pub fn parse(args: []const []const u8) error{InvalidArguments}!Options {
    if (args.len == 0) return error.InvalidArguments;

    const formatting = std.mem.eql(u8, args[0], "fmt");
    const linting = std.mem.eql(u8, args[0], "lint");
    const native = std.mem.eql(u8, args[0], "build");
    const verifying = std.mem.eql(u8, args[0], "verify");
    const fpga = std.mem.eql(u8, args[0], "fpga");
    const input_index: usize = if (formatting or linting or native or verifying or fpga) 1 else 0;

    if (args.len <= input_index or std.mem.startsWith(u8, args[input_index], "--")) return error.InvalidArguments;

    var options = Options{ .input = args[input_index], .formatting = formatting, .linting = linting, .native = native, .verifying = verifying, .fpga = fpga };
    var optimized = false;
    var selected_mode = false;
    var selected_host = false;
    var selected_result = false;
    var index = input_index + 1;

    while (index < args.len) : (index += 1) {
        const argument = args[index];

        if (std.mem.eql(u8, argument, "--")) {
            if (!options.run) return error.InvalidArguments;

            options.run_args = args[index + 1 ..];

            break;
        } else if (std.mem.eql(u8, argument, "--run")) {
            if (!native or options.run) return error.InvalidArguments;

            options.run = true;
        } else if (std.mem.eql(u8, argument, "--check") or std.mem.eql(u8, argument, "--write")) {
            if (!formatting or options.check or options.write) return error.InvalidArguments;

            options.check = std.mem.eql(u8, argument, "--check");
            options.write = !options.check;
        } else if (std.mem.eql(u8, argument, "--workspace")) {
            if (!linting or options.workspace_lint) return error.InvalidArguments;

            options.workspace_lint = true;
        } else if (std.mem.eql(u8, argument, "--semantic")) {
            if (!linting or options.semantic_lint) return error.InvalidArguments;

            options.semantic_lint = true;
        } else if (std.mem.eql(u8, argument, "--kind")) {
            if ((!formatting and !linting) or options.config_kind != null or index + 1 == args.len) return error.InvalidArguments;

            index += 1;
            options.config_kind = std.meta.stringToEnum(@import("configuration/kind.zig").Kind, args[index]) orelse return error.InvalidArguments;
        } else if (std.mem.eql(u8, argument, "--out") or std.mem.eql(u8, argument, "--project")) {
            if (formatting or (linting and std.mem.eql(u8, argument, "--out")) or index + 1 == args.len) return error.InvalidArguments;

            index += 1;

            if (std.mem.eql(u8, argument, "--out")) {
                if (options.output != null) return error.InvalidArguments;

                options.output = args[index];
            } else {
                if (options.project != null) return error.InvalidArguments;

                options.project = args[index];
            }
        } else if (std.mem.eql(u8, argument, "--no-cache")) {
            if (formatting or linting or !options.cache) return error.InvalidArguments;

            options.cache = false;
        } else if (std.mem.eql(u8, argument, "--cache-stats")) {
            if (formatting or linting or options.cache_stats) return error.InvalidArguments;

            options.cache_stats = true;
        } else if (std.mem.eql(u8, argument, "--watch")) {
            if (!native or options.watch) return error.InvalidArguments;

            options.watch = true;
        } else if (std.mem.eql(u8, argument, "--clocked")) {
            if (!fpga or options.clocked) return error.InvalidArguments;

            options.clocked = true;
        } else if (std.mem.eql(u8, argument, "--mode")) {
            if (!native or selected_mode or index + 1 == args.len) return error.InvalidArguments;

            index += 1;
            options.mode = std.meta.stringToEnum(@TypeOf(options.mode), args[index]) orelse return error.InvalidArguments;
            selected_mode = true;
        } else if (std.mem.eql(u8, argument, "--node-lib")) {
            if (!native or options.node_library != null or index + 1 == args.len) return error.InvalidArguments;

            index += 1;
            options.node_library = args[index];
        } else if (std.mem.eql(u8, argument, "--host")) {
            if (!native or selected_host or index + 1 == args.len) return error.InvalidArguments;

            index += 1;
            options.host = std.meta.stringToEnum(@TypeOf(options.host), args[index]) orelse return error.InvalidArguments;
            selected_host = true;
        } else if (std.mem.eql(u8, argument, "--result")) {
            if (!native or selected_result or index + 1 == args.len) return error.InvalidArguments;

            index += 1;
            options.result = std.meta.stringToEnum(@TypeOf(options.result), args[index]) orelse return error.InvalidArguments;
            selected_result = true;
        } else if (std.mem.eql(u8, argument, "--solver")) {
            if (formatting or linting or options.solver != null or index + 1 == args.len) return error.InvalidArguments;

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

                options.optimize = std.builtin.OptimizeMode.fromString(args[index]) orelse return error.InvalidArguments;
                optimized = true;
            }
        } else return error.InvalidArguments;
    }

    if (options.workspace_lint and (options.project != null or options.config_kind != null)) return error.InvalidArguments;
    if (linting and ((options.project != null and !options.semantic_lint) or (options.semantic_lint and options.config_kind != null))) return error.InvalidArguments;
    if ((native or fpga) and options.output == null) return error.InvalidArguments;
    if (options.mode == .lib and (options.assembly != null or options.target != null or options.cpu != null or optimized or selected_result)) return error.InvalidArguments;
    if (options.host == .node and (options.mode != .app or selected_result)) return error.InvalidArguments;
    if (options.node_library != null and options.host != .node) return error.InvalidArguments;
    if (options.run and (!options.watch or options.mode != .app or options.host != .process or options.target != null)) return error.InvalidArguments;

    return options;
}
