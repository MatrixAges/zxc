const std = @import("std");
const library = @import("compiler").zig.host.library;
const Config = @import("project.zig").Config;
pub const GeneratedModule = library.Module;

pub fn render(allocator: std.mem.Allocator, config: Config, public_modules: []const GeneratedModule, generated: []const GeneratedModule, views: []const @import("abi.zig").File) library.Error![]u8 {
    const native = try allocator.alloc(library.Native, config.native_modules.len);

    defer allocator.free(native);

    for (config.native_modules, native) |module, *mapped| {
        var view_path: ?[]const u8 = null;

        for (views) |view| {
            if (std.mem.eql(u8, view.module, module.name)) view_path = view.path;
        }

        mapped.* = .{
            .name = module.name,
            .path = module.path,
            .header = module.header,
            .dependencies = module.dependencies,
            .include_paths = module.include_paths orelse config.include_paths,
            .abi_view = view_path,
        };
    }

    return library.render(allocator, .{
        .native = native,
        .generated = generated,
        .public = public_modules,
        .libraries = config.libraries,
        .library_paths = config.library_paths,
    });
}
