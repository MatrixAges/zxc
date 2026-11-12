const std = @import("std");
const ir = @import("zx").ir;
const Binding = @import("../function_import.zig");
const Nodes = @import("nodes.zig");
const Error = @import("model.zig").Error;
const References = @import("roots/record.zig").References;

const Surface = struct {
    exports: []const ir.Export = &.{},
    constant_exports: []const ir.Constant = &.{},
    constant_imports: []const ir.Constant = &.{},
    type_imports: []const ir.Export = &.{},
    function_imports: []const Binding = &.{},
    members: []const Binding = &.{},
};

pub fn linked(temporary: std.mem.Allocator, nodes: *const Nodes, exports: []const ir.Export, constants: []const ir.Constant) Error!Surface {
    const type_count = exports.len + constants.len;

    if (type_count == 0) return .{};

    var arena = std.heap.ArenaAllocator.init(temporary);
    var buffer: [2048]u8 = undefined;
    var scratch = std.heap.BufferFirstAllocator.init(&buffer, arena.allocator());

    defer arena.deinit();

    const memory = scratch.allocator();
    const types = try memory.alloc(u32, type_count);

    for (exports, types[0..exports.len]) |item, *slot| slot.* = @backingInt(item.type_id);
    for (constants, types[exports.len..]) |item, *slot| slot.* = @backingInt(item.type_id);

    return publish(memory, nodes, .{ .exports = exports, .constant_exports = constants }, .{ .types = types, .functions = &.{} });
}

pub fn publish(memory: std.mem.Allocator, nodes: *const Nodes, source: Surface, references: References) Error!Surface {
    const mapped = try @import("nodes/remap.zig").columns(memory, nodes, references.types, references.functions);
    var types = mapped.types;
    const allocator = nodes.allocator;
    var result: Surface = .{};
    result.exports = try copyExports(allocator, source.exports, &types);
    result.constant_exports = try copyConstants(allocator, source.constant_exports, &types);
    result.constant_imports = try copyConstants(allocator, source.constant_imports, &types);
    result.type_imports = try copyExports(allocator, source.type_imports, &types);

    var ports: Ports = .{
        .functions = mapped.functions,
        .inputs = types[0..mapped.functions.len],
        .outputs = types[mapped.functions.len..],
    };

    result.function_imports = try copyBindings(allocator, source.function_imports, &ports);
    result.members = try copyBindings(allocator, source.members, &ports);

    return result;
}

fn copyExports(allocator: std.mem.Allocator, source: []const ir.Export, types: *[]const u32) Error![]const ir.Export {
    const result = try allocator.alloc(ir.Export, source.len);

    for (source, result) |item, *target| target.* = .{
        .name = try allocator.dupe(u8, item.name),
        .type_id = take(ir.TypeId, types),
    };

    return result;
}

fn copyConstants(allocator: std.mem.Allocator, source: []const ir.Constant, types: *[]const u32) Error![]const ir.Constant {
    const result = try allocator.alloc(ir.Constant, source.len);
    const copy = @import("../../analysis/constants/copy.zig").copy;

    for (source, result) |item, *target| {
        target.* = try copy(allocator, item);
        target.type_id = take(ir.TypeId, types);
    }

    return result;
}

const Ports = struct {
    functions: []const u32,
    inputs: []const u32,
    outputs: []const u32,
};

fn copyBindings(allocator: std.mem.Allocator, source: []const Binding, ports: *Ports) Error![]const Binding {
    const result = try allocator.alloc(Binding, source.len);

    for (source, result) |*item, *target| {
        target.* = item.*;
        target.name = try allocator.dupe(u8, item.name);

        if (item.namespace) |name| target.namespace = try allocator.dupe(u8, name);

        if (item.intrinsic == null) {
            target.id = take(ir.FunctionId, &ports.functions);
            target.input_type = take(ir.TypeId, &ports.inputs);
            target.output_type = take(ir.TypeId, &ports.outputs);
        }
    }

    return result;
}

fn take(comptime Id: type, values: *[]const u32) Id {
    const first = values.*[0];

    values.* = values.*[1..];

    return @fromBackingInt(first);
}
