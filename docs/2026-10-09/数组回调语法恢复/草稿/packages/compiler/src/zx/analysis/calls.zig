const std = @import("std");
const zx = @import("zx");
const syntax = zx.syntax.borrow;
const ir = zx.ir;
const Analyzer = @import("analyzer.zig");
const Types = @import("types.zig");

pub fn analyze(self: *Analyzer, expression: anytype, expected: ?ir.TypeId) zx.Error!ir.ExprId {
    const call = syntax.value(expression).call;
    const callee = syntax.value(call.callee);

    if (call.type_argument != null) return self.reporter.fail(.unsupported, expression.span, "generic calls and database operations are not available");

    if (callee == .identifier) {
        const name = callee.identifier;

        if (self.lookup(name.text) != null) return self.reporter.fail(.type_mismatch, name.span, "a local value is not a callable function");

        for (self.active.items[0..self.scope_floor]) |symbol| {
            if (std.mem.eql(u8, self.symbols.at(@backingInt(symbol)).name, name.text)) {
                _ = try self.resolveValue(name);

                return self.reporter.fail(.type_mismatch, name.span, "a captured value is not a callable function");
            }
        }

        for (self.function_imports) |function| {
            if (function.namespace != null or !std.mem.eql(u8, function.name, name.text)) continue;

            return importedCall(self, expression, function);
        }

        if (std.mem.eql(u8, name.text, "loop")) return @import("iteration/root.zig").analyze(self, expression, expected);
        if (std.mem.eql(u8, name.text, "parallel")) return @import("tasks.zig").parallel(self, expression);

        return self.reporter.fail(.name, name.span, "unknown imported function");
    }

    if (callee != .field) return self.reporter.fail(.unsupported, expression.span, "only imported functions and collection methods are callable");

    const field = callee.field;
    const target_value = syntax.value(field.target);

    if (target_value == .identifier) {
        const namespace = target_value.identifier;

        if (self.lookup(namespace.text) == null) {
            var shadowed = false;

            for (self.active.items[0..self.scope_floor]) |symbol| {
                if (std.mem.eql(u8, self.symbols.at(@backingInt(symbol)).name, namespace.text)) {
                    _ = try self.resolveValue(namespace);
                    shadowed = true;
                }
            }

            var known_namespace = false;

            for (self.function_imports) |function| {
                if (shadowed) continue;

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

fn importedCall(self: *Analyzer, expression: anytype, function: Analyzer.FunctionImport) zx.Error!ir.ExprId {
    const signature = self.functions.at(@backingInt(function.id));

    if (signature.stores.count() != 0) return self.reporter.fail(.capability, expression.span, "Store functions require an explicitly authorized orchestration Call");

    const call = syntax.value(expression).call;
    const expand_tuple = if (signature.external) |external| external.expand_tuple else false;

    const argument = if (expand_tuple) blk: {
        const count = self.types.get(function.input_type).tuple.len;

        if (count != call.arguments.len) return self.reporter.fail(.type_mismatch, expression.span, "native argument count does not match its registered signature");

        const values = try self.allocator.alloc(ir.ExprId, count);

        for (0..count) |index| {
            const parameter = self.types.get(function.input_type).tuple.at(index);

            values[index] = try self.expression(syntax.item(call.arguments, index), parameter);
        }

        break :blk try self.append(.{ .span = expression.span, .type_id = function.input_type, .value = .{ .tuple = values } });
    } else if (function.input_type == Types.scalarId(.void) and call.arguments.len == 0)
        try self.append(.{ .span = expression.span, .type_id = function.input_type, .value = .unit })

    else blk: {
        if (call.arguments.len != 1) return self.reporter.fail(.type_mismatch, expression.span, "a ZX function requires one Input argument; void Input permits no arguments");

        break :blk try self.expression(syntax.item(call.arguments, 0), function.input_type);
    };

    return self.append(.{ .span = expression.span, .type_id = function.output_type, .value = .{ .call = .{ .function = function.id, .argument = argument } } });
}
