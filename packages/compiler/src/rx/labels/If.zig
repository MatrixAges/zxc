const std = @import("std");
const dsl = @import("dsl");
const checks = @import("../checks.zig");
const steps = @import("../steps.zig");
const Else = @import("Else.zig").Else;

const IfBase = dsl.element("If", struct { on: []const u8 }, dsl.list(struct {
    pub const Data = union(enum) { step: steps.Step, @"else": Else.Data };

    pub fn decode(allocator: std.mem.Allocator, input: anytype, reporter: *dsl.Reporter, context: anytype) dsl.Error!Data {
        const node = dsl.ast.view(input);

        if (Else.matches(node.name())) return .{ .@"else" = try Else.decode(allocator, input, reporter, context) };

        return .{ .step = try steps.child(.Body).decode(allocator, input, reporter, context) };
    }
}, .{ .min = 1 }));

pub const If = dsl.refineAlloc(IfBase, checkIf);

fn checkIf(allocator: std.mem.Allocator, data: IfBase.Data, input: anytype, _: anytype, reporter: *dsl.Reporter) dsl.Error!void {
    const node = dsl.ast.view(input);

    try checks.nonEmpty(node, reporter);

    if (comptime @import("rx_options").generated_rules) return @import("../schema/selection/adapter.zig").checkIf(allocator, data.children, node, reporter);

    var children = node.children();
    var index: usize = 0;

    while (children.next()) |item| : (index += 1) {
        const child = dsl.ast.view(item);

        if (!std.mem.eql(u8, child.name(), "Else")) continue;

        if (index == 0 or index != node.childCount() - 1) return reporter.fail(.{
            .code = .context,
            .location = child.location(),
            .element = child.name(),
            .message = "Else must follow the If body and appear once at the end",
        });
    }
}
