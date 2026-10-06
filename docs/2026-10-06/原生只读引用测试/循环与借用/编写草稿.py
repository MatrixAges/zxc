# -*- coding: utf-8 -*-
from pathlib import Path
import subprocess


root = Path(__file__).resolve().parents[1] / '草稿/packages/test'
runtime = root / 'tests/native/references/runtime'
repository = Path(__file__).resolve().parents[4]


def base(name):
    return subprocess.check_output(['git', 'show', 'f245985a:packages/test/' + name], cwd=repository, text=True)


def write(name, text):
    path = runtime / name
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(text.strip() + '\n', encoding='utf-8')


for name in ('borrowed', 'loop_write', 'loop_history', 'two_buffers'):
    borrowed = name == 'borrowed'
    history = name == 'loop_history'
    dual = name == 'two_buffers'
    imports = 'import host from "zig:host"\n\n' if borrowed else ''
    input_field = 'node: Node' if borrowed else 'values: Node[]'
    original = 'host.references(in.node)' if borrowed else 'in.values'
    fields = 'left_values: Node[], right_values: Node[]' if dual else 'values: Node[]'
    fields += ', history: Node[]' if history else ''
    initial = 'left_values: original, right_values: original' if dual else 'values: original'
    initial += ', history: original' if history else ''
    mutations = '      state.history = state.values\n' if history else ''
    mutations += '      state.left_values[0] = state.left\n      state.right_values[1] = state.right' if dual else '      state.values[0] = state.index % 2 == 0 ? state.left : state.right'
    output_fields = 'values: Node[], other: Node[]' if dual else 'values: Node[]'
    output_fields += ', history: Node[]' if history else ''
    result = 'values: result.left_values, other: result.right_values' if dual else 'values: result.values'
    result += ', history: result.history' if history else ''

    write(name + '/main.zx', f'''{imports}import type {{ Node }} from "zig:host"

export type Input = {{ {input_field}, left: Node, right: Node, count: u64 }}

export type State = {{ {fields}, left: Node, right: Node, index: u64, count: u64 }}

export type Output = {{ original: Node[], {output_fields} }}

export default function (in: Input): Output {{
  const original = {original}
  const initial: State = {{ {initial}, left: in.left, right: in.right, index: 0, count: in.count }}

  const result = loop(initial, {{
    while: state => state.index < state.count,
    next: state => {{
{mutations}
      state.index += 1
    }}
  }})

  return {{ original: original, {result} }}
}}''')

    input_value = '.node = host.fromNode(&owner)' if borrowed else '.values = values'
    extra = '''
    try std.testing.expectEqual(length, result.other.len);
    try support.expectNode(if (count == 0) &original else &right, result.other[1]);
    try support.expectNode(&original, result.other[0]);

    if (count > 0) try std.testing.expect(result.values.ptr != result.other.ptr);

    for (2..length) |index| try support.expectNode(&original, result.other[index]);
''' if dual else ''
    extra += '''
    try std.testing.expectEqual(length, result.history.len);
    const previous = if (count <= 1) &original else if ((count - 2) % 2 == 0) &left else &right;

    try support.expectNode(previous, result.history[0]);

    for (1..length) |index| try support.expectNode(&original, result.history[index]);
''' if history else ''
    allocation_test = '''
test "safe native reference loop updates have equal allocation cost for short and long execution" {
    const short = try run(std.testing.allocator, 4, 257);
    const long = try run(std.testing.allocator, 64, 257);

    try std.testing.expectEqual(short, long);
}
''' if not history else '''
test "native reference history preserves the previous version across multiple replacements" {
    for ([_]usize{ 2, 3, 17 }) |count| _ = try run(std.testing.allocator, count, 17);
}
'''

    write(name + '/execution_test.zig', f'''const std = @import("std");
const program = @import("program");
const host = @import("host");
const support = @import("reference_support");
const allocation_testing = @import("allocation_testing");

fn run(allocator: std.mem.Allocator, count: usize, length: usize) !usize {{
    const original = host.HostNode{{ .value = 7, .payload = "original" }};
    const left = host.HostNode{{ .value = 7, .payload = "left" }};
    const right = host.HostNode{{ .value = 7, .payload = "right" }};
    const values = try std.testing.allocator.alloc(host.Node, length);

    defer std.testing.allocator.free(values);
    @memset(values, host.fromNode(&original));

    const owner = host.HostNode{{ .value = 11, .payload = "owner", .references = values }};
    const input: @typeInfo(program.Input).pointer.child = .{{ {input_value}, .left = host.fromNode(&left), .right = host.fromNode(&right), .count = @intCast(count) }};
    var tracked = std.testing.FailingAllocator.init(allocator, .{{}});
    var arena = std.heap.ArenaAllocator.init(tracked.allocator());

    defer arena.deinit();
    host.reset(0);

    const result = program.execute(&arena, &input) catch |err| {{
        try preserved(values, &original, owner, left, right);

        return err;
    }};

    try std.testing.expectEqual(length, result.original.len);
    try std.testing.expectEqual(values.ptr, result.original.ptr);
    try std.testing.expectEqual(length, result.values.len);

    const updated = if (count == 0) &original else {'&left' if dual else 'if ((count - 1) % 2 == 0) &left else &right'};

    try support.expectNode(updated, result.values[0]);

    if (count == 0) {{
        try std.testing.expectEqual(values.ptr, result.values.ptr);
    }} else {{
        try std.testing.expect(values.ptr != result.values.ptr);
    }}

    for (1..length) |index| try support.expectNode(&original, result.values[index]);
{extra}
    try std.testing.expectEqual(@as(usize, {1 if borrowed else 0}), host.calls);
    try preserved(values, &original, owner, left, right);

    return tracked.allocated_bytes;
}}

fn preserved(values: []const host.Node, original: *const host.HostNode, owner: host.HostNode, left: host.HostNode, right: host.HostNode) !void {{
    for (values) |value| try support.expectNode(original, value);

    try support.expectOwner(.{{ .value = 7, .payload = "original" }}, original.*);
    try support.expectOwner(.{{ .value = 7, .payload = "left" }}, left);
    try support.expectOwner(.{{ .value = 7, .payload = "right" }}, right);
    try support.expectOwner(.{{ .value = 11, .payload = "owner", .references = values }}, owner);
}}

fn failures(allocator: std.mem.Allocator) !void {{
    _ = try run(allocator, 4, 17);
}}

test "native reference loop preserves the zero step borrowed slots and first write isolation" {{
    for ([_]usize{{ 0, 1 }}) |count| _ = try run(std.testing.allocator, count, 17);
}}

test "native reference loop preserves every input slot across long execution" {{
    _ = try run(std.testing.allocator, 64, 257);
}}
{allocation_test}
test "native reference loop releases all allocation failures without changing any owner or input slot" {{
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, failures, .{{}});
}}''')


