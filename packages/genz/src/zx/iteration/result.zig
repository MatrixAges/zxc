const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const aggregate = @import("../aggregate.zig");
const generated = @import("genz_options").generated_analysis;
const entry = if (generated) @import("generated_iteration_result_finish") else struct {};

const Plan = if (generated) std.meta.Child(entry.Output) else struct {
    preparation: enum { BufferedConsumer, DeepConsumer, Consumer, ConvertedConsumer, Unit, Reserve, Block, Layout, Pointer },
    completion: enum { Prepared, State, GuardPrepared, GuardState, GuardDeep, GuardConstruct },
};

const Preparation = @FieldType(Plan, "preparation");
pub const Mode = enum { reference, value, discard, consume };

pub const Result = struct {
    consumer: ?@import("../iteration_consumer.zig").Consumer,
    deep: bool,
    context: *@import("../iteration_value/root.zig"),
    converted: bool,
    type_id: ir.TypeId,
    by_value: bool,
    local: bool,
    selected_state: bool,
    initial: node.ExpressionId,
    changed_name: []const u8,
    mode: Mode,
    pub fn lower(config: Result, self: *Lower, body: *std.ArrayList(node.Statement), state: node.ExpressionId) Lower.Error!node.ExpressionId {
        const actions = config.plan();
        const prepared = try config.prepare(self, body, state, actions.preparation);

        switch (actions.completion) {
            .Prepared => return aggregate.finish(self, body, prepared),
            .State => return aggregate.finish(self, body, state),
            else => {},
        }

        const condition = try self.builder.identifier(config.changed_name);

        const result = switch (actions.completion) {
            .GuardPrepared => prepared,
            .GuardState => state,
            .GuardDeep => try @import("../iteration_value/conversion.zig").convert(config.context, config.type_id, state, true),
            .GuardConstruct => try self.construct(config.type_id, state),
            else => unreachable,
        };

        return aggregate.finishGuarded(self, body, condition, result, config.initial);
    }
    fn prepare(config: Result, self: *Lower, body: *std.ArrayList(node.Statement), state: node.ExpressionId, action: Preparation) Lower.Error!node.ExpressionId {
        return switch (action) {
            .BufferedConsumer => @import("../iteration_value/result.zig").buffered(config.context, body, config.consumer.?, state),
            .DeepConsumer => @import("../iteration_value/result.zig").lower(self, config.consumer.?, state),
            .Consumer, .ConvertedConsumer => projected: {
                const consumer = config.consumer.?;
                const value = try @import("../iteration_consumer.zig").read(self, consumer, consumer.result, state);

                if (action == .Consumer) break :projected value;

                const bound = try aggregate.bind(self, body, value);
                const type_id = self.program.expression(consumer.result).type_id;

                break :projected @import("../state_value/conversion.zig").convert(self, body, type_id, bound, .pointer);
            },
            .Unit => self.builder.expression(.unit),
            .Reserve => reserved: {
                self.serial = std.math.add(usize, self.serial, 1) catch return error.OutOfMemory;

                break :reserved state;
            },
            .Block, .Layout, .Pointer => wrapped: {
                var inner: std.ArrayList(node.Statement) = .empty;
                const value = if (action == .Block) state else try @import("../state_value/conversion.zig").convert(self, &inner, config.type_id, state, if (action == .Layout) .layout else .pointer);

                break :wrapped aggregate.finish(self, &inner, value);
            },
        };
    }

    fn plan(config: Result) Plan {
        if (!generated) return config.seedPlan();

        const Input = std.meta.Child(entry.Input);

        const input: Input = .{
            .consumer = config.consumer != null,
            .deep = config.deep,
            .inline_lists = config.context.inline_lists,
            .converted = config.converted,
            .discard = config.mode == .discard,
            .by_value = config.by_value,
            .local = config.local,
            .selected = config.selected_state,
        };

        var fixed = std.heap.FixedBufferAllocator.init(&.{});
        const result = zx.columns.invoke(entry.executeValue, fixed.allocator(), &input) catch unreachable;

        return .{ .preparation = result.preparation, .completion = result.completion };
    }
    fn seedPlan(config: Result) Plan {
        if (config.consumer != null) {
            const action: Preparation = if (config.deep)
                if (config.context.inline_lists) .BufferedConsumer else .DeepConsumer

            else if (config.converted)
                .ConvertedConsumer
            else
                .Consumer;

            return .{ .preparation = action, .completion = .Prepared };
        }

        if (config.mode == .discard) return .{ .preparation = .Unit, .completion = .Prepared };

        const action: Preparation = if (config.converted)
            if (config.by_value) .Layout else .Pointer
        else
            .Block;

        const completion: @FieldType(Plan, "completion") = if (config.by_value)
            .Prepared

        else if (!config.local)
            .State
        else if (config.converted)
            .GuardPrepared
        else if (config.selected_state)
            .GuardState
        else if (config.deep)
            .GuardDeep
        else
            .GuardConstruct;

        return .{ .preparation = action, .completion = completion };
    }
};
