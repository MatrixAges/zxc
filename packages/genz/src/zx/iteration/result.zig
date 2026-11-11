const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const aggregate = @import("../aggregate.zig");
const generated = @import("genz_options").generated_analysis;
const entry = if (generated) @import("generated_iteration_result_route") else struct {};

const Route = if (generated)
    @typeInfo(@typeInfo(@TypeOf(entry.executeValue)).@"fn".return_type.?).error_union.payload

else
    enum { BufferedConsumer, DeepConsumer, ConvertedConsumer, Consumer, Discard, Value, Reference, ConvertedGuard, SelectedGuard, DeepGuard, ConstructGuard };

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
        const selected = config.route();

        switch (selected) {
            .BufferedConsumer => return aggregate.finish(self, body, try @import("../iteration_value/result.zig").buffered(config.context, body, config.consumer.?, state)),
            .DeepConsumer => return aggregate.finish(self, body, try @import("../iteration_value/result.zig").lower(self, config.consumer.?, state)),
            .Consumer, .ConvertedConsumer => {
                const consumer = config.consumer.?;
                var result = try @import("../iteration_consumer.zig").read(self, consumer, consumer.result, state);

                if (selected == .ConvertedConsumer) {
                    const bound = try aggregate.bind(self, body, result);
                    result = try @import("../state_value/conversion.zig").convert(self, body, self.program.expression(consumer.result).type_id, bound, .pointer);
                }

                return try aggregate.finish(self, body, result);
            },
            .Discard => return aggregate.finish(self, body, try self.builder.expression(.unit)),
            else => {},
        }

        const boundary = if (!generated or config.converted or selected == .Value) converted: {
            var converted_body: std.ArrayList(node.Statement) = .empty;
            const converted_state = if (config.converted) try @import("../state_value/conversion.zig").convert(self, &converted_body, config.type_id, state, if (selected == .Value) .layout else .pointer) else state;

            break :converted try aggregate.finish(self, &converted_body, converted_state);
        } else unused: {
            // Preserve later label numbers without storing an unreachable result block.
            self.serial = std.math.add(usize, self.serial, 1) catch return error.OutOfMemory;

            break :unused state;
        };

        switch (selected) {
            .Value => return aggregate.finish(self, body, boundary),
            .Reference => return aggregate.finish(self, body, state),
            else => {},
        }

        const condition = try self.builder.identifier(config.changed_name);

        const result = switch (selected) {
            .ConvertedGuard => boundary,
            .SelectedGuard => state,
            .DeepGuard => try @import("../iteration_value/conversion.zig").convert(config.context, config.type_id, state, true),
            .ConstructGuard => try self.construct(config.type_id, state),
            else => unreachable,
        };

        return aggregate.finishGuarded(self, body, condition, result, config.initial);
    }
    fn route(config: Result) Route {
        if (!generated) {
            if (config.consumer != null) {
                if (config.deep) return if (config.context.inline_lists) .BufferedConsumer else .DeepConsumer;

                return if (config.converted) .ConvertedConsumer else .Consumer;
            }

            if (config.mode == .discard) return .Discard;
            if (config.by_value) return .Value;
            if (!config.local) return .Reference;
            if (config.converted) return .ConvertedGuard;
            if (config.selected_state) return .SelectedGuard;
            if (config.deep) return .DeepGuard;

            return .ConstructGuard;
        }

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

        return zx.columns.invoke(entry.executeValue, fixed.allocator(), &input) catch unreachable;
    }
};
