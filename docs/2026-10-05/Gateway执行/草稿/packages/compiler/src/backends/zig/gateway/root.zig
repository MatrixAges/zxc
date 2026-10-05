const std = @import("std");
const generating = @import("genz");
const modules = @import("../modules.zig");
const library = @import("../library.zig");
pub const Options = struct { routes: []const generating.gateway.Route, listen: []const u8, max_header_bytes: u32, max_body_bytes: u32 };
pub const Route = generating.gateway.Route;

pub fn create(result: *const @import("../../../library/root.zig").Result, bundle: *library.Bundle, options: Options) !modules.Bundle {
    const allocator = bundle.arena.allocator();
    const mapped = try @import("state.zig").create(allocator, result, bundle.*);
    var files: std.ArrayList(modules.File) = .empty;

    try files.appendSlice(allocator, bundle.modules);

    for (bundle.public_modules) |facade| try files.append(allocator, facade.file);

    const entry = try append(allocator, &files, mapped.objects, mapped.services, options);
    const module_files = try files.toOwnedSlice(allocator);

    const generated = modules.Bundle{
        .arena = bundle.arena,
        .entry = entry,
        .types = bundle.types,
        .modules = module_files,
        .type_names = bundle.type_names,
        .native_modules = bundle.native_modules,
        .store_initializers = bundle.store_initializers,
    };

    bundle.* = undefined;

    return generated;
}

pub fn empty(allocator: std.mem.Allocator, options: Options) !modules.Bundle {
    var arena = std.heap.ArenaAllocator.init(allocator);

    errdefer arena.deinit();

    const owned = arena.allocator();
    var files: std.ArrayList(modules.File) = .empty;
    const entry = try append(owned, &files, &.{}, &.{}, options);
    const module_files = try files.toOwnedSlice(owned);

    return .{ .arena = arena, .entry = entry, .types = "", .modules = module_files };
}

fn append(allocator: std.mem.Allocator, files: *std.ArrayList(modules.File), objects: []const generating.zx.state.Object, services: []const generating.gateway.Service, options: Options) !modules.File {
    const initial_imports = try allocator.alloc([]const u8, objects.len);

    for (objects, initial_imports) |object, *name| name.* = object.module_name;

    const state_imports = try std.mem.concat(allocator, []const u8, &.{ &.{"application=gateway_storage_contract"}, initial_imports });

    try files.append(allocator, .{ .name = "gateway_storage_contract", .source = try generating.gateway.storage.render(allocator, objects), .imports = initial_imports });
    try files.append(allocator, .{ .name = "zxc_gateway_state", .source = try generating.zx.state.renderStorage(allocator, objects), .imports = state_imports });

    const imports = try allocator.alloc([]const u8, services.len + 1);

    imports[0] = "zxc_gateway_state";

    for (services, imports[1..]) |service, *name| name.* = service.module_name;

    return .{
        .name = "application",
        .imports = imports,
        .source = try generating.gateway.entry.render(allocator, .{ .services = services, .routes = options.routes, .listen = options.listen, .max_header_bytes = options.max_header_bytes, .max_body_bytes = options.max_body_bytes }),
    };
}
