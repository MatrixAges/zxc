pub const Implementation = struct { module: []const u8, member: []const u8, allocator_argument: bool = false, expand_tuple: bool = false, fallible: bool = false };

pub const External = struct {
    specifier: []const u8,
    export_name: ?[]const u8 = null,
    signature: []const u8,
    implementation: Implementation,
};

pub const Native = struct {
    specifier: []const u8,
    path: []const u8,
    source: []const u8,
    module: []const u8,
    namespace: []const []const u8 = &.{},
};

pub const standard = blk: {
    const catalog = @import("standard_interfaces").modules;
    var modules: [catalog.len]Native = undefined;

    for (catalog, 0..) |module, index| modules[index] = .{ .specifier = module.specifier, .path = module.path, .source = module.source, .module = module.module, .namespace = module.namespace };

    break :blk modules;
};
