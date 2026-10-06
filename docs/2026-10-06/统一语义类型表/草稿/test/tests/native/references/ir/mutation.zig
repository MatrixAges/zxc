const std = @import("std");
const f = @import("fixture.zig");
const ir = f.ir;
pub const Mode = enum { missing_owner, renamed_binding, renamed_type, distinct_owner, same_owner, unnamed_input, mismatched_input, concurrent, scalar_source, nested_concurrent, nested_scalar_source, store };

pub fn apply(allocator: std.mem.Allocator, original: ir.Program, mode: Mode) !ir.Program {
    var program = original;
    const modules = try allocator.dupe(ir.NativeModule, original.native_modules);
    const bindings = try allocator.dupe(ir.Export, modules[0].types);
    const functions = try allocator.dupe(ir.Function, original.functions);
    const labels = try allocator.dupe([]const u8, original.types.labels);
    const reference = bindings[0].type_id;
    program.native_modules = modules;
    program.functions = functions;
    program.types.labels = labels;
    modules[0].types = bindings;

    switch (mode) {
        .missing_owner => modules[0].types = &.{},
        .renamed_binding => bindings[0].name = "Other",
        .renamed_type => labels[@backingInt(reference)] = "Other",
        .distinct_owner, .same_owner => {
            const repeated = try allocator.alloc(ir.NativeModule, 2);

            repeated[0] = modules[0];
            repeated[1] = modules[0];
            repeated[1].import_name = "alias";

            if (mode == .distinct_owner) repeated[1].identity = "another-owner";

            program.native_modules = repeated;
        },
        .store => program.stores = try allocator.dupe(ir.StoreSlot, &.{.{ .path = "store.host", .type_id = original.output_type }}),
        else => {
            program = f.nativeOnly(program);

            for (functions) |*function| {
                if (function.external == null) continue;

                switch (mode) {
                    .unnamed_input => function.external.?.input = .{},
                    .mismatched_input => function.external.?.input = .{ .name = "Other" },
                    .concurrent => function.external.?.concurrent = true,
                    .scalar_source => {
                        function.input_type = @fromBackingInt(@backingInt(ir.Scalar.u64));
                        function.external.?.input = .{};
                    },
                    .nested_concurrent => {
                        function.input_type = original.output_type;
                        function.external.?.input = null;
                        function.output_type = @fromBackingInt(@backingInt(ir.Scalar.u64));
                        function.external.?.concurrent = true;
                    },
                    .nested_scalar_source => {
                        function.input_type = @fromBackingInt(@backingInt(ir.Scalar.u64));
                        function.external.?.input = .{};
                        function.output_type = original.output_type;
                    },
                    else => unreachable,
                }
            }
        },
    }

    return program;
}
