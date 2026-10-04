const std = @import("std");
const dsl = @import("dsl");
const checks = @import("../checks.zig");
const steps = @import("../steps.zig");
pub const Task = checks.nonEmptySchema(dsl.element("Task", struct { name: []const u8, out: ?[]const u8 = null }, steps.children(.task)));
pub const Sequential = dsl.refine(Task, checkSequential);

fn checkSequential(_: Task.Data, node: dsl.ast.Node, _: anytype, reporter: *dsl.Reporter) dsl.Error!void {
    for (node.attributes) |attribute| {
        if (std.mem.eql(u8, attribute.name, "out")) return reporter.fail(.{ .code = .invalid_attribute, .location = attribute.location, .element = node.name, .attribute = "out", .message = "Task.out is only available on direct Parallel branches" });
    }
}
