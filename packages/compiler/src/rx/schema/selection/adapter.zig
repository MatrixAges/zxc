const std = @import("std");
const dsl = @import("dsl");
const checks = @import("../../checks.zig");
const rule = @import("generated_rx_selection_schema");
const Input = std.meta.Child(rule.Input);
const RuleResult = std.meta.Child(rule.Output);
const RuleFinding = if (@typeInfo(RuleResult) == .pointer) std.meta.Child(RuleResult) else RuleResult;
const Finding = struct { issue: @FieldType(RuleFinding, "issue"), index: usize };
const table_load_ratio = 2;

pub fn checkIf(allocator: std.mem.Allocator, children: anytype, node: anytype, reporter: *dsl.Reporter) dsl.Error!void {
    const first = for (children, 0..) |child, index| {
        if (child == .@"else") break index;
    } else return;

    var empty: []u64 = &.{};

    const finding = try run(allocator, &.{
        .kind = .If,
        .count = children.len,
        .first_else = first,
        .second_default = null,
        .keys = &.{},
        .braced = &.{},
        .string_buckets = @ptrCast(&empty),
        .expression_buckets = @ptrCast(&empty),
        .string_capacity = 0,
        .expression_capacity = 0,
    }) orelse return;

    return misplacedElse(dsl.ast.childAt(node, finding.index), reporter);
}

pub fn misplacedElse(input: anytype, reporter: *dsl.Reporter) dsl.Error {
    const child = dsl.ast.view(input);

    return reporter.fail(.{
        .code = .context,
        .location = child.location(),
        .element = child.name(),
        .message = "Else must follow the If body and appear once at the end",
    });
}

pub fn checkSwitch(allocator: std.mem.Allocator, children: anytype, node: anytype, reporter: *dsl.Reporter) dsl.Error!void {
    const finding = try findSwitch(allocator, children, node) orelse return;
    const child = dsl.ast.childAt(node, finding.index);

    return switch (finding.issue) {
        .DuplicateCase => checks.fail(child, "value", "Duplicate RX declaration", reporter),
        .DuplicateDefault => repeatedDefault(child, reporter),
        .MisplacedElse => unreachable,
    };
}

pub fn repeatedDefault(input: anytype, reporter: *dsl.Reporter) dsl.Error {
    const child = dsl.ast.view(input);

    return reporter.fail(.{
        .code = .context,
        .location = child.location(),
        .element = child.name(),
        .message = "Switch allows at most one Default",
    });
}

fn findSwitch(allocator: std.mem.Allocator, children: anytype, input: anytype) std.mem.Allocator.Error!?Finding {
    if (children.len < 2) return null;

    var case_count: usize = 0;
    var seen_default = false;
    var second_default: ?usize = null;

    for (children, 0..) |child, index| {
        if (child == .case) {
            case_count += 1;
        } else if (!seen_default) {
            seen_default = true;
        } else if (second_default == null) {
            second_default = index;
        }
    }

    if (case_count < 2 and second_default == null) return null;

    var arena = std.heap.ArenaAllocator.init(allocator);
    var buffer: [512]u8 align(@alignOf(u64)) = undefined;
    var scratch = std.heap.BufferFirstAllocator.init(&buffer, arena.allocator());

    defer arena.deinit();

    const temporary = scratch.allocator();
    const keys = try temporary.alloc([]const u8, if (case_count > 1) case_count else 0);
    const braced = try temporary.alloc(bool, keys.len);
    var expression_count: usize = 0;

    if (keys.len != 0) {
        const node = dsl.ast.view(input);
        var nodes = node.children();
        var index: usize = 0;

        for (children) |child| {
            const element = nodes.next().?;

            if (child != .case) continue;

            const attribute = dsl.ast.view(element).schemaAttribute(0);
            keys[index] = attribute.value;
            braced[index] = attribute.kind == .expression;
            expression_count += @intFromBool(braced[index]);
            index += 1;
        }
    }

    const strings = try buckets(temporary, keys.len - expression_count);
    const expressions = try buckets(temporary, expression_count);

    const finding = try run(temporary, &.{
        .kind = .Switch,
        .count = children.len,
        .first_else = null,
        .second_default = second_default,
        .keys = keys,
        .braced = braced,
        .string_buckets = @ptrCast(&strings),
        .expression_buckets = @ptrCast(&expressions),
        .string_capacity = strings.len,
        .expression_capacity = expressions.len,
    }) orelse return null;

    if (finding.issue != .DuplicateCase) return finding;

    var ordinal: usize = 0;

    for (children, 0..) |child, index| {
        if (child != .case) continue;
        if (ordinal == finding.index) return .{ .issue = finding.issue, .index = index };

        ordinal += 1;
    }

    unreachable;
}

fn buckets(allocator: std.mem.Allocator, count: usize) std.mem.Allocator.Error![]u64 {
    if (count < 2) return &.{};

    const required = std.math.mul(usize, count, table_load_ratio) catch return error.OutOfMemory;
    const capacity = std.math.ceilPowerOfTwo(usize, required) catch return error.OutOfMemory;
    const storage = try allocator.alloc(u64, capacity);

    @memset(storage, 0);

    return storage;
}

fn run(allocator: std.mem.Allocator, input: *const Input) std.mem.Allocator.Error!?Finding {
    const finding = rule.executeValue(allocator, input) catch |err| switch (@as(anyerror, err)) {
        error.OutOfMemory, error.Overflow, error.IntegerOverflow => return error.OutOfMemory,
        else => unreachable,
    } orelse return null;

    return .{ .issue = finding.issue, .index = @intCast(finding.index) };
}
