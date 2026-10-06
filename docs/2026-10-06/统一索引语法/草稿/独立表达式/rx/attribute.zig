const std = @import("std");
const rx = @import("rx");
const zx = @import("zx");
const frontend = @import("frontend");

pub fn parse(allocator: std.mem.Allocator, attribute: rx.ast.Attribute, owner: []const u8) std.mem.Allocator.Error!frontend.ExpressionInput.Result {
    var result: frontend.ExpressionInput.Result = switch (attribute.kind) {
        .string => .{ .native = try frontend.stringExpression(allocator, attribute.value, owner) },
        .expression => try frontend.parseExpressionInput(allocator, attribute.value, owner),
    };

    errdefer result.deinit();

    if (result.diagnostic() != null) return result;

    if (try validate(allocator, &result)) |issue| {
        var arena = std.heap.ArenaAllocator.init(allocator);

        errdefer arena.deinit();

        var owned = issue;
        owned.message = try arena.allocator().dupe(u8, issue.message);
        owned.message_allocator = null;

        result.deinit();

        return .{ .native = .{ .arena = arena, .value = .{ .diagnostic = owned } } };
    }

    return result;
}

fn validate(allocator: std.mem.Allocator, input: *const frontend.ExpressionInput.Result) std.mem.Allocator.Error!?zx.Diagnostic {
    return switch (input.*) {
        .native => |result| @import("value_rules.zig").validate(result.value.parsed.expression),
        .indexed => |result| if (frontend.ExpressionInput.indexed_enabled) block: {
            var scratch = std.heap.ArenaAllocator.init(allocator);

            defer scratch.deinit();

            const view = try result.view(scratch.allocator());

            break :block @import("value_rules.zig").validate(view.expression(result.output.result));
        } else unreachable,
    };
}
