const std = @import("std");
const zx = @import("zx");
pub const node = @import("node/root.zig");
pub const wasm = @import("wasm/root.zig").render;
pub const catalog = @import("catalog.zig");
pub const resources = @import("resources.zig");
pub const library = @import("library/root.zig");
pub const gateway = @import("gateway/root.zig").render;
pub const cli = @import("cli/root.zig").render;

pub const BootstrapEntries = struct {
    member: []const u8,
    value_entry: bool,
    state_entry: bool,
    allocator_entry: bool,
};

pub fn reexports(allocator: std.mem.Allocator, module: []const u8, member: []const u8, names: []const []const u8) std.mem.Allocator.Error![]u8 {
    if (comptime !@import("genz_options").generated_analysis) return @import("bindings_seed.zig").reexports(allocator, module, member, names);

    const entry = @import("generated_host_reexports");
    const input: std.meta.Child(entry.Input) = .{ .module = module, .member = member, .names = names };

    return render(allocator, allocator, entry, &input);
}

pub fn bootstrapReexports(allocator: std.mem.Allocator, workspace: std.mem.Allocator, entries: BootstrapEntries) std.mem.Allocator.Error![]u8 {
    if (comptime !@import("genz_options").generated_analysis) return @import("bindings_seed.zig").bootstrapReexports(allocator, workspace, entries);

    const entry = @import("generated_host_bootstrap_reexports");
    const input = zx.columns.view(std.meta.Child(entry.Input), entries);

    return render(allocator, workspace, entry, &input);
}

pub fn result(allocator: std.mem.Allocator, emit: bool) std.mem.Allocator.Error![]u8 {
    if (comptime !@import("genz_options").generated_analysis) return @import("bindings_seed.zig").result(allocator, emit);

    const entry = @import("generated_host_result");
    const input: std.meta.Child(entry.Input) = .{ .emit = emit };

    return render(allocator, allocator, entry, &input);
}

pub fn cAdapter(allocator: std.mem.Allocator) std.mem.Allocator.Error![]u8 {
    if (comptime !@import("genz_options").generated_analysis) return @import("bindings_seed.zig").cAdapter(allocator);

    const entry = @import("generated_host_c_adapter");
    const input: std.meta.Child(entry.Input) = .{};

    return render(allocator, allocator, entry, &input);
}

fn render(allocator: std.mem.Allocator, workspace: std.mem.Allocator, comptime entry: type, input: anytype) std.mem.Allocator.Error![]u8 {
    var arena = std.heap.ArenaAllocator.init(workspace);

    defer arena.deinit();

    const scratch = arena.allocator();
    const output = zx.columns.invoke(entry.executeValue, scratch, input) catch |err| return failure(err);

    if (!output.valid) return error.OutOfMemory;

    return @import("../printer/module.zig").render(allocator, scratch, std.meta.Child(entry.Output), output);
}

fn failure(err: anyerror) std.mem.Allocator.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => @panic("invalid host binding AST"),
    };
}
