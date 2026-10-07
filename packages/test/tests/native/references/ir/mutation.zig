const std = @import("std");
const f = @import("fixture.zig");
const ir = f.ir;
pub const Mode = enum { missing_owner, renamed_binding, renamed_type, distinct_owner, same_owner, unnamed_input, mismatched_input, concurrent, scalar_source, nested_concurrent, nested_scalar_source, store };

pub fn apply(allocator: std.mem.Allocator, original: ir.Program, mode: Mode) !ir.Program {
    var program = original;
    const modules = try allocator.dupe(ir.NativeModule, original.native_modules);
    const bindings = try allocator.dupe(ir.Export, modules[0].types);
    const input_types = try allocator.dupe(u32, original.functions.input_types);
    const output_types = try allocator.dupe(u32, original.functions.output_types);
    const external = try allocator.dupe(?ir.External, original.functions.external);
    const labels = try allocator.dupe([]const u8, original.types.labels);
    const reference = bindings[0].type_id;
    program.native_modules = modules;
    program.functions.input_types = input_types;
    program.functions.output_types = output_types;
    program.functions.external = external;
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
        .store => program.stores = try ir.StoreTable.fromValues(allocator, &.{.{ .path = "store.host", .type_id = original.output_type }}),
        else => {
            program = f.nativeOnly(program);

            for (external, 0..) |*value, index| {
                if (value.* == null) continue;

                switch (mode) {
                    .unnamed_input => value.*.?.input = .{},
                    .mismatched_input => value.*.?.input = .{ .name = "Other" },
                    .concurrent => value.*.?.concurrent = true,
                    .scalar_source => {
                        input_types[index] = @backingInt(ir.Scalar.u64);
                        value.*.?.input = .{};
                    },
                    .nested_concurrent => {
                        input_types[index] = @backingInt(original.output_type);
                        value.*.?.input = null;
                        output_types[index] = @backingInt(ir.Scalar.u64);
                        value.*.?.concurrent = true;
                    },
                    .nested_scalar_source => {
                        input_types[index] = @backingInt(ir.Scalar.u64);
                        value.*.?.input = .{};
                        output_types[index] = @backingInt(original.output_type);
                    },
                    else => unreachable,
                }
            }
        },
    }

    return program;
}
