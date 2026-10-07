const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");

pub fn statement(self: *Lower, statements: ir.Block, index: usize) Lower.Error!?node.Statement {
    if (self.program.store_mode != .orchestration or self.program.stores.count() == 0) return null;

    const first = value(self, statements.at(index)) orelse return null;

    if (first != .store_get and first != .call) return null;
    if (index > 0) if (value(self, statements.at(index - 1))) |previous| if (previous == .store_get) return null;

    var slots: std.ArrayList(u32) = .empty;
    var cursor = index;

    while (cursor < statements.len) : (cursor += 1) {
        const expression = value(self, statements.at(cursor)) orelse break;

        switch (expression) {
            .store_get => |slot| try append(self, &slots, slot),
            .call => |call| {
                const target = self.program.functions[@backingInt(call.function)];

                if (target.store_mode == .transaction) for (call.stores) |slot| try append(self, &slots, slot);

                break;
            },
            else => break,
        }
    }

    if (slots.items.len == 0) return null;

    self.uses_context = true;

    return try invoke(self, try self.builder.identifier("context"), try array(self, slots.items));
}

pub fn invoke(self: *Lower, context: *const node.Expression, slots: *const node.Expression) Lower.Error!node.Statement {
    const meta = try self.field(try self.builder.identifier("std"), "meta");
    const supported = try self.call(try self.field(meta, "hasMethod"), &.{ try self.builtin(.TypeOf, &.{context}), try self.builder.string("begin") }, false);
    const call = try self.call(try self.field(context, "begin"), &.{slots}, true);

    return .{ .branch = .{ .condition = try self.builder.expression(.{ .comptime_value = supported }), .yes = try self.allocator.dupe(node.Statement, &.{.{ .expression = call }}), .no = &.{} } };
}

pub fn array(self: *Lower, slots: []const u32) Lower.Error!*const node.Expression {
    const values = try self.allocator.alloc(*const node.Expression, slots.len);

    for (slots, values) |slot, *item| item.* = try self.builder.expression(.{ .integer = slot });

    return self.builder.expression(.{ .array = .{ .element_type = try self.builder.expression(.{ .primitive = .u32 }), .values = values } });
}

fn value(self: *Lower, statement_value: ir.StatementRow) ?@FieldType(ir.ExpressionRow, "value") {
    const id = switch (statement_value) {
        .constant => |binding| binding.value,
        .evaluate => |id| id,
        else => return null,
    };

    return self.program.expression(id).value;
}

fn append(self: *Lower, slots: *std.ArrayList(u32), slot: u32) Lower.Error!void {
    if (std.mem.indexOfScalar(u32, slots.items, slot) == null) try slots.append(self.allocator, slot);
}
