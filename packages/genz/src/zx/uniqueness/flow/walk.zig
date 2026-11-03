const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Flow = @import("../flow.zig");
const Slots = @import("../slots.zig");
const Body = @import("body.zig");
const generated = @import("generated_uniqueness_flow_body");
const Input = std.meta.Child(generated.Input);
const Source = std.meta.Child(@FieldType(Input, "body"));
const Layout = std.meta.Child(@FieldType(Source, "layout"));
const Current = std.meta.Child(@FieldType(Input, "current"));
const Self = @This();

allocator: std.mem.Allocator,
flow: Flow,
slots: Slots,
scratch: ?std.heap.ArenaAllocator = null,
pub fn deinit(self: *Self) void {
    if (self.scratch) |*scratch| scratch.deinit();
}

pub fn analyze(self: *Self, index: u32, body: *const Body, held: []bool, text: []bool, written: []bool) std.mem.Allocator.Error!bool {
    if (self.scratch == null) self.scratch = .init(self.allocator);

    const scratch = &self.scratch.?;

    _ = scratch.reset(.retain_capacity);

    const slots = self.slots;
    const layout = Layout{ .offsets = slots.offsets, .members = @ptrCast(slots.members), .unwrapped = @ptrCast(slots.unwrapped) };

    const source = Source{
        .expressions = zx.columns.pointer(@FieldType(Source, "expressions"), &body.function.expressions),
        .type_kinds = slots.types.kinds,
        .type_first = slots.types.first,
        .layout = &layout,
        .counts = slots.counts,
        .time = body.order.nodes.time,
        .definitions = zx.columns.pointer(@FieldType(Source, "definitions"), &body.order.definitions),
        .results = @ptrCast(body.order.results),
        .prepared = zx.columns.pointer(@FieldType(Source, "prepared"), &body.prepared),
    };

    const current = Current{ .held = held, .text_held = text, .written = written };

    const input = Input{
        .function_index = index,
        .body = &source,
        .held = self.flow.held,
        .text_held = self.flow.text_held,
        .written = self.flow.written,
        .current = &current,
    };

    const output = generated.executeIn(scratch.allocator(), &input) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => unreachable,
    };

    if (held.ptr != output.held.ptr) @memcpy(held, output.held);
    if (text.ptr != output.text_held.ptr) @memcpy(text, output.text_held);
    if (written.ptr != output.written.ptr) @memcpy(written, output.written);

    return output.changed;
}
