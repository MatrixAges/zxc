const std = @import("std");
const ir = @import("zx").ir;
const Origins = @import("nominal_data");
const Writer = @import("merge_writer_view");
pub const Error = std.mem.Allocator.Error || error{ MissingNominalOrigin, ConflictingNominalType };

pub fn append(writer: *Writer, first: usize) Error!void {
    const generated = @import("generated_type_merge");
    const Input = @typeInfo(generated.Input).pointer.child;
    const Table = @typeInfo(@FieldType(Input, "source")).pointer.child;
    const Bindings = @typeInfo(@FieldType(Input, "origins")).pointer.child;
    const table = ir.TypeTable.borrow(Table, writer.source);
    const bindings = Origins.Table.borrow(Bindings, writer.origins);
    const input: Input = .{ .source = &table, .origins = &bindings, .first = first, .writer = @ptrCast(writer), .buffer = @ptrCast(&writer.references) };
    var storage: [0]u8 = undefined;
    var fixed = std.heap.FixedBufferAllocator.init(&storage);
    var arena = std.heap.ArenaAllocator.init(fixed.allocator());

    defer arena.deinit();

    const result = generated.execute(&arena, &input) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => unreachable,
    };

    return switch (result) {
        0 => {},
        1 => error.MissingNominalOrigin,
        2 => error.ConflictingNominalType,
        else => unreachable,
    };
}
