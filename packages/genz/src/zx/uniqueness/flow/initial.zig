const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Flow = @import("../flow.zig");
const Slots = @import("../slots.zig");

pub fn create(allocator: std.mem.Allocator, program: ir.Program, slots: Slots, texts: []const bool) std.mem.Allocator.Error!Flow {
    if (!@import("genz_options").generated_analysis) return seed(allocator, program, slots, texts);

    const generated = @import("generated_uniqueness_flow_initial");
    const Input = std.meta.Child(generated.Input);
    const Layout = std.meta.Child(@FieldType(Input, "layout"));
    const layout = Layout{ .offsets = slots.offsets, .members = @ptrCast(slots.members), .unwrapped = @ptrCast(slots.unwrapped) };

    const input = Input{
        .input_types = @ptrCast(program.functions.input_types),
        .output_types = @ptrCast(program.functions.output_types),
        .native_modules = program.functions.native_modules,
        .texts = texts,
        .counts = slots.counts,
        .kinds = slots.types.kinds,
        .layout = &layout,
    };

    const output = generated.executeIn(allocator, &input) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => unreachable,
    };

    return .{ .held = output.held, .text_held = output.text_held, .written = output.written };
}

fn seed(allocator: std.mem.Allocator, program: ir.Program, slots: Slots, texts: []const bool) std.mem.Allocator.Error!Flow {
    const count = program.functions.count();
    const held = try allocator.alloc([]bool, count);
    const text_held = try allocator.alloc([]bool, count);
    const written = try allocator.alloc([]bool, count);
    var scratch = std.heap.ArenaAllocator.init(allocator);

    defer scratch.deinit();

    const temporary = scratch.allocator();

    for (0..count) |index| {
        const function = program.functions.at(index);
        const size = slots.count(function.input_type);
        held[index] = try allocator.alloc(bool, size);
        written[index] = try allocator.alloc(bool, size);
        text_held[index] = try allocator.alloc(bool, if (texts[@backingInt(function.output_type)]) size else 0);

        @memset(held[index], false);
        @memset(text_held[index], false);
        @memset(written[index], false);

        if (function.external == null) continue;

        @memset(text_held[index], true);

        for (text_held[index], 0..) |value, slot| held[index][slot] = value;

        const outputs = try @import("../basis.zig").lists(temporary, slots, function.output_type);

        for (held[index], 0..) |*value, slot| value.* = value.* or std.mem.indexOfScalar(ir.TypeId, outputs, slots.listType(function.input_type, @intCast(slot))) != null;
    }

    return .{ .held = held, .text_held = text_held, .written = written };
}
