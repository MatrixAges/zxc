const std = @import("std");
const compiler = @import("compiler");
const rx = @import("rx");
const analysis = @import("rx_analysis");

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);

    if (args.len != 4) return error.ExpectedWorkflowLogicAndOutput;

    var library = block: {
        const workflow = try read(init.io, allocator, args[1]);
        const logic = try read(init.io, allocator, args[2]);
        const parsed = try rx.parseXml(allocator, workflow);

        if (parsed.value == .diagnostic) return error.InvalidXml;

        const sources = [_]compiler.project.Source{.{ .path = "read.zx", .source = logic }};

        var inferred = try analysis.project.infer(allocator, .{
            .entry = "main.rx",
            .modules = &.{.{ .path = "main.rx", .node = parsed.value.node }},
            .sources = &sources,
        });

        defer inferred.deinit();

        if (inferred.value == .diagnostic) return error.InvalidWorkflow;

        const contract = inferred.value.contract;
        var workflow_analysis = compiler.AnalysisResult{ .arena = std.heap.ArenaAllocator.init(allocator), .value = .{ .ir = contract.program }, .nominal_types = contract.nominal_types };

        defer workflow_analysis.deinit();

        var logic_analysis = try compiler.analyzeProject(allocator, &sources, .{ .entry = "read.zx" });

        defer logic_analysis.deinit();

        break :block try compiler.library.link(allocator, &.{
            .{ .name = "choose", .analysis = &workflow_analysis },
            .{ .name = "read", .analysis = &logic_analysis },
        });
    };

    defer library.deinit();

    const encoded = try compiler.library.codec.encode(allocator, &library);

    try write(init.io, allocator, args[3], "library.zxcir", encoded);

    std.debug.print("encoded_exports={d} bytes={d}\n", .{ library.exports.len, encoded.len });
}

fn read(io: std.Io, allocator: std.mem.Allocator, path: []const u8) ![]const u8 {
    return std.Io.Dir.cwd().readFileAlloc(io, path, allocator, .limited(1024 * 1024));
}

fn write(io: std.Io, allocator: std.mem.Allocator, directory: []const u8, name: []const u8, text: []const u8) !void {
    const path = try std.fs.path.join(allocator, &.{ directory, name });
    var file = try std.Io.Dir.cwd().createFileAtomic(io, path, .{ .make_path = true, .replace = true });

    defer file.deinit(io);

    try file.file.writeStreamingAll(io, text);
    try file.replace(io);
}
