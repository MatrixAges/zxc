const std = @import("std");
const compiler = @import("compiler");
const flow = @import("flow.zig");

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);

    if (args.len < 3) return error.ExpectedEntryAndSources;

    const sources = try allocator.alloc(compiler.project.Source, args.len - 2);

    for (args[2..], sources) |path, *source| source.* = .{
        .path = path,
        .source = try std.Io.Dir.cwd().readFileAlloc(init.io, path, allocator, .unlimited),
    };

    var result = try compiler.project.analyze(allocator, sources, .{ .entry = args[1] });

    defer result.deinit();

    if (result.value == .diagnostic) return error.InvalidSource;

    const program = result.value.ir;

    if (try compiler.validateIr(allocator, program)) |_| return error.InvalidIr;

    const value_functions = try @import("genz").zx.value_call.functions(allocator, program);
    const summaries = try flow.functions(allocator, program, value_functions);
    var buffer: [4096]u8 = undefined;
    var output = std.Io.File.Writer.initStreaming(.stdout(), init.io, &buffer);

    for (program.functions, summaries) |function, lanes| {
        try std.json.Stringify.value(.{ .file = function.file_name, .consumes_input = function.consumes_input, .provenance = lanes }, .{}, &output.interface);
        try output.interface.writeByte('\n');
    }

    try output.interface.flush();
}
