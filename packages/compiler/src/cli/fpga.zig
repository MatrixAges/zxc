const std = @import("std");
const compiler = @import("compiler");
const Options = @import("options.zig").Options;
const artifacts = @import("artifacts.zig");

pub fn run(io: std.Io, allocator: std.mem.Allocator, sources: []const compiler.project.Source, project: compiler.project.Options, options: Options, writer: *std.Io.Writer) !bool {
    var analyzed = try compiler.analyzeProject(allocator, sources, project);

    defer analyzed.deinit();

    if (analyzed.value == .diagnostic) {
        try writer.print("fpga: {s}\n", .{analyzed.value.diagnostic.message});

        return false;
    }

    const program = analyzed.value.ir;
    var requires_verification = program.contracts.len != 0 or options.solver != null;

    for (program.functions) |function| requires_verification = requires_verification or function.contracts.len != 0;
    if (requires_verification and !try compiler.verification.check(io, allocator, program, sources, project.entry, .{ .solver = options.solver }, writer)) return false;

    var generated = try compiler.hardware.generate(allocator, program);

    defer generated.deinit();

    if (generated.value == .diagnostic) {
        try writer.print("fpga: {s}\n", .{generated.value.diagnostic.message});

        return false;
    }

    const module = generated.value.module;
    const source = try compiler.verilog.emit(allocator, module, options.clocked);

    const manifest = try std.json.Stringify.valueAlloc(allocator, .{
        .format_version = 1,
        .source_ir_version = program.version,
        .top = "zxc_kernel",
        .clocked = options.clocked,
        .latency_cycles = @as(u32, if (options.clocked) 1 else 0),
        .initiation_interval = @as(?u32, if (options.clocked) 1 else null),
        .handshake = if (options.clocked) @as(?[]const u8, "accept on input_valid && input_ready; output becomes valid after the accepting edge and remains stable until output_ready; reset requires a clock edge") else null,
        .reset = if (options.clocked) @as(?[]const u8, "synchronous_active_high") else null,
        .fault = "output data is invalid when fault is high",
        .sources = sources,
        .hardware = module,
    }, .{ .whitespace = .indent_2 });

    try artifacts.write(io, options.output.?, source);
    try artifacts.write(io, try std.fmt.allocPrint(allocator, "{s}.json", .{options.output.?}), manifest);
    try writer.print("fpga: generated {s} and port/graph manifest\n", .{options.output.?});

    return true;
}
