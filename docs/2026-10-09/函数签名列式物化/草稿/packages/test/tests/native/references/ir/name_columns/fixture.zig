const std = @import("std");
const f = @import("native_ir_fixture");
pub const compiler = f.compiler;
pub const ir = f.ir;

pub const names: []const ?[]const u8 = &.{ "Packet", null, null, "Alpha", null, null, "Beta", null };

pub fn analyze(allocator: std.mem.Allocator) !compiler.AnalysisResult {
    const source =
        \\import host from "zig:host"
        \\
        \\import type { Packet } from "zig:host"
        \\
        \\export type Input = Packet
        \\
        \\export type Output = u64
        \\
        \\export default function (in: Input): Output {
        \\    return host.read(in)
        \\}
    ;
    const declaration =
        \\export type Alpha = opaque
        \\
        \\export type Beta = opaque
        \\
        \\export type Packet = { scalar: u64, right: [u64, Beta], left: Alpha?[] }
        \\
        \\export declare function read(packet: Packet): u64
    ;

    var result = try compiler.analyzeProject(allocator, &.{.{ .path = "main.zx", .source = source }}, .{
        .entry = "main.zx",
        .root_dir = "/project",
        .native_interfaces = &.{.{ .specifier = "zig:host", .path = "host.d.zx", .source = declaration, .module = "host" }},
    });

    errdefer result.deinit();

    try std.testing.expect(result.value == .ir);
    try std.testing.expect(try compiler.validateIr(allocator, result.value.ir) == null);

    return result;
}

pub fn withNames(allocator: std.mem.Allocator, original: ir.Program, values: []const ?[]const u8) !ir.Program {
    var program = f.nativeOnly(original);
    const inputs = try allocator.dupe(?[]const ?[]const u8, original.functions.native_inputs);
    var count: usize = 0;

    for (original.functions.native_modules, 0..) |module, index| {
        if (module == null) continue;

        inputs[index] = values;
        count += 1;
    }

    try std.testing.expectEqual(@as(usize, 1), count);

    program.functions.native_inputs = inputs;

    return program;
}

pub fn check(allocator: std.mem.Allocator, values: []const ?[]const u8, accepted: bool) !void {
    var result = try analyze(allocator);

    defer result.deinit();

    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const program = try withNames(arena.allocator(), result.value.ir, values);

    if (!accepted) return f.rejected(allocator, program);

    try std.testing.expect(try compiler.validateIr(allocator, program) == null);

    const bundle = try compiler.zig.emitBundle(allocator, program);

    defer bundle.deinit(allocator);
}
