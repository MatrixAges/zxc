const std = @import("std");
const generated = @import("generated_bundle_abi");
pub const Input = std.meta.Child(generated.Input);
pub const Output = generated.Output;
pub const Bindings = std.meta.Child(@FieldType(Input, "modules"));
pub const Scope = std.meta.Child(std.meta.Child(@FieldType(Input, "scopes")));
pub const Native = std.meta.Child(std.meta.Child(@FieldType(Input, "natives")));
pub const Aliases = @typeInfo(@FieldType(Native, "aliases")).optional.child;
pub const Alias = std.meta.Child(std.meta.Child(Aliases));

pub fn scoped(allocator: std.mem.Allocator, identities: []const ?[]const u8) std.mem.Allocator.Error!bool {
    return @import("generated_source_abi_scoped").executeIn(allocator, identities) catch |err| switch (@as(anyerror, err)) {
        error.OutOfMemory => return error.OutOfMemory,
        else => unreachable,
    };
}

pub fn create(allocator: std.mem.Allocator, input: *const Input) (std.mem.Allocator.Error || error{ ConflictingNativeAbiAlias, NativeModuleNameConflict })!Output {
    const result = generated.executeIn(allocator, input) catch |err| switch (err) {
        error.OutOfMemory, error.Overflow => return error.OutOfMemory,
        else => unreachable,
    };

    switch (result.status) {
        .Valid => return result,
        .ConflictingAlias => return error.ConflictingNativeAbiAlias,
        .NameConflict => return error.NativeModuleNameConflict,
    }
}
