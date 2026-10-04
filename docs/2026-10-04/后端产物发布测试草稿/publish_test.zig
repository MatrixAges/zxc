const std = @import("std");
const Fixture = @import("fixture.zig");
const io = std.testing.io;

test "backend stable inputs publish both artifacts" {
    var fixture = try Fixture.init();
    defer fixture.deinit();

    try std.testing.expect(try fixture.publish());
    try fixture.expectOutputs("new-bin", "new-asm");
}

test "backend changed input preserves both previous artifacts" {
    var fixture = try Fixture.init();
    defer fixture.deinit();
    try fixture.temporary.dir.writeFile(io, .{ .sub_path = "input", .data = "mutated" });

    try std.testing.expect(!try fixture.publish());
    try fixture.expectOutputs("old-bin", "old-asm");
}

test "backend removed input preserves both previous artifacts" {
    var fixture = try Fixture.init();
    defer fixture.deinit();
    try fixture.temporary.dir.deleteFile(io, "input");

    try std.testing.expect(!try fixture.publish());
    try fixture.expectOutputs("old-bin", "old-asm");
}

test "backend new dependencies prevent first publication" {
    var fixture = try Fixture.init();
    defer fixture.deinit();
    fixture.result.new_inputs = true;

    try std.testing.expect(!try fixture.publish());
    try fixture.expectOutputs("old-bin", "old-asm");
}

test "backend incomplete input report prevents publication" {
    var fixture = try Fixture.init();
    defer fixture.deinit();
    fixture.result.response.inputs_complete = false;

    try std.testing.expect(!try fixture.publish());
    try fixture.expectOutputs("old-bin", "old-asm");
}

test "backend unsuccessful response prevents publication" {
    var fixture = try Fixture.init();
    defer fixture.deinit();
    fixture.result.response.succeeded = false;

    try std.testing.expect(!try fixture.publish());
    try fixture.expectOutputs("old-bin", "old-asm");
}

test "backend input overlap rejects either output before copying" {
    for ([_]bool{ false, true }) |assembly| {
        var fixture = try Fixture.init();
        defer fixture.deinit();
        if (assembly) fixture.options.assembly = fixture.options.input else fixture.options.output = fixture.options.input;

        try std.testing.expectError(error.OutputOverlapsInput, fixture.publish());
        try fixture.expectOutputs("old-bin", "old-asm");
        const source = try fixture.temporary.dir.readFileAlloc(io, "input", std.testing.allocator, .limited(1024));
        defer std.testing.allocator.free(source);
        try std.testing.expectEqualStrings("source", source);
    }
}

test "backend conflicting output paths preserve previous artifacts" {
    var fixture = try Fixture.init();
    defer fixture.deinit();
    fixture.options.assembly = fixture.options.output;

    try std.testing.expectError(error.ConflictingOutputPaths, fixture.publish());
    try fixture.expectOutputs("old-bin", "old-asm");
}
