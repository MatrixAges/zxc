const std = @import("std");
const zx = @import("zx");
const registry = @import("../target/registry.zig");
const interface = @import("../../interface.zig");
const enabled = @import("parser_options").generated_parser;

pub const Route = union(enum) { native: *const interface.Native, legacy, duplicate, conflict, invalid_legacy };

pub fn route(scoped: []const interface.Native, externals: []const interface.External, item: anytype) Route {
    const selected = registry.native(scoped, item.path, true);
    const conflict = selected == .found and registry.select(externals, "specifier", item.path, false).first != null;

    if (comptime enabled) {
        const generated = @import("generated_project_interface_route");
        const Input = std.meta.Child(generated.Input);

        const input: Input = .{
            .found = selected == .found,
            .duplicate = selected == .duplicate,
            .legacy_conflict = conflict,
            .function_import = item.kind == .function,
            .binding_count = item.nameCount(),
        };

        var scratch = std.heap.FixedBufferAllocator.init(&.{});

        return switch (zx.columns.invoke(generated.executeValue, scratch.allocator(), &input) catch unreachable) {
            .Native => .{ .native = selected.found },
            .Legacy => .legacy,
            .Duplicate => .duplicate,
            .Conflict => .conflict,
            .InvalidLegacy => .invalid_legacy,
        };
    }

    return switch (selected) {
        .duplicate => .duplicate,
        .found => |entry| if (conflict) .conflict else .{ .native = entry },
        .missing => if (item.kind == .function and item.nameCount() == 1) .legacy else .invalid_legacy,
    };
}

const Binding = struct {
    name: []const u8,
    namespace: ?[]const u8,
};

pub const Legacy = struct {
    names: std.StringHashMapUnmanaged(void) = .empty,
    previous_default: bool = false,
    pub fn bind(self: *Legacy, allocator: std.mem.Allocator, export_name: ?[]const u8, local: []const u8) std.mem.Allocator.Error!?Binding {
        const count = self.names.count();
        const claimed = try self.names.getOrPut(allocator, export_name orelse "");

        if (comptime enabled) {
            const generated = @import("generated_project_legacy_binding");
            const Input = std.meta.Child(generated.Input);

            const input: Input = .{
                .export_name = export_name,
                .local = local,
                .duplicate = claimed.found_existing,
                .count = count,
                .previous_default = self.previous_default,
            };

            var scratch = std.heap.FixedBufferAllocator.init(&.{});
            const result = zx.columns.invoke(generated.executeValue, scratch.allocator(), &input) catch unreachable;

            if (!result.valid) return null;

            self.previous_default = result.default_export;

            return .{ .name = result.name, .namespace = result.namespace };
        }

        if (claimed.found_existing or (count != 0 and (self.previous_default or export_name == null))) return null;

        self.previous_default = export_name == null;

        return .{
            .name = export_name orelse local,
            .namespace = if (export_name != null) local else null,
        };
    }
};
