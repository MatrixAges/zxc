const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const types = @import("../types.zig");
const aggregate = @import("../aggregate.zig");
const conversion = @import("../state_value/conversion.zig");

pub fn declarations(self: *Lower, output: *std.ArrayList(node.Declaration)) Lower.Error!bool {
    const represented_output = self.state_plan.represented(self.program, self.program.output_type);
    const represented_input = self.state_plan.represented(self.program, self.program.input_type) or self.state_plan.inlineRows(self.program, self.program.input_type);

    if (self.entry_flags.tasks or (!represented_output and !represented_input)) return false;

    if (if (represented_output) forwarded(self) else null) |function| {
        try output.append(self.allocator, .{ .constant = .{
            .name = "executeState",
            .value = try self.requestFunction(function, .value),
            .exported = true,
        } });

        return false;
    }

    var state = try self.functionValue("executeState");

    state.function.exported = true;

    try output.append(self.allocator, state);
    try output.append(self.allocator, try view(self, state.function));

    return true;
}

fn forwarded(self: *const Lower) ?ir.FunctionId {
    const statements = self.program.body.block();

    if (self.program.stores.count() != 0 or self.program.contracts.count() != 0 or statements.len != 1) return null;

    const statement = statements.at(0);

    if (statement != .result) return null;

    const result = statement.result orelse return null;
    const expression = self.program.expression(result);

    if (expression.value != .call) return null;

    const call = expression.value.call;
    const function = self.program.functions.at(@backingInt(call.function));
    const argument = self.program.expression(call.argument).value;

    for ([_]ir.ExprId{ call.argument, result }) |id| {
        const flags = self.plan.get(id);

        if (flags.normalize or flags.renew or @import("../state_value/ownership.zig").needsClip(self, id)) return null;
    }

    if (!self.value_functions[@backingInt(call.function)] or function.stores.count() != 0) return null;
    if (function.input_type != self.program.input_type or function.output_type != self.program.output_type) return null;

    if (argument != .reference or @backingInt(argument.reference) != 0) {
        if (argument != .unit or self.program.typeOf(function.input_type) != .scalar or self.program.typeOf(function.input_type).scalar != .void) return null;
    }

    return call.function;
}

fn view(self: *Lower, state: node.Function) Lower.Error!node.Declaration {
    const saved = try @import("../state_value/root.zig").enter(self);

    defer saved.restore();

    self.reference_storage = .empty;

    const parameters = try self.allocator.dupe(node.Field, state.parameters);
    parameters[1].value = try types.get(self, self.view_types, self.program.input_type);
    const arguments = try self.allocator.alloc(node.ExpressionId, parameters.len);
    var body: std.ArrayList(node.Statement) = .empty;

    for (parameters, arguments) |parameter, *argument| argument.* = try self.builder.identifier(parameter.name);

    arguments[1] = try conversion.convert(self, &body, self.program.input_type, arguments[1], .view_value);
    const result = try aggregate.bind(self, &body, try self.call(try self.builder.identifier(state.name), arguments, true));
    const returned = try conversion.convert(self, &body, self.program.output_type, result, .view_layout);
    var statements: std.ArrayList(node.Statement) = .empty;

    try statements.appendSlice(self.allocator, self.reference_storage.items);
    try statements.appendSlice(self.allocator, body.items);
    try statements.append(self.allocator, .{ .result = returned });

    var errors = self.builder.nodes.get(state.return_type).error_union;

    errors.payload = try types.get(self, self.view_types, self.program.output_type);

    return .{ .function = .{
        .name = "executeValue",
        .parameters = parameters,
        .return_type = try self.builder.expression(.{ .error_union = errors }),
        .body = try self.builder.statements(statements.items),
        .exported = true,
        .inlined = state.inlined,
    } };
}
