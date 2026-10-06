const std = @import("std");
const f = @import("fixture.zig");
pub const Tag = enum { void_scalar, mode, errors, plain_optional, empty_tuple, empty_object, node, numbers, optional_node, list_node, tuple_native_first, tuple_native_last, tuple_plain, tuple_list_first, tuple_list_last, tuple_mixed, tuple_shared, empty_tuple_after, object_native_first, object_native_last, object_list_last, object_mixed, object_plain, optional_list_node, optional_numbers, optional_object, task_scalar, task_node, task_numbers, task_list_node, task_object, task_enum, late_enum, late_node };
pub const Expected = struct { native: bool, list: bool };

pub const Graph = struct {
    storage: f.ir.TypeStorage,
    ids: [std.enums.values(Tag).len]f.ir.TypeId,
    pub fn id(self: Graph, tag: Tag) f.ir.TypeId {
        return self.ids[@backingInt(tag)];
    }
};

pub fn expected(tag: Tag) Expected {
    return switch (tag) {
        .void_scalar => .{ .native = false, .list = false },
        .mode => .{ .native = false, .list = false },
        .errors => .{ .native = false, .list = false },
        .plain_optional => .{ .native = false, .list = false },
        .empty_tuple => .{ .native = false, .list = false },
        .empty_object => .{ .native = false, .list = false },
        .node => .{ .native = true, .list = false },
        .numbers => .{ .native = false, .list = true },
        .optional_node => .{ .native = true, .list = false },
        .list_node => .{ .native = true, .list = true },
        .tuple_native_first => .{ .native = true, .list = false },
        .tuple_native_last => .{ .native = true, .list = false },
        .tuple_plain => .{ .native = false, .list = false },
        .tuple_list_first => .{ .native = false, .list = true },
        .tuple_list_last => .{ .native = false, .list = true },
        .tuple_mixed => .{ .native = true, .list = true },
        .tuple_shared => .{ .native = true, .list = false },
        .empty_tuple_after => .{ .native = false, .list = false },
        .object_native_first => .{ .native = true, .list = false },
        .object_native_last => .{ .native = true, .list = false },
        .object_list_last => .{ .native = false, .list = true },
        .object_mixed => .{ .native = true, .list = true },
        .object_plain => .{ .native = false, .list = false },
        .optional_list_node => .{ .native = true, .list = true },
        .optional_numbers => .{ .native = false, .list = true },
        .optional_object => .{ .native = true, .list = true },
        .task_scalar => .{ .native = false, .list = false },
        .task_node => .{ .native = true, .list = false },
        .task_numbers => .{ .native = false, .list = false },
        .task_list_node => .{ .native = true, .list = false },
        .task_object => .{ .native = true, .list = false },
        .task_enum => .{ .native = false, .list = false },
        .late_enum => .{ .native = false, .list = false },
        .late_node => .{ .native = true, .list = false },
    };
}

