const std = @import("std");
const Analysis = @import("../analysis/analyze.zig");
const Builder = @import("artifact/build.zig");
const model = @import("artifact/model.zig");
pub const Result = model.Result;
pub const Module = model.Module;
pub const Error = model.Error;
pub const type_link = @import("type_link.zig");
pub const program_link = @import("link/program.zig");
pub const function_table = @import("link/function_table.zig");
pub const source_link = @import("link/source.zig");
pub const native_link = @import("link/native.zig");
pub const linker = @import("link.zig");

pub fn extract(allocator: std.mem.Allocator, analysis: *const Analysis.Result, module_index: usize) Error!Result {
    if (analysis.value != .ir) return error.InvalidAnalysis;
    if (module_index >= analysis.modules.len) return error.InvalidModule;
    if (try @import("../ir/validate.zig").validate(allocator, analysis.value.ir) != null) return error.InvalidIr;

    var arena = std.heap.ArenaAllocator.init(allocator);

    errdefer arena.deinit();

    var temporary = std.heap.ArenaAllocator.init(allocator);

    defer temporary.deinit();

    if (comptime @import("parser_options").generated_parser) {
        const value = try @import("artifact/prepared/root.zig").extract(&arena, &temporary, analysis, analysis.modules[module_index]);

        return .{ .arena = arena, .value = value };
    }

    var builder = try Builder.init(arena.allocator(), temporary.allocator(), analysis);
    const value = try builder.extract(analysis.modules[module_index]);

    return .{ .arena = arena, .value = value };
}
