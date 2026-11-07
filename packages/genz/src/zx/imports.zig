const std = @import("std");
const node = @import("../node.zig");
const view = @import("../node/view.zig");
const Lower = @import("lower.zig");

pub fn lower(self: *Lower, declarations: *std.ArrayList(node.Declaration)) Lower.Error![]const []const u8 {
    if (!@import("genz_options").generated_analysis) return @import("imports/seed.zig").lower(self, declarations);

    const generated = @import("generated_native_imports");
    const Input = std.meta.Child(generated.Input);
    var scratch = std.heap.ArenaAllocator.init(self.workspace);

    defer scratch.deinit();

    const prelude = try self.builder.nodes.declarations(self.allocator, declarations.items);
    const expressions = view.rows(std.meta.Child(@FieldType(Input, "expressions")), self.builder.nodes.expressions);
    const previous = view.rows(std.meta.Child(@FieldType(Input, "declarations")), self.builder.nodes.declaration_rows);

    const input = Input{
        .expressions = &expressions,
        .declarations = &previous,
        .first = prelude.start,
        .count = prelude.len,
        .modules = self.program.native_modules.import_names,
        .expression_base = @intCast(self.builder.nodes.expressions.tags.items.len),
    };

    const output = generated.executeIn(scratch.allocator(), &input) catch |err| switch (err) {
        error.OutOfMemory, error.IntegerOverflow => return error.OutOfMemory,
        else => unreachable,
    };

    if (!output.valid) return error.OutOfMemory;

    const imported = view.join(output.expressions.*, output.forms.*);

    @import("../node/import_rows.zig").append(self.allocator, &self.builder.nodes.expressions, &imported) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        error.InvalidAst => unreachable,
    };

    @import("../node/import_constants.zig").append(self.allocator, declarations, output.declarations) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        error.InvalidAst => unreachable,
    };

    const names = try self.allocator.alloc([]const u8, output.aliases.len);

    for (names, output.aliases) |*name, alias| name.* = declarations.items[alias].constant.name;

    return names;
}
