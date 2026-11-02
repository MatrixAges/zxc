const std = @import("std");
const ir = @import("zx").ir;
const model = @import("../compiled.zig");
pub const Error = std.mem.Allocator.Error || error{InvalidLibrary};

pub fn validate(allocator: std.mem.Allocator, library: model.Graph) Error!void {
    if (comptime !@import("parser_options").generated_parser) return @import("seed_validate.zig").validate(allocator, library);
    try validateHeader(&library.program, library.exports.len);

    return @import("host/root.zig").validate(allocator, library);
}

pub fn validateHeader(program: *const ir.Program, public_count: usize) error{InvalidLibrary}!void {
    if (comptime !@import("parser_options").generated_parser) return @import("seed_validate.zig").validateHeader(program, public_count);

    return @import("host/header.zig").validate(program, public_count);
}
