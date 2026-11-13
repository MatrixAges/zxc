const std = @import("std");
const ir = @import("zx").ir;
const Analysis = @import("../../../analysis/analyze.zig");
const Record = @import("../../module_record.zig");
const Origins = @import("../../nominal_origins.zig");
const Error = @import("../model.zig").Error;
const borrow = @import("../../../ir/canonical/borrow.zig");
const generated = @import("generated_artifact_prepare");
const projection = @import("../roots/record.zig");

const Prepared = struct {
    output: generated.Output,
    references: projection.References,
};

pub fn execute(arena: *std.heap.ArenaAllocator, temporary: *std.heap.ArenaAllocator, analysis: *const Analysis.Result, record: Record) Error!Prepared {
    const program = analysis.value.ir;

    if (!analysis.nominal_types.hasValidShape()) return error.InvalidModule;

    const RootInput = std.meta.Child(@import("generated_artifact_roots").Input);
    const Projected = std.meta.Child(@FieldType(RootInput, "record"));
    const view = try projection.project(Projected, temporary.allocator(), record);
    const projected = view.record;
    const roots = try @import("../roots/run.zig").executeProjected(temporary, program, projected);
    const Input = std.meta.Child(generated.Input);
    const Request = std.meta.Child(@FieldType(Input, "request"));
    const Table = std.meta.Child(@FieldType(Request, "table"));
    const Bindings = std.meta.Child(@FieldType(Request, "origins"));
    const Signatures = std.meta.Child(@FieldType(Input, "signatures"));
    const Imports = std.meta.Child(@FieldType(Input, "function_imports"));
    const Dependencies = std.meta.Child(@FieldType(Input, "dependencies"));
    const table = ir.TypeTable.borrow(Table, program.types);
    const origins = Origins.Table.borrow(Bindings, analysis.nominal_types);
    const keys = try temporary.allocator().alloc([]const u8, record.imports.len);

    for (record.imports, keys) |dependency, *key| key.* = dependency.identity orelse dependency.specifier;

    const Declarations = std.meta.Child(@FieldType(Input, "declarations"));
    const declarations = borrow.columns(Declarations, ir.SignatureTable.fromFunctions(program.functions));
    const signatures: Signatures = .{ .inputs = program.functions.input_types, .outputs = program.functions.output_types, .native_modules = program.functions.native_modules };
    const imports: Imports = .{ .ids = projected.function_ids, .inputs = projected.function_inputs, .outputs = projected.function_outputs };
    const dependencies: Dependencies = .{ .kinds = borrow.slice(@FieldType(Dependencies, "kinds"), projected.import_kinds), .keys = keys };
    const request: Request = .{ .table = &table, .origins = &origins, .names = analysis.nominal_types.names, .roots = roots, .scalar_count = std.enums.values(ir.Scalar).len, .maximum_count = std.math.maxInt(u32) };
    const own_function = if (record.own_function) |id| @as(?u32, @backingInt(id)) else null;
    const Body = std.meta.Child(@FieldType(Input, "body"));

    const body: Body = .{
        .kind = switch (record.body) {
            .types => .Types,
            .entry => .Entry,
            .function => .Function,
        },
        .function_id = if (record.body == .function) @backingInt(record.body.function) else null,
        .own_function = own_function,
    };

    const fields = .{ .body = &body, .own_function = own_function, .declarations = &declarations, .request = &request, .modules = borrow.pointer(@FieldType(Input, "modules"), &program.native_modules), .type_imports = projected.type_imports, .dependencies = &dependencies, .signatures = &signatures, .function_imports = &imports };

    var input: Input = undefined;

    inline for (@typeInfo(Input).@"struct".field_names) |name| @field(input, name) = @field(fields, name);

    const result = generated.execute(arena, &input) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => return error.InvalidModule,
    };

    return switch (result.plan.state.status) {
        .Ready => .{ .output = result, .references = view.references },
        .MissingOrigin => error.MissingNominalOrigin,
        .Invalid => error.InvalidModule,
    };
}
