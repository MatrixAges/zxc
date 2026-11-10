const std = @import("std");
const zx = @import("zx");
const node = @import("../node.zig");
const Builder = @import("../builder.zig");
const Service = @import("root.zig").Service;

pub fn lower(builder: Builder, service: Service, index: usize) std.mem.Allocator.Error!?node.Declaration {
    if (comptime !@import("genz_options").generated_analysis) return @import("adapter_seed.zig").lower(builder, service, index);

    const root = (try lowerStored(builder, service, index)) orelse return null;

    return builder.nodes.materializeDeclaration(builder.allocator, root);
}

pub fn lowerStored(builder: Builder, service: Service, index: usize) std.mem.Allocator.Error!?u32 {
    if (comptime !@import("genz_options").generated_analysis) {
        const declaration = (try @import("adapter_seed.zig").lower(builder, service, index)) orelse return null;

        return (try builder.nodes.declarations(builder.allocator, &.{declaration})).start;
    }

    const entry = @import("generated_gateway_adapter");
    const Parameter = @typeInfo(@TypeOf(entry.executeValue)).@"fn".param_types[1].?;
    const indirect = @typeInfo(Parameter) == .pointer;
    const Input = if (indirect) std.meta.Child(Parameter) else Parameter;
    const Bases = std.meta.Child(@FieldType(Input, "bases"));
    const Slots = @FieldType(Input, "slots");
    const framed = @typeInfo(Slots) == .@"struct";
    const Slice = if (framed) @FieldType(Slots, "items") else Slots;
    const slots = zx.columns.storage.view(Slice, service.slots);

    const bases: Bases = .{
        .capture = null,
        .expression_base = @intCast(builder.nodes.expressions.tags.items.len),
        .statement_base = @intCast(builder.nodes.statements.tags.items.len),
        .field_base = @intCast(builder.nodes.field_columns.count()),
        .serial = 0,
    };

    const input: Input = .{
        .bases = &bases,
        .slots = if (framed) .{ .items = slots, .storage = .plain } else slots,
        .service_index = index,
        .declaration_base = @intCast(builder.nodes.declaration_rows.tags.items.len),
    };

    const result = entry.executeValue(builder.allocator, if (indirect) &input else input) catch |err| return failure(err);
    const output = result orelse return null;

    if (!output.valid) return error.OutOfMemory;

    const Output = @TypeOf(output);
    const Module = if (@typeInfo(Output) == .pointer) std.meta.Child(Output) else Output;
    @import("../node/import_module.zig").appendBorrowed(builder.allocator, builder.nodes, Module, output) catch |err| return failure(err);

    return output.root;
}

fn failure(err: anyerror) std.mem.Allocator.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => @panic("invalid Gateway adapter AST"),
    };
}
