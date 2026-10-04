const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Analyzer = @import("analyzer.zig");
const Binding = @import("analyze.zig").ContextBinding;

pub fn resolve(self: *Analyzer, bindings: []const Binding, span: zx.Span) zx.Error![]const ir.ContextSlot {
    const slots = try self.allocator.alloc(ir.ContextSlot, bindings.len);

    for (bindings, 0..) |binding, index| {
        if (std.mem.trim(u8, binding.id, " \t\r\n").len == 0) return self.reporter.fail(.capability, span, "Context id must not be empty");

        for (bindings[0..index]) |previous| {
            if (std.mem.eql(u8, previous.id, binding.id)) return self.reporter.fail(.capability, span, "Context ids must be unique at a ZX entry");
        }

        if ((binding.type_name != null) == (binding.type_id != null)) return self.reporter.fail(.capability, span, "Context requires exactly one named or resolved type");

        const type_id = if (binding.type_name) |name| try self.types.named(.{ .text = name, .span = span }) else blk: {
            const id = binding.type_id.?;

            if (@intFromEnum(id) >= self.context_type_count) return self.reporter.fail(.capability, span, "Context type id must belong to the supplied shared type table");

            break :blk id;
        };

        if (self.types.get(type_id) != .object) return self.reporter.fail(.capability, span, "Context values must have an object type");

        slots[index] = .{ .id = try self.allocator.dupe(u8, binding.id), .type_id = type_id };
    }

    return slots;
}

pub fn slot(self: *const Analyzer, expression: *const zx.ast.Expression) ?u32 {
    const call = expression.value.call;

    if (call.type_argument != null or call.arguments.len != 1 or call.arguments[0].value != .string) return null;

    const text = call.arguments[0].value.string;

    for (self.contexts, 0..) |binding, index| {
        if (@import("../frontend/string_literal.zig").equal(text[1 .. text.len - 1], binding.id)) return @intCast(index);
    }

    return null;
}

pub fn read(self: *Analyzer, expression: *const zx.ast.Expression) zx.Error!ir.ExprId {
    if (self.lambda_depth != 0) return self.reporter.fail(.capability, expression.span, "a callback cannot capture an injected Context");

    const call = expression.value.call;

    if (call.type_argument != null or call.arguments.len != 1 or call.arguments[0].value != .string) return self.reporter.fail(.capability, expression.span, "useContext requires one literal string id");

    const index = slot(self, expression) orelse return self.reporter.fail(.capability, expression.span, "this Context was not injected at the ZX entry");

    return self.append(.{ .span = expression.span, .type_id = self.contexts[index].type_id, .value = .{ .context_get = index } });
}
