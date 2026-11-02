const std = @import("std");
const compiler = @import("compiler");
const view = compiler.zig.abi_view;
const Loaded = @import("project.zig").Loaded;

const Bundle = struct {
    types: []const u8,
    type_names: []const []const u8,
    native_modules: compiler.ir.NativeModuleTable,
    modules: []const compiler.zig.ModuleFile,
};

pub const File = struct { module: []const u8, name: []const u8, path: []const u8, source: []const u8 };
pub const Result = struct { source: []const u8, views: []const File = &.{} };

pub fn create(allocator: std.mem.Allocator, bundle: compiler.zig.ModuleBundle, loaded: Loaded) !Result {
    return render(allocator, .{ .types = bundle.types, .type_names = bundle.type_names, .native_modules = bundle.native_modules, .modules = bundle.modules }, loaded);
}

pub fn createLibrary(allocator: std.mem.Allocator, bundle: compiler.zig.LibraryBundle, loaded: Loaded) !Result {
    return render(allocator, .{ .types = bundle.types, .type_names = bundle.type_names, .native_modules = bundle.native_modules, .modules = bundle.modules }, loaded);
}

fn render(allocator: std.mem.Allocator, bundle: Bundle, loaded: Loaded) !Result {
    var scratch = std.heap.ArenaAllocator.init(allocator);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var buffered = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const temporary = buffered.allocator();
    const planner = compiler.zig.bundle_abi;

    if (!try planner.scoped(temporary, bundle.native_modules.identities)) return .{ .source = bundle.types };

    const input = try @import("abi/input.zig").create(temporary, bundle.native_modules, bundle.modules, loaded);
    const plan = try planner.create(temporary, &input);
    const views = try allocator.alloc(File, plan.views.len);

    for (plan.views, views) |selected, *file| file.* = .{
        .module = try allocator.dupe(u8, selected.module),
        .name = try allocator.dupe(u8, selected.name),
        .path = try allocator.dupe(u8, selected.path),
        .source = try view.render(allocator, bundle.type_names, try aliases(temporary, selected.aliases), true),
    };

    const root_view = try view.render(temporary, &.{}, try aliases(temporary, plan.aliases), false);

    return .{ .source = try std.mem.concat(allocator, u8, &.{ bundle.types, "\n", root_view }), .views = views };
}

fn aliases(allocator: std.mem.Allocator, source: anytype) std.mem.Allocator.Error![]const view.Alias {
    const result = try allocator.alloc(view.Alias, source.len);

    for (source, result) |alias, *target| target.* = .{ .name = alias.name, .identity = alias.identity };

    return result;
}
