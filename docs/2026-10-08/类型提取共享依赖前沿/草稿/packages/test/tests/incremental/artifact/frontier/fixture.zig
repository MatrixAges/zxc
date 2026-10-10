const std = @import("std");
pub const compiler = @import("compiler");
pub const ir = compiler.ir;
pub const artifact = compiler.project.artifact;
pub const Origins = @FieldType(compiler.AnalysisResult, "nominal_types");
pub const Case = @import("source.zig").Case;

pub fn analyze(memory: std.mem.Allocator, args: Case) !compiler.AnalysisResult {
    var result = try compiler.project.analyze(memory, try @import("source.zig").create(memory, args), .{ .entry = "main.zx", .root_dir = "/project" });

    errdefer result.deinit();

    if (result.value == .diagnostic) std.debug.print("frontier {d}/{d}: {t}: {s}\n", .{ args.depth, args.width, result.value.diagnostic.code, result.value.diagnostic.message });
    try std.testing.expect(result.value == .ir);
    try std.testing.expectEqual(null, try compiler.validateIr(memory, result.value.ir));

    return result;
}

pub fn entry(analysis: compiler.AnalysisResult) !usize {
    for (analysis.modules, 0..) |record, index| {
        if (std.mem.eql(u8, record.path, "/project/main.zx")) return index;
    }

    return error.MissingEntry;
}

pub fn ownedColumns(memory: std.mem.Allocator, value: anytype) !@TypeOf(value) {
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

pub fn ownedExports(memory: std.mem.Allocator, source: []const ir.Export) ![]const ir.Export {
    const result = try memory.dupe(ir.Export, source);

    for (result) |*item| item.name = try memory.dupe(u8, item.name);

    return result;
}

pub fn sameColumns(left: anytype, right: @TypeOf(left)) !void {
    inline for (@typeInfo(@TypeOf(left)).@"struct".field_names) |name| {
        const a = @field(left, name);
        const b = @field(right, name);

        try std.testing.expectEqual(a.len, b.len);

        if (@typeInfo(@TypeOf(a)).pointer.child == []const u8) {
            for (a, b) |x, y| try std.testing.expectEqualStrings(x, y);
        } else try std.testing.expectEqualSlices(@typeInfo(@TypeOf(a)).pointer.child, a, b);
    }
}
