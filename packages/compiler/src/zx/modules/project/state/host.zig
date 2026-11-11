const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Origins = @import("../../nominal_origins.zig");
const Context = @import("../../../analysis/analyze.zig").Context;
const enabled = @import("parser_options").generated_parser;
pub const Admission = if (enabled) Output(@import("generated_project_state_open")) else enum { Ready, Types, Native, Nominal };
pub const Publication = if (enabled) Output(@import("generated_project_body_publish")) else enum { Types, Dependency, Entry, RecursiveDependency, RecursiveEntry };

fn Output(comptime module: type) type {
    return @typeInfo(@TypeOf(module.executeValue(undefined, undefined))).error_union.payload;
}

pub const State = struct {
    types: ir.TypeStorage,
    native_modules: ir.NativeModuleStorage,
    origins: Origins,
};

pub const Open = union(enum) {
    state: State,
    diagnostic: zx.Diagnostic,
};

pub fn open(allocator: std.mem.Allocator, context: *const Context) std.mem.Allocator.Error!Open {
    switch (try admission(context)) {
        .Types => return failure("invalid shared type table"),
        .Native => return failure("invalid shared native module table"),
        .Nominal => return failure("invalid shared nominal type table"),
        .Ready => {},
    }

    const types = try @import("../../../analysis/type_table.zig").storage(allocator, context.types);
    const native = try @import("../../native_context.zig").storage(allocator, context.native_modules);
    var origins: Origins = .{ .allocator = allocator };

    try origins.copyValidated(types.view(), context.nominal_types);

    return .{ .state = .{ .types = types, .native_modules = native, .origins = origins } };
}

fn admission(context: *const Context) std.mem.Allocator.Error!Admission {
    if (comptime enabled) {
        const generated = @import("generated_project_state_open");
        const Input = std.meta.Child(generated.Input);
        const table = ir.TypeTable.borrow(std.meta.Child(@FieldType(Input, "table")), context.types);
        const modules = zx.columns.pointer(@FieldType(Input, "modules"), &context.native_modules);
        const origins = Origins.Table.borrow(std.meta.Child(@FieldType(Input, "origins")), context.nominal_types);

        const input: Input = .{
            .table = &table,
            .modules = modules,
            .origins = &origins,
            .names = context.nominal_types.names,
            .scalar_count = std.enums.values(ir.Scalar).len,
            .maximum_count = std.math.maxInt(u32),
        };

        var empty = std.heap.FixedBufferAllocator.init(&.{});

        return zx.columns.invoke(generated.executeValue, empty.allocator(), &input) catch |err| switch (@as(anyerror, err)) {
            error.OutOfMemory => return error.OutOfMemory,
            else => unreachable,
        };
    }

    if (context.types.count() != 0 and !@import("../../../ir/type_rules.zig").validate(context.types)) return .Types;
    if (!@import("../../native_context.zig").valid(context.types, context.native_modules)) return .Native;
    if (!try @import("../../../analysis/semantic/origins.zig").valid(context.types, context.nominal_types)) return .Nominal;

    return .Ready;
}

fn failure(message: []const u8) Open {
    return .{ .diagnostic = .{ .code = .contract, .span = .{ .start = 0, .end = 0 }, .message = message } };
}

pub fn publish(type_only: bool, entry: bool, recursive: bool) Publication {
    if (comptime enabled) {
        const generated = @import("generated_project_body_publish");
        var empty = std.heap.FixedBufferAllocator.init(&.{});
        const input: std.meta.Child(generated.Input) = .{ .type_only = type_only, .entry = entry, .recursive = recursive };

        return zx.columns.invoke(generated.executeValue, empty.allocator(), &input) catch unreachable;
    }

    if (type_only) return .Types;
    if (entry) return if (recursive) .RecursiveEntry else .Entry;

    return if (recursive) .RecursiveDependency else .Dependency;
}
