const std = @import("std");
const Analysis = @import("../../analysis/analyze.zig");
const Record = @import("../module_record.zig");
const Model = @import("model.zig");

/// The caller has validated this exact project IR, including its function and type tables.
pub fn validated(allocator: std.mem.Allocator, scratch: std.mem.Allocator, analysis: *const Analysis.Result, record: Record) Model.Error!Model.Result {
    const constants = @import("../../analysis/constants/check.zig");
    const types = analysis.value.ir.types;

    if (!try constants.validate(allocator, types, record.constant_exports)) return error.InvalidModule;
    if (!try constants.validate(allocator, types, record.constant_imports)) return error.InvalidModule;

    var arena = std.heap.ArenaAllocator.init(allocator);

    errdefer arena.deinit();

    if (comptime @import("parser_options").generated_parser) {
        const value = try @import("prepared/root.zig").extract(arena.allocator(), scratch, analysis, record);

        return .{ .arena = arena, .value = value };
    }

    var builder = try @import("build.zig").init(arena.allocator(), scratch, analysis);
    const value = try builder.extract(record);

    return .{ .arena = arena, .value = value };
}
