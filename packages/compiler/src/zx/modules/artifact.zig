const std = @import("std");
const Analysis = @import("../analysis/analyze.zig");
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

    var scratch = @import("zx").Arena.init(allocator);

    defer scratch.deinit();

    return @import("artifact/extract.zig").validated(allocator, scratch.allocator(), analysis, analysis.modules[module_index]);
}
