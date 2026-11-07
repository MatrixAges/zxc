const std = @import("std");
const ir = @import("zx").ir;
const generated = @import("genz_options").generated_analysis;
const Seed = @import("requests/seed.zig");
const creating = @import("generated_function_requests_create");
const pushing = @import("generated_function_requests_push");
const State = if (generated) @typeInfo(@typeInfo(@TypeOf(creating.executeState)).@"fn".return_type.?).error_union.payload else Seed;
const Self = @This();

pub const Variant = enum {
    regular,
    value,
    pub fn member(self: Variant) []const u8 {
        if (!generated) return switch (self) {
            .regular => "call",
            .value => "callValue",
        };

        var fixed = std.heap.FixedBufferAllocator.init(&.{});

        return @import("generated_function_reference_member").executeIn(fixed.allocator(), switch (self) {
            .regular => .Regular,
            .value => .Value,
        }) catch unreachable;
    }
    pub fn name(self: Variant, allocator: std.mem.Allocator, id: ir.FunctionId) std.mem.Allocator.Error![]const u8 {
        if (!generated) return if (self == .regular)
            std.fmt.allocPrint(allocator, "function_{d}", .{@backingInt(id)})
        else
            std.fmt.allocPrint(allocator, "function_{d}_{s}", .{ @backingInt(id), @tagName(self) });

        const naming = @import("generated_function_reference_name");

        const input: std.meta.Child(naming.Input) = .{
            .id = @backingInt(id),
            .variant = switch (self) {
                .regular => .Regular,
                .value => .Value,
            },
        };

        return naming.executeIn(allocator, &input) catch |err| return failure(err);
    }
};

pub const Item = struct { id: ir.FunctionId, variant: Variant, first: bool };

state: State,
pub fn init(allocator: std.mem.Allocator, size: usize) std.mem.Allocator.Error!Self {
    if (!generated) return .{ .state = try Seed.init(allocator, size) };

    return .{ .state = creating.executeState(allocator, size) catch |err| return failure(err) };
}

pub fn add(self: *Self, allocator: std.mem.Allocator, id: ir.FunctionId, variant: Variant) std.mem.Allocator.Error!void {
    if (!generated) return self.state.add(allocator, id, variant);

    self.state = pushing.executeState(allocator, .{
        .state = self.state,
        .id = @backingInt(id),
        .variant = switch (variant) {
            .regular => .Regular,
            .value => .Value,
        },
    }) catch |err| return failure(err);
}

pub fn count(self: *const Self) usize {
    return if (generated) self.state.ids.items.len else self.state.items.items.len;
}

pub fn at(self: *const Self, index: usize) Item {
    if (!generated) return self.state.items.items[index];

    return .{
        .id = @fromBackingInt(self.state.ids.items[index]),
        .variant = switch (self.state.variants.items[index]) {
            .Regular => .regular,
            .Value => .value,
        },
        .first = self.state.first.items[index],
    };
}

fn failure(err: anyerror) std.mem.Allocator.Error {
    if (err == error.OutOfMemory) return error.OutOfMemory;

    std.debug.panic("function request state failed: {s}", .{@errorName(err)});
}
