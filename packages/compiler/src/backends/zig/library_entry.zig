const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Library = @import("../../library/root.zig").Result;

pub fn create(allocator: std.mem.Allocator, library: *const Library, index: usize) (std.mem.Allocator.Error || error{InvalidModule})!ir.Program {
    if (comptime !@import("parser_options").generated_parser) return @import("library_entry_seed.zig").create(allocator, library, index);

    var program = try library.module(index);
    const entry = @import("generated_library_entry");
    const Input = std.meta.Child(entry.Input);

    const input: Input = .{
        .function_id = if (library.exports[index].function) |id| @backingInt(id) else null,
        .input_type = @backingInt(program.input_type),
        .output_type = @backingInt(program.output_type),
        .store_count = program.stores.count(),
    };

    const result = zx.columns.invoke(entry.executeValue, allocator, &input) catch |err| switch (@as(anyerror, err)) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => return error.OutOfMemory,
        else => unreachable,
    };

    const wrapper = result orelse return program;

    try @import("frontend").installForwardEntry(allocator, &program, &wrapper);

    return program;
}
