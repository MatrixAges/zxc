const compiler = @import("compiler");
pub const Dependency = struct { name: []const u8, requirement: []const u8 };
pub const Workspace = struct { packages: []const []const u8 };
pub const NativeModule = struct { name: []const u8, path: ?[]const u8 = null, header: ?[]const u8 = null, dependencies: []const []const u8 = &.{}, bundle_files: []const []const u8 = &.{} };
pub const NativeInterface = struct { specifier: []const u8, path: []const u8, module: []const u8, namespace: []const []const u8 = &.{} };

pub const Manifest = struct {
    name: []const u8,
    version: []const u8,
    entry: ?[]const u8 = null,
    private: bool = false,
    dependencies: []const Dependency = &.{},
    dev_dependencies: []const Dependency = &.{},
    workspace: ?Workspace = null,
    native_interfaces: []const NativeInterface = &.{},
    externals: []const compiler.project.External = &.{},
    native_modules: []const NativeModule = &.{},
    libraries: []const []const u8 = &.{},
    include_paths: []const []const u8 = &.{},
    library_paths: []const []const u8 = &.{},
};

pub const Diagnostic = struct { line: usize, column: usize, message: []const u8 };
