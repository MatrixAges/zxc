const std = @import("std");
const zx = @import("zx");
const syntax = zx.syntax.borrow;
const ir = zx.ir;
const Analyzer = @import("analyzer.zig");
const Types = @import("types.zig");

pub fn block(self: *Analyzer, value: anytype) zx.Error!ir.BlockId {
    const scope_start = self.active.items.len;
    const facts = self.refinement.mark();

    defer self.active.shrinkRetainingCapacity(scope_start);
    defer self.refinement.restore(facts);

    var result: std.ArrayList(ir.Statement) = .empty;

    defer result.deinit(self.allocator);

    for (0..value.statements.len) |statement_index| {
        const statement = syntax.item(value.statements, statement_index);

        if (self.control.terminates(result.items)) return self.reporter.fail(.return_path, statement.span, "unreachable statement after a terminating branch or return");

        switch (statement.value) {
            .state_update => return self.reporter.fail(.unsupported, statement.span, "state updates are only allowed in loop"),
            .evaluate => |source| {
                const id = try evaluate(self, source);

                try result.append(self.allocator, .{ .evaluate = id });
            },
            .constant => |binding| {
                try bindingName(self, binding.name);

                const annotation = if (binding.annotation) |type_node| try self.resolveType(type_node) else null;
                const initializer = try self.expression(binding.value, annotation);

                if (self.types.get(self.node(initializer).type_id) == .task and self.node(initializer).value != .task) return self.reporter.fail(.ownership, binding.name.span, "a task binding must create its own task; task handles cannot be copied");
                if (self.node(initializer).type_id == Types.scalarId(.void)) return self.reporter.fail(.type_mismatch, binding.name.span, "void results cannot be bound to a value");

                const symbol = try self.bind(binding.name, self.node(initializer).type_id, scope_start);

                try result.append(self.allocator, .{ .constant = .{ .symbol = symbol, .value = initializer } });
            },
            .destructure => |binding| {
                const initializer = try self.expression(binding.value, null);
                const value_type = self.types.get(self.node(initializer).type_id);

                if (value_type != .tuple or value_type.tuple.len != binding.names.len) return self.reporter.fail(.type_mismatch, statement.span, "tuple destructuring must match every result slot; use _ to discard a slot");

                const symbols = try self.allocator.alloc(?ir.SymbolId, binding.names.len);

                for (0..value_type.tuple.len, 0..) |view_index, index| {
                    const type_id = value_type.tuple.at(view_index);
                    const name = syntax.item(binding.names, index);

                    if (std.mem.eql(u8, name.text, "_")) {
                        symbols[index] = null;
                    } else {
                        try bindingName(self, name);
                        if (type_id == Types.scalarId(.void)) return self.reporter.fail(.type_mismatch, name.span, "void tuple results must be discarded with _");

                        symbols[index] = try self.bind(name, type_id, scope_start);
                    }
                }

                try result.append(self.allocator, .{ .destructure = .{ .symbols = symbols, .value = initializer } });
                try self.refinement.bind(self.allocator, self.node(initializer), symbols);
            },
            .result => |source| {
                const id = if (source) |expression| try self.expression(expression, self.output_type) else null;

                if (id == null and self.output_type != Types.scalarId(.void)) return self.reporter.fail(.type_mismatch, statement.span, "return must provide Output");
                try result.append(self.allocator, .{ .result = id });
            },
            .branch => |branch| {
                const condition = try self.expression(branch.condition, Types.scalarId(.bool));
                const before = self.refinement.mark();

                try self.refinement.assume(self.allocator, self.nodes.view(), condition, true);

                const yes = try block(self, branch.yes);

                self.refinement.restore(before);

                try self.refinement.assume(self.allocator, self.nodes.view(), condition, false);

                const no = if (branch.no) |body| try block(self, body) else try self.control.appendBlock(self.allocator, &.{});

                self.refinement.restore(before);

                if (self.control.returns(yes)) try self.refinement.assume(self.allocator, self.nodes.view(), condition, false);
                if (self.control.returns(no)) try self.refinement.assume(self.allocator, self.nodes.view(), condition, true);
                try result.append(self.allocator, .{ .branch = .{ .condition = condition, .yes = yes, .no = no } });
            },
            .switch_stmt => |selection| try result.append(self.allocator, try @import("switch.zig").analyze(self, selection.subject, selection.cases)),
            .store_set => |setter| {
                if (!self.allow_store or self.lambda_depth != 0) return self.reporter.fail(.capability, statement.span, "Store writes require the explicit setter parameter and cannot occur in a lambda");

                const authorized = try @import("store.zig").writeSlot(self, setter.target);
                const value_id = try self.expression(setter.value, self.stores.at(authorized).type_id);

                try result.append(self.allocator, .{ .store_set = .{ .slot = authorized, .value = value_id } });
            },
        }
    }

    return self.control.appendBlock(self.allocator, result.items);
}

pub fn bindingName(self: *Analyzer, name: zx.ast.Name) zx.Error!void {
    if (std.mem.startsWith(u8, name.text, "$") or std.mem.eql(u8, name.text, "in") or std.mem.eql(u8, name.text, "store") or std.mem.eql(u8, name.text, "_")) {
        return self.reporter.fail(.name, name.span, "reserved bindings cannot be redeclared; _ is only a tuple discard pattern");
    }
}

pub fn evaluate(self: *Analyzer, source: anytype) zx.Error!ir.ExprId {
    const id = try self.expression(source, null);

    if (self.node(id).value == .iteration) return id;

    return self.coerce(id, Types.scalarId(.void), source.span);
}
