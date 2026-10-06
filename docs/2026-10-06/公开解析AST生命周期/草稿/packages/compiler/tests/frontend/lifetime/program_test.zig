const std = @import("std");
const compiler = @import("compiler");
const allocations = @import("../../support/allocation_testing.zig");

const source =
    \\import transform from "./transform"
    \\
    \\import type { Shape } from "./shape"
    \\
    \\export type Input = { values: [i64, string?][] }
    \\
    \\export type Output = string
    \\
    \\export enum Phase { Ready, Done }
    \\
    \\export default function (in: Input): Output {
    \\  // retained comment
    \\  const [first, _] = [in.values[0], null]
    \\
    \\  if (true) {
    \\    const mapped = in.values.map((item) => item[1] ?? "fallback")
    \\
    \\    return `mapped-${transform({ ...in, values: mapped })}`
    \\  } else {
    \\    return "empty"
    \\  }
    \\}
;

fn check(allocator: std.mem.Allocator) !void {
    var parsed = blk: {
        var caller = std.heap.ArenaAllocator.init(allocator);

        defer caller.deinit();

        const text = try caller.allocator().dupe(u8, source);
        const path = try caller.allocator().dupe(u8, "owned_program.zx");
        const result = try compiler.parse(allocator, text, path);

        @memset(text, 'x');
        @memset(path, 'x');

        break :blk result;
    };

    defer parsed.deinit();

    try std.testing.expect(parsed.value == .parsed);

    const input = parsed.value.parsed;
    const program = input.ast;

    try std.testing.expectEqualStrings(source, input.source);
    try std.testing.expectEqualStrings("owned_program.zx", input.file_name);
    try std.testing.expectEqualStrings("import", input.lexed.tokens[0].text(input.source));
    try std.testing.expectEqual(@as(usize, 1), input.lexed.comments.len);

    const comment = input.lexed.comments[0];

    try std.testing.expectEqualStrings("// retained comment", input.source[comment.start..comment.end]);
    try std.testing.expectEqualStrings("transform", program.imports[0].names[0].text);
    try std.testing.expectEqualStrings("./transform", program.imports[0].path);
    try std.testing.expectEqualStrings("Shape", program.imports[1].names[0].text);
    try std.testing.expectEqualStrings("./shape", program.imports[1].path);
    try std.testing.expectEqualStrings("Input", program.declarations[0].name.text);

    const values = program.declarations[0].value.object[0];
    const tuple = values.value.list.tuple;

    try std.testing.expectEqualStrings("values", values.name.text);
    try std.testing.expectEqualStrings("i64", tuple[0].named.text);
    try std.testing.expectEqualStrings("string", tuple[1].optional.named.text);
    try std.testing.expectEqualStrings("Done", program.declarations[2].value.enumeration[1].text);

    const statements = program.body.?.statements;
    const destructure = statements[0].value.destructure;

    try std.testing.expectEqualStrings("first", destructure.names[0].text);
    try std.testing.expectEqualStrings("_", destructure.names[1].text);
    try std.testing.expectEqualStrings("0", destructure.value.value.list[0].value.index.index.value.number);
    try std.testing.expect(destructure.value.value.list[1].value == .null_value);

    const branch = statements[1].value.branch;
    const call = branch.yes.statements[0].value.constant.value.value.call;
    const lambda = call.arguments[0].value.lambda;

    try std.testing.expectEqualStrings("map", call.callee.value.field.name.text);
    try std.testing.expectEqualStrings("item", lambda.parameters[0].text);
    try std.testing.expectEqualStrings("\"fallback\"", lambda.body.value.binary.right.value.string);
    try std.testing.expectEqualStrings("1", lambda.body.value.binary.left.value.index.index.value.number);

    const parts = branch.yes.statements[1].value.result.?.value.template;
    const transform = parts[1].expression.value.call;
    const fields = transform.arguments[0].value.object;

    try std.testing.expectEqualStrings("mapped-", parts[0].text);
    try std.testing.expectEqualStrings("transform", transform.callee.value.identifier.text);
    try std.testing.expect(fields[0].spread);
    try std.testing.expectEqualStrings("in", fields[0].value.value.identifier.text);
    try std.testing.expectEqualStrings("values", fields[1].name.text);
    try std.testing.expectEqualStrings("mapped", fields[1].value.value.identifier.text);
    try std.testing.expectEqualStrings("\"empty\"", branch.no.?.statements[0].value.result.?.value.string);
}

test "public program AST outlives caller source and file name buffers" {
    try check(std.testing.allocator);
}

test "public program AST ownership releases every allocation failure" {
    try allocations.checkAllAllocationFailures(std.testing.allocator, check, .{});
}
