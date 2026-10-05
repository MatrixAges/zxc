const std = @import("std");
const allocation_testing = @import("allocation_testing");
const h = @import("check.zig");

test "fresh mapped value transfers to owned helper" {
    try h.run(.{
        .body = "  return consume(in.map(item => item))",
    });
}

test "owned entry transfers its input" {
    try h.run(.{
        .body = "  return consume(in)",
        .owned = true,
    });
}

test "borrowed entry cannot transfer input" {
    try h.run(.{
        .body = "  return consume(in)",
        .marker = "consume(in)",
    });
}

test "owned result can be consumed repeatedly through new bindings" {
    try h.run(.{
        .body = "  const values = in.map(item => item)\n  const next = consume(values)\n\n  return consume(next)",
    });
}

test "old binding cannot be reused after owned call" {
    try h.run(.{
        .body = "  const values = in.map(item => item)\n  const next = consume(values)\n\n  return values",
        .marker = "values",
    });
}

test "second call cannot consume old binding" {
    try h.run(.{
        .body = "  const values = in.map(item => item)\n  const next = consume(values)\n\n  return consume(values)",
        .marker = "values",
    });
}

test "scalar filter creates an owned value for consumption" {
    try h.run(.{
        .body = "  return consume(in.filter(item => item > 0))",
    });
}

test "reference element map remains borrowed" {
    try h.run(.{
        .body = "  return consume(in.map(item => item))",
        .input = "u64[][]",
        .output = "u64[][]",
        .helper_input = "u64[][]",
        .helper_output = "u64[][]",
        .helper_body = "  return in.reverse()[0]",
        .marker = "consume(in.map(item => item))",
    });
}

test "fresh aggregate containing borrowed list cannot transfer" {
    try h.run(.{
        .body = "  return consume({items: in, count: 1})",
        .helper_input = "{items: u64[], count: u64}",
        .helper_body = "  const count = in.count\n\n  return in.items.push(count)[0]",
        .marker = "consume({items: in, count: 1})",
    });
}

test "fresh aggregate containing owned list can transfer" {
    try h.run(.{
        .body = "  return consume({items: in.map(item => item), count: 1})",
        .helper_input = "{items: u64[], count: u64}",
        .helper_body = "  const count = in.count\n\n  return in.items.push(count)[0]",
    });
}

test "scalar owned input remains copyable" {
    try h.run(.{
        .body = "  const first = consume(in)\n\n  return first + consume(in)",
        .input = "u64",
        .output = "u64",
        .helper_input = "u64",
        .helper_output = "u64",
        .helper_body = "  return in + 1",
        .ownership = "copy",
    });
}

test "borrowed helper does not consume owned argument" {
    try h.run(.{
        .body = "  const values = in.map(item => item)\n  const count = consume(values)\n\n  return values.push(count)[0]",
        .helper_owned = false,
        .helper_output = "u64",
        .helper_body = "  return in.length",
    });
}

test "owned scalar-returning helper still consumes reference" {
    try h.run(.{
        .body = "  const values = in.map(item => item)\n  const count = consume(values)\n\n  return values.push(count)[0]",
        .helper_output = "u64",
        .helper_body = "  return in.length",
        .marker = "values",
    });
}

test "reduce transfers owned accumulator across helper calls" {
    try h.run(.{
        .body = "  const initial: u64[] = []\n\n  return in.reduce((items, item) => consume(items), initial)",
    });
}

test "reduce cannot transfer borrowed initial accumulator" {
    try h.run(.{
        .body = "  return in.reduce((items, item) => consume(items), in)",
        .marker = "consume(items)",
    });
}

test "one branch consuming input invalidates later reuse" {
    try h.run(.{
        .body = "  const values = in.map(item => item)\n  if (in.length > 0) {\n    const next = consume(values)\n  }\n\n  return values",
        .marker = "values",
    });
}

test "owned input can return fresh mapped result" {
    try h.run(.{
        .body = "  return consume(in)",
        .owned = true,
        .helper_body = "  return in.map(item => item)",
    });
}

test "owned input identity return remains owned" {
    try h.run(.{
        .body = "  return consume(in).reverse()[0]",
        .owned = true,
        .helper_body = "  return in",
    });
}

test "owned helper success releases allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, h.allocated, .{h.Case{
        .body = "  return consume(in.map(item => item))",
    }});
}

test "borrowed helper call rejection releases allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, h.allocated, .{h.Case{
        .body = "  return consume(in)",
        .marker = "consume(in)",
    }});
}

test "owned input contract does not upgrade borrowed function result" {
    try h.run(.{
        .body = "  return consume(in.map(item => item))",
        .helper_borrows = true,
        .helper_body = "  return view(in)",
        .ownership = "borrowed",
    });
}

test "borrowed output from owned helper cannot be consumed" {
    try h.run(.{
        .body = "  const result = consume(in.map(item => item))\n\n  return result.reverse()[0]",
        .helper_borrows = true,
        .helper_body = "  return view(in)",
        .marker = "result.reverse()",
    });
}
