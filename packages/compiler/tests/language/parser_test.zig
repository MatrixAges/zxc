const std = @import("std");
const h = @import("../helpers.zig");

test "zx-file-roles: pure type files do not require a default function" {
    var result = try h.parseValid("export type User = { id: u64; name?: string; }; export enum State { Ready, Done, }");

    defer result.deinit();

    const program = result.value.parsed.ast;

    try std.testing.expect(program.body == null);
    try std.testing.expectEqual(@as(usize, 2), program.declarations.len);
    try std.testing.expect(program.declarations[0].value.object[1].value.* == .optional);
    try std.testing.expectEqualStrings("Done", program.declarations[1].value.enumeration[1].text);
}

test "zx-type-postfix: optional and list operators associate in source order" {
    var result = try h.parseValid("export type A = u64?[]; export type B = u64[]?; export type C = [u64[], u64?];");

    defer result.deinit();

    const declarations = result.value.parsed.ast.declarations;

    try std.testing.expect(declarations[0].value.list.* == .optional);
    try std.testing.expect(declarations[1].value.optional.* == .list);
    try std.testing.expectEqual(@as(usize, 2), declarations[2].value.tuple.len);
}

test "zx-imports: distinguish type, enum and default function imports" {
    var result = try h.parseValid(
        \\import type { User, Money } from "./types";
        \\import { State } from "@/state";
        \\import normalizePrice from "./normalize_price";
        \\export type Input = User;
        \\export type Output = Money;
        \\export default function (in: Input,): Output { return normalizePrice(in); }
    );

    defer result.deinit();

    const program = result.value.parsed.ast;

    try std.testing.expect(program.imports[0].kind == .type_only);
    try std.testing.expect(program.imports[1].kind == .enumeration);
    try std.testing.expect(program.imports[2].kind == .function);
    try std.testing.expect(program.body.?.statements[0].value.result.?.value == .call);
}

test "zx-ownership-binding: explicit tuple destructuring preserves discard names" {
    var result = try h.parseValid(
        \\export type Input = u64[];
        \\export type Output = u64[];
        \\export default function (in: Input): Output {
        \\  const items: u64[] = [1, 2, 3,];
        \\  const [next_items, _] = items.push(4);
        \\  return next_items;
        \\}
    );

    defer result.deinit();

    const statements = result.value.parsed.ast.body.?.statements;

    try std.testing.expect(statements[0].value.constant.annotation.?.* == .list);
    try std.testing.expectEqualStrings("_", statements[1].value.destructure.names[1].text);
}

test "zx-collections: parse chained filter and map lambdas" {
    var result = try h.parseValid(
        \\export type Input = u64[];
        \\export type Output = u64[];
        \\export default function (in: Input): Output {
        \\  return in.filter((score) => score >= 60).map(score => score + 10);
        \\}
    );

    defer result.deinit();

    const call = result.value.parsed.ast.body.?.statements[0].value.result.?.value.call;

    try std.testing.expect(call.arguments[0].value == .lambda);
    try std.testing.expectEqualStrings("map", call.callee.value.field.name.text);
}

test "zx-template: interpolation uses expression parsing and absolute spans" {
    const source =
        \\export type Input = u64;
        \\export type Output = string;
        \\export default function (in: Input): Output { return `order-${in + 1}-${`nested-${in}`}`; }
    ;

    var result = try h.parseValid(source);

    defer result.deinit();

    const parts = result.value.parsed.ast.body.?.statements[0].value.result.?.value.template;

    try std.testing.expectEqualStrings("order-", parts[0].text);
    try std.testing.expectEqualStrings("in + 1", source[parts[1].expression.span.start..parts[1].expression.span.end]);
    try std.testing.expect(parts[3].expression.value == .template);
}

test "zx-switch: preserve case boundaries and default" {
    var result = try h.parseValid(
        \\export type Input = u64;
        \\export type Output = u64;
        \\export default function (in: Input): Output {
        \\  switch (in) { case 1: return 10; case 2: return 20; default: return 0; }
        \\}
    );

    defer result.deinit();

    const cases = result.value.parsed.ast.body.?.statements[0].value.switch_stmt.cases;

    try std.testing.expectEqual(@as(usize, 3), cases.len);
    try std.testing.expect(cases[2].value == null);
    try std.testing.expectEqual(@as(usize, 1), cases[0].body.statements.len);
}

test "zx-store-signature: setter and spread retain their syntax" {
    var result = try h.parseValid(
        \\export type Input = { count: u64; };
        \\export type Output = void;
        \\export default function (in: Input, { store },): Output {
        \\  store.state.counter = { ...in, count: in.count + 1 };
        \\}
    );

    defer result.deinit();

    const program = result.value.parsed.ast;

    try std.testing.expect(program.has_store);
    try std.testing.expect(program.body.?.statements[0].value.store_set.value.value.object[0].spread);
}

test "zx-negative-parse: const requires an initializer" {
    try h.parseInvalid("export type Input = u64; export type Output = void; export default function (in: Input): Output { const value; }", .syntax);
}

test "zx-negative-parse: ordinary variable reassignment is forbidden" {
    try h.parseInvalid("export type Input = u64; export type Output = void; export default function (in: Input): Output { in = 2; }", .syntax);
}

test "zx-negative-parse: unterminated interpolation is lexical failure" {
    try h.parseInvalid("export type Input = u64; export type Output = string; export default function (in: Input): Output { return `x${in; }", .lexical);
}

test "zx-negative-parse: import type requires named bindings" {
    try h.parseInvalid("import type User from \"./user\";", .syntax);
}

test "zx-template: lexical interpolation errors retain absolute source positions" {
    const source = "export type Input = void; export type Output = string; export default function (in: Input): Output { return `value ${^}`; }";
    var result = try @import("compiler").parse(std.testing.allocator, source, "template.zx");

    defer result.deinit();

    try std.testing.expect(result.value == .diagnostic);
    try std.testing.expectEqual(std.mem.indexOfScalar(u8, source, '^').?, result.value.diagnostic.span.start);
}
