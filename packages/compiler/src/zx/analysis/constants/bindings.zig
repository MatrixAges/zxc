const std = @import("std");
const zx = @import("zx");
const generated_mode = @import("parser_options").generated_parser;
const Input = if (generated_mode) std.meta.Child(@import("generated_constant_bindings").Input) else void;
pub const Comparison = enum { Missing, Different, Equal };

pub const Request = struct {
    previous: []const zx.ir.Constant,
    current: []const zx.ir.Constant,
    mapping: []const zx.ir.TypeId,
    current_mapping: ?[]const zx.ir.TypeId = null,
    name: ?[]const u8 = null,
};

pub const Prepared = struct {
    arena: zx.Arena,
    request: Request,
    input: Input,
    pub fn deinit(self: *Prepared) void {
        self.arena.deinit();
    }
    pub fn compare(self: *Prepared, name: ?[]const u8) std.mem.Allocator.Error!Comparison {
        if (comptime !generated_mode) {
            var request = self.request;

            request.name = name;

            return @import("bindings/seed.zig").compare(request);
        }

        var input = self.input;

        input.name = name;

        const result = @import("generated_constant_bindings").executeIn(self.arena.allocator(), &input) catch |err| switch (err) {
            error.OutOfMemory => return error.OutOfMemory,
            else => return .Different,
        };

        return switch (result) {
            .Missing => .Missing,
            .Different => .Different,
            .Equal => .Equal,
        };
    }
};

pub fn prepare(allocator: std.mem.Allocator, request: Request) std.mem.Allocator.Error!Prepared {
    var arena = zx.Arena.init(allocator);

    errdefer arena.deinit();

    if (comptime !generated_mode) return .{ .arena = arena, .request = request, .input = {} };

    const Values = std.meta.Child(@typeInfo(@FieldType(Input, "previous")).optional.child);
    const marshal = @import("input.zig").marshal;

    const input: Input = .{
        .name = request.name,
        .previous = try marshal(Values, arena.allocator(), request.previous),
        .current = try marshal(Values, arena.allocator(), request.current),
        .mapping = @ptrCast(request.mapping),
        .current_mapping = if (request.current_mapping) |mapping| @as([]const u32, @ptrCast(mapping)) else null,
    };

    return .{ .arena = arena, .request = request, .input = input };
}

pub fn compare(allocator: std.mem.Allocator, request: Request) std.mem.Allocator.Error!Comparison {
    if (request.name == null) {
        if (request.previous.len != request.current.len) return .Different;
        if (request.previous.len == 0) return .Equal;
    }

    var prepared = try prepare(allocator, request);

    defer prepared.deinit();

    return prepared.compare(request.name);
}
