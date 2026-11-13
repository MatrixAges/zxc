const std = @import("std");
const ir = @import("zx").ir;
const Analysis = @import("../../../analysis/analyze.zig");
const Record = @import("../../module_record.zig");
const Origins = @import("../../nominal_origins.zig");
const Error = @import("../model.zig").Error;
const borrow = @import("../../../ir/canonical/borrow.zig");
const generated = @import("generated_artifact_prepare");
const projection = @import("../roots/record.zig");
const source_view = @import("../roots/run.zig");
const Input = std.meta.Child(generated.Input);
const Source = std.meta.Child(@FieldType(Input, "source"));
const Output = std.meta.Child(generated.Output);
const Plan = @typeInfo(@FieldType(Output, "plan")).optional.child;
const Body = @typeInfo(@FieldType(Output, "body")).optional.child;

const Prepared = struct {
    plan: Plan,
    body: Body,
    references: projection.References,
};

pub fn execute(temporary: std.mem.Allocator, analysis: *const Analysis.Result, record: Record) Error!Prepared {
    const program = &analysis.value.ir;

    if (!analysis.nominal_types.hasValidShape()) return error.InvalidModule;

    const Projected = std.meta.Child(@FieldType(Source, "record"));
    const view = try projection.project(Projected, temporary, record);
    const keys = try temporary.alloc([]const u8, record.imports.len);

    for (record.imports, keys) |dependency, *key| key.* = dependency.identity orelse dependency.specifier;

    const table = ir.TypeTable.borrow(std.meta.Child(@FieldType(Source, "table")), program.types);
    const origins = Origins.Table.borrow(std.meta.Child(@FieldType(Input, "origins")), analysis.nominal_types);
    const functions = source_view.functions(std.meta.Child(@FieldType(Source, "functions")), program);
    const entry = source_view.body(std.meta.Child(@FieldType(Source, "entry")), program);

    const source: Source = .{
        .file_name = program.file_name,
        .type_only = program.type_only,
        .table = &table,
        .functions = &functions,
        .modules = borrow.pointer(@FieldType(Source, "modules"), &program.native_modules),
        .entry = &entry,
        .record = &view.record,
    };

    const body: std.meta.Child(@FieldType(Input, "body")) = .{
        .kind = switch (record.body) {
            .types => .Types,
            .entry => .Entry,
            .function => .Function,
        },
        .function_id = if (record.body == .function) @backingInt(record.body.function) else null,
        .own_function = if (record.own_function) |id| @backingInt(id) else null,
    };

    const input: Input = .{
        .source = &source,
        .body = &body,
        .origins = &origins,
        .origin_names = analysis.nominal_types.names,
        .dependency_keys = keys,
        .scalar_count = std.enums.values(ir.Scalar).len,
        .maximum_count = std.math.maxInt(u32),
    };

    const result = generated.executeIn(temporary, &input) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => return error.InvalidModule,
    };

    return switch (result.status) {
        .Ready => .{ .plan = result.plan.?, .body = result.body.?, .references = view.references },
        .MissingOrigin => error.MissingNominalOrigin,
        .Invalid => error.InvalidModule,
    };
}
