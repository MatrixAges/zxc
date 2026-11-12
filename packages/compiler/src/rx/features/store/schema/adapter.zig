const std = @import("std");
const dsl = @import("dsl");
const checks = @import("../../../checks.zig");

pub const Groups = struct {
    first: usize,
    starts: []const u32,
    next: []const ?u32,
};

pub fn validate(allocator: std.mem.Allocator, children: anytype, input: anytype, reporter: *dsl.Reporter) dsl.Error!Groups {
    const node = dsl.ast.view(input);

    if (children.len == 1 and children[0] == .object) return .{ .first = 0, .starts = &.{0}, .next = &.{null} };
    if (children.len > std.math.maxInt(u32)) return error.OutOfMemory;

    var alias_count: usize = 0;
    var field_count: usize = 0;

    for (children) |child| switch (child) {
        .type => alias_count += 1,
        .object => |object| field_count = std.math.add(usize, field_count, object.children.len) catch return error.OutOfMemory,
    };

    const object_count = children.len - alias_count;
    const tags = try allocator.alloc(bool, children.len);
    const aliases = try allocator.alloc([]const u8, alias_count);
    const objects = try allocator.alloc([]const u8, object_count);
    const fields = try allocator.alloc([]const u8, if (object_count > 1) field_count else 0);
    const offsets = try allocator.alloc(u64, if (object_count > 1) object_count + 1 else 0);
    var alias_index: usize = 0;
    var object_index: usize = 0;
    var row: usize = 0;

    for (children, tags) |child, *tag| {
        tag.* = child == .type;

        switch (child) {
            .type => |declared| {
                aliases[alias_index] = declared.attributes.as;
                alias_index += 1;
            },
            .object => |object| {
                objects[object_index] = object.attributes.name;

                if (object_count > 1) {
                    offsets[object_index] = row;

                    for (object.children) |field| {
                        fields[row] = field.attributes.name;
                        row += 1;
                    }
                }

                object_index += 1;
            },
        }
    }

    if (offsets.len != 0) offsets[object_count] = row;

    const rule = @import("generated_rx_store_schema");

    const result = rule.executeValue(allocator, &.{ .tags = tags, .aliases = aliases, .objects = objects, .fields = fields, .offsets = offsets }) catch |err| switch (@as(anyerror, err)) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => return error.OutOfMemory,
        else => unreachable,
    };

    const index: usize = @intCast(result.index);

    switch (result.issue) {
        .None => return .{ .first = alias_count, .starts = result.groups.starts, .next = result.groups.next },
        .DuplicateType => {
            var current: usize = 0;
            var sources = node.children();

            for (children) |child| {
                const source = sources.next().?;

                if (child != .type) continue;
                if (current == index) return checks.fail(source, "as", "Duplicate RX declaration", reporter);

                current += 1;
            }

            unreachable;
        },
        .LateType => return checks.fail(dsl.ast.childAt(node, index), "from", "Type declarations must precede Store objects", reporter),
        .MissingObject => return checks.fail(node, "", "Store requires at least one Object", reporter),
        .DuplicateField => {
            for (offsets[1..], 0..) |end, fragment| {
                if (index >= end) continue;

                const object = dsl.ast.childAt(node, alias_count + fragment);
                const field = dsl.ast.childAt(object, index - @as(usize, @intCast(offsets[fragment])));

                return checks.fail(field, "name", "Store object field path is already declared", reporter);
            }

            unreachable;
        },
    }
}

pub fn uniqueFields(allocator: std.mem.Allocator, children: anytype, input: anytype, reporter: *dsl.Reporter) dsl.Error!void {
    const node = dsl.ast.view(input);

    if (children.len < 2) return;
    if (children.len > std.math.maxInt(u32)) return error.OutOfMemory;

    var arena = std.heap.ArenaAllocator.init(allocator);
    var buffer: [std.heap.page_size_min / 4]u8 = undefined;
    var scratch = std.heap.BufferFirstAllocator.init(&buffer, arena.allocator());

    defer arena.deinit();

    const temporary = scratch.allocator();
    const names = try temporary.alloc([]const u8, children.len);

    for (children, names) |field, *name| name.* = field.attributes.name;

    const duplicate = @import("generated_rx_store_unique").executeValue(temporary, names) catch |err| switch (@as(anyerror, err)) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => return error.OutOfMemory,
        else => unreachable,
    };

    if (duplicate) |index| return checks.fail(dsl.ast.childAt(node, @intCast(index)), "name", "Duplicate RX declaration", reporter);
}
