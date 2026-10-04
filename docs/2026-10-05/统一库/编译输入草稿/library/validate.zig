const std = @import("std");
const compiled = @import("frontend").project.compiled;
const model = @import("root.zig");
pub const Error = std.mem.Allocator.Error || error{InvalidLibrary};

pub fn validate(allocator: std.mem.Allocator, library: *const model.Result) Error!void {
    return compiled.validate(allocator, .{ .program = library.program, .exports = library.exports, .nominal_types = library.nominal_types });
}
