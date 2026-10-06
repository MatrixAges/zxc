const std = @import("std");
const allocation_testing = @import("allocation_testing");
const h = @import("check.zig");

test "fresh mapped value passes to immutable helper" {
    try h.run(.{
        .body = "  return consume(in.map(item => item))",
    });
}

test "legacy owned Input syntax is rejected" {
    try h.run(.{
        .legacy_input = true,
        .body = "  return consume(in)",
    });
}

test "borrowed entry passes input without consumption" {
    try h.run(.{
        .body = "  return consume(in)",
    });
}

test "new results pass through repeated helper calls" {
    try h.run(.{
        .body = "  const values = in.map(item => item)\n  const next = consume(values)\n\n  return consume(next)",
    });
}

test "old binding remains usable after helper call" {
    try h.run(.{
        .body = "  const values = in.map(item => item)\n  const next = consume(values)\n\n  return values",
    });
}

test "second call can reuse old binding" {
    try h.run(.{
        .body = "  const values = in.map(item => item)\n  const next = consume(values)\n\n  return consume(values)",
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
        .ownership = "borrowed",
    });
}

test "aggregate containing borrowed list can produce new list" {
    try h.run(.{
        .body = "  return consume({items: in, count: 1})",
        .helper_input = "{items: u64[], count: u64}",
        .helper_body = "  const count = in.count\n\n  return in.items.push(count)[0]",
    });
}

test "aggregate containing new list can produce new list" {
    try h.run(.{
        .body = "  return consume({items: in.map(item => item), count: 1})",
        .helper_input = "{items: u64[], count: u64}",
        .helper_body = "  const count = in.count\n\n  return in.items.push(count)[0]",
    });
}

test "scalar input remains copyable" {
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

test "helper does not consume newly allocated argument" {
    try h.run(.{
        .body = "  const values = in.map(item => item)\n  const count = consume(values)\n\n  return values.push(count)[0]",
        .helper_output = "u64",
        .helper_body = "  return in.length",
    });
}

test "scalar-returning helper preserves reference argument" {
    try h.run(.{
        .body = "  const values = in.map(item => item)\n  const count = consume(values)\n\n  return values.push(count)[0]",
        .helper_output = "u64",
        .helper_body = "  return in.length",
    });
}

test "reduce passes accumulator through immutable helper calls" {
    try h.run(.{
        .body = "  const initial: u64[] = []\n\n  return in.reduce((items, item) => consume(items), initial)",
    });
}

test "reduce preserves borrowed initial accumulator" {
    try h.run(.{
        .body = "  return in.reduce((items, item) => consume(items), in)",
        .ownership = "borrowed",
    });
}

test "one branch calling helper preserves later reuse" {
    try h.run(.{
        .body = "  const values = in.map(item => item)\n  if (in.length > 0) {\n    const next = consume(values)\n  }\n\n  return values",
    });
}

test "immutable input can produce fresh mapped result" {
    try h.run(.{
        .body = "  return consume(in)",
        .helper_body = "  return in.map(item => item)",
    });
}

test "identity result can be reversed into a new list" {
    try h.run(.{
        .body = "  return consume(in).reverse()[0]",
        .helper_body = "  return in",
    });
}

test "immutable helper success releases allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, h.allocated, .{h.Case{
        .body = "  return consume(in.map(item => item))",
    }});
}

test "borrowed helper call releases allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, h.allocated, .{h.Case{
        .body = "  return consume(in)",
    }});
}

test "immutable call retains borrowed result provenance" {
    try h.run(.{
        .body = "  return consume(in.map(item => item))",
        .helper_borrows = true,
        .helper_body = "  return view(in)",
        .ownership = "borrowed",
    });
}

test "borrowed output can be reversed into a new list" {
    try h.run(.{
        .body = "  const result = consume(in.map(item => item))\n\n  return result.reverse()[0]",
        .helper_borrows = true,
        .helper_body = "  return view(in)",
    });
}
