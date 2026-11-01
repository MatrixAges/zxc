const std = @import("std");
const dsl = @import("dsl");
const checks = @import("../checks.zig");
const steps = @import("../steps.zig");
const Else = @import("Else.zig").Else;

const IfBase = dsl.element("If", struct { on: []const u8 }, dsl.list(struct {
    pub const Data = union(enum) { step: steps.Step, @"else": Else.Data };

    pub fn decode(allocator: std.mem.Allocator, node: dsl.ast.Node, reporter: *dsl.Reporter, context: anytype) dsl.Error!Data {
        if (Else.matches(node.name)) return .{ .@"else" = try Else.decode(allocator, node, reporter, context) };

        return .{ .step = try steps.child(.body).decode(allocator, node, reporter, context) };
    }
}, .{ .min = 1 }));

pub const If = dsl.refine(IfBase, checkIf);

fn checkIf(_: IfBase.Data, node: dsl.ast.Node, _: anytype, reporter: *dsl.Reporter) dsl.Error!void {
    try checks.nonEmpty(node, reporter);

    for (node.children, 0..) |child, index| {
        if (!std.mem.eql(u8, child.name, "Else")) continue;

        if (index == 0 or index != node.children.len - 1) return reporter.fail(.{
            .code = .context,
            .location = child.location,
            .element = child.name,
            .message = "Else must follow the If body and appear once at the end",
        });
    }
}
