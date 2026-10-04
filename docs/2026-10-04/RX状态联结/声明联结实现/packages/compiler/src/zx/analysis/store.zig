const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Analyzer = @import("analyzer.zig");
const StoreBinding = @import("analyze.zig").StoreBinding;

pub fn resolve(self: *Analyzer, bindings: []const StoreBinding, span: zx.Span) zx.Error![]const ir.StoreSlot {
    const result = try self.allocator.alloc(ir.StoreSlot, bindings.len);

    for (bindings, 0..) |binding, index| {
        if (binding.handle.len < 2 or binding.handle[0] != '$') return self.reporter.fail(.capability, span, "injected Store handles must start with $");

        for (bindings[0..index]) |previous| {
            if (std.mem.eql(u8, previous.handle, binding.handle) or std.mem.eql(u8, previous.path, binding.path)) return self.reporter.fail(.capability, span, "Store handle and Object path must be unique in a Call");
        }

        if ((binding.type_name == null) == (binding.type_id == null)) return self.reporter.fail(.capability, span, "Store bindings require exactly one named type or shared type ID");

        const type_id = if (binding.type_id) |id| typed: {
            if (@intFromEnum(id) >= self.store_type_count) return self.reporter.fail(.capability, span, "Store type ID must belong to the supplied shared type table");

            break :typed id;
        } else try self.types.named(.{ .text = binding.type_name.?, .span = span });

        if (self.types.get(type_id) != .object) return self.reporter.fail(.capability, span, "a Store handle must refer to a complete Object type");

        result[index] = .{ .handle = try self.allocator.dupe(u8, binding.handle), .path = try self.allocator.dupe(u8, binding.path), .type_id = type_id, .readable = binding.readable, .writable = binding.writable };
    }

    return result;
}

fn handleSlot(self: *Analyzer, target: *const zx.ast.Expression) zx.Error!u32 {
    if (target.value != .field or target.value.field.target.value != .identifier or !std.mem.eql(u8, target.value.field.name.text, "value")) return self.reporter.fail(.capability, target.span, "Store handles only expose the value getter and setter");
    if (self.lambda_depth != 0) return self.reporter.fail(.capability, target.span, "a callback cannot capture an injected Store handle");

    const name = target.value.field.target.value.identifier.text;

    for (self.stores, 0..) |slot, index| if (std.mem.eql(u8, slot.handle, name)) {
        return @intCast(index);
    };

    return self.reporter.fail(.capability, target.span, "this Store handle was not injected by the Call");
}

pub fn read(self: *Analyzer, target: *const zx.ast.Expression) zx.Error!ir.ExprId {
    const slot = try handleSlot(self, target);

    if (!self.stores[slot].readable) return self.reporter.fail(.capability, target.span, "the Call did not grant read access to this Store handle");

    return self.append(.{ .span = target.span, .type_id = self.stores[slot].type_id, .value = .{ .store_get = slot } });
}

pub fn writeSlot(self: *Analyzer, target: *const zx.ast.Expression) zx.Error!u32 {
    const slot = if (target.value == .field and target.value.field.target.value == .identifier) try handleSlot(self, target) else blk: {
        if (target.value != .field or target.value.field.target.value != .field or target.value.field.target.value.field.target.value != .identifier or !std.mem.eql(u8, target.value.field.target.value.field.target.value.identifier.text, "store")) return self.reporter.fail(.capability, target.span, "a Store setter must replace a complete Object");

        const path = try std.fmt.allocPrint(self.allocator, "store.{s}.{s}", .{ target.value.field.target.value.field.name.text, target.value.field.name.text });

        for (self.stores, 0..) |store, index| if (std.mem.eql(u8, store.path, path)) {
            break :blk @as(u32, @intCast(index));
        };

        return self.reporter.fail(.capability, target.span, "Store Object is not authorized by this Call");
    };

    if (!self.stores[slot].writable) return self.reporter.fail(.capability, target.span, "the Call did not grant write access to this Store handle");

    return slot;
}
