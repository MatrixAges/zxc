const std = @import("std");
const frontend = @import("frontend");
const ir = @import("zx").ir;
const TypeMap = frontend.ArtifactNodes.TypeMap;
const Error = frontend.project.artifact.Error || error{ConflictingInterface};
const generated = @import("parser_options").generated_parser;

pub fn complete(owned: std.mem.Allocator, temporary: std.mem.Allocator, program: ir.Program, types: TypeMap) Error![]const ir.Export {
    if (!generated) return completeSeed(owned, program, types);

    const entry = @import("generated_library_public_types");
    const mapping = types.mapped;
    var arena = std.heap.ArenaAllocator.init(temporary);
    var buffer: [1024]u8 = undefined;
    var scratch = std.heap.BufferFirstAllocator.init(&buffer, arena.allocator());

    defer arena.deinit();

    const memory = scratch.allocator();
    const names = try memory.alloc([]const u8, program.exports.len);
    const ids = try memory.alloc(u32, program.exports.len);

    for (program.exports, names, ids) |source, *name, *id| {
        name.* = source.name;
        id.* = @backingInt(source.type_id);
    }

    const input_type = if (program.type_only) 0 else @backingInt(try types.include(program.input_type));
    const output_type = if (program.type_only) 0 else @backingInt(try types.include(program.output_type));

    const input: std.meta.Child(entry.Input) = .{
        .names = names,
        .ids = ids,
        .mapping = @as([*]const u32, @ptrCast(mapping.ptr))[0..mapping.len],
        .input_type = input_type,
        .output_type = output_type,
        .executable = !program.type_only,
    };

    const result = @import("zx").columns.invoke(entry.executeValue, memory, &input) catch |err| switch (@as(anyerror, err)) {
        error.OutOfMemory => return error.OutOfMemory,
        else => return error.InvalidModule,
    };

    if (!result.ports.compatible) return error.ConflictingInterface;

    const extra = @as(usize, @intFromBool(result.ports.input_name != null)) + @intFromBool(result.ports.output_name != null);
    const exports = try owned.alloc(ir.Export, names.len + extra);

    for (exports[0..names.len], names, result.ids) |*target, name, id| {
        target.* = .{ .name = try owned.dupe(u8, name), .type_id = @fromBackingInt(id) };
    }

    var next = names.len;

    if (result.ports.input_name) |name| {
        exports[next] = .{ .name = try owned.dupe(u8, name), .type_id = @fromBackingInt(input_type) };
        next += 1;
    }

    if (result.ports.output_name) |name| {
        exports[next] = .{ .name = try owned.dupe(u8, name), .type_id = @fromBackingInt(output_type) };
    }

    return exports;
}

fn completeSeed(allocator: std.mem.Allocator, program: ir.Program, types: TypeMap) Error![]const ir.Export {
    var exports: std.ArrayList(ir.Export) = .empty;

    for (program.exports) |item| try exports.append(allocator, .{ .name = try allocator.dupe(u8, item.name), .type_id = try types.include(item.type_id) });

    if (!program.type_only) {
        for ([_]ir.Export{ .{ .name = "Input", .type_id = program.input_type }, .{ .name = "Output", .type_id = program.output_type } }) |signature| {
            const type_id = try types.include(signature.type_id);
            var found = false;

            for (exports.items) |item| if (std.mem.eql(u8, item.name, signature.name)) {
                if (item.type_id != type_id) return error.ConflictingInterface;

                found = true;
            };

            if (!found) try exports.append(allocator, .{ .name = try allocator.dupe(u8, signature.name), .type_id = type_id });
        }
    }

    return exports.items;
}
