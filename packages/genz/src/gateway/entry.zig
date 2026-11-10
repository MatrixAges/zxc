const std = @import("std");
const zx = @import("zx");
const model = @import("root.zig");

pub const Options = struct { services: []const model.Service, service_modules: []const []const u8, routes: []const model.Route, listen: []const u8, max_header_bytes: u32, max_body_bytes: u32 };

pub fn render(allocator: std.mem.Allocator, options: Options) std.mem.Allocator.Error![]u8 {
    if (comptime !@import("genz_options").generated_analysis) return @import("entry_seed.zig").render(allocator, options);

    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const workspace = arena.allocator();
    const entry = @import("generated_gateway_entry");
    const Parameter = @typeInfo(@TypeOf(entry.executeValue)).@"fn".param_types[1].?;
    const indirect = @typeInfo(Parameter) == .pointer;
    const Input = if (indirect) std.meta.Child(Parameter) else Parameter;

    const input: Input = .{
        .services = try services(@FieldType(Input, "services"), workspace, options.services),
        .routes = try routes(@FieldType(Input, "routes"), workspace, options.routes),
        .service_modules = options.service_modules,
        .listen = options.listen,
        .max_header_bytes = options.max_header_bytes,
        .max_body_bytes = options.max_body_bytes,
    };

    const output = entry.executeValue(workspace, if (indirect) &input else input) catch |err| return failure(err);

    if (output.invalid_route) @panic("invalid Gateway method group");
    if (!output.valid) return error.OutOfMemory;

    return allocator.dupe(u8, output.output);
}

fn routes(comptime Target: type, allocator: std.mem.Allocator, values: []const model.Route) std.mem.Allocator.Error!Target {
    if (comptime @sizeOf(usize) == @sizeOf(u64)) return zx.columns.storage.view(Target, values);

    const Row = std.meta.Child(Target);
    const headers = try allocator.alloc(Row, values.len);

    for (values, headers) |value, *header| {
        header.* = .{ .method = value.method, .path = value.path, .service = @intCast(value.service) };
    }

    return headers;
}

fn services(comptime Target: type, allocator: std.mem.Allocator, values: []const model.Service) std.mem.Allocator.Error!Target {
    const Pointer = std.meta.Child(Target);
    const Row = std.meta.Child(Pointer);
    const Types = std.meta.Child(@FieldType(Row, "types"));
    const tables = try allocator.alloc(Types, values.len);
    const headers = try allocator.alloc(Row, values.len);
    const pointers = try allocator.alloc(Pointer, values.len);

    for (values, tables, headers, pointers) |value, *table, *header, *pointer| {
        table.* = zx.ir.TypeTable.borrow(Types, value.output.types);

        header.* = .{
            .slots = try @import("slots.zig").borrow(@FieldType(Row, "slots"), allocator, value.slots),
            .requires_io = value.requires_io,
            .requires_process = value.requires_process,
            .types = table,
            .output_type = @backingInt(value.output.id),
        };

        pointer.* = header;
    }

    return pointers;
}

fn failure(err: anyerror) std.mem.Allocator.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => @panic("invalid Gateway entry AST"),
    };
}
