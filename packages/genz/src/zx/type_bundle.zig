const std = @import("std");
const node = @import("../node.zig");
const Lower = @import("lower.zig");

pub fn declarations(self: *Lower) Lower.Error![]const node.Declaration {
    var output: std.ArrayList(node.Declaration) = .empty;
    var modules: std.ArrayList(node.Declaration) = .empty;
    var layouts: std.ArrayList(node.Declaration) = .empty;
    var scoped = false;

    for (0..self.program.native_modules.count()) |module_row| {
        const module = self.program.native_modules.at(module_row);

        if (module.identity != null) scoped = true;
    }

    try @import("types.zig").lower(self, &output, true);

    var seen: std.StringHashMapUnmanaged(void) = .empty;

    for (0..self.program.native_modules.count()) |module_row| {
        const module = self.program.native_modules.at(module_row);
        const entry = try seen.getOrPut(self.allocator, module.key());

        if (entry.found_existing) continue;

        var names: std.StringHashMapUnmanaged(void) = .empty;
        var members: std.ArrayList(node.Declaration) = .empty;
        var storage: std.ArrayList(node.Declaration) = .empty;

        for (0..self.program.native_modules.count()) |implementation_row| {
            const implementation = self.program.native_modules.at(implementation_row);

            if (!std.mem.eql(u8, implementation.key(), module.key())) continue;

            for (0..implementation.types.count()) |binding_index| {
                const binding = implementation.types.at(binding_index);
                const name = try names.getOrPut(self.allocator, binding.name);

                if (name.found_existing) continue;

                try members.append(self.allocator, .{ .constant = .{
                    .name = binding.name,
                    .value = self.types[@backingInt(binding.type_id)],
                    .exported = true,
                } });

                try storage.append(self.allocator, .{ .constant = .{
                    .name = binding.name,
                    .value = self.layouts[@backingInt(binding.type_id)],
                    .exported = true,
                } });
            }
        }

        for (0..self.program.functions.count()) |function_row| {
            const function = self.program.functions.at(function_row);
            const external = function.external orelse continue;
            const implementation = self.program.native_modules.at(@backingInt(external.module));

            if (!std.mem.eql(u8, implementation.key(), module.key())) continue;

            const name = try names.getOrPut(self.allocator, external.exportName());

            if (name.found_existing) continue;

            const signature = try self.allocator.alloc(node.Declaration, 4);
            signature[0] = .{ .constant = .{ .name = "Input", .value = self.types[@backingInt(function.input_type)], .exported = true } };
            signature[1] = .{ .constant = .{ .name = "Output", .value = self.types[@backingInt(function.output_type)], .exported = true } };
            signature[2] = .{ .constant = .{ .name = "InputValue", .value = self.layouts[@backingInt(function.input_type)], .exported = true } };
            signature[3] = .{ .constant = .{ .name = "OutputValue", .value = self.layouts[@backingInt(function.output_type)], .exported = true } };

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
