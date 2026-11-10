const std = @import("std");
const zx = @import("zx");
const Basis = @import("../basis.zig");
const generated = @import("generated_uniqueness_program_identity");
const Input = std.meta.Child(generated.Input);

pub fn build(value: zx.ir.Program, basis: *const Basis) [32]u8 {
    var hash: zx.Sha256 = undefined;
    const hash_state = zx.Sha256State{ .value = &hash };

    const input: Input = .{
        .hash = @ptrCast(&hash_state),
        .types = &basis.types,
        .input_types = @ptrCast(value.functions.input_types),
        .output_types = @ptrCast(value.functions.output_types),
        .native_modules = value.functions.native_modules,
        .held = @ptrCast(basis.flow.held),
        .written = @ptrCast(basis.flow.written),
        .return_only = std.mem.sliceAsBytes(basis.return_only),
    };

    var memory = std.heap.FixedBufferAllocator.init(&.{});

    generated.executeIn(memory.allocator(), &input) catch |err| std.debug.panic("program identity failed: {s}", .{@errorName(err)});

    return hash.finalResult();
}
