const std = @import("std");
const node = @import("../node.zig");
const Lower = @import("lower.zig");
const types = @import("types.zig");
const aggregate = @import("aggregate.zig");
const conversion = @import("state_value/conversion.zig");
const emit = @import("entry/emitting.zig");

pub fn declarations(self: *Lower, output: *std.ArrayList(node.Declaration), name: []const u8) Lower.Error!bool {
    if (!emit.generated) return @import("entry/state_seed.zig").declarations(self, output);

    if (@import("entry/policy.zig").forwarded(self)) |function| {
        try output.append(self.allocator, try emit.alias(self, true, try self.requestFunction(function, .value)));

        return false;
    }

    var state = try self.functionValue(name);

    state.function.exported = true;

    try output.append(self.allocator, state);
    try output.append(self.allocator, try view(self, state.function));

    return true;
}

fn view(self: *Lower, state: node.Function) Lower.Error!node.Declaration {
    const saved = try @import("state_value/root.zig").enter(self);

    defer saved.restore();

    self.reference_storage = .empty;

    const input_type = try types.get(self, self.view_types, self.program.input_type);
    const prepared = try emit.prepare(self, state.parameters, input_type);
    const arguments = prepared.arguments;
    var body: std.ArrayList(node.Statement) = .empty;
    arguments[1] = try conversion.convert(self, &body, self.program.input_type, arguments[1], .view_value);

    const result = try aggregate.bind(self, &body, try emit.call(self, state.name, arguments));
    const returned = try conversion.convert(self, &body, self.program.output_type, result, .view_layout);
    const output_type = try types.get(self, self.view_types, self.program.output_type);
    const tail = try emit.finish(self, state, returned, output_type);
    var statements: std.ArrayList(node.Statement) = .empty;

    try statements.appendSlice(self.allocator, self.reference_storage.items);
    try statements.appendSlice(self.allocator, body.items);
    try statements.appendSlice(self.allocator, tail.statements);

    return .{ .function = .{
        .name = tail.name,
        .parameters = prepared.parameters,
        .return_type = tail.return_type,
        .body = try self.builder.statements(statements.items),
        .exported = true,
        .inlined = tail.inlined,
    } };
}
