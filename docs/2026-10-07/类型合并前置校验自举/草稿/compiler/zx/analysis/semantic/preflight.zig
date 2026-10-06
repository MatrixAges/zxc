const std = @import("std");
const ir = @import("zx").ir;
const Origins = @import("nominal_data");
const Workspace = @import("merge_workspace_view");
pub const Result = Workspace.Result;
pub const Error = std.mem.Allocator.Error || error{InvalidModule};

pub fn prepare(allocator: std.mem.Allocator, temporary: std.mem.Allocator, source: ir.TypeTable, origins: Origins.Table, target: ir.TypeTable, first: usize) Error!Result {
    if (!@import("parser_options").generated_parser) return @import("seed_preflight.zig").prepare(allocator, temporary, source, origins, target, first);

    const generated = @import("generated_merge_preflight");
    const Input = @typeInfo(generated.Input).pointer.child;
    const Table = @typeInfo(@FieldType(Input, "source")).pointer.child;
    const Bindings = @typeInfo(@FieldType(Input, "origins")).pointer.child;
    const source_table = ir.TypeTable.borrow(Table, source);
    const target_table = ir.TypeTable.borrow(Table, target);
    const bindings = Origins.Table.borrow(Bindings, origins);
    var workspace = Workspace{ .allocator = allocator, .temporary = temporary };
    const input: Input = .{ .source = &source_table, .target = &target_table, .origins = &bindings, .names = origins.names, .first = first, .workspace = @ptrCast(&workspace) };
    var storage: [0]u8 = undefined;
    var fixed = std.heap.FixedBufferAllocator.init(&storage);
    var arena = std.heap.ArenaAllocator.init(fixed.allocator());

    defer arena.deinit();

    const valid = generated.execute(&arena, &input) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => unreachable,
    };

    if (!valid) return error.InvalidModule;

    return workspace.result;
}
