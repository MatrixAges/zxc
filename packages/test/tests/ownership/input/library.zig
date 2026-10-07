const std = @import("std");
const allocation_testing = @import("allocation_testing");
const f = @import("fixture.zig");
const compiler = f.compiler;
const borrowed_call = "import consume from \"owned\"\nexport type Input = u64[]\nexport type Output = u64[]\nexport default function (in: Input): Output { return consume(in) }\n";
const legacy_call = "import consume from \"owned\"\nexport type Input = u64[]\nexport type Output = u64[]\nexport default function (in: owned Input): Output { return consume(in) }\n";

fn checkConsumer(library: *const compiler.library.Result, source: []const u8, accepted: bool) !void {
    var result = try f.consumer(std.testing.allocator, library, source);

    defer result.deinit();

    if (accepted) {
        try std.testing.expect(result.value == .ir);
        try std.testing.expectEqual(.owned, result.value.ir.output_ownership);
        try std.testing.expect(try compiler.validateIr(std.testing.allocator, result.value.ir) == null);
    } else {
        try std.testing.expect(result.value == .diagnostic);
        try std.testing.expectEqual(.syntax, result.value.diagnostic.code);
        try std.testing.expectEqual(@as(?usize, 0), result.value.diagnostic.source_index);
        try std.testing.expectEqual(std.mem.indexOf(u8, source, "owned Input").?, result.value.diagnostic.span.start);
    }
}

test "encoded library restores immutable export after original storage release" {
    var restored = try f.restored(std.testing.allocator);

    defer restored.deinit();

    const module = try restored.module(0);

    try std.testing.expectEqual(.owned, module.output_ownership);
    try std.testing.expect(try compiler.validateIr(std.testing.allocator, module) == null);
}

test "compiled export accepts borrowed caller input" {
    var restored = try f.restored(std.testing.allocator);

    defer restored.deinit();

    try checkConsumer(&restored, borrowed_call, true);
}

test "compiled export rejects legacy owned syntax" {
    var restored = try f.restored(std.testing.allocator);

    defer restored.deinit();

    try checkConsumer(&restored, legacy_call, false);
}

test "compiled export accepts fresh scalar map" {
    var restored = try f.restored(std.testing.allocator);

    defer restored.deinit();

    try checkConsumer(&restored, "import consume from \"owned\"\nexport type Input = u64[]\nexport type Output = u64[]\nexport default function (in: Input): Output { return consume(in.map(item => item)) }\n", true);
}

fn republished(allocator: std.mem.Allocator) !compiler.library.Result {
    var restored = try f.restored(allocator);

    defer restored.deinit();

    var analysis = try f.consumer(allocator, &restored, borrowed_call);

    defer analysis.deinit();

    if (analysis.value != .ir) return error.UnexpectedDiagnostic;

    var published = try compiler.library.link(allocator, &.{.{ .name = "consume", .analysis = &analysis }});

    defer published.deinit();

    const bytes = try compiler.library.codec.encode(allocator, &published);

    defer allocator.free(bytes);

    return compiler.library.codec.decode(allocator, bytes);
}

test "republished immutable wrapper retains nested functions" {
    var restored = try republished(std.testing.allocator);

    defer restored.deinit();

    const module = try restored.module(0);

    try std.testing.expect(module.functions.count() >= 2);
    try checkConsumer(&restored, borrowed_call, true);
}

test "republished wrapper rejects legacy owned syntax" {
    var restored = try republished(std.testing.allocator);

    defer restored.deinit();

    try checkConsumer(&restored, legacy_call, false);
}

test "old IR version cannot enter immutable input execution" {
    var restored = try f.restored(std.testing.allocator);

    defer restored.deinit();

    var program = try restored.module(0);

    program.version -= 1;
    const issue = (try compiler.validateIr(std.testing.allocator, program)).?;

    try std.testing.expectEqual(.contract, issue.code);
}

fn restoreAllocated(allocator: std.mem.Allocator, publish_again: bool) !void {
    var restored = if (publish_again) try republished(allocator) else try f.restored(allocator);

    defer restored.deinit();

    try std.testing.expect(try compiler.validateIr(allocator, try restored.module(0)) == null);
}

test "library encode restore chain cleans allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, restoreAllocated, .{false});
}

test "library republish chain cleans allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, restoreAllocated, .{true});
}
