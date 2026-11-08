const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const aggregate = @import("../aggregate.zig");
const generated = @import("genz_options").generated_analysis;
const seed = @import("seed.zig");
const policy = @import("policy.zig");
pub const analysis = @import("analysis.zig");
pub const functions = analysis.functions;
pub const containsDescendant = analysis.containsDescendant;

pub fn expression(self: *Lower, id: ir.ExprId) Lower.Error!node.ExpressionId {
    if (!generated) return seed.expression(self, id);

    const selected = policy.dispatch(self, id);
    const value = self.program.expression(id);

    return switch (selected) {
        .Value => self.expr(id),
        .Dereference => self.builder.expression(.{ .dereference = try self.expr(id) }),
        .Capture => @import("../capture.zig").lowerValue(self, value.type_id, value.value.capture),
        .Object => aggregate.objectValue(self, id),
        .Tuple => aggregate.tupleValue(self, value, value.value.tuple),
        .Collection => @import("../collections.zig").lowerValue(self, id, try self.layoutExpr(value.type_id)),
        .Scope => @import("../scope.zig").lowerValue(self, value.value.scope),
        .Iteration => @import("../iteration.zig").lowerValue(self, id, value.value.iteration),
        .Match => @import("../match.zig").lowerValue(self, value.value.match_expr),
        .Conditional => self.builder.expression(.{ .conditional = .{
            .condition = try self.expr(value.value.conditional.condition),
            .yes = try expression(self, value.value.conditional.yes),
            .no = try expression(self, value.value.conditional.no),
        } }),
        .Invocation => invocation(self, value.value.call),
    };
}

pub fn invocation(self: *Lower, value: @FieldType(@FieldType(ir.ExpressionRow, "value"), "call")) Lower.Error!node.ExpressionId {
    if (!generated) return seed.invocation(self, value);

    var body: std.ArrayList(node.Statement) = .empty;
    const result = try lowerInvocation(self, &body, value, false, .layout);

    return aggregate.finish(self, &body, result);
}

pub fn borrowInvocation(self: *Lower, body: *std.ArrayList(node.Statement), value: @FieldType(@FieldType(ir.ExpressionRow, "value"), "call")) Lower.Error!node.ExpressionId {
    if (!generated) return seed.borrowInvocation(self, body, value);

    return lowerInvocation(self, body, value, true, .layout);
}

pub fn pointerInvocation(self: *Lower, value: @FieldType(@FieldType(ir.ExpressionRow, "value"), "call")) Lower.Error!node.ExpressionId {
    if (!generated) return seed.pointerInvocation(self, value);

    var body: std.ArrayList(node.Statement) = .empty;
    const result = try lowerInvocation(self, &body, value, false, .pointer);

    return aggregate.finish(self, &body, result);
}

fn lowerInvocation(self: *Lower, body: *std.ArrayList(node.Statement), value: @FieldType(@FieldType(ir.ExpressionRow, "value"), "call"), borrowed: bool, result_mode: @import("../state_value/conversion.zig").Mode) Lower.Error!node.ExpressionId {
    const plan = policy.invocation(self, value, borrowed, result_mode == .pointer);
    const function = self.program.functions.at(@backingInt(value.function));

    var argument = switch (plan.argument) {
        .Value => try self.expr(value.argument),
        .BorrowObject => try @import("argument.zig").borrow(self, body, value.argument),
        .StackObject => stack: {
            const layout = try aggregate.bind(self, body, try aggregate.objectValue(self, value.argument));

            break :stack try self.builder.expression(.{ .address_of = layout });
        },
    };

    if (plan.legacy) {
        const result = try self.call(try self.functionReference(value.function), &.{ try self.builder.identifier("allocator"), argument }, true);

        return if (plan.legacy_deref) self.builder.expression(.{ .dereference = result }) else result;
    }

    if (plan.transition) {
        argument = try aggregate.bind(self, body, argument);
        argument = try @import("../state_value/conversion.zig").convert(self, body, function.input_type, argument, if (plan.input_value) .value else .borrow);
    }

    if (plan.clip) argument = try @import("../state_value/ownership.zig").clip(self, body, value.argument, argument);

    const callee = try self.requestFunction(value.function, .value);
    const result = try self.call(callee, &.{ try self.builder.identifier("allocator"), argument }, true);

    return switch (plan.result) {
        .Value => result,
        .Dereference => self.builder.expression(.{ .dereference = result }),
        .Borrow => @import("../state_value/conversion.zig").convert(self, body, function.output_type, try aggregate.bind(self, body, result), .borrow),
        .Address => self.builder.expression(.{ .address_of = try aggregate.bind(self, body, result) }),
        .Convert => @import("../state_value/conversion.zig").convert(self, body, function.output_type, try aggregate.bind(self, body, result), result_mode),
        .Construct => self.construct(function.output_type, try aggregate.bind(self, body, result)),
    };
}
