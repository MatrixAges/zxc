const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const view = @import("../../node/view.zig");
const rows = @import("../../node/import_rows.zig");
const Lower = @import("../lower.zig");
const generated = @import("generated_shared_state");
const Parameter = @typeInfo(@TypeOf(generated.executeValue)).@"fn".param_types[1].?;
const indirect = @typeInfo(Parameter) == .pointer;
const Input = if (indirect) std.meta.Child(Parameter) else Parameter;
const Mode = @FieldType(std.meta.Child(@FieldType(Input, "request")), "mode");

pub fn build(self: *Lower, index: usize, mode: Mode) Lower.Error!void {
    const AbiField = @FieldType(Input, "abi");
    const Abi = if (@typeInfo(AbiField) == .pointer) std.meta.Child(AbiField) else AbiField;
    const types = ir.TypeTable.borrow(std.meta.Child(@FieldType(Abi, "types")), self.program.types);
    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var buffered = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const abi: Abi = .{
        .types = &types,
        .names = self.type_names,
        .cached = view.slice(@FieldType(Abi, "cached"), @as([]const node.ExpressionId, self.abi_types)),
        .root = @intCast(index),
        .base = @intCast(self.builder.nodes.expressions.tags.items.len),
    };

    const input: Input = .{
        .abi = if (@typeInfo(AbiField) == .pointer) &abi else abi,
        .selected = self.state_plan.selected,
        .borrowed = self.state_plan.borrowed,
        .keys = std.mem.sliceAsBytes(self.state_plan.keys),
        .states = view.slice(@FieldType(Input, "states"), @as([]const node.ExpressionId, self.state_types)),
        .state_layouts = view.slice(@FieldType(Input, "state_layouts"), @as([]const node.ExpressionId, self.state_layouts)),
        .views = view.slice(@FieldType(Input, "views"), @as([]const node.ExpressionId, self.view_types)),
        .abi_layouts = view.slice(@FieldType(Input, "abi_layouts"), @as([]const node.ExpressionId, self.abi_layouts)),
        .request = &.{ .id = @intCast(index), .mode = mode },
    };

    const output = generated.executeValue(buffered.allocator(), if (indirect) &input else input) catch |err| switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => return error.OutOfMemory,
        else => unreachable,
    };

    if (!output.valid) return error.OutOfMemory;

    const Expressions = std.meta.Child(std.meta.Child(@FieldType(std.meta.Child(generated.Output), "segments")));

    for (output.segments) |segment| {
        var expressions: Expressions = undefined;

        inline for (@typeInfo(Expressions).@"struct".field_names) |name| @field(expressions, name) = @field(segment, name);

        const imported = rows.append(self.allocator, &self.builder.nodes.expressions, &expressions);

        imported catch |err| switch (err) {
            error.OutOfMemory => return error.OutOfMemory,
            error.InvalidAst => unreachable,
        };
    }

    for (output.entries) |entry| {
        const id = entry.request.id;
        const value: node.ExpressionId = @fromBackingInt(entry.value);
        const layout: node.ExpressionId = @fromBackingInt(entry.layout);

        switch (entry.request.mode) {
            .Abi => {
                self.abi_types[id] = value;
                self.abi_layouts[id] = layout;
            },
            .State => {
                self.state_types[id] = value;
                self.state_layouts[id] = layout;
            },
            .View => self.view_types[id] = value,
        }
    }
}
