const std = @import("std");
const ir = @import("zx").ir;
const generated = @import("generated_compiled_header");

pub fn validate(program: *const ir.Program, public_count: usize) error{InvalidLibrary}!void {
    const Input = @typeInfo(generated.Input).pointer.child;

    const input: Input = .{
        .type_only = program.type_only,
        .export_count = program.exports.len,
        .constant_exports = program.constant_exports.len != 0,
        .store_count = program.stores.count(),
        .public_count = public_count,
    };

    var storage: [0]u8 = undefined;
    var fixed = std.heap.FixedBufferAllocator.init(&storage);

    if (!(generated.executeIn(fixed.allocator(), &input) catch unreachable)) return error.InvalidLibrary;
}
