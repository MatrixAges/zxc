const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Analyzer = @import("analyzer.zig");
const Types = @import("types.zig");

pub fn analyze(self: *Analyzer, expression: *const zx.ast.Expression, expected: ?ir.TypeId) zx.Error!ir.ExprId {
    const call = expression.value.call;

    if (call.type_argument != null) return self.reporter.fail(.unsupported, expression.span, "generic calls and database operations are not available");

    if (call.callee.value == .identifier) {
        const name = call.callee.value.identifier;

        if (self.lookup(name.text) != null) return self.reporter.fail(.type_mismatch, name.span, "a local value is not a callable function");

        for (self.active.items[0..self.scope_floor]) |symbol| {
            if (std.mem.eql(u8, self.symbols.items[@intFromEnum(symbol)].name, name.text)) {
                _ = try self.resolveValue(name);
            }
        }

        for (self.function_imports) |function| {
            if (function.namespace != null or !std.mem.eql(u8, function.name, name.text)) continue;

            return importedCall(self, expression, function);
        }

        return self.reporter.fail(.name, name.span, "unknown imported function");
    }

    if (call.callee.value != .field) return self.reporter.fail(.unsupported, expression.span, "only imported functions and collection methods are callable");

    const field = call.callee.value.field;

    if (field.target.value == .identifier) {
        const namespace = field.target.value.identifier;

        if (self.lookup(namespace.text) == null) {
            for (self.active.items[0..self.scope_floor]) |symbol| {
                if (std.mem.eql(u8, self.symbols.items[@intFromEnum(symbol)].name, namespace.text)) {
                    _ = try self.resolveValue(namespace);
                }
            }

            var known_namespace = false;

            for (self.function_imports) |function| {
                const owner = function.namespace orelse continue;

                if (!std.mem.eql(u8, owner, namespace.text)) continue;

                known_namespace = true;

                if (std.mem.eql(u8, function.name, field.name.text)) return importedCall(self, expression, function);
            }

            if (known_namespace) return self.reporter.fail(.name, field.name.span, "unknown module member");
        }
    }

    const target = try self.expression(field.target, null);
    const target_type = self.node(target).type_id;
    const name = field.name.text;

    if (std.mem.eql(u8, name, "clone")) return self.reporter.fail(.unsupported, expression.span, "deep copying is not supported; move an owned value or borrow it read-only");
    if (self.types.get(target_type) != .list) return self.reporter.fail(.type_mismatch, field.name.span, "collection methods require a list");

    const kind = std.meta.stringToEnum(@FieldType(ir.Transform, "kind"), name);

    if (kind) |transform_kind| return @import("transforms.zig").analyze(self, expression, target, transform_kind, expected);

    return @import("list_operations.zig").analyze(self, expression, target);
}

fn importedCall(self: *Analyzer, expression: *const zx.ast.Expression, function: Analyzer.FunctionImport) zx.Error!ir.ExprId {
    if (self.functions[@intFromEnum(function.id)].stores.len != 0) return self.reporter.fail(.capability, expression.span, "Store functions require an explicitly authorized orchestration Call");

    const call = expression.value.call;

    const argument = if (function.positional_types) |parameters| blk: {
        if (parameters.len != call.arguments.len) return self.reporter.fail(.type_mismatch, expression.span, "native argument count does not match its registered signature");

        const values = try self.allocator.alloc(ir.ExprId, parameters.len);

        for (call.arguments, parameters, 0..) |source, type_id, index| values[index] = try self.expression(source, type_id);

        break :blk try self.append(.{ .span = expression.span, .type_id = function.input_type, .value = .{ .tuple = values } });
    } else if (function.input_type == Types.scalarId(.void) and call.arguments.len == 0)
        try self.append(.{ .span = expression.span, .type_id = function.input_type, .value = .unit })

    else blk: {
        if (call.arguments.len != 1) return self.reporter.fail(.type_mismatch, expression.span, "a ZX function requires one Input argument; void Input permits no arguments");

        break :blk try self.expression(call.arguments[0], function.input_type);
    };

    return self.append(.{ .span = expression.span, .type_id = function.output_type, .value = .{ .call = .{ .function = function.id, .argument = argument } } });
}
