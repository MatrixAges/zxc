const std = @import("std");
const frontend = @import("compiler");
const zx = @import("zx");
const helpers = @import("../helpers.zig");

fn expectInvalid(program: zx.ir.Program) !void {
    const issue = try frontend.validateIr(std.testing.allocator, program);

    try std.testing.expect(issue != null);
    try std.testing.expectEqualStrings("contract", @tagName(issue.?.code));
}

test "ir: rejects a callback capture supplied by a foreign frontend" {
    var parsed = try helpers.parseValid("export type Input = u64[]\n export type Output = u64[]\n export default function (in: Input): Output { const offset = 1\n return in.map((item) => item + 1) }");

    defer parsed.deinit();

    var analyzed = try frontend.analyze(std.testing.allocator, parsed.value.parsed);

    defer analyzed.deinit();

    try std.testing.expect(analyzed.value == .ir);

    var program = analyzed.value.ir;

    try std.testing.expect(try frontend.validateIr(std.testing.allocator, program) == null);

    const references = try std.testing.allocator.dupe(u32, program.expressions.references);

    defer std.testing.allocator.free(references);

    for (references) |*reference| {
        if (reference.* == 2) reference.* = 1;
    }

    program.expressions.references = references;

    try expectInvalid(program);
}

test "ir: rejects forward edges and wrong versions" {
    var parsed = try helpers.parseValid("export type Input = u64\n export type Output = u64\n export default function (in: Input): Output { return in + 1 }");

    defer parsed.deinit();

    var analyzed = try frontend.analyze(std.testing.allocator, parsed.value.parsed);

    defer analyzed.deinit();

    var program = analyzed.value.ir;

    program.version = 1;

    try expectInvalid(program);

    program.version = zx.ir_version;

    const left = try std.testing.allocator.dupe(u32, program.expressions.binary_left);

    defer std.testing.allocator.free(left);

    const last = program.expressions.count() - 1;
    left[program.expressions.payloads[last]] = @intCast(last);
    program.expressions.binary_left = left;

    try expectInvalid(program);
}

test "ir: accepts pure type modules and rejects phantom executable bodies" {
    var parsed = try helpers.parseValid("export type Value = u64[]\n");

    defer parsed.deinit();

    var analyzed = try frontend.analyze(std.testing.allocator, parsed.value.parsed);

    defer analyzed.deinit();

    var program = analyzed.value.ir;

    try std.testing.expect(try frontend.validateIr(std.testing.allocator, program) == null);

    program.type_only = false;

    try expectInvalid(program);
}

test "ir: foreign self-recursion cannot bypass source module cycle checks" {
    var parsed = try helpers.parseValid("export type Input = u64\n export type Output = u64\n export default function (in: Input): Output { return in + 1 }");

    defer parsed.deinit();

    var analyzed = try frontend.analyze(std.testing.allocator, parsed.value.parsed);

    defer analyzed.deinit();

    var program = analyzed.value.ir;
    var expressions = program.expressions;
    const kinds = try std.testing.allocator.dupe(@typeInfo(@TypeOf(expressions.kinds)).pointer.child, expressions.kinds);

    defer std.testing.allocator.free(kinds);

    const payloads = try std.testing.allocator.dupe(u32, expressions.payloads);

    defer std.testing.allocator.free(payloads);

    try std.testing.expectEqual(@as(usize, 1), expressions.binary_left.len);
    try std.testing.expectEqual(.Binary, kinds[kinds.len - 1]);

    kinds[kinds.len - 1] = .Call;
    payloads[payloads.len - 1] = 0;
    expressions.kinds = kinds;
    expressions.payloads = payloads;
    expressions.binary_operators = &.{};
    expressions.binary_left = &.{};
    expressions.binary_right = &.{};
    expressions.call_functions = &.{0};
    expressions.call_arguments = &.{0};
    expressions.call_store_first = &.{0};
    expressions.call_store_count = &.{0};

    const functions = [_]zx.ir.Function{.{ .file_name = "foreign.zx", .input_type = program.input_type, .output_type = program.output_type, .symbols = program.symbols, .expressions = expressions, .body = program.body }};

    program.functions = &functions;

    try expectInvalid(program);
}

test "ir: a supplied Store slot cannot bypass its read permission" {
    var parsed = try helpers.parseValid("export type State = { count: u64 }\n export type Input = void\n export type Output = u64\n export default function (in: Input): Output { return $state.value.count }");

    defer parsed.deinit();

    var analyzed = try frontend.analyzeWithContext(std.testing.allocator, parsed.value.parsed, .{ .stores = &.{.{ .handle = "$state", .path = "store.orders.state", .type_name = "State" }} });

    defer analyzed.deinit();

    try std.testing.expect(analyzed.value == .ir);

    var program = analyzed.value.ir;

    try std.testing.expect(try frontend.validateIr(std.testing.allocator, program) == null);

    var stores = [_]zx.ir.StoreSlot{program.stores[0]};
    stores[0].readable = false;
    program.stores = &stores;

    try expectInvalid(program);
}
