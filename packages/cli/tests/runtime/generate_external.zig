const std = @import("std");
const compiler = @import("compiler");

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);

    const source =
        \\import squareRoot from "zig:sqrt"
        \\import clamp from "lib:clamp"
        \\import borrowRecord from "lib:record"
        \\import zero from "lib:zero"
        \\import zeroTuple from "lib:zero-tuple"
        \\
        \\export type Input = f64
        \\
        \\export type Output = f64
        \\
        \\export default function (in: Input): Output {
        \\  return borrowRecord({ value: clamp(squareRoot(in), 1, 4) }).value + zero() + zeroTuple()
        \\}
    ;
    var result = try compiler.analyzeProject(allocator, &.{.{ .path = "main.zx", .source = source }}, .{
        .entry = "main.zx",
        .externals = &.{
            .{ .specifier = "lib:record", .signature = "export type Input = { value: f64 }\n export type Output = { value: f64 }\n", .implementation = .{ .module = "native_fixture", .member = "borrow" } },
            .{ .specifier = "lib:zero", .signature = "export type Input = void\n export type Output = f64\n", .implementation = .{ .module = "native_fixture", .member = "zero" } },
            .{ .specifier = "lib:zero-tuple", .signature = "export type Input = []\n export type Output = f64\n", .implementation = .{ .module = "native_fixture", .member = "zero", .expand_tuple = true } },
            .{ .specifier = "zig:sqrt", .signature = "export type Input = f64\n export type Output = f64\n", .implementation = .{ .module = "std", .member = "math.sqrt" } },
            .{ .specifier = "lib:clamp", .signature = "export type Input = [f64, f64, f64]\n export type Output = f64\n", .implementation = .{ .module = "std", .member = "math.clamp", .expand_tuple = true } },
        },
    });

    defer result.deinit();

    if (result.value == .diagnostic) {
        std.debug.print("{t}: {s}\n", .{ result.value.diagnostic.code, result.value.diagnostic.message });

        return error.CompileFailed;
    }

    const bundle = try compiler.zig.emitBundle(allocator, result.value.ir);

    defer bundle.deinit(allocator);

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[1], .data = bundle.source });
    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[2], .data = bundle.types });
}
