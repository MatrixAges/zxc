const std = @import("std");
const zx = @import("zx");
const node = @import("../node.zig");
const view = @import("../node/view.zig");
const Builder = @import("../builder.zig");
const Options = @import("entry.zig").Options;

pub fn lower(builder: Builder, declarations: *std.ArrayList(node.Declaration), options: Options) std.mem.Allocator.Error!void {
    if (comptime !@import("genz_options").generated_analysis) return @import("prelude_seed.zig").lower(builder, declarations, options);

    const entry = @import("generated_gateway_prelude");
    const Input = @typeInfo(@TypeOf(entry.executeValue)).@"fn".param_types[1].?;
    const Bases = std.meta.Child(@FieldType(Input, "bases"));

    const bases: Bases = .{
        .capture = null,
        .expression_base = @intCast(builder.nodes.expressions.tags.items.len),
        .statement_base = @intCast(builder.nodes.statements.tags.items.len),
        .field_base = @intCast(builder.nodes.field_columns.count()),
        .serial = 0,
    };

    const input: Input = .{
        .bases = &bases,
        .declaration_base = @intCast(declarations.items.len),
        .service_modules = options.service_modules,
        .listen = options.listen,
        .max_header_bytes = options.max_header_bytes,
        .max_body_bytes = options.max_body_bytes,
    };

    const output = entry.executeValue(builder.allocator, input) catch |err| return failure(err);

    if (!output.valid) return error.OutOfMemory;

    const Output = std.meta.Child(entry.Output);
    const values = zx.columns.view(std.meta.Child(@FieldType(Output, "expressions")), output.expressions);
    const forms = zx.columns.view(std.meta.Child(@FieldType(Output, "forms")), output.forms);
    const expressions = view.join(values, forms);
    const Constants = @TypeOf(output.declarations);
    const constants = if (@typeInfo(Constants) == .@"struct") output.declarations.items else output.declarations;
    @import("../node/import_rows.zig").appendBorrowed(builder.allocator, &builder.nodes.expressions, &expressions) catch |err| return failure(err);
    @import("../node/import_constants.zig").appendValuesBorrowingText(builder.allocator, declarations, constants) catch |err| return failure(err);
}

fn failure(err: anyerror) std.mem.Allocator.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => @panic("invalid Gateway prelude AST"),
    };
}
