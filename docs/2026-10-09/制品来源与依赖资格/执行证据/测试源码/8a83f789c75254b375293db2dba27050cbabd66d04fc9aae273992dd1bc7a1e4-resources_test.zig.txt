const std = @import("std");
const f = @import("fixture.zig");
const graph = @import("graph.zig");
const Scenario = enum { scalar, chain, mixed, unknown };

fn execute(types: *f.Types, scenario: Scenario) !void {
    if (scenario == .mixed) try types.initialize() else _ = try types.named(f.name("Alias0", 9000));
}

fn check(types: f.Types, scenario: Scenario, memory: std.mem.Allocator) !void {
    try f.heldUnchanged(types, 3);
    try f.prefix(types);
    if (scenario != .scalar) try std.testing.expectEqual(f.scalar(.bool), types.resolved.get("Cached").?);

    if (scenario == .mixed) {
        const exports = try memory.alloc(f.ir.Export, types.declarations.len);

        for (types.declarations, exports) |item, *exported| exported.* = .{ .name = item.name.text, .type_id = types.resolved.get(item.name.text).? };
        try graph.declarations(types.items.view(), exports);
    } else if (scenario != .unknown) {
        try std.testing.expectEqual(f.scalar(.u64), types.resolved.get("Alias0").?);
    }
}

fn attempt(scenario: Scenario, fail_index: usize) !usize {
    var input = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer input.deinit();

    var owner = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer owner.deinit();

    var parsed = try f.frontend.parse(std.testing.allocator, @embedFile("graph.zx"), "types.zx");

    defer parsed.deinit();

    try std.testing.expect(parsed.value == .parsed);

    const declarations = switch (scenario) {
        .mixed => parsed.value.parsed.ast.declarations,
        .scalar => try f.chain(input.allocator(), 1, "u64"),
        .chain => try f.chain(input.allocator(), 32, "u64"),
        .unknown => try f.chain(input.allocator(), 12, "Missing"),
    };

    const memory = owner.allocator();
    var reporter: f.zx.Reporter = .{};
    var types = try f.base(memory, &reporter, declarations);

    try f.held(&types, 3);
    if (scenario != .scalar) try types.resolved.put(memory, "Cached", f.scalar(.bool));

    var vtable = memory.vtable.*;
    vtable.resize = std.mem.Allocator.noResize;
    vtable.remap = std.mem.Allocator.noRemap;
    const backing = std.mem.Allocator{ .ptr = memory.ptr, .vtable = &vtable };
    var failure = std.testing.FailingAllocator.init(backing, .{ .fail_index = fail_index });
    types.allocator = failure.allocator();

    var failed = false;

    execute(&types, scenario) catch |err| {
        failed = true;

        try f.heldUnchanged(types, 3);
        if (scenario != .scalar) try std.testing.expectEqual(f.scalar(.bool), types.resolved.get("Cached").?);

        if (failure.has_induced_failure) {
            try std.testing.expectEqual(error.OutOfMemory, err);
            try std.testing.expectEqual(null, reporter.diagnostic);
            try f.prefix(types);
        } else {
            try std.testing.expectEqual(Scenario.unknown, scenario);
            try std.testing.expectEqual(error.InvalidSource, err);
            try f.diagnostic(reporter, .name, "unknown or unsupported type", declarations[declarations.len - 1].value.named.span);
        }
    };

    try std.testing.expectEqual(fail_index != std.math.maxInt(usize), failure.has_induced_failure);

    if (failure.has_induced_failure or scenario == .unknown) try std.testing.expect(failed) else try std.testing.expect(!failed);

    const allocation_count = failure.alloc_index;
    types.allocator = memory;
    reporter.diagnostic = null;

    if (scenario == .unknown) {
        try std.testing.expectError(error.InvalidSource, execute(&types, scenario));
        try f.diagnostic(reporter, .name, "unknown or unsupported type", declarations[declarations.len - 1].value.named.span);
        try f.heldUnchanged(types, 3);
        try std.testing.expectEqual(f.scalar(.bool), types.resolved.get("Cached").?);
    } else {
        try execute(&types, scenario);
        try check(types, scenario, input.allocator());
    }

    return allocation_count;
}

fn sweep(scenario: Scenario) !void {
    const count = try attempt(scenario, std.math.maxInt(usize));

    try std.testing.expect(count > 0);
    for (0..count) |index| _ = try attempt(scenario, index);
}

test "last scalar alias cache allocation failure removes only its own visiting marker" {
    const count = try attempt(.scalar, std.math.maxInt(usize));

    try std.testing.expect(count >= 2);

    _ = try attempt(.scalar, count - 1);
}

test "scalar named resolution sweeps each API allocation and retries after OOM" {
    try sweep(.scalar);
}

test "deep alias resolution sweeps frame map and cache allocations preserving existing state" {
    try sweep(.chain);
}

test "mixed declaration initialization sweeps every API allocation and retries after OOM" {
    try sweep(.mixed);
}

test "unknown alias rejection sweeps every preceding allocation and preserves exact retry diagnostic" {
    try sweep(.unknown);
}
