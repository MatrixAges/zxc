const std = @import("std");
const f = @import("fixture.zig");
const compiler = f.compiler;

pub fn main(init: std.process.Init) !void {
    const args = try init.minimal.args.toSlice(init.arena.allocator());
    var heap: std.heap.DebugAllocator(.{}) = .init;
    defer _ = heap.deinit();

    const allocator = heap.allocator();

    {
        var analysis = try f.analyze(allocator, f.consume_source);

        defer analysis.deinit();

        try emit(init, allocator, analysis.value.ir, args[1..3]);
    }

    {
        var modules = try f.Modules.init(allocator, f.consume_source);

        defer modules.deinit();

        std.mem.swap(f.artifact.Module, &modules.values[0], &modules.values[1]);

        var linked = try f.artifact.linker.link(allocator, &modules.values, "/project/main.zx");

        defer linked.deinit();

        try emit(init, allocator, linked.program, args[3..5]);
    }

    var library = try f.restored(allocator);

    defer library.deinit();

    try emit(init, allocator, try library.module(0), args[9..11]);

    const source = try std.mem.replaceOwned(u8, allocator, f.main_source, "./consume", "owned");

    defer allocator.free(source);

    var consumer = try f.consumer(allocator, &library, source);

    defer consumer.deinit();

    if (consumer.value != .ir) return error.UnexpectedDiagnostic;
    try emit(init, allocator, consumer.value.ir, args[5..7]);

    var republished = try compiler.library.link(allocator, &.{.{ .name = "consume", .analysis = &consumer }});

    defer republished.deinit();

    const bytes = try compiler.library.codec.encode(allocator, &republished);

    defer allocator.free(bytes);

    var decoded = try compiler.library.codec.decode(allocator, bytes);

    defer decoded.deinit();

    var outer = try f.consumer(allocator, &decoded, "import consume from \"owned\"\nexport type Input = u64[]\nexport type Output = u64[]\nexport default function (in: Input): Output { return consume(in) }\n");

    defer outer.deinit();

    if (outer.value != .ir) return error.UnexpectedDiagnostic;
    try emit(init, allocator, outer.value.ir, args[7..9]);

    const mutating_source = try std.mem.replaceOwned(u8, allocator, f.consume_source, "in.push(in.length)[0]", "in.reverse()[0]");

    defer allocator.free(mutating_source);

    var mutating = try compiler.project.analyze(allocator, &.{.{ .path = "reverse.zx", .source = mutating_source }}, .{ .entry = "reverse.zx", .root_dir = "/project" });

    defer mutating.deinit();

    if (mutating.value != .ir) return error.UnexpectedDiagnostic;
    try emit(init, allocator, mutating.value.ir, args[11..13]);
}

fn emit(init: std.process.Init, allocator: std.mem.Allocator, program: compiler.ir.Program, paths: []const []const u8) !void {
    if (try compiler.validateIr(allocator, program) != null) return error.InvalidIr;

    const bundle = try compiler.zig.emitBundle(allocator, program);

    defer bundle.deinit(allocator);

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = paths[0], .data = bundle.source });
    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = paths[1], .data = bundle.types });
}
