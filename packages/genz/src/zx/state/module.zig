const std = @import("std");
const zx = @import("zx");
const Builder = @import("../../builder.zig");
const state = @import("../state.zig");

pub fn render(allocator: std.mem.Allocator, objects: []const state.Object, requirements: state.Requirements, execute: bool) std.mem.Allocator.Error![]u8 {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const builder = try Builder.init(arena.allocator());

    const selected = scope: {
        const entry = @import("generated_store_state");
        const Parameter = @typeInfo(@TypeOf(entry.executeValue)).@"fn".param_types[1].?;
        const indirect = @typeInfo(Parameter) == .pointer;
        const Input = if (indirect) std.meta.Child(Parameter) else Parameter;

        const input: Input = .{
            .objects = zx.columns.slice(@FieldType(Input, "objects"), objects),
            .execute = execute,
            .io = requirements.io,
            .process = requirements.process,
        };

        var scratch = std.heap.ArenaAllocator.init(allocator);

        defer scratch.deinit();

        const output = entry.executeValue(scratch.allocator(), if (indirect) &input else input) catch |err| return failure(err);

        if (!output.valid) return error.OutOfMemory;

        const parts = output.parts orelse return error.OutOfMemory;
        const values = if (@typeInfo(@TypeOf(parts)) == .pointer) parts.* else parts;
        const Output = payload(entry.Output);
        const Parts = payload(@FieldType(Output, "parts"));

        inline for (@typeInfo(Parts).@"struct".field_names) |name| {
            @import("../../node/import_module.zig").append(builder.allocator, builder.nodes, payload(@FieldType(Parts, name)), @field(values, name)) catch |err| return failure(err);
        }

        const roots = zx.columns.view(struct { roots: @FieldType(Output, "roots") }, output).roots;

        break :scope builder.nodes.selectDeclarations(builder.allocator, roots) catch |err| return failure(err);
    };

    return @import("../../render.zig").renderStored(allocator, builder.nodes, selected);
}

fn payload(comptime T: type) type {
    return switch (@typeInfo(T)) {
        .pointer => |pointer| if (pointer.size == .one) payload(pointer.child) else T,
        .optional => |optional| payload(optional.child),
        else => T,
    };
}

fn failure(err: anyerror) std.mem.Allocator.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => @panic("invalid State module AST"),
    };
}
