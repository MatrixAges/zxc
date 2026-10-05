from pathlib import Path


DIRECTORY = Path(__file__).resolve().parent / '代码草稿/runtime'
PREFIX = '  const [err, res] = try native.value(in)\n\n'
CAPTURE = '  const [err, res] = try native.{name}(in)\n\n  if (err != null) {{\n    return 999\n  }}\n\n  return res'
CASES = {
    'scalar': ('u64', 'u64', PREFIX + '  if (err != null) {\n    return err == error.NativeFailure ? 101 : 102\n  }\n\n  return res'),
    'optional': ('u64', 'u64?', '  const [err, res] = try native.optional(in)\n\n  if (err != null) {\n    return 0\n  }\n\n  return res'),
    'void': ('u64', 'u64', '  const [err, _] = try native.effect(in)\n\n  return err == null ? in : 0'),
    'infallible': ('u64', 'u64', CAPTURE.format(name='identity')),
    'empty': ('u64', 'u64', CAPTURE.format(name='empty')),
    'before': ('u64', 'u64', '  const first = native.value(in)\n\n  const [err, res] = try native.value(first)\n\n  if (err != null) {\n    return 0\n  }\n\n  return res'),
    'after': ('u64', 'u64', PREFIX + '  if (err != null) {\n    return 999\n  }\n\n  return native.value(res - 2)'),
    'nested': ('u64', 'u64', '  const [outerErr, pair] = try (try native.value(in))\n\n  if (outerErr != null) {\n    return outerErr == error.OutOfMemory ? 999 : 998\n  }\n\n  const [err, res] = pair\n\n  return res ?? 0'),
    'index': ('u64[]', 'u64', '  const [err, res] = try in[0]\n\n  if (err != null) {\n    return err == error.IndexOutOfBounds ? 133 : 0\n  }\n\n  return res'),
    'compound': ('u64', 'u64', '  const [err, res] = try (native.value(in) + native.value(in))\n\n  if (err != null) {\n    return 0\n  }\n\n  return res'),
}

EXTRA = {
    'scalar': '''
test "direct scalar capture introduces no result wrapper allocation" {
    var failing = std.testing.FailingAllocator.init(std.testing.allocator, .{ .fail_index = 0 });
    var arena = std.heap.ArenaAllocator.init(failing.allocator());

    defer arena.deinit();

    host.reset();

    try std.testing.expectEqual(@as(u64, 2), try program.execute(&arena, 2));
    try std.testing.expectEqual(@as(usize, 1), host.calls);
    try std.testing.expect(!failing.has_induced_failure);
    try std.testing.expectEqual(@as(usize, 0), failing.allocated_bytes);
}
''',
    'nested': '''
test "outer capture handles inner tuple allocation failure" {
    var failing = std.testing.FailingAllocator.init(std.testing.allocator, .{ .fail_index = 0 });
    var arena = std.heap.ArenaAllocator.init(failing.allocator());

    defer arena.deinit();

    host.reset();

    try std.testing.expectEqual(@as(u64, 999), try program.execute(&arena, 2));
    try std.testing.expect(failing.has_induced_failure);
}
''',
}
CHECKS = {
    'scalar': [
        ('capture returns the exact native success value', 'output(2, 2, 1)'),
        ('capture handles NativeFailure as its declared member', 'output(0, 101, 1)'),
        ('capture distinguishes MissingValue from NativeFailure', 'output(1, 102, 1)'),
    ],
    'optional': [
        ('successful null remains null after outer result unwrap', 'output(1, null, 1)'),
        ('failed optional call differs from successful null', 'output(0, 0, 1)'),
        ('successful optional value retains its original payload', 'output(2, 2, 1)'),
    ],
    'void': [
        ('successful captured void call executes once', 'output(2, 2, 1)'),
        ('failed captured void call executes once and exposes its error', 'output(0, 0, 1)'),
    ],
    'infallible': [
        ('capturing infallible zero succeeds with a present result', 'output(0, 0, 1)'),
        ('capturing infallible maximum preserves all bits', 'output(std.math.maxInt(u64), std.math.maxInt(u64), 1)'),
    ],
    'empty': [
        ('capturing empty throws zero succeeds with a present result', 'output(0, 0, 1)'),
        ('capturing empty throws maximum preserves all bits', 'output(std.math.maxInt(u64), std.math.maxInt(u64), 1)'),
    ],
    'before': [
        ('ordinary failure before capture propagates and skips capture', 'failure(0, error.NativeFailure, 1)'),
        ('another ordinary error before capture retains its member', 'failure(1, error.MissingValue, 1)'),
        ('successful ordinary call continues into the later capture', 'output(2, 2, 2)'),
    ],
    'after': [
        ('captured initial failure prevents the later ordinary call', 'output(0, 999, 1)'),
        ('ordinary failure after capture remains outside its boundary', 'failure(2, error.NativeFailure, 2)'),
        ('ordinary second member after capture continues to propagate', 'failure(3, error.MissingValue, 2)'),
        ('successful capture continues to the ordinary result', 'output(4, 2, 2)'),
    ],
    'nested': [
        ('nested capture preserves an inner success result', 'output(2, 2, 1)'),
        ('nested capture keeps NativeFailure inside the inner tuple', 'output(0, 0, 1)'),
        ('nested capture keeps MissingValue inside the inner tuple', 'output(1, 0, 1)'),
    ],
    'index': [
        ('captured empty list index exposes IndexOutOfBounds', 'output(&.{}, 133, 0)'),
        ('captured zero list element is a successful present result', 'output(&.{0}, 0, 0)'),
        ('captured list index returns only the selected element', 'output(&.{ 7, 9 }, 7, 0)'),
    ],
    'compound': [
        ('capture encloses the whole compound expression', 'output(2, 4, 2)'),
        ('compound capture stops at the first NativeFailure', 'output(0, 0, 1)'),
        ('compound capture stops at the first MissingValue', 'output(1, 0, 1)'),
    ],
}


for name, (input_type, output_type, body) in CASES.items():
    directory = DIRECTORY / name
    directory.mkdir(parents=True, exist_ok=True)
    source = f'import native from "zig:host"\n\nexport type Input = {input_type}\n\nexport type Output = {output_type}\n\nexport default function (in: Input): Output {{\n{body}\n}}\n'
    (directory / 'main.zx').write_text(source)
    imports = 'const check = @import("capture_check");\n'

    if name in ['infallible', 'empty']:
        imports = 'const std = @import("std");\n' + imports

    if name in EXTRA:
        imports = 'const std = @import("std");\nconst program = @import("program");\nconst host = @import("host");\n' + imports

    tests = imports

    for title, call in CHECKS[name]:
        tests += f'\ntest "{title}" {{\n    try check.{call};\n}}\n'

    tests += EXTRA.get(name, '')

    (directory / 'execution_test.zig').write_text(tests)
