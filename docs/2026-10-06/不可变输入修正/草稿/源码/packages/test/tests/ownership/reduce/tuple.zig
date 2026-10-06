const std = @import("std");
const allocation_testing = @import("allocation_testing");
const h = @import("check.zig");

test "static tuple index heterogeneous first member" {
    try h.run(.{
        .input = "[u64, string, bool]",
        .output = "u64",
        .body = "  return in[0]",
        .ownership = "copy",
    });
}

test "static tuple index heterogeneous string member" {
    try h.run(.{
        .input = "[u64, string, bool]",
        .output = "string",
        .body = "  return in[1]",
        .ownership = "borrowed",
    });
}

test "static tuple index heterogeneous final member" {
    try h.run(.{
        .input = "[u64, string, bool]",
        .output = "bool",
        .body = "  return in[2]",
        .ownership = "copy",
    });
}

test "static tuple index nested tuple member" {
    try h.run(.{
        .input = "[[u64, string], bool]",
        .output = "string",
        .body = "  return in[0][1]",
        .ownership = "borrowed",
    });
}

test "static tuple index out of bounds" {
    try h.run(.{
        .input = "[u64, bool]",
        .output = "u64",
        .body = "  return in[2]",
        .ownership = "copy",
        .marker = "2",
        .code = "type_mismatch",
    });
}

test "static tuple index runtime index" {
    try h.run(.{
        .input = "{ pair: [u64, bool], index: u64 }",
        .output = "u64",
        .body = "  return in.pair[in.index]",
        .ownership = "copy",
        .marker = "in.index",
        .code = "type_mismatch",
    });
}

test "static tuple index arithmetic index is not literal" {
    try h.run(.{
        .input = "[u64, bool]",
        .output = "u64",
        .body = "  return in[0 + 0]",
        .ownership = "copy",
        .marker = "0 + 0",
        .code = "type_mismatch",
    });
}

test "static tuple index tuple list member produces reversed copy" {
    try h.run(.{
        .input = "[u64[], bool]",
        .output = "u64[]",
        .body = "  return in[0].reverse()[0]",
    });
}

test "static tuple index out of bounds cleans allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, h.allocated, .{h.Case{
        .input = "[u64, bool]",
        .output = "u64",
        .body = "  return in[2]",
        .code = "type_mismatch",
        .marker = "2",
    }});
}
