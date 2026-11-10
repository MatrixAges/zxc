const std = @import("std");
const zx = @import("zx");

pub fn render(allocator: std.mem.Allocator, stateful: bool, output: @import("../json_output.zig").Output) std.mem.Allocator.Error![]u8 {
    if (comptime !@import("genz_options").generated_analysis) return @import("root_seed.zig").render(allocator, stateful, output);

    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const workspace = arena.allocator();
    const entry = @import("generated_cli_host");
    const Input = std.meta.Child(entry.Input);
    const types = zx.ir.TypeTable.borrow(std.meta.Child(@FieldType(Input, "types")), output.types);

    const input: Input = .{
        .stateful = stateful,
        .types = &types,
        .output_type = @backingInt(output.id),
    };

    const result = zx.columns.invoke(entry.executeValue, workspace, &input) catch |err| return failure(err);

    if (!result.valid) return error.OutOfMemory;

    return @import("../../printer/module.zig").render(allocator, workspace, std.meta.Child(entry.Output), result);
}

fn failure(err: anyerror) std.mem.Allocator.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => @panic("invalid CLI host AST"),
    };
}
