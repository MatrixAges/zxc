const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const calls = @import("call.zig");
const generated = @import("generated_growth_renew");
const Input = std.meta.Child(generated.Input);
const Source = std.meta.Child(@FieldType(Input, "source"));

pub fn lower(self: *Lower, body: *std.ArrayList(node.Statement), type_id: ir.TypeId, value: node.ExpressionId, path: []const u32) Lower.Error!void {
    const types = ir.TypeTable.borrow(std.meta.Child(@FieldType(Input, "types")), self.program.types);

    var source = calls.prepare(self, .Renew, .{
        .element = @fromBackingInt(0),
        .value = value,
        .flag = !self.may_grow,
    });

    const Capture = std.meta.Child(@typeInfo(@FieldType(Source, "capture")).optional.child);
    var boundary: Capture = undefined;

    if (self.capture) |capture| {
        boundary = .{ .name = capture.name, .label = capture.label, .failure = @backingInt(capture.failure) };
        source.capture = &boundary;
    }

    const input: Input = .{
        .source = &source,
        .types = &types,
        .type_id = @backingInt(type_id),
        .path = path,
    };

    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var buffered = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const output = generated.executeIn(buffered.allocator(), &input) catch |err| switch (@as(anyerror, err)) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => return error.OutOfMemory,
        else => unreachable,
    };

    std.debug.assert(output.serial == self.serial);

    _ = try calls.publish(self, body, output);
}
