const std = @import("std");
const compiler = @import("compiler");
const shared_source = "export enum State { First, Second, Third }\n\nexport type Code = u8\n";
const choose_source = "import { State } from \"../types\"\n\nimport type { Code } from \"../types\"\n\nexport type Input = Code\n\nexport type Output = State\n\nexport default function (in: Input): Output { return in == 0 ? State.First : in == 1 ? State.Second : State.Third }\n";

fn check(prefix: []const u8) !void {
    const source = try std.fmt.allocPrint(std.testing.allocator, "{s}\nexport type Input = Code\n\nexport type Output = u64\n\nexport default function (in: Input): Output {{ return match choose(in) {{ State.First => 11, State.Second => 22, _ => 33 }} }}\n", .{prefix});

    defer std.testing.allocator.free(source);

    var result = try compiler.project.analyze(std.testing.allocator, &.{
        .{ .path = "main.zx", .source = source },
        .{ .path = "nested/choose.zx", .source = choose_source },
        .{ .path = "types.zx", .source = shared_source },
    }, .{ .entry = "main.zx", .root_dir = "/project" });

    defer result.deinit();

    try std.testing.expect(result.value == .ir);

    const program = result.value.ir;

    try std.testing.expect(try compiler.validateIr(std.testing.allocator, program) == null);
    try std.testing.expectEqual(@as(usize, 3), result.modules.len);
    try std.testing.expectEqual(@as(usize, 1), program.functions.len);
    try std.testing.expectEqual(compiler.ir.Type{ .scalar = .u8 }, program.typeOf(program.input_type));
    try std.testing.expectEqual(compiler.ir.Type{ .scalar = .u64 }, program.typeOf(program.output_type));

    var enum_count: usize = 0;

    for (program.types) |value| {
        if (value == .enumeration) enum_count += 1;
    }

    try std.testing.expectEqual(@as(usize, 1), enum_count);
}

test "match shares enum identity with enum type and function imports in source order" {
    try check("import { State } from \"./types\"\nimport type { Code } from \"./types\"\nimport choose from \"./nested/choose\"\n");
}

test "match shares enum identity with function type and enum imports in source order" {
    try check("import choose from \"./nested/choose\"\nimport type { Code } from \"./types\"\nimport { State } from \"./types\"\n");
}
