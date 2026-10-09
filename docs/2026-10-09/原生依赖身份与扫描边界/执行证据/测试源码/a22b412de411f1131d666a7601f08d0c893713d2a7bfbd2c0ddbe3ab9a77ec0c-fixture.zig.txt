const std = @import("std");
pub const compiler = @import("compiler");
pub const ir = compiler.ir;
pub const artifact = compiler.project.artifact;
const OriginManager = @FieldType(artifact.type_link.Table, "origins");
pub const Origins = OriginManager.Table;
pub const Mutation = enum { none, missing_node, duplicate_node, wrong_node_name, missing_noise };

pub fn analyze(allocator: std.mem.Allocator) !compiler.AnalysisResult {
    var result = try compiler.project.analyze(allocator, &.{
        .{ .path = "main.zx", .source = @embedFile("main.zx") },
        .{ .path = "types.zx", .source = @embedFile("types.zx") },
        .{ .path = "noise.zx", .source = @embedFile("noise.zx") },
    }, .{ .entry = "main.zx", .root_dir = "/project", .native_interfaces = &.{.{ .specifier = "zig:host", .path = "host.d.zx", .source = @embedFile("host.d.zx"), .module = "host", .identity = "fixture@1", .namespace = &.{ "owned", "api" } }} });

    errdefer result.deinit();

    if (result.value == .diagnostic) std.debug.print("mixed extraction diagnostic: {s}\n", .{result.value.diagnostic.message});
    try std.testing.expect(result.value == .ir);
    try std.testing.expectEqual(null, try compiler.validateIr(allocator, result.value.ir));
    try std.testing.expectEqual(@as(usize, 3), result.modules.len);

    return result;
}

pub fn moduleIndex(analysis: compiler.AnalysisResult, path: []const u8) !usize {
    for (analysis.modules, 0..) |record, index| {
        if (std.mem.eql(u8, record.path, path)) return index;
    }

    return error.MissingFixtureModule;
}

pub fn nominalId(analysis: compiler.AnalysisResult, name: []const u8) !ir.TypeId {
    for (0..analysis.nominal_types.count()) |index| {
        const item = analysis.nominal_types.at(index);

        if (std.mem.eql(u8, item.name, name)) return item.type_id;
    }

    return error.MissingFixtureNominal;
}

pub fn mutate(analysis: *compiler.AnalysisResult, mutation: Mutation) !void {
    if (mutation == .none) return;

    var result: OriginManager.Storage = .{};
    const memory = analysis.arena.allocator();

    for (0..analysis.nominal_types.count()) |index| {
        var item = analysis.nominal_types.at(index);
        const node = std.mem.eql(u8, item.name, "Node");

        if (mutation == .missing_node and node) continue;
        if (mutation == .missing_noise and std.mem.eql(u8, item.name, "Noise")) continue;
        if (mutation == .wrong_node_name and node) item.name = "OtherNode";
        try result.append(memory, item);
        if (mutation == .duplicate_node and node) try result.append(memory, item);
    }

    analysis.nominal_types = result.view();

    try std.testing.expect(analysis.nominal_types.hasValidShape());
    try std.testing.expectEqual(null, try compiler.validateIr(std.testing.allocator, analysis.value.ir));
}

pub fn scalar(value: ir.Scalar) ir.TypeId {
    return @fromBackingInt(@intCast(@backingInt(value)));
}

pub fn copyColumns(memory: std.mem.Allocator, value: anytype) !@TypeOf(value) {
    var result: @TypeOf(value) = .{};

    inline for (@typeInfo(@TypeOf(value)).@"struct".field_names) |name| {
        const column = @field(value, name);
        const copied = try memory.dupe(@typeInfo(@TypeOf(column)).pointer.child, column);

        if (@typeInfo(@TypeOf(column)).pointer.child == []const u8) {
            for (column, copied) |text, *item| item.* = try memory.dupe(u8, text);
        }

        @field(result, name) = copied;
    }

    return result;
}

pub fn sameColumns(left: anytype, right: @TypeOf(left)) !void {
    inline for (@typeInfo(@TypeOf(left)).@"struct".field_names) |name| {
        const before = @field(left, name);
        const after = @field(right, name);

        try std.testing.expectEqual(before.len, after.len);

        if (@typeInfo(@TypeOf(before)).pointer.child == []const u8) {
            for (before, after) |a, b| try std.testing.expectEqualStrings(a, b);
        } else try std.testing.expectEqualSlices(@typeInfo(@TypeOf(before)).pointer.child, before, after);
    }
}
