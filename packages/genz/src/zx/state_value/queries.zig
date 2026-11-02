const std = @import("std");
const ir = @import("zx").ir;

pub const Kind = if (@import("genz_options").generated_analysis)
    std.meta.Child(@FieldType(std.meta.Child(@import("generated_function_facts").Output), "state_queries"))

else
    u8;

const Property = if (@import("genz_options").generated_analysis)
    @FieldType(std.meta.Child(@import("generated_state_query").Input), "property")

else
    u8;

pub fn create(allocator: std.mem.Allocator, program: ir.Program, selected: []const bool) std.mem.Allocator.Error![]const Kind {
    if (comptime !@import("genz_options").generated_analysis) return &.{};

    const generated = @import("generated_state_query_plan");
    const Input = std.meta.Child(generated.Input);
    const types = ir.TypeTable.borrow(std.meta.Child(@FieldType(Input, "types")), program.types);
    const input: Input = .{ .types = &types, .selected = selected };
    var scratch = std.heap.ArenaAllocator.init(allocator);

    defer scratch.deinit();

    const output = generated.executeIn(scratch.allocator(), &input) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => unreachable,
    };

    return allocator.dupe(Kind, output);
}

pub fn read(value: Kind, property: Property) bool {
    const table = comptime build();

    return table[@backingInt(value)][@backingInt(property)];
}

fn build() [@typeInfo(Kind).@"enum".field_names.len][@typeInfo(Property).@"enum".field_names.len]bool {
    const generated = @import("generated_state_query");
    var table: [@typeInfo(Kind).@"enum".field_names.len][@typeInfo(Property).@"enum".field_names.len]bool = undefined;

    for (std.enums.values(Kind)) |value| {
        for (std.enums.values(Property)) |property| {
            const input: std.meta.Child(generated.Input) = .{ .value = value, .property = property };

            table[@backingInt(value)][@backingInt(property)] = generated.executeValue(std.heap.page_allocator, &input) catch unreachable;
        }
    }

    return table;
}
