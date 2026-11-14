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
const Constants = std.meta.Child(@typeInfo(@FieldType(Input, "constants")).optional.child);
const Output = std.meta.Child(generated.Output);
const Plan = @typeInfo(@FieldType(Output, "plan")).optional.child;
const Body = @typeInfo(@FieldType(Output, "body")).optional.child;

pub const Prepared = struct {
    plan: Plan,
    body: Body,
};

pub fn execute(temporary: std.mem.Allocator, analysis: *const Analysis.Result, record: Record) Error!Prepared {
    const program = &analysis.value.ir;
    const Projected = std.meta.Child(@FieldType(Source, "record"));
    const view = try projection.project(Projected, temporary, record);
    const table = ir.TypeTable.borrow(std.meta.Child(@FieldType(Source, "table")), program.types);
    const origins = Origins.Table.borrow(std.meta.Child(@FieldType(Input, "origins")), analysis.nominal_types);
    const functions = source_view.functions(std.meta.Child(@FieldType(Source, "functions")), program);
    const entry = source_view.body(std.meta.Child(@FieldType(Source, "entry")), program);
    const roots = try temporary.alloc(bool, program.types.count());

    @memset(roots, false);

    const root_bytes = std.mem.sliceAsBytes(roots);

    const source: Source = .{
        .roots = roots,
        .buffer = @ptrCast(&root_bytes),
        .file_name = program.file_name,
        .type_only = program.type_only,
        .table = &table,
        .functions = &functions,
        .modules = borrow.pointer(@FieldType(Source, "modules"), &program.native_modules),
        .entry = &entry,
        .record = &view,
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

    const Tables = std.meta.Child(@FieldType(Constants, "types"));
    const Values = std.meta.Child(@typeInfo(@FieldType(Constants, "imports")).optional.child);
    const marshal = @import("../../../analysis/constants/input.zig").marshal;
    const base = ir.TypeTable.borrow(std.meta.Child(@FieldType(Tables, "base")), program.types);
    const delta = ir.TypeTable.borrow(std.meta.Child(@FieldType(Tables, "delta")), .{});
    const tables: Tables = .{ .base = &base, .delta = &delta };
    const exports = try marshal(Values, temporary, record.constant_exports);
    const imports = try marshal(Values, temporary, record.constant_imports);
    const constants: Constants = .{ .types = &tables, .exports = exports, .imports = imports };

    const input: Input = .{
        .source = &source,
        .body = &body,
        .origins = &origins,
        .origin_names = analysis.nominal_types.names,
        .constants = if (exports != null or imports != null) &constants else null,
        .scalar_count = std.enums.values(ir.Scalar).len,
        .maximum_count = std.math.maxInt(u32),
    };

    const result = generated.executeIn(temporary, &input) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => return error.InvalidModule,
    };

    return switch (result.status) {
        .Ready => .{ .plan = result.plan.?, .body = result.body.? },
        .MissingOrigin => error.MissingNominalOrigin,
        .Invalid => error.InvalidModule,
    };
}
