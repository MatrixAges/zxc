const std = @import("std");
const f = @import("fixture.zig");
const ir = f.ir;
pub const Mode = enum { missing_owner, renamed_binding, renamed_type, distinct_owner, same_owner, unnamed_input, mismatched_input, concurrent, scalar_source, nested_concurrent, nested_scalar_source, store };

pub fn apply(allocator: std.mem.Allocator, original: ir.Program, mode: Mode) !ir.Program {
    var program = original;
    var modules: ir.NativeModuleStorage = .{};

    for (0..original.native_modules.count()) |index| try modules.append(allocator, original.native_modules.at(index));

    const names = try allocator.dupe([]const u8, modules.type_names.items[0]);
    const input_types = try allocator.dupe(u32, original.functions.input_types);
    const output_types = try allocator.dupe(u32, original.functions.output_types);
    const native_inputs = try allocator.dupe(?ir.NativeType, original.functions.native_inputs);
    const native_concurrent = try allocator.dupe(bool, original.functions.native_concurrent);
    const labels = try allocator.dupe([]const u8, original.types.labels);
    const reference: ir.TypeId = @fromBackingInt(modules.type_ids.items[0][0]);
    program.native_modules = modules.view();
    program.functions.input_types = input_types;
    program.functions.output_types = output_types;
    program.functions.native_inputs = native_inputs;
    program.functions.native_concurrent = native_concurrent;
    program.types.labels = labels;
    modules.type_names.items[0] = names;

    switch (mode) {
        .missing_owner => {
            modules.type_names.items[0] = &.{};
            modules.type_ids.items[0] = &.{};
        },
        .renamed_binding => names[0] = "Other",
        .renamed_type => labels[@backingInt(reference)] = "Other",
        .distinct_owner, .same_owner => {
            var repeated = modules.at(0);

            repeated.import_name = "alias";

            if (mode == .distinct_owner) repeated.identity = "another-owner";
            try modules.append(allocator, repeated);

            program.native_modules = modules.view();
        },
        .store => program.stores = try ir.StoreTable.fromValues(allocator, &.{.{ .path = "store.host", .type_id = original.output_type }}),
        else => {
            program = f.nativeOnly(program);

            for (original.functions.native_modules, 0..) |module, index| {
                if (module == null) continue;

                switch (mode) {
                    .unnamed_input => native_inputs[index] = .{},
                    .mismatched_input => native_inputs[index] = .{ .names = &.{"Other"} },
                    .concurrent => native_concurrent[index] = true,
                    .scalar_source => {
                        input_types[index] = @backingInt(ir.Scalar.u64);
                        native_inputs[index] = .{};
                    },
                    .nested_concurrent => {
                        input_types[index] = @backingInt(original.output_type);
                        native_inputs[index] = null;
                        output_types[index] = @backingInt(ir.Scalar.u64);
                        native_concurrent[index] = true;
                    },
                    .nested_scalar_source => {
                        input_types[index] = @backingInt(ir.Scalar.u64);
                        native_inputs[index] = .{};
                        output_types[index] = @backingInt(original.output_type);
                    },
                    else => unreachable,
                }
            }
        },
    }

    return program;
}
