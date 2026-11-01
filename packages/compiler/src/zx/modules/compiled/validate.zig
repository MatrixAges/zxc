const std = @import("std");
const model = @import("../compiled.zig");
pub const Error = std.mem.Allocator.Error || error{InvalidLibrary};

pub fn validate(allocator: std.mem.Allocator, library: model.Graph) Error!void {
    try checkConstants(library.program, library.exports);
    if (comptime !@import("parser_options").generated_parser) return @import("seed_validate.zig").validate(allocator, library);

    return @import("host/root.zig").validate(allocator, library);
}

pub fn checkConstants(program: @import("zx").ir.Program, exports: []const model.Export) error{InvalidLibrary}!void {
    if (program.constant_exports.len != 0) return error.InvalidLibrary;
    for (exports) |exported| if (exported.constants.len != 0) return error.InvalidLibrary;
}
