const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const aggregate = @import("../aggregate.zig");
const generated = @import("genz_options").generated_analysis;
const seed = @import("seed.zig");
const policy = @import("policy.zig");
const emission = @import("emission.zig");
pub const analysis = @import("analysis.zig");
pub const functions = analysis.functions;
pub const containsDescendant = analysis.containsDescendant;

pub fn expression(self: *Lower, id: ir.ExprId) Lower.Error!node.ExpressionId {
    if (!generated) return seed.expression(self, id);

    const selected = policy.dispatch(self, id);
    const value = self.program.expression(id);

    return switch (selected) {
        .Value => self.expr(id),
        .Dereference => emission.emit(self, null, .Dereference, .{ .value = try self.expr(id) }),
        .Capture => @import("../capture.zig").lowerValue(self, value.type_id, value.value.capture),
        .Object => aggregate.objectValue(self, id),
        .Tuple => aggregate.tupleValue(self, value, value.value.tuple),
        .Collection => @import("../collections.zig").lowerValue(self, id, try self.layoutExpr(value.type_id)),
        .Scope => @import("../scope.zig").lowerValue(self, value.value.scope),
        .Iteration => @import("../iteration.zig").lowerValue(self, id, value.value.iteration),
        .Match => @import("../match.zig").lowerValue(self, value.value.match_expr),
        .Conditional => conditional: {
            const condition = try self.expr(value.value.conditional.condition);
            const yes = try expression(self, value.value.conditional.yes);
            const no = try expression(self, value.value.conditional.no);

            break :conditional emission.emit(self, null, .Conditional, .{ .condition = condition, .yes = yes, .no = no });
        },
        .Invocation => invocation(self, value.value.call),
    };
}

pub fn invocation(self: *Lower, value: @FieldType(@FieldType(ir.ExpressionRow, "value"), "call")) Lower.Error!node.ExpressionId {
    if (!generated) return seed.invocation(self, value);

    var body: std.ArrayList(node.Statement) = .empty;
    const result = try lowerInvocation(self, &body, value, false, .layout);

    return emission.emit(self, &body, .Block, .{ .value = result });
}

pub fn borrowInvocation(self: *Lower, body: *std.ArrayList(node.Statement), value: @FieldType(@FieldType(ir.ExpressionRow, "value"), "call")) Lower.Error!node.ExpressionId {
    if (!generated) return seed.borrowInvocation(self, body, value);

    return lowerInvocation(self, body, value, true, .layout);
}

pub fn pointerInvocation(self: *Lower, value: @FieldType(@FieldType(ir.ExpressionRow, "value"), "call")) Lower.Error!node.ExpressionId {
    if (!generated) return seed.pointerInvocation(self, value);

    var body: std.ArrayList(node.Statement) = .empty;
    const result = try lowerInvocation(self, &body, value, false, .pointer);

    return emission.emit(self, &body, .Block, .{ .value = result });
}

fn lowerInvocation(self: *Lower, body: *std.ArrayList(node.Statement), value: @FieldType(@FieldType(ir.ExpressionRow, "value"), "call"), borrowed: bool, result_mode: @import("../state_value/conversion.zig").Mode) Lower.Error!node.ExpressionId {
    const plan = policy.invocation(self, value, borrowed, result_mode == .pointer);
    const function = self.program.functions.at(@backingInt(value.function));

    var argument = switch (plan.argument) {
        .Value => try self.expr(value.argument),
        .BorrowObject => try @import("argument.zig").borrow(self, body, value.argument),
        .StackObject => try emission.emit(self, body, .Stack, .{ .value = try aggregate.objectValue(self, value.argument) }),
    };

    if (plan.legacy) {
        const callee = try self.functionReference(value.function);

        return emission.emit(self, body, .Invoke, .{ .callee = callee, .value = argument, .plan = plan });
    }

    if (plan.transition) {
        argument = try emission.emit(self, body, .Bind, .{ .value = argument });
        argument = try @import("../state_value/conversion.zig").convert(self, body, function.input_type, argument, if (plan.input_value) .value else .borrow);
    }

    if (plan.clip) argument = try @import("../state_value/ownership.zig").clip(self, body, value.argument, argument);

    const callee = try self.requestFunction(value.function, .value);
    const result = try emission.emit(self, body, .Invoke, .{ .callee = callee, .value = argument, .plan = plan });

    return switch (plan.result) {
        .Borrow => @import("../state_value/conversion.zig").convert(self, body, function.output_type, result, .borrow),
        .Convert => @import("../state_value/conversion.zig").convert(self, body, function.output_type, result, result_mode),
        .Construct => self.construct(function.output_type, result),
        else => result,
    };
}
