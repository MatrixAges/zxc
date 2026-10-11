const std = @import("std");
const zx = @import("zx");
const Context = @import("context.zig");
const FunctionImport = @import("../function_import.zig");

pub fn apply(allocator: std.mem.Allocator, item: anytype, context: Context, reporter: *zx.Reporter, aliases: *std.ArrayList(zx.ir.Export), imports: *std.ArrayList(FunctionImport)) zx.Error!void {
    if (item.kind == .function) {
        if (context.target == .native) {
            if (item.nameCount() != 1 or context.members.len == 0) return reporter.fail(.module, item.span, "native namespaces require one binding and callable exports");

            for (context.members) |member| {
                var binding = member;
                binding.namespace = try allocator.dupe(u8, item.nameAt(0).text);

                try imports.append(allocator, binding);
            }
        } else {
            if (context.type_only or item.nameCount() != 1) return reporter.fail(.module, item.span, "default imports must refer to an executable module");

            var binding = context.members[0];
            binding.name = try allocator.dupe(u8, item.nameAt(0).text);

            try imports.append(allocator, binding);
        }

        return;
    }

    if (context.target == .source and !context.type_only) return reporter.fail(.module, item.span, "type and enum imports must refer to a pure type module");

    for (0..item.nameCount()) |index| {
        const name = item.nameAt(index);
        var found = false;

        for (context.exports) |exported| {
            if (!std.mem.eql(u8, name.text, exported.name)) continue;
            if (item.kind == .enumeration and context.types.get(exported.type_id) != .enumeration) return reporter.fail(.module, name.span, if (context.target == .native) "native value imports must name an enum" else "value imports from a type module must name an enum");
            try aliases.append(allocator, .{ .name = try allocator.dupe(u8, name.text), .type_id = exported.type_id });

            found = true;

            break;
        }

        if (!found) return reporter.fail(.module, name.span, if (context.target == .native) "native interface does not export this type" else "the imported name is not exported by the module");
    }
}
