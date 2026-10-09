const std = @import("std");
const f = @import("fixture.zig");
const check = @import("check.zig");
const mutation = @import("mutation.zig");

fn rejected(kind: mutation.Mutation) !void {
    for (f.orderings) |ordering| {
        var analysis = try f.analyze(std.testing.allocator, ordering, true);

        defer analysis.deinit();

        const index = try f.entry(analysis);
        var control = try f.artifact.extract(std.testing.allocator, &analysis, index);

        defer control.deinit();

        try check.module(analysis, index, control.value);
        try mutation.apply(&analysis, index, kind);
        try std.testing.expectError(error.InvalidModule, f.artifact.extract(std.testing.allocator, &analysis, index));
    }
}

test "artifact extraction rejects a function import outside the global function table" {
    try rejected(.id);
}

test "artifact extraction rejects an import input that differs from its real signature" {
    try rejected(.input);
}

test "artifact extraction rejects an import output that differs from its real signature" {
    try rejected(.output);
}

test "artifact extraction rejects an imported input outside the global type table" {
    try rejected(.input_range);
}

test "artifact extraction rejects an imported output outside the global type table" {
    try rejected(.output_range);
}

test "a previously included function still validates a later alias input" {
    try rejected(.alias_input);
}

test "a previously included function still validates a later alias output" {
    try rejected(.alias_output);
}
