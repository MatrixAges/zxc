const std = @import("std");
const ir = @import("zx").ir;
const generating = @import("genz");
const Library = @import("../../../library/root.zig").Result;
const Bundle = @import("../library.zig").Bundle;
const names = @import("../names.zig");
pub const Result = struct { objects: []const generating.zx.state.Object, services: []const generating.gateway.Service };
pub const Error = names.Error || error{ InvalidModule, ConflictingStore, MissingInitializer, InvalidInitializer };

pub fn create(allocator: std.mem.Allocator, library: *const Library, bundle: Bundle) Error!Result {
    if (library.exports.len != bundle.public_modules.len) return error.InvalidModule;

    const independent = try @import("frontend").storesOwnValues(allocator, library.program);
    const identities = try names.create(allocator, library.program, library.nominal_types);
    const io_functions = try generating.zx.capabilities.functions(allocator, library.program, .io);
    const process_functions = try generating.zx.capabilities.functions(allocator, library.program, .process);
    const services = try allocator.alloc(generating.gateway.Service, library.exports.len);
    var objects: std.ArrayList(generating.zx.state.Object) = .empty;
    var slots: std.StringHashMapUnmanaged(struct { index: usize, type_id: ir.TypeId }) = .empty;

    defer slots.deinit(allocator);

    for (library.exports, bundle.public_modules, services, 0..) |exported, facade, *service, index| {
        if (!std.mem.eql(u8, exported.name, facade.name) or exported.function == null) return error.InvalidModule;

        const program = try library.module(index);
        const bindings = try allocator.alloc(generating.gateway.Slot, program.stores.len);

        for (program.stores, bindings) |slot, *binding| {
            const entry = try slots.getOrPut(allocator, slot.path);

            if (entry.found_existing) {
                if (entry.value_ptr.type_id != slot.type_id) return error.ConflictingStore;
            } else {
                const initial = for (bundle.store_initializers) |candidate| {
                    if (std.mem.eql(u8, candidate.identity, slot.path)) break candidate;
                } else return error.MissingInitializer;

                if (!std.mem.eql(u8, initial.type_name, identities.types[@backingInt(slot.type_id)])) return error.InvalidInitializer;

                entry.value_ptr.* = .{ .index = objects.items.len, .type_id = slot.type_id };

                try objects.append(allocator, .{ .module_name = initial.module_name, .writable = false, .independent = independent });
            }

            const global = entry.value_ptr.index;
            objects.items[global].writable = objects.items[global].writable or slot.writable;
            binding.* = .{ .index = global, .writable = slot.writable };
        }

        service.* = .{
            .name = facade.name,
            .module_name = facade.file.name,
            .slots = bindings,
            .requires_io = generating.zx.io.uses(program.expressions, program.contracts, io_functions),
            .requires_process = generating.zx.capabilities.uses(program.expressions, program.contracts, process_functions),
        };
    }

    return .{ .objects = try objects.toOwnedSlice(allocator), .services = services };
}
