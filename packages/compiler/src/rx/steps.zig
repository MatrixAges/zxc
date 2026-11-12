const std = @import("std");
const dsl = @import("dsl");
const flow = @import("flow.zig");
const execution = @import("schema/execution/adapter.zig");

pub const Step = union(enum) {
    call: flow.Call.Data,
    task: flow.Task.Data,
    parallel: flow.Parallel.Data,
    @"switch": flow.Switch.Data,
    @"if": flow.If.Data,
    emit: flow.Emit.Data,
    @"return": flow.Return.Data,
};

const Scope = execution.Scope;

pub fn children(comptime scope: Scope) type {
    return dsl.list(child(scope), .{ .min = 1 });
}

pub fn child(comptime scope: Scope) type {
    return struct {
        pub const Data = Step;

        pub fn decode(allocator: std.mem.Allocator, input: anytype, reporter: *dsl.Reporter, context: anytype) dsl.Error!Data {
            const node = dsl.ast.view(input);

            return switch (execution.admit(node.name(), scope)) {
                .Call => .{ .call = try flow.Call.decode(allocator, input, reporter, context) },
                .Task => .{ .task = try flow.Task.decode(allocator, input, reporter, context) },
                .Parallel => .{ .parallel = try flow.Parallel.decode(allocator, input, reporter, context) },
                .Switch => .{ .@"switch" = try flow.Switch.decode(allocator, input, reporter, context) },
                .If => .{ .@"if" = try flow.If.decode(allocator, input, reporter, context) },
                .Emit => .{ .emit = try flow.Emit.decode(allocator, input, reporter, context) },
                .Return => .{ .@"return" = try flow.Return.decode(allocator, input, reporter, context) },
                else => reporter.fail(.{
                    .code = .unexpected_element,
                    .location = node.location(),
                    .element = node.name(),
                    .message = "Element is not allowed in this RX execution scope",
                }),
            };
        }
    };
}
