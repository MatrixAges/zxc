const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const node = @import("../node.zig");
const Lower = @import("lower.zig");
const generated = @import("genz_options").generated_analysis;
const seed = @import("binding/seed.zig");
const before_rule = @import("generated_binding_before");
const after_rule = @import("generated_binding_after");
pub const Route = if (generated) @typeInfo(@typeInfo(@TypeOf(before_rule.executeValue)).@"fn".return_type.?).error_union.payload else seed.Route;
const Plan = if (generated) @typeInfo(@typeInfo(@TypeOf(after_rule.executeValue)).@"fn".return_type.?).error_union.payload else seed.Plan;

pub const Declaration = struct {
    symbol: ?ir.SymbolId,
    value: node.ExpressionId,
    by_value: bool,
    scope: bool = false,
    mutable: bool = false,
};

pub fn before(self: *const Lower, value: ir.ExprId, symbol: ?ir.SymbolId, scope: bool) Route {
    if (!generated) return seed.before(self, value, symbol, scope);

    const Input = std.meta.Child(before_rule.Input);
    const row = @backingInt(value);

    const input: Input = .{
        .kind = @fromBackingInt(@intCast(@backingInt(self.program.expressions.kinds[row]))),
        .type_kind = self.program.types.kinds[self.program.expressions.types[row]],
        .scope = scope,
        .has_symbol = symbol != null,
        .used = if (symbol) |id| self.used[@backingInt(id)] else false,
    };

    var memory = std.heap.FixedBufferAllocator.init(&.{});

    return zx.columns.invoke(before_rule.executeValue, memory.allocator(), &input) catch unreachable;
}

fn after(self: *const Lower, declaration: Declaration) Plan {
    if (!generated) return seed.after(self, declaration.symbol, declaration.by_value, declaration.scope, declaration.mutable);

    const Input = std.meta.Child(after_rule.Input);

    const input: Input = .{
        .has_symbol = declaration.symbol != null,
        .used = if (declaration.symbol) |id| self.used[@backingInt(id)] else false,
        .by_value = declaration.by_value,
        .loop_field = if (declaration.scope and self.loop_fields != null and declaration.symbol != null) self.loop_fields.?.symbol(declaration.symbol.?) else false,
        .mutable = declaration.mutable,
    };

    var memory = std.heap.FixedBufferAllocator.init(&.{});

    return zx.columns.invoke(after_rule.executeValue, memory.allocator(), &input) catch unreachable;
}

pub fn append(self: *Lower, output: *std.ArrayList(node.Statement), declaration: Declaration) Lower.Error!void {
    const plan = after(self, declaration);

    const type_expr: ?node.ExpressionId = switch (plan.type_mode) {
        .None => null,
        .LoopLayout => self.loop_fields.?.layout,
        .Layout => try self.layoutExpr(self.program.symbols.at(@backingInt(declaration.symbol.?)).type_id),
        .Abi => try self.typeExpr(self.program.symbols.at(@backingInt(declaration.symbol.?)).type_id),
    };

    const name = if (plan.type_mode == .None) &.{} else self.names[@backingInt(declaration.symbol.?)];

    if (!generated) return output.append(self.allocator, switch (plan.kind) {
        .constant => .{ .constant = .{ .name = name, .type_expr = type_expr, .value = declaration.value } },
        .variable => .{ .variable = .{ .name = name, .type_expr = type_expr, .value = declaration.value } },
        .discard => .{ .discard = declaration.value },
        else => unreachable,
    });

    const entry = @import("generated_binding_emit");
    const Input = std.meta.Child(entry.Input);

    const input: Input = .{
        .kind = @fromBackingInt(@backingInt(plan.kind)),
        .name = name,
        .type_expr = if (type_expr) |id| @backingInt(id) else null,
        .value = @backingInt(declaration.value),
    };

    var buffer: [std.heap.page_size_min]u8 = undefined;
    var memory = std.heap.FixedBufferAllocator.init(&buffer);
    const rows = zx.columns.view(std.meta.Child(entry.Output), try zx.columns.invoke(entry.executeValue, memory.allocator(), &input));

    @import("../node/import_statements.zig").appendBorrowingText(self.allocator, output, &rows) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        error.InvalidAst => unreachable,
    };
}
