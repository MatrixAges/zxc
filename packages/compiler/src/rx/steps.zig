const std = @import("std");
const dsl = @import("dsl");
const flow = @import("flow.zig");

pub const Step = union(enum) {
    call: flow.Call.Data,
    task: flow.Task.Data,
    parallel: flow.Parallel.Data,
    @"switch": flow.Switch.Data,
    emit: flow.Emit.Data,
    @"return": flow.Return.Data,
};

const Scope = enum { body, task, parallel };

pub fn children(comptime scope: Scope) type {
    return dsl.list(struct {
        pub const Data = Step;

        pub fn decode(allocator: std.mem.Allocator, node: dsl.ast.Node, reporter: *dsl.Reporter, context: anytype) dsl.Error!Data {
            inline for (.{ "call", "task", "parallel", "switch", "emit", "return" }) |tag| {
                const allowed = comptime switch (scope) {
                    .body => true,
                    .task => !std.mem.eql(u8, tag, "task"),
                    .parallel => std.mem.eql(u8, tag, "task") or std.mem.eql(u8, tag, "call"),
                };

                if (comptime allowed) {
                    const Schema = schema(tag);

                    if (Schema.matches(node.name)) return @unionInit(Data, tag, try Schema.decode(allocator, node, reporter, context));
                }
            }

            return reporter.fail(.{
                .code = .unexpected_element,
                .location = node.location,
                .element = node.name,
                .message = "Element is not allowed in this RX execution scope",
            });
        }
    }, .{ .min = 1 });
}

fn schema(comptime tag: []const u8) type {
    if (std.mem.eql(u8, tag, "call")) return flow.Call;
    if (std.mem.eql(u8, tag, "task")) return flow.Task;
    if (std.mem.eql(u8, tag, "parallel")) return flow.Parallel;
    if (std.mem.eql(u8, tag, "switch")) return flow.Switch;
    if (std.mem.eql(u8, tag, "emit")) return flow.Emit;
    if (std.mem.eql(u8, tag, "return")) return flow.Return;

    unreachable;
}
