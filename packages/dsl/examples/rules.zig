const std = @import("std");
const dsl = @import("dsl");

const Condition = dsl.element("Condition", struct {
    field: []const u8,
    operator: enum { equal, between },
    value: []const u8,
}, dsl.empty);

const Action = dsl.element("Action", struct {
    type: []const u8,
    enabled: bool = true,
    retries: u8 = 0,
}, dsl.empty);

const Rule = dsl.element("Rule", struct {
    id: []const u8,
    priority: ?f64 = null,
}, dsl.sequence(.{ dsl.refine(Condition, checkCondition), Action }));

const Note = dsl.element("Note", struct { label: []const u8 }, dsl.empty);

const Engine = dsl.element("RuleEngine", struct {}, dsl.list(dsl.choice(.{
    .rule = Rule,
    .note = Note,
}), .{ .min = 1 }));

const Context = struct {
    fields: []const []const u8,
};

fn checkCondition(data: Condition.Data, node: dsl.ast.Node, context: Context, reporter: *dsl.Reporter) dsl.Error!void {
    var known = false;

    for (context.fields) |field| {
        if (std.mem.eql(u8, field, data.attributes.field)) known = true;
    }

    if (!known) return reporter.fail(.{
        .code = .context,
        .location = node.location,
        .element = node.name,
        .attribute = "field",
        .message = "Condition field is not registered in the application context",
    });

    if (data.attributes.operator != .between) return;

    var parts = std.mem.splitScalar(u8, data.attributes.value, ',');
    var range: [2]f64 = undefined;

    for (&range) |*value| {
        const part = parts.next() orelse return invalidRange(node, reporter);

        value.* = std.fmt.parseFloat(f64, part) catch return invalidRange(node, reporter);

        if (!std.math.isFinite(value.*)) return invalidRange(node, reporter);
    }

    if (parts.next() != null or range[0] > range[1]) return invalidRange(node, reporter);
}

fn invalidRange(node: dsl.ast.Node, reporter: *dsl.Reporter) dsl.Error {
    for (node.attributes) |attribute| {
        if (std.mem.eql(u8, attribute.name, "value")) return reporter.fail(.{
            .code = .context,
            .location = attribute.value_location,
            .element = node.name,
            .attribute = attribute.name,
            .expected = "lower,upper",
            .message = "between requires two finite numbers in ascending order",
        });
    }

    unreachable;
}

pub fn main() !void {
    const location = dsl.ast.Location{ .offset = 0, .line = 1, .column = 1 };

    const node = dsl.ast.Node{
        .name = "RuleEngine",
        .location = location,
        .children = &.{.{
            .name = "Rule",
            .location = location,
            .attributes = &.{.{ .name = "id", .value = "discount", .location = location, .value_location = location }},
            .children = &.{
                .{
                    .name = "Condition",
                    .location = location,
                    .attributes = &.{
                        .{ .name = "field", .value = "amount", .location = location, .value_location = location },
                        .{ .name = "operator", .value = "between", .location = location, .value_location = location },
                        .{ .name = "value", .value = "10,20", .location = location, .value_location = location },
                    },
                },
                .{
                    .name = "Action",
                    .location = location,
                    .attributes = &.{
                        .{ .name = "type", .value = "discount", .location = location, .value_location = location },
                        .{ .name = "enabled", .value = "true", .location = location, .value_location = location },
                        .{ .name = "retries", .value = "2", .location = location, .value_location = location },
                    },
                },
            },
        }},
    };

    var allocator_state: std.heap.DebugAllocator(.{}) = .init;

    defer std.debug.assert(allocator_state.deinit() == .ok);

    var result = try dsl.validate(Engine, allocator_state.allocator(), node, Context{ .fields = &.{"amount"} });

    defer result.deinit();

    switch (result.value) {
        .data => |data| {
            const rule: Rule.Data = data.children[0].rule;

            std.debug.print("Rule {s}: {s} {s}, action={s}, retries={d}\n", .{
                rule.attributes.id,
                @tagName(rule.children[0].attributes.operator),
                rule.children[0].attributes.value,
                rule.children[1].attributes.type,
                rule.children[1].attributes.retries,
            });
        },
        .diagnostic => |issue| {
            std.debug.print("Line {d}, Column {d}: <{s}> {s}\n", .{
                issue.location.line,
                issue.location.column,
                issue.element,
                issue.message,
            });

            return error.InvalidExample;
        },
    }
}
