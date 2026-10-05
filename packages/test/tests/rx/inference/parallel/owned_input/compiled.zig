const std = @import("std");
const compiler = @import("compiler");
const h = @import("../check.zig");

const fresh = h.Case{
    .source = "<Module><Call fn='list' in={$in} out='items'/><Call module='owned/consume' in={items} out='next'/><Return value={next.length}/></Module>",
};

fn allocated(allocator: std.mem.Allocator, case: h.Case) !void {
    var analysis = try compiler.project.analyze(allocator, &.{.{ .path = "consume.zx", .source = @embedFile("consume.zx") }}, .{ .entry = "consume.zx", .root_dir = "/library" });

    defer analysis.deinit();

    try std.testing.expect(analysis.value == .ir);

    var library = try compiler.library.link(allocator, &.{.{ .name = "consume", .analysis = &analysis }});

    defer library.deinit();

    const bytes = try compiler.library.codec.encode(allocator, &library);

    defer allocator.free(bytes);

    var decoded = try compiler.library.codec.decode(allocator, bytes);

    defer decoded.deinit();

    var configured = case;
    configured.packages = &.{.{ .specifier = "owned/consume", .compiled = .{ .instance = "owned@1", .artifact = "owned.zxlib", .name = "consume" } }};
    configured.compiled_libraries = &.{.{ .instance = "owned@1", .artifact = "owned.zxlib", .program = decoded.program, .exports = decoded.exports, .nominal_types = decoded.nominal_types }};

    try h.allocated(allocator, configured);
}

test "RX compiled owned ZX export accepts fresh owned value" {
    try allocated(std.testing.allocator, fresh);
}

test "RX compiled owned ZX export rejects borrowed module input" {
    try allocated(std.testing.allocator, .{
        .source = "<Module><Call module='owned/consume' in={$in} out='next'/><Return value={next.length}/></Module>",
        .expected = .{ .code = "ownership", .marker = "$in" },
    });
}

test "RX compiled owned ZX export invalidates old binding" {
    try allocated(std.testing.allocator, .{
        .source = "<Module><Call fn='list' in={$in} out='items'/><Call module='owned/consume' in={items} out='next'/><Return value={items.length}/></Module>",
        .expected = .{ .code = "ownership", .marker = "items.length" },
    });
}

test "RX compiled owned ZX export rejects duplicate parallel transfer" {
    try allocated(std.testing.allocator, .{
        .source = "<Module><Call fn='list' in={$in} out='items'/><Parallel><Call module='owned/consume' in={items} out='left'/><Call module='owned/consume' in={items} out='right'/></Parallel><Return value={left.length + right.length}/></Module>",
        .expected = .{ .code = "ownership", .marker = "items", .last = true },
    });
}

test "RX compiled owned ZX transfer releases library and inference allocation failures" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, allocated, .{fresh});
}
