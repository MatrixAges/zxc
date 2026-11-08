const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;

pub fn descendant(program: ir.Program, parent: ir.TypeId, root: ir.TypeId) bool {
    return query(@import("generated_type_descendant"), program, .{ .parent = @backingInt(parent), .root = @backingInt(root) });
}

pub fn shared(program: ir.Program, input: ir.TypeId, output: ir.TypeId) bool {
    return query(@import("generated_type_shared"), program, .{ .input = @backingInt(input), .output = @backingInt(output) });
}

fn query(comptime entry: type, program: ir.Program, arguments: anytype) bool {
    const Input = std.meta.Child(entry.Input);
    const types = ir.TypeTable.borrow(std.meta.Child(@FieldType(Input, "types")), program.types);

    const input: Input = input: {
        var value: Input = undefined;
        value.types = &types;

        inline for (@typeInfo(@TypeOf(arguments)).@"struct".field_names) |name| @field(value, name) = @field(arguments, name);

        break :input value;
    };

    var fixed = std.heap.FixedBufferAllocator.init(&.{});

    return zx.columns.invoke(entry.executeValue, fixed.allocator(), &input) catch @panic("invalid type relation query");
}
