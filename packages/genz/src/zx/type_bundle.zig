const std = @import("std");
const zx = @import("zx");
const node = @import("../node.zig");
const Lower = @import("lower.zig");

pub fn declarations(self: *Lower) Lower.Error![]const node.Declaration {
    if (!@import("genz_options").generated_analysis) return @import("type_bundle/seed.zig").declarations(self);

    const generated = @import("generated_native_namespaces");
    const Input = std.meta.Child(generated.Input);
    const Modules = std.meta.Child(@FieldType(Input, "modules"));
    const Functions = std.meta.Child(@FieldType(Input, "functions"));
    var scratch = std.heap.ArenaAllocator.init(self.workspace);

    defer scratch.deinit();

    var modules: Modules = undefined;
    var functions: Functions = undefined;

    inline for (@typeInfo(Modules).@"struct".field_names) |name| {
        @field(modules, name) = zx.columns.slice(@FieldType(Modules, name), @field(self.program.native_modules, name));
    }

    inline for (@typeInfo(Functions).@"struct".field_names) |name| {
        @field(functions, name) = zx.columns.slice(@FieldType(Functions, name), @field(self.program.functions, name));
    }

    const plan = generated.executeIn(scratch.allocator(), &.{ .modules = &modules, .functions = &functions }) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => unreachable,
    };

    var output: std.ArrayList(node.Declaration) = .empty;
    var namespaces: std.ArrayList(node.Declaration) = .empty;
    var layouts: std.ArrayList(node.Declaration) = .empty;

    try @import("types.zig").lower(self, &output, true);

    for (plan.groups) |group| {
        var members: std.ArrayList(node.Declaration) = .empty;
        var storage: std.ArrayList(node.Declaration) = .empty;

        for (group.types) |entry| {
            const implementation = self.program.native_modules.at(@intCast(entry.module));
            const binding = implementation.types.at(@intCast(entry.binding));

            try members.append(self.allocator, .{ .constant = .{
                .name = binding.name,
                .value = try self.typeExpr(binding.type_id),
                .exported = true,
            } });

            try storage.append(self.allocator, .{ .constant = .{
                .name = binding.name,
                .value = try self.layoutExpr(binding.type_id),
                .exported = true,
            } });
        }

        for (group.functions) |index| {
            const function = self.program.functions.at(@intCast(index));
            const external = function.external.?;
            const signature = try self.allocator.alloc(node.Declaration, 4);
            signature[0] = .{ .constant = .{ .name = "Input", .value = try self.typeExpr(function.input_type), .exported = true } };
            signature[1] = .{ .constant = .{ .name = "Output", .value = try self.typeExpr(function.output_type), .exported = true } };
            signature[2] = .{ .constant = .{ .name = "InputValue", .value = try self.layoutExpr(function.input_type), .exported = true } };
            signature[3] = .{ .constant = .{ .name = "OutputValue", .value = try self.layoutExpr(function.output_type), .exported = true } };

            try members.append(self.allocator, .{ .constant = .{
                .name = external.exportName(),
                .value = try self.builder.expression(.{ .namespace_type = signature }),
                .exported = true,
            } });
        }

        try namespaces.append(self.allocator, .{ .constant = .{
            .name = group.key,
            .value = try self.builder.expression(.{ .namespace_type = try members.toOwnedSlice(self.allocator) }),
            .exported = true,
        } });

        try layouts.append(self.allocator, .{ .constant = .{
            .name = group.key,
            .value = try self.builder.expression(.{ .namespace_type = try storage.toOwnedSlice(self.allocator) }),
            .exported = true,
        } });
    }

    try output.append(self.allocator, .{ .constant = .{
        .name = plan.native_name,
        .value = try self.builder.expression(.{ .namespace_type = try namespaces.toOwnedSlice(self.allocator) }),
        .exported = true,
    } });

    try output.append(self.allocator, .{ .constant = .{
        .name = plan.layouts_name,
        .value = try self.builder.expression(.{ .namespace_type = try layouts.toOwnedSlice(self.allocator) }),
        .exported = true,
    } });

    return output.toOwnedSlice(self.allocator);
}
