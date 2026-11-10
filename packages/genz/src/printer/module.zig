const std = @import("std");
const zx = @import("zx");
const generated = @import("generated_printer");
const Input = std.meta.Child(generated.Input);
const Source = std.meta.Child(@FieldType(Input, "source"));

/// Source AST payloads stay borrowed until the unified printer has finished.
pub fn render(allocator: std.mem.Allocator, workspace: std.mem.Allocator, comptime Module: type, module: anytype) std.mem.Allocator.Error![]u8 {
    const expression_views = if (@hasField(Module, "context")) legacy: {
        const Context = std.meta.Child(@FieldType(Module, "context"));
        const expressions = zx.columns.view(std.meta.Child(@FieldType(Context, "expressions")), module.context.expressions);
        const forms = zx.columns.view(std.meta.Child(@FieldType(Context, "forms")), module.context.forms);

        break :legacy if (@hasField(Module, "extra"))
            .{ expressions, forms, zx.columns.view(std.meta.Child(@FieldType(Module, "extra")), module.extra) }
        else
            .{ expressions, forms };
    } else .{zx.columns.view(std.meta.Child(@FieldType(Module, "expressions")), module.expressions)};

    const statements = zx.columns.view(std.meta.Child(@FieldType(Module, "statements")), module.statements);
    const declarations = zx.columns.view(std.meta.Child(@FieldType(Module, "declarations")), module.declarations);
    const fields = zx.columns.view(std.meta.Child(@FieldType(Module, "fields")), module.fields);
    const expression_columns = project(std.meta.Child(@FieldType(Source, "expressions")), expression_views);
    const statement_columns = project(std.meta.Child(@FieldType(Source, "statements")), .{statements});
    const declaration_columns = project(std.meta.Child(@FieldType(Source, "declarations")), .{declarations});
    const field_columns = project(std.meta.Child(@FieldType(Source, "fields")), .{fields});
    const arm_columns = project(std.meta.Child(@FieldType(Source, "arms")), .{});

    const source: Source = .{
        .expressions = &expression_columns,
        .statements = &statement_columns,
        .declarations = &declaration_columns,
        .fields = &field_columns,
        .arms = &arm_columns,
        .first = 0,
        .count = std.math.cast(u32, declarations.tags.len) orelse return error.OutOfMemory,
    };

    const input: Input = .{ .source = &source, .output = &.{} };

    const output = zx.columns.invoke(generated.executeValue, workspace, &input) catch |err| switch (err) {
        error.OutOfMemory, error.Overflow => return error.OutOfMemory,
        else => unreachable,
    };

    return allocator.dupe(u8, output);
}

fn project(comptime Target: type, sources: anytype) Target {
    @setEvalBranchQuota(100_000);

    var result: Target = undefined;

    inline for (@typeInfo(Target).@"struct".field_names) |name| {
        const Field = @FieldType(Target, name);

        @field(result, name) = found: {
            inline for (sources) |source| {
                if (@hasField(@TypeOf(source), name)) break :found zx.columns.slice(Field, @field(source, name));
            }

            break :found &.{};
        };
    }

    return result;
}
