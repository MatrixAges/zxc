const std = @import("std");
const zx = @import("zx");
const node = @import("../node.zig");
const Lower = @import("lower.zig");

pub fn declarations(self: *Lower) Lower.Error!@import("../node/stored.zig").Declarations {
    if (!@import("genz_options").generated_analysis) return self.builder.nodes.declarations(self.allocator, try @import("type_bundle/seed.zig").declarations(self));

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

    var prefix: std.ArrayList(node.Declaration) = .empty;

    try @import("types.zig").lower(self, &prefix, true);

    const emitter = @import("generated_native_declarations");
    const EmitInput = std.meta.Child(emitter.Input);

    const input = EmitInput{
        .plan = plan,
        .modules = &modules,
        .functions = &functions,
        .types = @import("../node/view.zig").slice(@FieldType(EmitInput, "types"), @as([]const node.ExpressionId, self.types)),
        .layouts = @import("../node/view.zig").slice(@FieldType(EmitInput, "layouts"), @as([]const node.ExpressionId, self.layouts)),
        .expression_base = @intCast(self.builder.nodes.expressions.tags.items.len),
        .declaration_base = @intCast(self.builder.nodes.declaration_rows.tags.items.len),
        .prefix_count = @intCast(prefix.items.len),
    };

    const output = emitter.executeIn(scratch.allocator(), &input) catch |err| switch (err) {
        error.OutOfMemory, error.IntegerOverflow => return error.OutOfMemory,
        else => unreachable,
    };

    if (!output.valid) return error.OutOfMemory;

    const rows = @import("../node/import_rows.zig");

    rows.appendBorrowed(self.allocator, &self.builder.nodes.expressions, output.expressions) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        error.InvalidAst => unreachable,
    };

    rows.appendBorrowed(self.allocator, &self.builder.nodes.declaration_rows, output.declarations) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        error.InvalidAst => unreachable,
    };

    const selected = try self.builder.nodes.declarations(self.allocator, prefix.items);

    rows.appendBorrowed(self.allocator, &self.builder.nodes.declaration_rows, output.roots) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        error.InvalidAst => unreachable,
    };

    return .{ .start = selected.start, .len = @intCast(prefix.items.len + output.roots.tags.len) };
}
