const std = @import("std");
const allocation_testing = @import("allocation_testing");
const compiler = @import("compiler");
const h = @import("../check.zig");

const fresh = h.Case{
    .source = "<Module><Call fn='list' in={$in}/><Call module='owned/consume' in={$ctx.list}/><Return value={$ctx.consume.length}/></Module>",
};

fn allocated(allocator: std.mem.Allocator, case: h.Case) !void {
    var analysis = try compiler.project.analyze(allocator, &.{.{ .path = "consume.zx", .source = @embedFile("consume.zx") }}, .{ .entry = "consume.zx", .root_dir = "/library" });

    defer analysis.deinit();

    try std.testing.expect(analysis.value == .ir);

    var library = try compiler.library.link(allocator, &.{
        .{ .name = "consume", .analysis = &analysis },
        .{ .name = "consume_left", .analysis = &analysis },
        .{ .name = "consume_right", .analysis = &analysis },
    });

    defer library.deinit();

    const bytes = try compiler.library.codec.encode(allocator, &library);

    defer allocator.free(bytes);

    var decoded = try compiler.library.codec.decode(allocator, bytes);

    defer decoded.deinit();

    var configured = case;

    configured.packages = &.{
        .{ .specifier = "owned/consume", .compiled = .{ .instance = "owned@1", .artifact = "owned.zxlib", .name = "consume" } },
        .{ .specifier = "owned/consume_left", .compiled = .{ .instance = "owned@1", .artifact = "owned.zxlib", .name = "consume_left" } },
        .{ .specifier = "owned/consume_right", .compiled = .{ .instance = "owned@1", .artifact = "owned.zxlib", .name = "consume_right" } },
    };

    configured.compiled_libraries = &.{.{ .instance = "owned@1", .artifact = "owned.zxlib", .program = decoded.program, .exports = decoded.exports, .nominal_types = decoded.nominal_types }};

    try h.allocated(allocator, configured);
}

test "RX compiled owned ZX export accepts fresh owned value" {
    try allocated(std.testing.allocator, fresh);
}

test "RX compiled owned ZX export accepts borrowed module input" {
    try allocated(std.testing.allocator, .{
        .source = "<Module><Call module='owned/consume' in={$in}/><Return value={$ctx.consume.length}/></Module>",
    });
}

test "RX compiled owned ZX export invalidates old binding" {
    try allocated(std.testing.allocator, .{
        .source = "<Module><Call fn='list' in={$in}/><Call module='owned/consume' in={$ctx.list}/><Return value={$ctx.list.length}/></Module>",
    });
}

test "RX compiled owned ZX export accepts shared parallel transfer" {
    try allocated(std.testing.allocator, .{
        .source = "<Module><Call fn='list' in={$in}/><Parallel><Call module='owned/consume_left' in={$ctx.list}/><Call module='owned/consume_right' in={$ctx.list}/></Parallel><Return value={$ctx.consume_left.length + $ctx.consume_right.length}/></Module>",
    });
}

test "RX compiled owned ZX transfer releases library and inference allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, allocated, .{fresh});
}
