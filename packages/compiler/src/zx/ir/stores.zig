const std = @import("std");
const ir = @import("zx").ir;

pub fn validate(allocator: std.mem.Allocator, program: ir.Program) std.mem.Allocator.Error!bool {
    if (program.type_only and program.stores.count() != 0) return false;

    for (0..program.stores.count()) |index| {
        const slot = program.stores.at(index);

        if (@backingInt(slot.type_id) >= program.types.count() or program.typeOf(slot.type_id) != .object or !std.mem.startsWith(u8, slot.path, "store.")) return false;
        if (try ir.containsNativeReference(allocator, program.types, slot.type_id)) return false;

        for (program.stores.paths[0..index]) |previous| {
            if (std.mem.eql(u8, previous, slot.path)) return false;
        }
    }

    return true;
}

pub fn call(program: ir.Program, invocation: @FieldType(@FieldType(ir.ExpressionRow, "value"), "call")) bool {
    const target = program.functions[@backingInt(invocation.function)];

    if (invocation.stores.len != target.stores.count()) return false;
    if (target.stores.count() != 0 and program.store_mode != .orchestration) return false;

    for (invocation.stores, 0..) |id, index| {
        const required = target.stores.at(index);

        if (id >= program.stores.count()) return false;

        const available = program.stores.at(id);

        if (available.type_id != required.type_id or !std.mem.eql(u8, available.path, required.path)) return false;
        if ((required.readable and !available.readable) or (required.writable and !available.writable)) return false;

        for (invocation.stores[0..index]) |previous| if (previous == id) {
            return false;
        };
    }

    return true;
}
