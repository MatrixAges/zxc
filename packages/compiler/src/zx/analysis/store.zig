const std = @import("std");
const zx = @import("zx");
const syntax = zx.syntax.borrow;
const ir = zx.ir;
const Analyzer = @import("analyzer.zig");
const StoreBinding = @import("analyze.zig").StoreBinding;

pub fn resolve(self: *Analyzer, bindings: []const StoreBinding, span: zx.Span) zx.Error!ir.StoreTable {
    var result: ir.StoreStorage = .{};

    errdefer result.deinit(self.allocator);

    for (bindings, 0..) |binding, index| {
        if (binding.handle.len < 2 or binding.handle[0] != '$') return self.reporter.fail(.capability, span, "injected Store handles must start with $");

        for (bindings[0..index]) |previous| {
            if (std.mem.eql(u8, previous.handle, binding.handle) or std.mem.eql(u8, previous.path, binding.path)) return self.reporter.fail(.capability, span, "Store handle and Object path must be unique in a Call");
        }

        if ((binding.type_name == null) == (binding.type_id == null)) return self.reporter.fail(.capability, span, "Store bindings require exactly one named type or shared type ID");

        const type_id = if (binding.type_id) |id| typed: {
            if (@backingInt(id) >= self.store_type_count) return self.reporter.fail(.capability, span, "Store type ID must belong to the supplied shared type table");

            break :typed id;
        } else try self.types.named(.{ .text = binding.type_name.?, .span = span });

        if (try ir.containsNativeReference(self.allocator, self.types.items.view(), type_id)) return self.reporter.fail(.capability, span, "Store cannot retain host references");
        if (self.types.get(type_id) != .object) return self.reporter.fail(.capability, span, "a Store handle must refer to a complete Object type");
        try result.append(self.allocator, .{ .handle = try self.allocator.dupe(u8, binding.handle), .path = try self.allocator.dupe(u8, binding.path), .type_id = type_id, .readable = binding.readable, .writable = binding.writable });
    }

    return result.finish(self.allocator);
}

fn handleSlot(self: *Analyzer, target: anytype) zx.Error!u32 {
    const node = syntax.value(target);

    if (node != .field) return self.reporter.fail(.capability, target.span, "Store handles only expose the value getter and setter");

    const owner = syntax.value(node.field.target);

    if (owner != .identifier or !std.mem.eql(u8, node.field.name.text, "value")) return self.reporter.fail(.capability, target.span, "Store handles only expose the value getter and setter");
    if (self.lambda_depth != 0) return self.reporter.fail(.capability, target.span, "a callback cannot capture an injected Store handle");

    const name = owner.identifier.text;

    for (self.stores.handles, 0..) |handle, index| if (std.mem.eql(u8, handle, name)) {
        return @intCast(index);
    };

    return self.reporter.fail(.capability, target.span, "this Store handle was not injected by the Call");
}

pub fn read(self: *Analyzer, target: anytype) zx.Error!ir.ExprId {
    const slot = try handleSlot(self, target);

    if (!self.stores.at(slot).readable) return self.reporter.fail(.capability, target.span, "the Call did not grant read access to this Store handle");

    return self.append(.{ .span = target.span, .type_id = self.stores.at(slot).type_id, .value = .{ .store_get = slot } });
}

pub fn writeSlot(self: *Analyzer, target: anytype) zx.Error!u32 {
    const node = syntax.value(target);

    const slot = if (node == .field and syntax.value(node.field.target) == .identifier) try handleSlot(self, target) else blk: {
        const message = "a Store setter must replace a complete Object";

        if (node != .field) return self.reporter.fail(.capability, target.span, message);

        const object = syntax.value(node.field.target);

        if (object != .field) return self.reporter.fail(.capability, target.span, message);

        const root = syntax.value(object.field.target);

        if (root != .identifier or !std.mem.eql(u8, root.identifier.text, "store")) return self.reporter.fail(.capability, target.span, message);

        const path = try std.fmt.allocPrint(self.allocator, "store.{s}.{s}", .{ object.field.name.text, node.field.name.text });

        for (self.stores.paths, 0..) |store_path, index| if (std.mem.eql(u8, store_path, path)) {
            break :blk @as(u32, @intCast(index));
        };

        return self.reporter.fail(.capability, target.span, "Store Object is not authorized by this Call");
    };

    if (!self.stores.at(slot).writable) return self.reporter.fail(.capability, target.span, "the Call did not grant write access to this Store handle");

    return slot;
}
