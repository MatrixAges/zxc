const std = @import("std");
const zx = @import("zx");
const generating = @import("genz");
const Library = @import("../../../library/root.zig").Result;
const Bundle = @import("../library.zig").Bundle;
const names = @import("../names.zig");
pub const Result = @import("state_seed.zig").Result;
pub const Error = @import("state_seed.zig").Error;

pub fn create(allocator: std.mem.Allocator, library: *const Library, bundle: Bundle) Error!Result {
    if (comptime !@import("parser_options").generated_parser) return @import("state_seed.zig").create(allocator, library, bundle);
    if (library.exports.len != bundle.public_modules.len) return error.InvalidModule;

    const independent = try @import("frontend").storesOwnValues(allocator, library.program);
    const identities = try names.create(allocator, bundle.arena.child_allocator, library.program, library.nominal_types);
    const entry = @import("generated_gateway_bindings");
    const Input = std.meta.Child(entry.Input);
    const MemberRef = std.meta.Child(@FieldType(Input, "members"));
    const Member = if (@typeInfo(MemberRef) == .pointer) std.meta.Child(MemberRef) else MemberRef;
    const Types = std.meta.Child(@FieldType(Input, "types"));
    const Functions = std.meta.Child(@FieldType(Input, "functions"));
    var scratch = std.heap.ArenaAllocator.init(bundle.arena.child_allocator);

    defer scratch.deinit();

    const temporary = scratch.allocator();
    const members = try temporary.alloc(MemberRef, library.exports.len);

    for (library.exports, bundle.public_modules, members) |exported, facade, *member| {
        const value: Member = .{
            .export_name = exported.name,
            .name = facade.name,
            .function_id = if (exported.function) |id| @backingInt(id) else null,
            .requires_io = if (facade.requirements) |requirements| requirements.io else null,
        };

        if (comptime @typeInfo(MemberRef) == .pointer) {
            const borrowed = try temporary.create(Member);
            borrowed.* = value;
            member.* = borrowed;
        } else {
            member.* = value;
        }
    }

    const initializers = try zx.columns.pointers(@FieldType(Input, "initializers"), temporary, bundle.store_initializers);
    const types = zx.ir.TypeTable.borrow(Types, library.program.types);
    const functions = zx.columns.borrow(Functions, &library.program.functions);

    const input: Input = .{
        .types = &types,
        .type_names = identities.types,
        .functions = &functions,
        .members = members,
        .initializers = initializers,
        .independent = independent,
    };

    const output = zx.columns.invoke(entry.executeValue, allocator, &input) catch |err| switch (@as(anyerror, err)) {
        error.OutOfMemory, error.Overflow, error.IntegerOverflow => return error.OutOfMemory,
        else => unreachable,
    };

    switch (output.status) {
        .Valid => {},
        .InvalidModule => return error.InvalidModule,
        .UnsupportedHostReference => return error.UnsupportedHostReference,
        .ConflictingStore => return error.ConflictingStore,
        .MissingInitializer => return error.MissingInitializer,
        .InvalidInitializer => return error.InvalidInitializer,
    }

    const objects = try allocator.alloc(generating.zx.state.Object, output.modules.len);

    for (output.modules, output.writable, objects) |module_name, writable, *object| {
        object.* = .{ .independent = independent, .module_name = module_name, .writable = writable };
    }

    const slots = try allocator.alloc(generating.gateway.Slot, output.indices.len);

    for (output.indices, output.access, slots) |index, writable, *slot| {
        slot.* = .{ .index = index, .writable = writable };
    }

    const services = try allocator.alloc(generating.gateway.Service, library.exports.len);
    var start: usize = 0;

    for (library.exports, bundle.public_modules, output.ends, services) |exported, facade, end, *service| {
        const id = @backingInt(exported.function.?);

        service.* = .{
            .name = facade.name,
            .module_name = facade.file.name,
            .slots = slots[start..end],
            .output = .{ .types = library.program.types, .id = @fromBackingInt(library.program.functions.output_types[id]) },
            .requires_io = facade.requirements.?.io,
            .requires_process = facade.requirements.?.process,
        };

        start = end;
    }

    return .{ .objects = objects, .services = services };
}
