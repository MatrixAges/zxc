const std = @import("std");
const genz = @import("genz");
const node = genz.node;
pub const groups = genz.zx.partition;
pub const layout = @import("partition/layout.zig");
pub const demand = @import("partition/demand.zig");
pub const Scanning = @import("partition/scanning.zig");
pub const Export = struct { file: []const u8, variant: []const u8 };

pub const Module = struct {
    file: []const u8,
    name: []const u8,
    pub fn jsonStringify(self: @This(), writer: anytype) !void {
        try writer.write(.{ .name = self.name, .file = self.file });
    }
};

pub fn root(allocator: std.mem.Allocator, modules: []const Module, panic_handler: bool) ![]const u8 {
    return rootBacked(allocator, allocator, modules, panic_handler);
}

pub fn rootBacked(allocator: std.mem.Allocator, workspace: std.mem.Allocator, modules: []const Module, panic_handler: bool) ![]const u8 {
    if (comptime !@import("parser_options").generated_parser) return @import("partition_seed.zig").root(allocator, modules, panic_handler);

    var arena = std.heap.ArenaAllocator.init(workspace);

    defer arena.deinit();

    const entry = @import("generated_partition_root");
    const zx = @import("zx");
    const Input = @typeInfo(@TypeOf(entry.executeValue)).@"fn".param_types[1].?;

    const input: Input = .{
        .modules = zx.columns.slice(@FieldType(Input, "modules"), modules),
        .panic_handler = panic_handler,
    };

    const output = entry.executeValue(arena.allocator(), input) catch |err| return failure(err);

    if (!output.valid) return error.OutOfMemory;

    return render(allocator, arena.allocator(), std.meta.Child(entry.Output), output);
}

fn failure(err: anyerror) std.mem.Allocator.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => @panic("invalid partition root AST"),
    };
}

pub fn exports(allocator: std.mem.Allocator, entries: []const Export) ![]const u8 {
    return exportsBacked(allocator, allocator, entries);
}

pub fn exportsBacked(allocator: std.mem.Allocator, workspace: std.mem.Allocator, entries: []const Export) ![]const u8 {
    if (comptime !@import("parser_options").generated_parser) return @import("partition_seed.zig").exports(allocator, entries);

    var arena = std.heap.ArenaAllocator.init(workspace);

    defer arena.deinit();

    const entry = @import("generated_partition_exports");
    const Input = @typeInfo(@TypeOf(entry.executeValue)).@"fn".param_types[1].?;
    const Row = std.meta.Child(std.meta.Child(Input));
    const rows = try arena.allocator().alloc(Row, entries.len);

    for (rows, entries) |*row, item| row.* = .{
        .function_name = std.fs.path.stem(item.file),
        .variant = item.variant,
    };

    const input = try @import("zx").columns.pointers(Input, arena.allocator(), @as([]const Row, rows));
    const output = entry.executeValue(arena.allocator(), input) catch |err| return failure(err);

    if (!output.valid) return error.OutOfMemory;

    return render(allocator, arena.allocator(), std.meta.Child(entry.Output), output);
}

pub fn stub(allocator: std.mem.Allocator, file: []const u8, variants: []const []const u8, comptime_entry: bool) ![]const u8 {
    return stubBacked(allocator, allocator, file, variants, comptime_entry);
}

pub fn stubBacked(allocator: std.mem.Allocator, workspace: std.mem.Allocator, file: []const u8, variants: []const []const u8, comptime_entry: bool) ![]const u8 {
    if (comptime !@import("parser_options").generated_parser) return @import("partition_seed.zig").stub(allocator, file, variants, comptime_entry);

    var arena = std.heap.ArenaAllocator.init(workspace);

    defer arena.deinit();

    const entry = @import("generated_partition_stub");
    const Input = @typeInfo(@TypeOf(entry.executeValue)).@"fn".param_types[1].?;

    const input: Input = .{
        .function_name = std.fs.path.stem(file),
        .variants = variants,
        .comptime_entry = comptime_entry,
    };

    const output = entry.executeValue(arena.allocator(), input) catch |err| return failure(err);

    if (!output.valid) return error.OutOfMemory;

    return render(allocator, arena.allocator(), std.meta.Child(entry.Output), output);
}

fn render(allocator: std.mem.Allocator, workspace: std.mem.Allocator, comptime ModuleType: type, output: anytype) std.mem.Allocator.Error![]u8 {
    if (comptime genz.render_module.available) return genz.render_module.render(allocator, workspace, ModuleType, output);

    const builder = try genz.Builder.init(workspace);

    genz.import_module.appendBorrowed(workspace, builder.nodes, ModuleType, output) catch |err| return failure(err);

    const declarations = try workspace.alloc(node.Declaration, builder.nodes.declaration_rows.tags.items.len);

    for (declarations, 0..) |*declaration, index| declaration.* = try builder.nodes.materializeDeclaration(workspace, @intCast(index));

    return genz.render(allocator, builder.nodes, declarations);
}
