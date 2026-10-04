const std = @import("std");
const node = @import("../node.zig");
const Lower = @import("lower.zig");

pub fn declarations(self: *Lower) Lower.Error![]const node.Declaration {
    var output: std.ArrayList(node.Declaration) = .empty;
    var modules: std.ArrayList(node.Declaration) = .empty;
    var layouts: std.ArrayList(node.Declaration) = .empty;
    var scoped = false;

    for (self.program.native_modules) |module| {
        if (module.identity != null) scoped = true;
    }

    try @import("types.zig").lower(self, &output, true);

    var seen: std.StringHashMapUnmanaged(void) = .empty;

    for (self.program.native_modules) |module| {
        const entry = try seen.getOrPut(self.allocator, module.key());

        if (entry.found_existing) continue;

        var names: std.StringHashMapUnmanaged(void) = .empty;
        var members: std.ArrayList(node.Declaration) = .empty;
        var storage: std.ArrayList(node.Declaration) = .empty;

        for (self.program.native_modules) |implementation| {
            if (!std.mem.eql(u8, implementation.key(), module.key())) continue;

            for (implementation.types) |binding| {
                const name = try names.getOrPut(self.allocator, binding.name);

                if (name.found_existing) continue;

                try members.append(self.allocator, .{ .constant = .{
                    .name = binding.name,
                    .value = self.types[@intFromEnum(binding.type_id)],
                    .exported = true,
                } });

                try storage.append(self.allocator, .{ .constant = .{
                    .name = binding.name,
                    .value = self.layouts[@intFromEnum(binding.type_id)],
                    .exported = true,
                } });
            }
        }

        for (self.program.functions) |function| {
            const external = function.external orelse continue;
            const implementation = self.program.native_modules[@intFromEnum(external.module)];

            if (!std.mem.eql(u8, implementation.key(), module.key())) continue;

            const name = try names.getOrPut(self.allocator, external.exportName());

            if (name.found_existing) continue;

            const signature = try self.allocator.alloc(node.Declaration, 4);
            signature[0] = .{ .constant = .{ .name = "Input", .value = self.types[@intFromEnum(function.input_type)], .exported = true } };
            signature[1] = .{ .constant = .{ .name = "Output", .value = self.types[@intFromEnum(function.output_type)], .exported = true } };
            signature[2] = .{ .constant = .{ .name = "InputValue", .value = self.layouts[@intFromEnum(function.input_type)], .exported = true } };
            signature[3] = .{ .constant = .{ .name = "OutputValue", .value = self.layouts[@intFromEnum(function.output_type)], .exported = true } };

            try members.append(self.allocator, .{ .constant = .{
                .name = external.exportName(),
                .value = try self.builder.expression(.{ .namespace_type = signature }),
                .exported = true,
            } });
        }

        try modules.append(self.allocator, .{ .constant = .{
            .name = module.key(),
            .value = try self.builder.expression(.{ .namespace_type = try members.toOwnedSlice(self.allocator) }),
            .exported = true,
        } });

        try layouts.append(self.allocator, .{ .constant = .{
            .name = module.key(),
            .value = try self.builder.expression(.{ .namespace_type = try storage.toOwnedSlice(self.allocator) }),
            .exported = true,
        } });
    }

    try output.append(self.allocator, .{ .constant = .{
        .name = if (scoped) "native_by_identity" else "native",
        .value = try self.builder.expression(.{ .namespace_type = try modules.toOwnedSlice(self.allocator) }),
        .exported = true,
    } });

    try output.append(self.allocator, .{ .constant = .{
        .name = if (scoped) "layouts_by_identity" else "layouts",
        .value = try self.builder.expression(.{ .namespace_type = try layouts.toOwnedSlice(self.allocator) }),
        .exported = true,
    } });

    return output.toOwnedSlice(self.allocator);
}
