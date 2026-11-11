const std = @import("std");
const ir = @import("zx").ir;
const Lower = @import("../lower.zig");
const layout = @import("../iteration_layout.zig");
const consumers = @import("../iteration_consumer.zig");
const Mode = @import("../iteration/result.zig").Mode;
pub const Representation = enum { plain, stack, state, deep, buffered, dereference, reject };

pub const Selection = struct {
    representation: Representation,
    forwarded: ?ir.ExprId = null,
    pure: bool = false,
    direct_initial: bool = false,
};

pub fn choose(self: *Lower, id: ir.ExprId, iteration: ir.Iteration, mode: Mode, consumer: ?consumers.Consumer, projected_output: bool) Lower.Error!Selection {
    if (comptime !@import("genz_options").generated_analysis) {
        return @import("select_seed.zig").choose(self, id, iteration, mode, consumer, projected_output);
    }

    const entry = @import("generated_iteration_layout_selection");
    const Input = std.meta.Child(entry.Input);
    const type_id = self.program.expression(id).type_id;

    var input: Input = .{
        .mode = switch (mode) {
            .reference => .Reference,
            .value => .Value,
            .discard => .Discard,
            .consume => .Consume,
        },
        .state_active = self.state_active,
        .consumer = consumer != null,
        .projected_output = projected_output,
        .flat = layout.flat(self, type_id),
        .represented = layout.represented(self, type_id),
        .aggregate = layout.aggregate(self, type_id),
        .state_represented = self.state_plan.represented(self.program, type_id),
        .buffer_candidate = self.plan.get(id).buffered,
        .scalar_result = if (consumer) |selected| @import("../types/scalar.zig").check(self.program.types, self.program.expression(selected.result).type_id) else false,
        .pure = null,
        .local = null,
        .forwarded = null,
        .buffered = null,
        .deep = null,
        .abi = null,
        .shallow = null,
        .projection = null,
        .initial = null,
    };

    var forwarded: ?ir.ExprId = null;
    var memory = std.heap.FixedBufferAllocator.init(&.{});

    while (true) {
        const action = entry.executeIn(memory.allocator(), &input) catch unreachable;

        switch (action) {
            .CheckPure => input.pure = try layout.eligible(self.allocator, self.program, iteration, self.pure_functions),
            .CheckLocal => input.local = try layout.eligible(self.allocator, self.program, iteration, self.local_functions),
            .CheckForwarding => {
                forwarded = try layout.forwarded(self, iteration);
                input.forwarded = forwarded != null;
            },
            .CheckBuffers => input.buffered = try layout.buffers(self.allocator, self.program, iteration, self.identity_free_functions, self.plan.flags),
            .CheckDeep => input.deep = try layout.deep(self.allocator, self.program, iteration, self.identity_free_functions),
            .CheckAbi => input.abi = try layout.abi(self, iteration, type_id),
            .CheckShallow => input.shallow = try layout.shallow(self.allocator, self.program, iteration),
            .CheckProjection => {
                const selected = consumer.?;

                input.projection = consumers.projection(self.program, selected.result, selected.symbol);
            },
            .CheckInitial => input.initial = try layout.initialValue(self.allocator, self.program, iteration.initial, self.identity_free_functions),
            else => return .{
                .representation = switch (action) {
                    .Plain => .plain,
                    .Stack => .stack,
                    .State => .state,
                    .Deep => .deep,
                    .Buffered => .buffered,
                    .Dereference => .dereference,
                    .Reject => .reject,
                    else => unreachable,
                },
                .forwarded = forwarded,
                .pure = input.pure.?,
                .direct_initial = input.initial orelse false,
            },
        }
    }
}
