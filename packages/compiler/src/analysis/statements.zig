const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Analyzer = @import("analyzer.zig");
const Types = @import("types.zig");

pub fn block(self: *Analyzer, value: zx.ast.Block) zx.Error![]const ir.Statement {
    const scope_start = self.active.items.len;

    defer self.active.shrinkRetainingCapacity(scope_start);

    var result: std.ArrayList(ir.Statement) = .empty;

    for (value.statements) |statement| {
        if (Analyzer.returns(result.items)) return self.reporter.fail(.return_path, statement.span, "unreachable statement after a terminating branch or return");

        switch (statement.value) {
            .constant => |binding| {
                try bindingName(self, binding.name);

                const annotation = if (binding.annotation) |type_node| try self.types.resolve(type_node) else null;
                const initializer = try self.expression(binding.value, annotation);

                if (self.node(initializer).type_id == Types.scalarId(.void)) return self.reporter.fail(.type_mismatch, binding.name.span, "void results cannot be bound to a value");

                const symbol = try self.bind(binding.name, self.node(initializer).type_id, scope_start);

                try result.append(self.allocator, .{ .constant = .{ .symbol = symbol, .value = initializer } });
            },
            .destructure => |binding| {
                const initializer = try self.expression(binding.value, null);
                const value_type = self.types.get(self.node(initializer).type_id);

                if (value_type != .tuple or value_type.tuple.len != binding.names.len) return self.reporter.fail(.type_mismatch, statement.span, "tuple destructuring must match every result slot; use _ to discard a slot");

                const symbols = try self.allocator.alloc(?ir.SymbolId, binding.names.len);

                for (binding.names, value_type.tuple, 0..) |name, type_id, index| {
                    if (std.mem.eql(u8, name.text, "_")) {
                        symbols[index] = null;
                    } else {
                        try bindingName(self, name);
                        if (type_id == Types.scalarId(.void)) return self.reporter.fail(.type_mismatch, name.span, "void tuple results must be discarded with _");

                        symbols[index] = try self.bind(name, type_id, scope_start);
                    }
                }

                try result.append(self.allocator, .{ .destructure = .{ .symbols = symbols, .value = initializer } });
            },
            .result => |source| {
                const id = if (source) |expression| try self.expression(expression, self.output_type) else null;

                if (id == null and self.output_type != Types.scalarId(.void)) return self.reporter.fail(.type_mismatch, statement.span, "return must provide Output");
                try result.append(self.allocator, .{ .result = id });
            },
            .branch => |branch| {
                const condition = try self.expression(branch.condition, Types.scalarId(.bool));
                const yes = try block(self, branch.yes);
                const no = if (branch.no) |body| try block(self, body) else &.{};

                try result.append(self.allocator, .{ .branch = .{ .condition = condition, .yes = yes, .no = no } });
            },
            .switch_stmt => |selection| try result.append(self.allocator, try @import("switch.zig").analyze(self, selection.subject, selection.cases)),
            .store_set => |setter| {
                if (!self.allow_store or self.lambda_depth != 0) return self.reporter.fail(.capability, statement.span, "Store writes require the explicit setter parameter and cannot occur in a lambda");

                const authorized = try @import("store.zig").writeSlot(self, setter.target);
                const value_id = try self.expression(setter.value, self.stores[authorized].type_id);

                try result.append(self.allocator, .{ .store_set = .{ .slot = authorized, .value = value_id } });
            },
        }
    }

    return result.toOwnedSlice(self.allocator);
}

fn bindingName(self: *Analyzer, name: zx.ast.Name) zx.Error!void {
    if (std.mem.startsWith(u8, name.text, "$") or std.mem.eql(u8, name.text, "in") or std.mem.eql(u8, name.text, "store") or std.mem.eql(u8, name.text, "_")) {
        return self.reporter.fail(.name, name.span, "reserved bindings cannot be redeclared; _ is only a tuple discard pattern");
    }
}
