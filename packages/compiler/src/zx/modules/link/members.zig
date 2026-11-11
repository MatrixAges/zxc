const std = @import("std");
const ir = @import("zx").ir;
const Module = @import("../artifact/model.zig").Module;
const Binding = @import("../function_import.zig");
const Nodes = @import("../artifact/nodes.zig");
const Error = @import("../artifact/model.zig").Error || error{ConflictingInterface};

pub fn find(module: *const Module, name: []const u8) ?Binding {
    const original = if (std.mem.eql(u8, name, "default")) "" else name;

    for (module.members) |member| {
        if (std.mem.eql(u8, member.name, original)) return member;
    }

    return null;
}

pub fn check(provider: *const Module, member: Binding, consumers: []const Binding, local: []const u8, nodes: *Nodes, functions: ir.FunctionTable, mapping: []const ir.TypeId) Error!void {
    if (!member.valid() or member.namespace != null) return error.InvalidModule;

    const name = if (std.mem.eql(u8, local, "default")) "" else local;

    for (consumers) |binding| {
        if (binding.namespace != null or !std.mem.eql(u8, binding.name, name)) continue;
        if (!binding.valid() or binding.intrinsic != member.intrinsic) return error.ConflictingInterface;
        if (member.intrinsic != null) return;
        if (@backingInt(member.id.?) >= provider.functions.count()) return error.InvalidModule;

        const expected = provider.functions.at(@backingInt(member.id.?));
        const actual = functions.at(@backingInt(try nodes.functionId(binding.id.?)));

        if (@backingInt(expected.input_type) >= mapping.len or @backingInt(expected.output_type) >= mapping.len) return error.InvalidModule;
        if (!std.mem.eql(u8, expected.file_name, actual.file_name) or mapping[@backingInt(expected.input_type)] != actual.input_type or mapping[@backingInt(expected.output_type)] != actual.output_type or expected.output_ownership != actual.output_ownership) return error.ConflictingInterface;

        return;
    }

    return error.ConflictingInterface;
}
