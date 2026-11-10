const std = @import("std");
const zx = @import("zx");

pub const Module = struct { name: []const u8, path: []const u8, dependencies: []const []const u8 };

pub const Native = struct {
    name: []const u8,
    path: ?[]const u8,
    header: ?[]const u8,
    dependencies: []const []const u8,
    include_paths: []const []const u8,
    abi_view: ?[]const u8,
};

pub const Options = struct {
    native: []const Native,
    generated: []const Module,
    public: []const Module,
    libraries: []const []const u8,
    library_paths: []const []const u8,
};

pub const Error = std.mem.Allocator.Error || error{UnknownModuleDependency};

pub fn render(allocator: std.mem.Allocator, options: Options) Error![]u8 {
    if (comptime !@import("genz_options").generated_analysis) return @import("root_seed.zig").render(allocator, options);

    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const workspace = arena.allocator();
    const entry = @import("generated_library_build");
    const Input = std.meta.Child(entry.Input);

    const input: Input = .{
        .native = try rows(@FieldType(Input, "native"), workspace, options.native),
        .generated = try rows(@FieldType(Input, "generated"), workspace, options.generated),
        .public = try rows(@FieldType(Input, "public"), workspace, options.public),
        .libraries = options.libraries,
        .library_paths = options.library_paths,
    };

    const output = zx.columns.invoke(entry.executeValue, workspace, &input) catch |err| return failure(err);

    if (output.status != .Ready) return error.UnknownModuleDependency;
    if (!output.valid) return error.OutOfMemory;

    return @import("../../printer/module.zig").render(allocator, workspace, std.meta.Child(entry.Output), output);
}

fn rows(comptime Target: type, allocator: std.mem.Allocator, values: anytype) std.mem.Allocator.Error!Target {
    const Pointer = std.meta.Child(Target);
    const Row = std.meta.Child(Pointer);
    const headers = try allocator.alloc(Row, values.len);
    const pointers = try allocator.alloc(Pointer, values.len);

    for (values, headers, pointers) |value, *header, *pointer| {
        header.* = zx.columns.view(Row, value);
        pointer.* = header;
    }

    return pointers;
}

fn failure(err: anyerror) std.mem.Allocator.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => @panic("invalid library build AST"),
    };
}
