const ir = @import("zx").ir;
const Lower = @import("../../lower.zig");

pub fn eligible(self: *const Lower, id: ir.ExprId, slot: u32) bool {
    const index: usize = @backingInt(id);

    if (index + 1 >= self.plan.slot_first.len) return false;

    const first = self.plan.slot_first[index];
    const end = self.plan.slot_first[index + 1];
    const base = self.plan.slot_first[0];

    if (slot >= end - first) return false;

    const bit = first - base + slot;
    const width = @bitSizeOf(u64);
    const word = bit / width;

    return word < self.plan.transfers.len and self.plan.transfers[word] & (@as(u64, 1) << @intCast(bit % width)) != 0;
}

pub fn needed(self: *const Lower, id: ir.ExprId, type_id: ir.TypeId, slot: u32) bool {
    const target = self.program.typeOf(type_id);

    if (target == .optional) return needed(self, id, target.optional, slot);
    if (!self.state_plan.selected[@backingInt(type_id)]) return false;

    var offset = slot;

    switch (target) {
        .list => return !eligible(self, id, slot),
        .object => |fields| for (0..fields.len) |index| {
            const child = fields.at(index).type_id;

            if (needed(self, id, child, offset)) return true;

            offset += @import("../ownership.zig").count(self, child);
        },
        .tuple => |children| for (0..children.len) |index| {
            const child = children.at(index);

            if (needed(self, id, child, offset)) return true;

            offset += @import("../ownership.zig").count(self, child);
        },
        else => {},
    }

    return false;
}

pub fn outlined(self: *const Lower, id: ir.ExprId, type_id: ir.TypeId, slot: u32) bool {
    if (self.program.typeOf(type_id) == .optional) return false;

    return (leaves(self, id, type_id, slot) orelse return false) >= 2;
}

fn leaves(self: *const Lower, id: ir.ExprId, type_id: ir.TypeId, slot: u32) ?usize {
    if (!needed(self, id, type_id, slot)) return 0;
    if (self.state_plan.referenced(type_id)) return null;

    var offset = slot;
    var total: usize = 0;

    switch (self.program.typeOf(type_id)) {
        .list => return 1,
        .optional => |child| return leaves(self, id, child, slot),
        .object => |fields| for (0..fields.len) |index| {
            const child = fields.at(index).type_id;

            total += leaves(self, id, child, offset) orelse return null;
            offset += @import("../ownership.zig").count(self, child);
        },
        .tuple => |fields| for (0..fields.len) |index| {
            const child = fields.at(index);

            total += leaves(self, id, child, offset) orelse return null;
            offset += @import("../ownership.zig").count(self, child);
        },
        else => {},
    }

    return total;
}
