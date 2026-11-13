const std = @import("std");
const dsl = @import("dsl");
const ast = dsl.ast;
const generated = @import("rx_options").generated_graph;

pub fn byteOffset(attribute: ast.Attribute, offset: usize, end_bias: bool) ?usize {
    if (!generated) return dsl.attributeByteOffset(attribute, offset, end_bias);

    const source = attribute.raw_value orelse return null;
    const relative = relativeOffset(attribute, source, offset, end_bias) orelse return null;

    return attribute.value_location.offset + relative;
}

pub fn locate(attribute: ast.Attribute, offset: usize) ?ast.Location {
    if (!generated) return dsl.attributeLocation(attribute, offset);

    return locateWithBias(attribute, offset, false);
}

pub fn locateEnd(attribute: ast.Attribute, offset: usize) ?ast.Location {
    if (!generated) return dsl.attributeEndLocation(attribute, offset);

    return locateWithBias(attribute, offset, true);
}

fn locateWithBias(attribute: ast.Attribute, offset: usize, end_bias: bool) ?ast.Location {
    const source = attribute.raw_value orelse return null;
    const relative = relativeOffset(attribute, source, offset, end_bias) orelse return null;
    const start = attribute.value_location;

    return rawLocation(source, start, start.offset + relative, true);
}

fn relativeOffset(attribute: ast.Attribute, raw: []const u8, offset: usize, end_bias: bool) ?usize {
    if (offset > attribute.value.len) return null;
    if (offset == 0 or attribute.kind == .expression) return offset;

    var empty = std.heap.FixedBufferAllocator.init(&.{});

    const result = @import("generated_rx_attribute_offset").executeValue(empty.allocator(), &.{
        .raw = raw,
        .decoded = attribute.value,
        .offset = offset,
        .end_bias = end_bias,
    }) catch unreachable;

    return if (result) |relative| @intCast(relative) else null;
}

pub fn rawLocation(raw: []const u8, start: ast.Location, offset: usize, xml_newlines: bool) ast.Location {
    if (offset == start.offset) return start;
    if (!generated) return rawSeed(raw, start, offset, xml_newlines);

    var result: [2]u64 = undefined;
    const destination: []u64 = &result;
    var buffer: [@sizeOf([8]u64) + @alignOf(u64)]u8 = undefined;
    var scratch = std.heap.FixedBufferAllocator.init(&buffer);

    @import("generated_rx_attribute_coordinates").executeValue(scratch.allocator(), &.{
        .raw = raw,
        .count = offset - start.offset,
        .line = start.line,
        .column = start.column,
        .xml_newlines = xml_newlines,
        .position = @ptrCast(&destination),
    }) catch unreachable;

    return .{ .offset = offset, .line = @intCast(result[0]), .column = @intCast(result[1]) };
}

fn rawSeed(raw: []const u8, start: ast.Location, offset: usize, xml_newlines: bool) ast.Location {
    var location = start;
    var previous_cr = false;

    for (raw[0 .. offset - start.offset]) |byte| {
        const cr = xml_newlines and byte == '\r';

        if (cr or (byte == '\n' and !previous_cr)) {
            location.line += 1;
            location.column = 1;
        } else if (byte != '\n') location.column += 1;

        previous_cr = cr;
    }

    location.offset = offset;

    return location;
}
