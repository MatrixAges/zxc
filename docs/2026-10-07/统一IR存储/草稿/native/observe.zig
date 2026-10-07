const std = @import("std");
const ir = @import("zx").ir;
const generated = @import("generated");
const convert = @import("observed_input.zig");
const model = @import("model.zig");
const Storage = @import("storage.zig");

pub fn run(program: ir.Program) void {
    compare(program) catch |err| std.debug.panic("canonical control mismatch in {s}: {t}", .{ program.file_name, err });
}

fn compare(program: ir.Program) !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);

    defer arena.deinit();

    const allocator = arena.allocator();
    var storage: Storage = .{};
    var expected: std.ArrayList(bool) = .empty;
    const root = try convert.block(allocator, &storage, &expected, program.body);
    const table = try storage.finish(allocator);

    defer storage.deinit(allocator);

    const Input = @typeInfo(generated.Input).pointer.child;
    const input = @import("borrow.zig").columns(Input, table);

    inline for (@typeInfo(model.Table).@"struct".field_names) |name| {
        if (@intFromPtr(@field(input, name).ptr) != @intFromPtr(@field(table, name).ptr)) return error.CopiedColumn;
        if (@field(input, name).len != @field(table, name).len) return error.ChangedColumnLength;
    }

    const output = try generated.execute(&arena, &input);

    if (!output.valid or !std.mem.eql(bool, output.returns, expected.items)) return error.ReturnsMismatch;
    if (!@import("observed_control.zig").equal(program.body, @import("control_read.zig").block(&table, root))) return error.ControlContentChanged;
    try @import("observed_body.zig").compare(&arena, program, table, root);

    var kinds = std.mem.zeroes([@typeInfo(model.Kind).@"enum".field_names.len]usize);

    for (table.statement_kinds) |kind| kinds[@backingInt(kind)] += 1;

    const encoded = try std.json.Stringify.valueAlloc(allocator, .{ .file = program.file_name, .blocks = expected.items.len, .statements = table.statement_kinds.len, .root = root, .kinds = kinds, .columns_borrowed = true, .all_block_results_equal = true, .control_read_equal = true }, .{});

    std.debug.print("canonical-control {s}\n", .{encoded});
}
