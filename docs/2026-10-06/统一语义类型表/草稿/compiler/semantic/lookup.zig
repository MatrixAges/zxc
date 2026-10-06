const std = @import("std");
const ir = @import("zx").ir;
pub const Value = ir.TypeValue;

pub fn find(table: ir.TypeTable, value: Value) std.mem.Allocator.Error!?ir.TypeId {
    if (!@import("parser_options").generated_parser) return @import("seed_lookup.zig").find(table, value);

    const generated = @import("generated_type_lookup");
    const Input = @typeInfo(generated.Input).pointer.child;
    const Tables = @typeInfo(@FieldType(Input, "tables")).pointer.child;
    const Table = @typeInfo(@FieldType(Tables, "base")).pointer.child;
    const Candidate = @typeInfo(@FieldType(Input, "candidate")).pointer.child;
    const Fields = @typeInfo(@FieldType(Candidate, "fields")).pointer.child;

    const fields: Fields = .{
        .names = if (value == .object) value.object.names else &.{},
        .types = if (value == .object) value.object.types else &.{},
    };

    const base = ir.TypeTable.borrow(Table, table);
    const delta = ir.TypeTable.borrow(Table, .{});
    const tables: Tables = .{ .base = &base, .delta = &delta };

    const candidate: Candidate = .{
        .kind = switch (value) {
            .scalar => .Scalar,
            .object => .Object,
            .optional => .Optional,
            .list => .List,
            .task => .Task,
            .tuple => .Tuple,
            .error_set => .ErrorSet,
            .enumeration => .Enumeration,
            .native_reference => .NativeReference,
        },
        .first = switch (value) {
            .scalar => |scalar| @intCast(@backingInt(scalar)),
            .optional, .list => |child| @backingInt(child),
            .task => |task| @backingInt(task.result),
            else => 0,
        },
        .second = if (value == .task) @backingInt(value.task.errors) else 0,
        .label = value.nominalName() orelse "",
        .children = if (value == .tuple) @as([*]const u32, @ptrCast(value.tuple.ptr))[0..value.tuple.len] else &.{},
        .fields = &fields,
        .names = switch (value) {
            .error_set => |names| names,
            .enumeration => |entry| entry.members,
            else => &.{},
        },
    };

    const input: Input = .{ .tables = &tables, .candidate = &candidate };
    var storage: [0]u8 = undefined;
    var fixed = std.heap.FixedBufferAllocator.init(&storage);
    var arena = std.heap.ArenaAllocator.init(fixed.allocator());

    defer arena.deinit();

    const id = generated.execute(&arena, &input) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => unreachable,
    };

    return if (id) |found| @fromBackingInt(found) else null;
}
