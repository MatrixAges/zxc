const std = @import("std");
const f = @import("fixture.zig");

pub const Mode = enum { out_of_range, empty_identity, prefix, nul, orphan, duplicate, public_function, legacy };

pub fn encode(mode: Mode) ![]u8 {
    var library = try f.library(std.testing.allocator, .single);

    defer library.deinit();

    const bytes = try f.compiler.library.codec.encode(std.testing.allocator, &library);

    defer std.testing.allocator.free(bytes);

    var document = try std.json.parseFromSlice(std.json.Value, std.testing.allocator, f.payload(bytes), .{});

    defer document.deinit();

    const table = document.value.object.getPtr("store_initializers").?;
    const initial = &table.array.items[0].object;

    switch (mode) {
        .out_of_range => initial.getPtr("function").?.* = .{ .integer = 999999 },
        .empty_identity => initial.getPtr("identity").?.* = .{ .string = "store." },
        .prefix => initial.getPtr("identity").?.* = .{ .string = "state.counter" },
        .nul => initial.getPtr("identity").?.* = .{ .string = "store.state\x00counter" },
        .orphan => initial.getPtr("identity").?.* = .{ .string = "store.unknown:counter" },
        .duplicate => try table.array.append(table.array.items[0]),
        .public_function => initial.getPtr("function").?.* = document.value.object.get("exports").?.array.items[0].object.get("function").?,
        .legacy => {},
    }

    const payload = try std.json.Stringify.valueAlloc(std.testing.allocator, document.value, .{});

    defer std.testing.allocator.free(payload);

    return f.envelope(payload, mode == .legacy);
}
