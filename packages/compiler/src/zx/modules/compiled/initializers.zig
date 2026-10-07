const std = @import("std");
const model = @import("../compiled.zig");

pub fn validate(allocator: std.mem.Allocator, library: model.Graph) (std.mem.Allocator.Error || error{InvalidLibrary})!void {
    const program = library.program;
    var identities: std.StringHashMapUnmanaged(void) = .empty;

    for (library.store_initializers) |initial| {
        if (!std.mem.startsWith(u8, initial.identity, "store.") or initial.identity.len == "store.".len or std.mem.indexOfScalar(u8, initial.identity, 0) != null or !std.unicode.utf8ValidateSlice(initial.identity)) return error.InvalidLibrary;
        if ((try identities.getOrPut(allocator, initial.identity)).found_existing) return error.InvalidLibrary;
        if (@backingInt(initial.function) >= program.functions.count()) return error.InvalidLibrary;

        const function = program.functions.at(@backingInt(initial.function));
        const input_type = program.typeOf(function.input_type);

        if (input_type != .scalar or input_type.scalar != .void or program.typeOf(function.output_type) != .object) return error.InvalidLibrary;
        if (function.external != null or function.stores.count() != 0 or function.contracts.count() != 0) return error.InvalidLibrary;

        for (0..function.expressions.count()) |expression_index| {
            const expression = function.expressions.at(expression_index);

            if (expression.value == .call) return error.InvalidLibrary;
        }

        var found = false;

        for (0..program.functions.count()) |owner_row| {
            const owner = program.functions.at(owner_row);

            for (0..owner.stores.count()) |store_index| {
                const slot = owner.stores.at(store_index);

                if (!std.mem.eql(u8, slot.path, initial.identity)) continue;
                if (slot.type_id != function.output_type) return error.InvalidLibrary;

                found = true;
            }
        }

        if (!found) return error.InvalidLibrary;
    }
}
