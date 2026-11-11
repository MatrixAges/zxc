const std = @import("std");
const frontend = @import("frontend");
const ir = @import("zx").ir;
const columns = @import("zx").columns;
const Nodes = frontend.ArtifactNodes;
const Error = frontend.project.artifact.Error;
const generated = @import("parser_options").generated_parser;

pub fn complete(temporary: std.mem.Allocator, nodes: *Nodes, source: []const ir.Constant) Error![]const ir.Constant {
    if (source.len == 0) return &.{};
    if (!generated) return nodes.constants(source);

    const entry = @import("generated_library_constant_types");
    const mapping = nodes.types.mapped;
    var arena = std.heap.ArenaAllocator.init(temporary);
    var buffer: [1024]u8 = undefined;
    var scratch = std.heap.BufferFirstAllocator.init(&buffer, arena.allocator());

    defer arena.deinit();

    const memory = scratch.allocator();
    const ids = try memory.alloc(u32, source.len);

    for (source, ids) |value, *id| id.* = @backingInt(value.type_id);

    const input: std.meta.Child(entry.Input) = .{
        .values = ids,
        .mapping = @as([*]const u32, @ptrCast(mapping.ptr))[0..mapping.len],
    };

    const mapped = columns.invoke(entry.executeValue, memory, &input) catch |err| switch (@as(anyerror, err)) {
        error.OutOfMemory => return error.OutOfMemory,
        else => return error.InvalidModule,
    };

    const result = try nodes.allocator.alloc(ir.Constant, source.len);

    for (source, mapped, result) |value, id, *target| {
        target.* = try frontend.copyConstant(nodes.allocator, value);
        target.type_id = @fromBackingInt(id);
    }

    return result;
}
