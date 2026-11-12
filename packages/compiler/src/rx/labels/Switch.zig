const std = @import("std");
const dsl = @import("dsl");
const checks = @import("../checks.zig");
const Case = @import("Case.zig").Case;
const Default = @import("Default.zig").Default;

const SwitchBase = dsl.element("Switch", struct { on: []const u8 }, dsl.list(dsl.choice(.{
    .case = Case,
    .default = Default,
}), .{ .min = 1 }));

pub const Switch = dsl.refineAlloc(SwitchBase, checkSwitch);

fn checkSwitch(allocator: std.mem.Allocator, data: SwitchBase.Data, input: anytype, _: anytype, reporter: *dsl.Reporter) dsl.Error!void {
    const node = dsl.ast.view(input);

    try checks.nonEmpty(node, reporter);
    if (comptime @import("rx_options").generated_rules) return @import("../schema/selection/adapter.zig").checkSwitch(allocator, data.children, node, reporter);
    try checks.uniqueChildren(node, "Case", "value", reporter);

    var default_seen = false;
    var children = node.children();

    while (children.next()) |item| {
        const child = dsl.ast.view(item);

        if (!std.mem.eql(u8, child.name(), "Default")) continue;

        if (default_seen) return reporter.fail(.{
            .code = .context,
            .location = child.location(),
            .element = child.name(),
            .message = "Switch allows at most one Default",
        });

        default_seen = true;
    }
}
