const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Names = @import("modules.zig").Names;
pub const Error = std.mem.Allocator.Error || error{ MissingNominalOrigin, InvalidNominalOrigin };
pub const Capabilities = struct { io: []const bool, process: []const bool };

pub fn create(allocator: std.mem.Allocator, workspace: std.mem.Allocator, program: ir.Program, origins: anytype) Error!Names {
    return createWith(allocator, workspace, program, origins, null);
}

pub fn createWith(allocator: std.mem.Allocator, workspace: std.mem.Allocator, program: ir.Program, origins: anytype, known: ?Capabilities) Error!Names {
    if (!@import("genz_options").generated_analysis) return @import("names/seed.zig").createWith(allocator, program, origins, known);

    const generated = @import("generated_stable_names");
    const Input = std.meta.Child(generated.Input);
    const Functions = std.meta.Child(@FieldType(Input, "functions"));
    const Modules = std.meta.Child(@FieldType(Input, "modules"));
    const Origins = std.meta.Child(@FieldType(Input, "origins"));
    var scratch = std.heap.ArenaAllocator.init(workspace);

    defer scratch.deinit();

    const types = ir.TypeTable.borrow(std.meta.Child(@FieldType(Input, "types")), program.types);
    var functions: Functions = undefined;
    var modules: Modules = undefined;
    var bindings: Origins = undefined;

    inline for (@typeInfo(Functions).@"struct".field_names) |name| {
        @field(functions, name) = zx.columns.slice(@FieldType(Functions, name), @field(program.functions, name));
    }

    inline for (@typeInfo(Modules).@"struct".field_names) |name| {
        @field(modules, name) = zx.columns.slice(@FieldType(Modules, name), @field(program.native_modules, name));
    }

    inline for (@typeInfo(Origins).@"struct".field_names) |name| {
        @field(bindings, name) = zx.columns.slice(@FieldType(Origins, name), @field(origins, name));
    }

    const input = Input{
        .types = &types,
        .functions = &functions,
        .modules = &modules,
        .origins = &bindings,
        .files = program.functions.files,
        .native_members = program.functions.native_members,
        .native_exports = program.functions.native_exports,
        .known = known != null,
        .io = if (known) |facts| facts.io else &.{},
        .process = if (known) |facts| facts.process else &.{},
    };

    const output = generated.executeIn(scratch.allocator(), &input) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => unreachable,
    };

    switch (output.status) {
        .InvalidOrigin => return error.InvalidNominalOrigin,
        .MissingOrigin => return error.MissingNominalOrigin,
        .Valid => {},
    }

    const type_names = try own(allocator, output.types);

    errdefer release(allocator, type_names);

    return .{ .types = type_names, .functions = try own(allocator, output.functions) };
}

fn own(allocator: std.mem.Allocator, values: []const []const u8) std.mem.Allocator.Error![]const []const u8 {
    const result = try allocator.alloc([]const u8, values.len);
    var initialized: usize = 0;

    errdefer {
        for (result[0..initialized]) |value| allocator.free(value);

        allocator.free(result);
    }

    for (values, result) |value, *target| {
        target.* = try allocator.dupe(u8, value);
        initialized += 1;
    }

    return result;
}

fn release(allocator: std.mem.Allocator, values: []const []const u8) void {
    for (values) |value| allocator.free(value);

    allocator.free(values);
}
