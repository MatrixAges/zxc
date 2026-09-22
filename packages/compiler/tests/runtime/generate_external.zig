const std = @import("std");
const compiler = @import("compiler");

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);

    const result = try compiler.compileProject(allocator, &.{.{ .path = "main.zx", .source = "import squareRoot from \"zig:sqrt\"; import clamp from \"lib:clamp\"; import copyRecord from \"lib:record\"; import zero from \"lib:zero\"; import zeroTuple from \"lib:zero-tuple\"; export type Input = f64; export type Output = f64; export default function (in: Input): Output { return copyRecord({ value: clamp(squareRoot(in), 1, 4) }).value + zero() + zeroTuple(); }" }}, .{
        .entry = "main.zx",
        .externals = &.{
            .{ .specifier = "lib:record", .signature = "export type Input = { value: f64; }; export type Output = { value: f64; };", .implementation = .{ .module = "native_fixture", .member = "copy" } },
            .{ .specifier = "lib:zero", .signature = "export type Input = void; export type Output = f64;", .implementation = .{ .module = "native_fixture", .member = "zero" } },
            .{ .specifier = "lib:zero-tuple", .signature = "export type Input = []; export type Output = f64;", .implementation = .{ .module = "native_fixture", .member = "zero", .expand_tuple = true } },
            .{ .specifier = "zig:sqrt", .signature = "export type Input = f64; export type Output = f64;", .implementation = .{ .module = "std", .member = "math.sqrt" } },
            .{ .specifier = "lib:clamp", .signature = "export type Input = [f64, f64, f64]; export type Output = f64;", .implementation = .{ .module = "std", .member = "math.clamp", .expand_tuple = true } },
        },
    });

    defer result.deinit(allocator);

    if (result == .diagnostic) {
        std.debug.print("{t}: {s}\n", .{ result.diagnostic.code, result.diagnostic.message });

        return error.CompileFailed;
    }

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[1], .data = result.source });
}