pub fn build(memory: std.mem.Allocator) !Graph {
    var result = Graph{ .storage = try f.base(memory), .ids = undefined };

    result.ids[@backingInt(Tag.void_scalar)] = f.scalar(.void);
    result.ids[@backingInt(Tag.mode)] = try f.add(memory, &result.storage, .{ .enumeration = .{ .name = "Mode", .members = &.{ "First", "Second" } } });
    result.ids[@backingInt(Tag.errors)] = try f.add(memory, &result.storage, .{ .error_set = &.{"Failure"} });
    result.ids[@backingInt(Tag.plain_optional)] = try f.add(memory, &result.storage, .{ .optional = f.scalar(.u64) });
    result.ids[@backingInt(Tag.empty_tuple)] = try f.add(memory, &result.storage, .{ .tuple = &.{} });
    result.ids[@backingInt(Tag.empty_object)] = try f.add(memory, &result.storage, .{ .object = .{ .names = &.{}, .types = &.{}, .len = 0 } });
    result.ids[@backingInt(Tag.node)] = try f.add(memory, &result.storage, .{ .native_reference = "Node" });
    result.ids[@backingInt(Tag.numbers)] = try f.add(memory, &result.storage, .{ .list = f.scalar(.u64) });
    result.ids[@backingInt(Tag.optional_node)] = try f.add(memory, &result.storage, .{ .optional = result.id(.node) });
    result.ids[@backingInt(Tag.list_node)] = try f.add(memory, &result.storage, .{ .list = result.id(.node) });
    result.ids[@backingInt(Tag.tuple_native_first)] = try f.add(memory, &result.storage, .{ .tuple = &.{ result.id(.node), f.scalar(.u64) } });
    result.ids[@backingInt(Tag.tuple_native_last)] = try f.add(memory, &result.storage, .{ .tuple = &.{ f.scalar(.u64), result.id(.node) } });
    result.ids[@backingInt(Tag.tuple_plain)] = try f.add(memory, &result.storage, .{ .tuple = &.{ f.scalar(.bool), f.scalar(.u64) } });
    result.ids[@backingInt(Tag.tuple_list_first)] = try f.add(memory, &result.storage, .{ .tuple = &.{ result.id(.numbers), f.scalar(.u64) } });
    result.ids[@backingInt(Tag.tuple_list_last)] = try f.add(memory, &result.storage, .{ .tuple = &.{ f.scalar(.u64), result.id(.numbers) } });
    result.ids[@backingInt(Tag.tuple_mixed)] = try f.add(memory, &result.storage, .{ .tuple = &.{ result.id(.optional_node), result.id(.numbers), result.id(.list_node) } });
    result.ids[@backingInt(Tag.tuple_shared)] = try f.add(memory, &result.storage, .{ .tuple = &.{ result.id(.optional_node), result.id(.optional_node), f.scalar(.bool) } });
    result.ids[@backingInt(Tag.empty_tuple_after)] = try f.add(memory, &result.storage, .{ .tuple = &.{} });
    result.ids[@backingInt(Tag.object_native_first)] = try f.add(memory, &result.storage, .{ .object = .{ .names = &.{ "a", "z" }, .types = &.{ @backingInt(result.id(.node)), @backingInt(f.scalar(.u64)) }, .len = 2 } });
    result.ids[@backingInt(Tag.object_native_last)] = try f.add(memory, &result.storage, .{ .object = .{ .names = &.{ "a", "z" }, .types = &.{ @backingInt(f.scalar(.u64)), @backingInt(result.id(.node)) }, .len = 2 } });
    result.ids[@backingInt(Tag.object_list_last)] = try f.add(memory, &result.storage, .{ .object = .{ .names = &.{ "a", "z" }, .types = &.{ @backingInt(f.scalar(.u64)), @backingInt(result.id(.numbers)) }, .len = 2 } });
    result.ids[@backingInt(Tag.object_mixed)] = try f.add(memory, &result.storage, .{ .object = .{ .names = &.{ "a", "b", "c" }, .types = &.{ @backingInt(result.id(.optional_node)), @backingInt(result.id(.numbers)), @backingInt(result.id(.tuple_mixed)) }, .len = 3 } });
    result.ids[@backingInt(Tag.object_plain)] = try f.add(memory, &result.storage, .{ .object = .{ .names = &.{ "a", "z" }, .types = &.{ @backingInt(f.scalar(.u64)), @backingInt(result.id(.mode)) }, .len = 2 } });
    result.ids[@backingInt(Tag.optional_list_node)] = try f.add(memory, &result.storage, .{ .optional = result.id(.list_node) });
    result.ids[@backingInt(Tag.optional_numbers)] = try f.add(memory, &result.storage, .{ .optional = result.id(.numbers) });
    result.ids[@backingInt(Tag.optional_object)] = try f.add(memory, &result.storage, .{ .optional = result.id(.object_mixed) });
    result.ids[@backingInt(Tag.task_scalar)] = try f.add(memory, &result.storage, .{ .task = .{ .result = f.scalar(.u64), .errors = result.id(.errors) } });
    result.ids[@backingInt(Tag.task_node)] = try f.add(memory, &result.storage, .{ .task = .{ .result = result.id(.node), .errors = result.id(.errors) } });
    result.ids[@backingInt(Tag.task_numbers)] = try f.add(memory, &result.storage, .{ .task = .{ .result = result.id(.numbers), .errors = result.id(.errors) } });
    result.ids[@backingInt(Tag.task_list_node)] = try f.add(memory, &result.storage, .{ .task = .{ .result = result.id(.list_node), .errors = result.id(.errors) } });
    result.ids[@backingInt(Tag.task_object)] = try f.add(memory, &result.storage, .{ .task = .{ .result = result.id(.object_mixed), .errors = result.id(.errors) } });
    result.ids[@backingInt(Tag.task_enum)] = try f.add(memory, &result.storage, .{ .task = .{ .result = result.id(.mode), .errors = result.id(.errors) } });
    result.ids[@backingInt(Tag.late_enum)] = try f.add(memory, &result.storage, .{ .enumeration = .{ .name = "Late", .members = &.{"Tag"} } });
    result.ids[@backingInt(Tag.late_node)] = try f.add(memory, &result.storage, .{ .native_reference = "OtherNode" });
    try f.valid(result.storage.view());

    return result;
}
