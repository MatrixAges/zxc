const std = @import("std");
const zx = @import("zx");
const Graph = @import("../types.zig");
const Expression = @import("../expression.zig");

pub fn infer(self: *Expression, source: zx.ast.Block, state_name: []const u8) zx.Error!void {
    const start = self.bindings.items.len;

    defer self.bindings.shrinkRetainingCapacity(start);

    for (source.statements) |statement| {
        const span = self.sourceSpan(statement.span);

        switch (statement.value) {
            .evaluate => |value| _ = try self.infer(value, try self.graph.scalar(.void, span)),
            .constant => |binding| {
                const hint = if (binding.annotation) |annotation| try annotated(self, annotation, span) else null;
                const value = try self.infer(binding.value, hint);

                try bind(self, binding.name, value, state_name, start);
            },
            .destructure => |binding| {
                const elements = try self.graph.allocator.alloc(Graph.Id, binding.names.len);

                for (elements) |*element| element.* = try self.graph.add(.unknown, span);

                _ = try self.infer(binding.value, try self.graph.add(.{ .tuple = elements }, span));

                for (binding.names, elements) |name, value| {
                    if (std.mem.eql(u8, name.text, "_")) continue;
                    try bind(self, name, value, state_name, start);
                }
            },
            .state_update => |update| {
                var target = update.target;

                while (true) {
                    target = switch (target.value) {
                        .field => |field| field.target,
                        .index => |index| index.target,
                        else => break,
                    };
                }

                if (target.value != .identifier or !std.mem.eql(u8, target.value.identifier.text, state_name)) return self.graph.reporter.fail(.ownership, span, "only the loop state parameter can be updated");

                const value = try self.infer(update.target, null);

                if (update.operator != null) try self.graph.restrict(value, Graph.numeric(), span);

                _ = try self.infer(update.value, value);
            },
            .branch => |branch| {
                _ = try self.infer(branch.condition, try self.graph.scalar(.bool, span));

                try infer(self, branch.yes, state_name);
                if (branch.no) |body| try infer(self, body, state_name);
            },
            .switch_stmt => |selection| {
                const subject = try self.infer(selection.subject, null);

                for (selection.cases) |case| {
                    if (case.value) |value| _ = try self.infer(value, subject);
                    try infer(self, case.body, state_name);
                }
            },
            .result => return self.graph.reporter.fail(.return_path, span, "loop steps yield state at the block end; return is not allowed"),
            .store_set => return self.graph.reporter.fail(.capability, span, "Store writes are not allowed in loop callbacks"),
        }
    }
}

fn bind(self: *Expression, name: zx.ast.Name, value: Graph.Id, state_name: []const u8, start: usize) zx.Error!void {
    const span = self.sourceSpan(name.span);

    if (std.mem.eql(u8, name.text, state_name)) return self.graph.reporter.fail(.name, span, "the loop state parameter cannot be redeclared");
    if (std.mem.startsWith(u8, name.text, "$") or std.mem.eql(u8, name.text, "in") or std.mem.eql(u8, name.text, "store") or std.mem.eql(u8, name.text, "_")) return self.graph.reporter.fail(.name, span, "reserved bindings cannot be redeclared");

    for (self.bindings.items[start..]) |binding| {
        if (std.mem.eql(u8, binding.name, name.text)) return self.graph.reporter.fail(.name, span, "duplicate binding in the same scope");
    }

    try self.bindings.append(self.graph.allocator, .{ .name = name.text, .value = value, .span = span });
}

fn annotated(self: *Expression, source: *const zx.ast.Type, span: zx.Span) zx.Error!Graph.Id {
    const type_id = self.graph.types.resolve(source) catch |err| {
        if (err == error.InvalidSource) {
            if (self.graph.reporter.diagnostic) |*diagnostic| diagnostic.span = self.sourceSpan(diagnostic.span);
        }

        return err;
    };

    return self.graph.known(type_id, span);
}
