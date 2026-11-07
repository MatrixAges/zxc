const std = @import("std");
const node = @import("../node.zig");
const rows = @import("import_rows.zig");
const Rows = @import("rows.zig").Rows;
const Stored = @import("stored.zig").Value(node.Statement);
const Tag = std.meta.Tag(node.Statement);
pub const Error = rows.Error;

pub fn append(allocator: std.mem.Allocator, target: *std.ArrayList(node.Statement), source: anytype) Error!void {
    return appendRows(allocator, target, source, false);
}

/// Text must outlive the target list and every AST block subsequently built from it.
pub fn appendBorrowingText(allocator: std.mem.Allocator, target: *std.ArrayList(node.Statement), source: anytype) Error!void {
    return appendRows(allocator, target, source, true);
}

fn appendRows(allocator: std.mem.Allocator, target: *std.ArrayList(node.Statement), source: anytype, comptime borrow_text: bool) Error!void {
    var empty: Rows(Stored) = .init();

    _ = try rows.check(&empty, source);

    const count = source.tags.len;

    if (count > std.math.maxInt(u32) - target.items.len) return error.OutOfMemory;

    for (source.tags) |item| switch (@as(Tag, @fromBackingInt(@backingInt(item)))) {
        .constant, .variable, .assignment, .break_value, .errdefer_expression, .defer_expression, .branch, .expression => {},
        else => return error.InvalidAst,
    };

    try target.ensureUnusedCapacity(allocator, count);

    for (source.tags, source.offsets) |item, offset| {
        const tag: Tag = @fromBackingInt(@backingInt(item));

        target.appendAssumeCapacity(switch (tag) {
            inline .constant, .variable => |selected| value: {
                const prefix = @tagName(selected);

                if (comptime @hasField(std.meta.Child(@TypeOf(source)), prefix ++ "_name")) {
                    const text = @field(source, prefix ++ "_name")[offset];
                    const type_expr = @field(source, prefix ++ "_type_expr")[offset];

                    const constant: node.Constant = .{
                        .name = if (comptime borrow_text) text else try allocator.dupe(u8, text),
                        .type_expr = if (type_expr) |id| @fromBackingInt(id) else null,
                        .value = @fromBackingInt(@field(source, prefix ++ "_value")[offset]),
                        .exported = @field(source, prefix ++ "_exported")[offset],
                    };

                    break :value @unionInit(node.Statement, prefix, constant);
                } else return error.InvalidAst;
            },
            .expression => if (comptime @hasField(std.meta.Child(@TypeOf(source)), "expression"))
                .{ .expression = @fromBackingInt(source.expression[offset]) }
            else
                return error.InvalidAst,
            .defer_expression => if (comptime @hasField(std.meta.Child(@TypeOf(source)), "defer_expression"))
                .{ .defer_expression = @fromBackingInt(source.defer_expression[offset]) }
            else
                return error.InvalidAst,
            .errdefer_expression => if (comptime @hasField(std.meta.Child(@TypeOf(source)), "errdefer_expression"))
                .{ .errdefer_expression = @fromBackingInt(source.errdefer_expression[offset]) }
            else
                return error.InvalidAst,
            .branch => if (comptime @hasField(std.meta.Child(@TypeOf(source)), "branch_condition")) .{ .branch = .{
                .condition = @fromBackingInt(source.branch_condition[offset]),
                .yes = .{ .start = source.branch_yes_start[offset], .len = source.branch_yes_len[offset] },
                .no = .{ .start = source.branch_no_start[offset], .len = source.branch_no_len[offset] },
                .capture = if (source.branch_capture[offset]) |text| if (comptime borrow_text) text else try allocator.dupe(u8, text) else null,
                .capture_reference = source.branch_capture_reference[offset],
                .error_capture = if (source.branch_error_capture[offset]) |text| if (comptime borrow_text) text else try allocator.dupe(u8, text) else null,
            } } else return error.InvalidAst,
            .assignment => .{ .assignment = .{
                .target = @fromBackingInt(source.assignment_target[offset]),
                .value = @fromBackingInt(source.assignment_value[offset]),
            } },
            .break_value => .{ .break_value = .{
                .label = if (comptime borrow_text) source.break_value_label[offset] else try allocator.dupe(u8, source.break_value_label[offset]),
                .value = @fromBackingInt(source.break_value_value[offset]),
            } },
            else => unreachable,
        });
    }
}
