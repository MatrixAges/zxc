const std = @import("std");
const f = @import("fixture.zig");
const compiler = f.compiler;
const borrowed_call = "import consume from \"owned\"\nexport type Input = u64[]\nexport type Output = u64[]\nexport default function (in: Input): Output { return consume(in) }\n";
const owned_call = "import consume from \"owned\"\nexport type Input = u64[]\nexport type Output = u64[]\nexport default function (in: owned Input): Output { return consume(in) }\n";

fn checkConsumer(library: *const compiler.library.Result, source: []const u8, accepted: bool) !void {
    var result = try f.consumer(std.testing.allocator, library, source);

    defer result.deinit();

    if (accepted) {
        try std.testing.expect(result.value == .ir);
        try std.testing.expectEqual(.owned, result.value.ir.output_ownership);
        try std.testing.expect(try compiler.validateIr(std.testing.allocator, result.value.ir) == null);
    } else {
        try std.testing.expect(result.value == .diagnostic);
        try std.testing.expectEqual(.ownership, result.value.diagnostic.code);
        try std.testing.expectEqual(@as(?usize, 0), result.value.diagnostic.source_index);
        try std.testing.expectEqual(std.mem.indexOf(u8, source, "consume(in)").?, result.value.diagnostic.span.start);
    }
}

test "encoded library restores owned export after original storage release" {
    var restored = try f.restored(std.testing.allocator);

    defer restored.deinit();

    const module = try restored.module(0);

    try std.testing.expect(module.consumes_input);
    try std.testing.expectEqual(.owned, module.output_ownership);
    try std.testing.expect(try compiler.validateIr(std.testing.allocator, module) == null);
}

test "compiled owned export accepts transferred caller input" {
    var restored = try f.restored(std.testing.allocator);

    defer restored.deinit();

    try checkConsumer(&restored, owned_call, true);
}

test "compiled owned export rejects borrowed caller input" {
    var restored = try f.restored(std.testing.allocator);

    defer restored.deinit();

    try checkConsumer(&restored, borrowed_call, false);
}

test "compiled owned export accepts fresh scalar map" {
    var restored = try f.restored(std.testing.allocator);

    defer restored.deinit();

    try checkConsumer(&restored, "import consume from \"owned\"\nexport type Input = u64[]\nexport type Output = u64[]\nexport default function (in: Input): Output { return consume(in.map(item => item)) }\n", true);
}

fn republished(allocator: std.mem.Allocator) !compiler.library.Result {
    var restored = try f.restored(allocator);

    defer restored.deinit();

    var analysis = try f.consumer(allocator, &restored, owned_call);

    defer analysis.deinit();

    if (analysis.value != .ir) return error.UnexpectedDiagnostic;

    var published = try compiler.library.link(allocator, &.{.{ .name = "consume", .analysis = &analysis }});

    defer published.deinit();

    const bytes = try compiler.library.codec.encode(allocator, &published);

    defer allocator.free(bytes);

    return compiler.library.codec.decode(allocator, bytes);
}

test "republished owned wrapper retains public and nested consumption flags" {
    var restored = try republished(std.testing.allocator);

    defer restored.deinit();

    const module = try restored.module(0);

    try std.testing.expect(module.consumes_input);
    try std.testing.expect(module.functions.len >= 2);
    for (module.functions) |function| try std.testing.expect(function.consumes_input);
    try checkConsumer(&restored, owned_call, true);
}

test "republished owned wrapper still rejects borrowing" {
    var restored = try republished(std.testing.allocator);

    defer restored.deinit();

    try checkConsumer(&restored, borrowed_call, false);
}

test "forged borrowed flag cannot hide consuming body" {
    var restored = try f.restored(std.testing.allocator);

    defer restored.deinit();

    var program = try restored.module(0);

    program.consumes_input = false;

    const issue = (try compiler.validateIr(std.testing.allocator, program)).?;

    try std.testing.expectEqual(.contract, issue.code);
}

fn restoreAllocated(allocator: std.mem.Allocator, publish_again: bool) !void {
    var restored = if (publish_again) try republished(allocator) else try f.restored(allocator);

    defer restored.deinit();

    try std.testing.expect((try restored.module(0)).consumes_input);
}

test "library encode restore chain cleans allocation failures" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, restoreAllocated, .{false});
}

test "library republish chain cleans allocation failures" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, restoreAllocated, .{true});
}