write('traversal/main.zx', '''import host from "zig:host"

import type { Node } from "zig:host"

export type Input = Node

export type Output = u64[]

export default function (in: Input): Output {
  return host.references(in).map(node => host.read(node))
}''')

write('traversal/execution_test.zig', '''const std = @import("std");
const program = @import("program");
const host = @import("host");
const support = @import("reference_support");
const allocation_testing = @import("allocation_testing");

fn run(allocator: std.mem.Allocator, length: usize) !void {
    const nodes = try std.testing.allocator.alloc(host.HostNode, length);

    defer std.testing.allocator.free(nodes);

    const values = try std.testing.allocator.alloc(host.Node, length);

    defer std.testing.allocator.free(values);

    for (nodes, values, 0..) |*node, *value, index| {
        node.* = .{ .value = @intCast(index % 7 + 1), .payload = "node" };
        value.* = host.fromNode(node);
    }

    const owner = host.HostNode{ .value = 31, .payload = "owner", .references = values };
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();
    host.reset(0);

    const result = program.execute(&arena, host.fromNode(&owner)) catch |err| {
        try preserved(nodes, values, owner);

        return err;
    };

    try std.testing.expectEqual(length, result.len);
    try std.testing.expectEqual(length + 1, host.calls);
    try support.expectNode(&owner, host.events[0].node);
    try std.testing.expectEqual(@as(u64, 5), host.events[0].marker);

    for (result, nodes, 0..) |value, *node, index| {
        try std.testing.expectEqual(@as(u64, @intCast(index % 7 + 1)), value);
        try support.expectNode(node, host.events[index + 1].node);
        try std.testing.expectEqual(@as(u64, 2), host.events[index + 1].marker);
    }

    try preserved(nodes, values, owner);
}

fn preserved(nodes: []const host.HostNode, values: []const host.Node, owner: host.HostNode) !void {
    for (nodes, values, 0..) |*node, value, index| {
        try support.expectNode(node, value);
        try support.expectOwner(.{ .value = @intCast(index % 7 + 1), .payload = "node" }, node.*);
    }

    try support.expectOwner(.{ .value = 31, .payload = "owner", .references = values }, owner);
}

fn failures(allocator: std.mem.Allocator) !void {
    try run(allocator, 17);
}

test "empty native reference traversal reads only the root accessor" {
    try run(std.testing.allocator, 0);
}

test "native reference traversal reads real leaf addresses in source order" {
    try run(std.testing.allocator, 257);
}

test "native reference traversal releases all allocation failures and preserves all host leaves" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, failures, .{});
}''')


host_path = runtime / 'host.zig'
host = base('tests/native/references/runtime/host.zig')
host = host.replace('children: []const HostNode = &.{}', 'children: []const HostNode = &.{}, references: []const Node = &.{}')
host = host.replace('events: [16]Event', 'events: [1024]Event')
host += '''
pub fn references(node: Node) []const Node {
    note(node, 5);

    return view(node).references;
}
'''
host_path.write_text(host, encoding='utf-8')

declaration = runtime / 'host.d.zx'
declaration.write_text(base('tests/native/references/runtime/host.d.zx') + '\nexport declare function references(node: Node): Node[]\n', encoding='utf-8')

support_path = runtime / 'support.zig'
support = base('tests/native/references/runtime/support.zig')
support = support.replace('    try std.testing.expectEqualDeep(expected.children, actual.children);', '''    try std.testing.expectEqualDeep(expected.children, actual.children);
    try std.testing.expectEqual(@intFromPtr(expected.references.ptr), @intFromPtr(actual.references.ptr));
    try std.testing.expectEqualSlices(host.Node, expected.references, actual.references);''')
support_path.write_text(support, encoding='utf-8')

builder = root / 'build/native_reference_runtime.zig'
text = base('build/native_reference_runtime.zig').replace('"containers", "order"', '"containers", "order", "traversal", "borrowed", "loop_write", "loop_history", "two_buffers"')
builder.write_text(text, encoding='utf-8')

print('Drafts: 5 runtime groups, 19 independent declarations')
