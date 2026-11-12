const std = @import("std");
const dsl = @import("dsl");
const checks = @import("../../checks.zig");
const rule = @import("generated_rx_module_schema");
const Input = if (@typeInfo(rule.Input) == .pointer) std.meta.Child(rule.Input) else rule.Input;
const Tag = std.meta.Child(@FieldType(Input, "tags"));
const RuleResult = std.meta.Child(rule.Output);
const RuleFinding = if (@typeInfo(RuleResult) == .pointer) std.meta.Child(RuleResult) else RuleResult;
const Finding = struct { issue: @FieldType(RuleFinding, "issue"), index: usize };

pub fn check(allocator: std.mem.Allocator, children: anytype, node: anytype, reporter: *dsl.Reporter) dsl.Error!void {
    const finding = try find(allocator, children) orelse return;
    const child = dsl.ast.childAt(node, finding.index);

    return switch (finding.issue) {
        .DuplicateType => checks.fail(child, "as", "Duplicate RX declaration", reporter),
        .LateType => checks.fail(child, "from", "Type declarations must precede Args and module steps", reporter),
        .MisplacedArgs => checks.fail(child, "in", "Args must appear once after Type declarations and before module steps", reporter),
        .DuplicateStore => checks.fail(child, if (children[finding.index].store.attributes.as != null) "as" else "from", "Store reference alias is already registered", reporter),
    };
}

fn find(allocator: std.mem.Allocator, children: anytype) std.mem.Allocator.Error!?Finding {
    if (children.len < 2) return null;

    var aliases: usize = 0;
    var stores: usize = 0;
    var args = false;

    for (children) |child| switch (child) {
        .type => aliases += 1,
        .args => args = true,
        .store => stores += 1,
        else => {},
    };

    if (aliases == 0 and !args and stores < 2) return null;

    var arena = std.heap.ArenaAllocator.init(allocator);
    var buffer: [512]u8 align(@alignOf(usize)) = undefined;
    var scratch = std.heap.BufferFirstAllocator.init(&buffer, arena.allocator());

    defer arena.deinit();

    const temporary = scratch.allocator();
    const tags = try temporary.alloc(Tag, children.len);
    const type_names = try temporary.alloc([]const u8, aliases);
    const store_names = try temporary.alloc([]const u8, if (stores > 1) stores else 0);
    var type_index: usize = 0;
    var store_index: usize = 0;

    for (children, tags) |child, *tag| {
        tag.* = switch (child) {
            .type => |declaration| block: {
                type_names[type_index] = declaration.attributes.as;
                type_index += 1;

                break :block .Type;
            },
            .store => |reference| block: {
                if (stores > 1) {
                    store_names[store_index] = reference.attributes.as orelse reference.attributes.from;
                    store_index += 1;
                }

                break :block .Store;
            },
            .args => .Args,
            else => .Step,
        };
    }

    const finding = rule.executeValue(temporary, &.{ .tags = tags, .aliases = type_names, .stores = store_names, .check_store_aliases = stores > 1 }) catch |err| switch (@as(anyerror, err)) {
        error.OutOfMemory, error.Overflow, error.IntegerOverflow => return error.OutOfMemory,
        else => unreachable,
    } orelse return null;

    const index: usize = @intCast(finding.index);

    if (finding.issue == .DuplicateType) {
        var ordinal: usize = 0;

        for (tags, 0..) |tag, position| {
            if (tag != .Type) continue;
            if (ordinal == index) return .{ .issue = finding.issue, .index = position };

            ordinal += 1;
        }

        unreachable;
    }

    return .{ .issue = finding.issue, .index = index };
}
