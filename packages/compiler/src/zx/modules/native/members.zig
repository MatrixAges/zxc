const std = @import("std");
const ir = @import("zx").ir;
const Native = @import("../interface.zig").Native;
const Self = @This();

pub const Member = struct {
    name: []const u8,
    signature: ir.Signature,
    pub fn function(self: Member) ir.Function {
        const signature = self.signature;

        return .{
            .file_name = signature.file_name,
            .input_type = signature.input_type,
            .output_type = signature.output_type,
            .output_ownership = signature.output_ownership,
            .external = signature.external,
            .symbols = .{},
            .expressions = .{},
            .body = .{},
        };
    }
};

allocator: std.mem.Allocator,
file_name: []const u8,
namespace: []const []const u8,
module: ir.NativeModuleId,
pub fn init(allocator: std.mem.Allocator, entry: Native, module: ir.NativeModuleId) std.mem.Allocator.Error!Self {
    return fromPath(allocator, entry.path, entry.namespace, module);
}

pub fn fromPath(allocator: std.mem.Allocator, path: []const u8, parts: []const []const u8, module: ir.NativeModuleId) std.mem.Allocator.Error!Self {
    const namespace = try @import("../compiled/host/native.zig").strings(allocator, parts);

    return .{ .allocator = allocator, .file_name = try allocator.dupe(u8, path), .namespace = namespace, .module = module };
}

pub fn create(self: Self, value: anytype, native_input: ir.NativeType) std.mem.Allocator.Error!Member {
    return self.own(value.name, .{
        .file_name = self.file_name,
        .input_type = @fromBackingInt(value.signature.input),
        .output_type = @fromBackingInt(value.signature.output),
        .output_ownership = .borrowed,
        .external = .{
            .input = native_input,
            .module = self.module,
            .member = &.{},
            .export_name = value.name,
            .allocator_argument = value.allocator_argument,
            .io_argument = value.io_argument,
            .process_argument = value.process_argument,
            .expand_tuple = value.expand_tuple,
            .fallible = value.fallible,
            .errors = value.errors,
            .concurrent = value.concurrent,
        },
    });
}

pub fn own(self: Self, source_name: []const u8, signature: ir.Signature) std.mem.Allocator.Error!Member {
    const allocator = self.allocator;
    const name = try allocator.dupe(u8, source_name);
    const path = try allocator.alloc([]const u8, self.namespace.len + 1);

    @memcpy(path[0..self.namespace.len], self.namespace);

    path[self.namespace.len] = name;

    var result = signature;
    var external = signature.external.?;

    external.module = self.module;
    external.member = path;
    external.export_name = if (external.export_name != null) name else null;
    result.file_name = self.file_name;
    result.external = try @import("../compiled/host/function.zig").copyExternalDetails(allocator, external);

    return .{ .name = name, .signature = result };
}
