const std = @import("std");
const rx = @import("rx");
const analysis = @import("rx_analysis");
const compiler = @import("compiler");
const number = "export type Input = u64\n\nexport type Output = u64\n\nexport default function (in: Input): Output {\n  return in\n}\n";
const length = "export type Input = string\n\nexport type Output = u64\n\nexport default function (in: Input): Output {\n  return in.length\n}\n";

pub const Case = struct {
    source: []const u8,
    input: compiler.ir.Scalar = .void,
    input_path: []const []const u8 = &.{},
    output: compiler.ir.Scalar = .void,
    calls: usize = 0,
    outs: ?[]const ?[]const u8 = null,
    returned: bool = false,
    code: ?[]const u8 = null,
};

pub fn run(case: Case) !void {
    try runAllocated(std.testing.allocator, case);
}

pub fn runAllocated(allocator: std.mem.Allocator, case: Case) !void {
    var parsed = try rx.parseXml(allocator, case.source);

    defer parsed.deinit();

    try std.testing.expect(parsed.value == .node);

    var result = try analysis.module.infer(allocator, .{
        .owner = "main.rx",
        .module = parsed.value.node,
        .sources = &.{
            .{ .path = "discard.zx", .source = "export type Input = u64\n\nexport type Output = void\n\nexport default function (in: Input): Output {\n}\n" },
            .{ .path = "number.zx", .source = number },
            .{ .path = "a.b.zx", .source = number },
            .{ .path = "$in.child.zx", .source = number },
            .{ .path = ".a.zx", .source = number },
            .{ .path = "$input.zx", .source = number },
            .{ .path = "text.zx", .source = "export type Input = string\n\nexport type Output = string\n\nexport default function (in: Input): Output {\n  return in\n}\n" },
            .{ .path = "length.zx", .source = length },
            .{ .path = "text_length.zx", .source = length },
        },
    });

    defer result.deinit();

    if (case.code) |code| {
        try std.testing.expect(result.value == .diagnostic);
        try std.testing.expectEqualStrings(code, result.value.diagnostic.code);
        try std.testing.expectEqualStrings("main.rx", result.value.diagnostic.path);

        return;
    }

    if (result.value == .diagnostic) {
        std.debug.print("unexpected inference diagnostic: {s}: {s}\n", .{ result.value.diagnostic.code, result.value.diagnostic.message });

        return error.UnexpectedDiagnostic;
    }

    const contract = result.value.contract;
    var input = contract.input_type;

    for (case.input_path) |name| {
        const value = contract.types[@backingInt(input)];

        try std.testing.expect(value == .object);
        try std.testing.expectEqual(@as(usize, 1), value.object.len);
        try std.testing.expectEqualStrings(name, value.object[0].name);

        input = value.object[0].type_id;
    }

    try std.testing.expectEqualDeep(compiler.ir.Type{ .scalar = case.input }, contract.types[@backingInt(input)]);
    try std.testing.expectEqualDeep(compiler.ir.Type{ .scalar = case.output }, contract.types[@backingInt(contract.output_type)]);
    try std.testing.expectEqual(case.calls, contract.calls.len);
    try std.testing.expectEqual(case.returned, contract.result != null);

    for (contract.calls) |call| {
        try std.testing.expectEqual(call.callee.input_type, call.argument.output_type);
    }

    if (case.outs) |names| {
        try std.testing.expectEqual(names.len, contract.calls.len);

        for (names, contract.calls) |name, call| {
            if (name) |value| {
                try std.testing.expect(call.out != null);
                try std.testing.expectEqualStrings(value, call.out.?);
            } else try std.testing.expect(call.out == null);
        }
    }

    if (contract.result) |program| try std.testing.expectEqual(contract.output_type, program.output_type);
}
