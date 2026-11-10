const std = @import("std");
const Lower = @import("lower.zig");
const modules = @import("modules.zig");

pub fn append(lower: *Lower, names: modules.Names, members: []const modules.PublicMember) modules.Error!@import("../node/stored.zig").Declarations {
    if (comptime !@import("genz_options").generated_analysis) return @import("public_exports_seed.zig").append(lower, names, members);

    var scratch = std.heap.ArenaAllocator.init(lower.workspace);

    defer scratch.deinit();

    const temporary = scratch.allocator();
    const generated = @import("generated_public_exports");
    const Input = @typeInfo(@TypeOf(generated.executeValue)).@"fn".param_types[1].?;
    const member_names = try temporary.alloc([]const u8, members.len);
    const functions = try temporary.alloc(u32, members.len);

    for (members, member_names, functions) |member, *name, *id| {
        name.* = member.name;
        id.* = @backingInt(member.function);
    }

    const start: u32 = @intCast(lower.builder.nodes.declaration_rows.tags.items.len);

    const input: Input = .{
        .names = member_names,
        .functions = functions,
        .paths = names.functions,
        .expression_base = @intCast(lower.builder.nodes.expressions.tags.items.len),
        .declaration_base = start,
    };

    const output = generated.executeValue(lower.allocator, input) catch |err| return failure(err);

    if (!output.valid) return error.OutOfMemory;

    const Output = std.meta.Child(generated.Output);
    const Expressions = std.meta.Child(@FieldType(Output, "expressions"));
    const Declarations = std.meta.Child(@FieldType(Output, "declarations"));
    const columns = @import("zx").columns;
    const expressions = columns.view(Expressions, output.expressions);
    const declarations = columns.view(Declarations, output.declarations);
    const rows = @import("../node/import_rows.zig");

    rows.appendBorrowed(lower.allocator, &lower.builder.nodes.expressions, &expressions) catch |err| return failure(err);
    rows.appendBorrowed(lower.allocator, &lower.builder.nodes.declaration_rows, &declarations) catch |err| return failure(err);

    return .{ .start = start, .len = @intCast(output.declarations.tags.len) };
}

fn failure(err: anyerror) modules.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => unreachable,
    };
}
