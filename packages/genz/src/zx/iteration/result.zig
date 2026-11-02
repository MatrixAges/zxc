const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const aggregate = @import("../aggregate.zig");
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
        const consumer = config.consumer;
        const deep = config.deep;
        const context = config.context;
        const type_id = config.type_id;
        const by_value = config.by_value;
        const local = config.local;
        const selected_state = config.selected_state;
        const initial = config.initial;
        const changed_name = config.changed_name;
        const mode = config.mode;

        if (consumer) |selected| {
            if (deep) {
                if (context.inline_lists) return aggregate.finish(self, body, try @import("../iteration_value/result.zig").buffered(context, body, selected, state));

                const result = try @import("../iteration_value/result.zig").lower(self, selected, state);

                return try aggregate.finish(self, body, result);
            }

            var result = try @import("../iteration_consumer.zig").read(self, selected, selected.result, state);

            if (config.converted) {
                const bound = try aggregate.bind(self, body, result);
                result = try @import("../state_value/conversion.zig").convert(self, body, self.program.expression(selected.result).type_id, bound, .pointer);
            }

            return try aggregate.finish(self, body, result);
        }

        if (mode == .discard) return try aggregate.finish(self, body, try self.builder.expression(.unit));

        var converted_body: std.ArrayList(node.Statement) = .empty;
        const converted_state = if (config.converted) try @import("../state_value/conversion.zig").convert(self, &converted_body, type_id, state, if (by_value) .layout else .pointer) else state;
        const boundary = try aggregate.finish(self, &converted_body, converted_state);

        const result = if (by_value) boundary else if (local) try self.builder.expression(.{ .conditional = .{
            .condition = try self.builder.identifier(changed_name),
            .yes = if (config.converted) boundary else if (selected_state) state else if (deep) try @import("../iteration_value/conversion.zig").convert(context, type_id, state, true) else try self.construct(type_id, state),
            .no = initial,
        } }) else state;

        return try aggregate.finish(self, body, result);
    }
};
