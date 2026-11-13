const std = @import("std");
const zx = @import("zx");
const model = @import("symbols.zig");
const Symbols = model.Symbols;
const Selection = model.Selection;

const Bucket = struct {
    names: std.ArrayList([]const u8) = .empty,
    indices: std.ArrayList(u64) = .empty,
    fn append(self: *Bucket, allocator: std.mem.Allocator, name: []const u8, index: usize) std.mem.Allocator.Error!void {
        try self.names.append(allocator, name);
        try self.indices.append(allocator, @intCast(index));
    }
    fn view(self: *const Bucket) model.Bindings {
        return .{ .names = self.names.items, .indices = self.indices.items };
    }
};

const Name = struct { original: []const u8, local: []const u8, span: zx.Span };

pub fn select(allocator: std.mem.Allocator, item: anytype, symbols: *const Symbols, reporter: *zx.Reporter) zx.Error!Selection {
    var aliases = Bucket{};
    var constants = Bucket{};
    var functions = Bucket{};
    var namespace: ?[]const u8 = null;
    var names: std.ArrayList(Name) = .empty;

    if (item.kind == .function) {
        if (symbols.target == .native) {
            if (item.nameCount() != 1 or symbols.functions.len == 0) return reporter.fail(.module, item.span, "native namespaces require one binding and callable exports");

            namespace = item.nameAt(0).text;
            for (symbols.functions, 0..) |name, index| try functions.append(allocator, name, index);

            return .{ .aliases = aliases.view(), .constants = constants.view(), .functions = functions.view(), .namespace = namespace };
        }

        if (item.nameCount() != 1 or position(symbols.functions, "") == null) return reporter.fail(.module, item.span, "default imports must refer to an executable module");
    }

    if (item.wildcard) {
        for (symbols.exports) |value| try names.append(allocator, .{ .original = value.name, .local = value.name, .span = item.span });

        if (item.kind != .type_only) {
            for (symbols.constants) |value| try names.append(allocator, .{ .original = value.name, .local = value.name, .span = item.span });

            for (symbols.functions) |name| {
                if (name.len != 0) try names.append(allocator, .{ .original = name, .local = name, .span = item.span });
            }
        }
    } else for (0..item.nameCount()) |index| {
        const name = item.sourceAt(index);

        try names.append(allocator, .{ .original = name.text, .local = item.nameAt(index).text, .span = name.span });
    }

    const constant_names = try allocator.alloc([]const u8, if (item.kind == .type_only) 0 else symbols.constants.len);
    const type_names = try allocator.alloc([]const u8, symbols.exports.len);

    for (symbols.constants[0..constant_names.len], constant_names) |*value, *name| name.* = value.name;
    for (symbols.exports, type_names) |value, *name| name.* = value.name;

    for (names.items) |name| {
        if (item.kind != .type_only) {
            const reference = if (item.kind == .function or std.mem.eql(u8, name.original, "default")) "" else name.original;

            if (position(symbols.functions, reference)) |index| {
                try functions.append(allocator, if (item.exported and std.mem.eql(u8, name.local, "default")) "" else name.local, index);

                continue;
            }

            if (item.kind == .enumeration) {
                if (position(constant_names, name.original)) |index| {
                    try constants.append(allocator, name.local, index);

                    continue;
                }
            }
        }

        if (position(type_names, name.original)) |index| {
            if (!item.exported and item.kind == .enumeration and symbols.types.get(symbols.exports[index].type_id) != .enumeration) return reporter.fail(.module, name.span, if (symbols.target == .native) "native value imports must name an enum" else "value imports from a type module must name an enum");
            try aliases.append(allocator, name.local, index);

            continue;
        }

        return reporter.fail(.module, name.span, if (symbols.target == .native) "native interface does not export this type" else "the imported name is not exported by the module");
    }

    return .{ .aliases = aliases.view(), .constants = constants.view(), .functions = functions.view(), .namespace = namespace };
}

fn position(names: []const []const u8, name: []const u8) ?usize {
    for (names, 0..) |value, index| if (std.mem.eql(u8, value, name)) return index;

    return null;
}
