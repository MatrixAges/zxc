const std = @import("std");
const node = @import("../node.zig");
const rows = @import("import_rows.zig");
const Rows = @import("rows.zig").Rows;
const Stored = @import("stored.zig").Value(node.Statement);
const Tag = std.meta.Tag(node.Statement);
pub const Error = rows.Error;

pub fn append(allocator: std.mem.Allocator, target: *std.ArrayList(node.Statement), source: anytype) Error!void {
    return appendRows(allocator, target, source, false, false);
}

/// Text must outlive the target list and every AST block subsequently built from it.
pub fn appendBorrowingText(allocator: std.mem.Allocator, target: *std.ArrayList(node.Statement), source: anytype) Error!void {
    return appendRows(allocator, target, source, true, false);
}

pub fn appendSelected(allocator: std.mem.Allocator, target: *std.ArrayList(node.Statement), source: anytype) Error!void {
    return appendRows(allocator, target, source, false, true);
}

/// Selected rows may share payload columns; all text must outlive the target.
pub fn appendSelectedBorrowingText(allocator: std.mem.Allocator, target: *std.ArrayList(node.Statement), source: anytype) Error!void {
    return appendRows(allocator, target, source, true, true);
}

/// Existing AST payloads and text must outlive the target list.
pub fn appendBlock(allocator: std.mem.Allocator, target: *std.ArrayList(node.Statement), storage: *const @import("storage.zig"), block: node.Block) Error!void {
    const start: usize = block.start;
    const count: usize = block.len;

    if (start > storage.statements.tags.items.len or count > storage.statements.tags.items.len - start) return error.InvalidAst;
    if (count > std.math.maxInt(u32) - target.items.len) return error.OutOfMemory;
    try target.ensureUnusedCapacity(allocator, count);

    for (0..count) |index| {
        const value = storage.statement(block, index);

        target.appendAssumeCapacity(switch (value) {
            inline else => |payload, tag| @unionInit(node.Statement, @tagName(tag), payload),
        });
    }
}

fn appendRows(allocator: std.mem.Allocator, target: *std.ArrayList(node.Statement), source: anytype, comptime borrow_text: bool, comptime selected_rows: bool) Error!void {
    var empty: Rows(Stored) = .init();

    _ = if (comptime selected_rows) try @import("import_selected.zig").check(&empty, source) else try rows.check(&empty, source);

    const count = source.tags.len;

    if (count > std.math.maxInt(u32) - target.items.len) return error.OutOfMemory;

    for (source.tags) |item| switch (@as(Tag, @fromBackingInt(@backingInt(item)))) {
        .constant, .variable, .assignment, .break_value, .errdefer_expression, .defer_expression, .branch, .while_loop, .expression, .discard, .discard_error, .result, .scope, .defer_scope, .unreachable_stmt => {},
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
            .unreachable_stmt => .unreachable_stmt,
            .discard => if (comptime @hasField(std.meta.Child(@TypeOf(source)), "discard"))
                .{ .discard = @fromBackingInt(source.discard[offset]) }

            else
                return error.InvalidAst,
            .discard_error => if (comptime @hasField(std.meta.Child(@TypeOf(source)), "discard_error"))
                .{ .discard_error = @fromBackingInt(source.discard_error[offset]) }
            else
                return error.InvalidAst,
            .result => if (comptime @hasField(std.meta.Child(@TypeOf(source)), "result"))
                .{ .result = if (source.result[offset]) |id| @fromBackingInt(id) else null }
            else
                return error.InvalidAst,
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
            .assignment => if (comptime @hasField(std.meta.Child(@TypeOf(source)), "assignment_target")) .{ .assignment = .{
                .target = @fromBackingInt(source.assignment_target[offset]),
                .value = @fromBackingInt(source.assignment_value[offset]),
            } } else return error.InvalidAst,
            .while_loop => if (comptime @hasField(std.meta.Child(@TypeOf(source)), "while_loop_condition")) .{ .while_loop = .{
                .condition = @fromBackingInt(source.while_loop_condition[offset]),
                .body = .{ .start = source.while_loop_body_start[offset], .len = source.while_loop_body_len[offset] },
                .capture = if (source.while_loop_capture[offset]) |text| if (comptime borrow_text) text else try allocator.dupe(u8, text) else null,
            } } else return error.InvalidAst,
            .scope => if (comptime @hasField(std.meta.Child(@TypeOf(source)), "scope_start")) .{ .scope = .{
                .start = source.scope_start[offset],
                .len = source.scope_len[offset],
            } } else return error.InvalidAst,
            .defer_scope => if (comptime @hasField(std.meta.Child(@TypeOf(source)), "defer_scope_start")) .{ .defer_scope = .{
                .start = source.defer_scope_start[offset],
                .len = source.defer_scope_len[offset],
            } } else return error.InvalidAst,
            .break_value => if (comptime @hasField(std.meta.Child(@TypeOf(source)), "break_value_label")) .{ .break_value = .{
                .label = if (comptime borrow_text) source.break_value_label[offset] else try allocator.dupe(u8, source.break_value_label[offset]),
                .value = @fromBackingInt(source.break_value_value[offset]),
            } } else return error.InvalidAst,
            else => unreachable,
        });
    }
}
