const std = @import("std");
pub const compiler = @import("compiler");
pub const members = &.{ "AlphaFailure", "ZetaFailure" };
pub const body = "const [err, res] = try native.apply(in)\nif (err == null) { return res } else { return 0 }";

pub const Case = struct {
    body: []const u8 = body,
    output: []const u8 = "u64",
    declaration: []const u8 = "export declare function apply(input: u64): u64 throws { ZetaFailure, AlphaFailure }\n",
};

pub fn library(allocator: std.mem.Allocator, case: Case) !compiler.library.Result {
    const source = try std.fmt.allocPrint(allocator, "import native from \"zig:sample\"\nexport type Input = u64\nexport type Output = {s}\nexport default function (in: Input): Output {{\n{s}\n}}\n", .{ case.output, case.body });

    defer allocator.free(source);

    var analyzed = try compiler.project.analyze(allocator, &.{.{ .path = "main.zx", .source = source }}, .{
        .entry = "main.zx",
        .root_dir = "/library",
        .native_interfaces = &.{.{ .specifier = "zig:sample", .path = "sample.d.zx", .source = case.declaration, .module = "sample" }},
    });

    defer analyzed.deinit();

    if (analyzed.value == .diagnostic) std.debug.print("unexpected diagnostic: {s}\n", .{analyzed.value.diagnostic.message});
    try std.testing.expect(analyzed.value == .ir);
    try std.testing.expect(try compiler.validateIr(allocator, analyzed.value.ir) == null);

    return compiler.library.link(allocator, &.{.{ .name = "call", .analysis = &analyzed }});
}

pub fn consume(allocator: std.mem.Allocator, value: *const compiler.library.Result, output: []const u8) !compiler.AnalysisResult {
    const source = try std.fmt.allocPrint(allocator, "import run from \"sample\"\nexport type Input = u64\nexport type Output = {s}\nexport default function (in: Input): Output {{ return run(in) }}\n", .{output});

    defer allocator.free(source);

    return compiler.project.analyze(allocator, &.{.{ .path = "consumer.zx", .source = source }}, .{
        .entry = "consumer.zx",
        .root_dir = "/consumer",
        .packages = &.{.{ .specifier = "sample", .compiled = .{ .instance = "sample@1", .artifact = "sample.zxlib", .name = "call" } }},
        .compiled_libraries = &.{.{ .instance = "sample@1", .artifact = "sample.zxlib", .program = value.program, .exports = value.exports, .nominal_types = value.nominal_types }},
    });
}

pub fn inspect(program: compiler.ir.Program, expected: []const []const u8, narrowed: bool) !void {
    try std.testing.expect(try compiler.validateIr(std.testing.allocator, program) == null);

    var captures: usize = 0;
    var proofs: usize = 0;
    var natives: usize = 0;

    try expressions(program, program.expressions, expected, &captures, &proofs);

    for (program.functions) |function| {
        try expressions(program, function.expressions, expected, &captures, &proofs);

        if (function.external) |external| {
            natives += 1;

            try expectMembers(external.errors orelse &.{}, expected);
        }
    }

    try std.testing.expectEqual(@as(usize, 1), captures);
    try std.testing.expectEqual(@as(usize, 1), natives);
    try std.testing.expectEqual(narrowed, proofs != 0);
}

fn expressions(program: compiler.ir.Program, values: compiler.ir.ExpressionTable, expected: []const []const u8, captures: *usize, proofs: *usize) !void {
    for (0..values.count()) |index| {
        const value = values.at(index);

        if (value.value == .optional_value) proofs.* += 1;
        if (value.value != .capture) continue;

        captures.* += 1;
        const slots = program.typeOf(value.type_id).tuple;
        const errors = program.typeOf(program.typeOf(slots.at(0)).optional).error_set;

        try std.testing.expectEqual(@as(usize, 2), slots.len);
        try expectMembers(errors, expected);

        const original = values.at(@backingInt(value.value.capture)).type_id;
        const payload = program.typeOf(slots.at(1));

        try std.testing.expectEqual(original, if (payload == .optional) payload.optional else slots.at(1));
    }
}

fn expectMembers(actual: []const []const u8, expected: []const []const u8) !void {
    try std.testing.expectEqual(expected.len, actual.len);

    for (expected) |name| {
        var found = false;

        for (actual) |member| if (std.mem.eql(u8, name, member)) {
            found = true;
        };

        try std.testing.expect(found);
    }
}
