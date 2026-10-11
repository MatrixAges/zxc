const std = @import("std");
const node = @import("../node.zig");
const Storage = @import("../node/storage.zig");
const view = @import("../node/view.zig");
const generated = @import("generated_printer");
const Input = @typeInfo(generated.Input).pointer.child;
const Source = @typeInfo(@FieldType(Input, "source")).pointer.child;

pub fn render(allocator: std.mem.Allocator, nodes: *Storage, declarations: []const node.Declaration) std.mem.Allocator.Error![]u8 {
    const selected = try nodes.declarations(nodes.allocator, declarations);
    const expressions = view.rows(@typeInfo(@FieldType(Source, "expressions")).pointer.child, &nodes.expressions);
    const statements = view.rows(@typeInfo(@FieldType(Source, "statements")).pointer.child, &nodes.statements);
    const declaration_rows = view.rows(@typeInfo(@FieldType(Source, "declarations")).pointer.child, &nodes.declaration_rows);
    const fields = view.members(@typeInfo(@FieldType(Source, "fields")).pointer.child, &nodes.field_columns);
    const arms = view.members(@typeInfo(@FieldType(Source, "arms")).pointer.child, &nodes.arm_columns);

    const source = Source{
        .expressions = &expressions,
        .statements = &statements,
        .declarations = &declaration_rows,
        .fields = &fields,
        .arms = &arms,
        .first = selected.start,
        .count = selected.len,
    };

    const workspace = nodes.allocator;
    var scratch = std.heap.ArenaAllocator.init(workspace);

    defer scratch.deinit();

    var output: std.ArrayList(u8) = .empty;
    var started = false;

    defer output.deinit(workspace);

    const Buffers = @typeInfo(@TypeOf(generated.executeBuffered)).@"fn".param_types[2].?;
    var buffers: Buffers = undefined;

    inline for (@typeInfo(Buffers).@"struct".field_names) |name| @field(buffers, name) = null;

    const lane = comptime outputLane();

    @field(buffers, lane) = .{ .buffer = &output, .started = &started, .allocator = workspace };

    _ = generated.executeBuffered(scratch.allocator(), &.{ .source = &source, .output = &.{} }, buffers) catch |err| switch (err) {
        error.OutOfMemory, error.Overflow => return error.OutOfMemory,
        else => unreachable,
    };

    return allocator.dupe(u8, output.items);
}

fn outputLane() []const u8 {
    for (generated.buffer_lanes) |lane| {
        if (lane.output.len != 0) continue;
        if (lane.input.len != 1 or !std.mem.eql(u8, lane.input[0], "output")) @compileError("Printer output must use its caller-owned output buffer");

        return lane.slot;
    }

    @compileError("Printer output does not have a reusable buffer lane");
}
