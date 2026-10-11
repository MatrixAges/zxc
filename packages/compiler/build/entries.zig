/// Bootstrap generation manifest shared by the build script and the generator, so output arguments follow one order.
/// `name` is the Sources field and output file; `abi` adds the shared type file of a typed entry.
pub const Entry = struct { path: []const u8, name: []const u8, abi: ?[]const u8 = null };
pub const Set = enum { main, checks };

/// Entries linked into zxc. The generator starts from the end, so the largest closures stay last.
pub const main = [_]Entry{
    .{ .path = "zx/frontend/parser/program.rx", .name = "program" },
    .{ .path = "zx/frontend/parser/expression_text.rx", .name = "expression" },
    .{ .path = "rx/syntax/parse.rx", .name = "xml" },
    .{ .path = "rx/path_segments/normalize.rx", .name = "paths" },
    .{ .path = "rx/dependency_graph/validate.rx", .name = "graph" },
    .{ .path = "rx/schema/attribute/classify.rx", .name = "attribute_role" },
    .{ .path = "rx/schema/content/validate.rx", .name = "attribute_content" },
    .{ .path = "rx/schema/call/validate.rx", .name = "call_rule" },
    .{ .path = "rx/path_kind/validate.rx", .name = "path_kind" },
    .{ .path = "rx/schema/file/classify.rx", .name = "file_kind" },
    .{ .path = "zx/modules/specifier/classify.rx", .name = "specifier" },
    .{ .path = "zx/modules/binding/bind.rx", .name = "project_binding", .abi = "project_binding_abi" },
    .{ .path = "zx/analysis/integer/decode.rx", .name = "integer" },
    .{ .path = "zx/analysis/semantic/origins.rx", .name = "origin_validation", .abi = "origins_abi" },
    .{ .path = "zx/analysis/semantic/produce.rx", .name = "origin_production", .abi = "production_abi" },
    .{ .path = "zx/analysis/semantic/preflight.rx", .name = "merge_preflight", .abi = "preflight_abi" },
    .{ .path = "zx/analysis/semantic/merge.rx", .name = "type_merge", .abi = "merge_abi" },
    .{ .path = "zx/analysis/semantic/validate_types.rx", .name = "type_validation", .abi = "validation_abi" },
    .{ .path = "zx/analysis/semantic/resolve.rx", .name = "type_resolution", .abi = "resolution_abi" },
    .{ .path = "zx/analysis/semantic/construct_type.rx", .name = "type_construction", .abi = "construction_abi" },
    .{ .path = "zx/analysis/semantic/query_types.rx", .name = "type_query", .abi = "query_abi" },
    .{ .path = "zx/ownership/check.rx", .name = "ownership", .abi = "ownership_abi" },
    .{ .path = "zx/ir/canonical/task_call_check.rx", .name = "ir_task_call", .abi = "ir_task_call_abi" },
    .{ .path = "zx/ir/canonical/program_pure_check.rx", .name = "ir_program_pure", .abi = "ir_program_pure_abi" },
    .{ .path = "zx/ir/canonical/refinement_assume.rx", .name = "refinement_assume", .abi = "refinement_assume_abi" },
    .{ .path = "zx/ir/canonical/refinement_bind.rx", .name = "refinement_bind", .abi = "refinement_bind_abi" },
    .{ .path = "zx/ir/canonical/refinement_type_of.rx", .name = "refinement_type", .abi = "refinement_type_abi" },
    .{ .path = "zx/ir/canonical/refinement/facts/contains_value.rx", .name = "refinement_contains", .abi = "refinement_contains_abi" },
    .{ .path = "zx/ir/canonical/refinement/facts/add_value.rx", .name = "refinement_add_value", .abi = "refinement_add_value_abi" },
    .{ .path = "zx/ir/canonical/native_modules_check.rx", .name = "native_modules", .abi = "native_modules_abi" },
    .{ .path = "zx/modules/native/load.rx", .name = "native_interface", .abi = "native_interface_abi" },
    .{ .path = "zx/modules/artifact/roots.rx", .name = "artifact_roots", .abi = "artifact_roots_abi" },
    .{ .path = "zx/modules/artifact/planning/materialize.rx", .name = "artifact_prepare", .abi = "artifact_prepare_abi" },
    .{ .path = "zx/modules/artifact/remapping/columns.rx", .name = "artifact_remap", .abi = "artifact_remap_abi" },
    .{ .path = "zx/ir/canonical/refinement/facts/mark.rx", .name = "refinement_mark" },
    .{ .path = "zx/ir/canonical/refinement/facts/restore.rx", .name = "refinement_restore" },
    .{ .path = "zx/ir/canonical/refinement/facts/add.rx", .name = "refinement_add" },
    .{ .path = "zx/analysis/analyzer/analyze.rx", .name = "analyzer", .abi = "analyzer_abi" },
    .{ .path = "zx/modules/source_signature/analyze.rx", .name = "source_signature", .abi = "source_signature_abi" },
    .{ .path = "zx/analysis/expression_program/compile.rx", .name = "expression_analysis", .abi = "expression_analysis_abi" },
    .{ .path = "zx/ir/canonical/validation/validate.rx", .name = "ir_validation", .abi = "ir_validation_abi" },
    .{ .path = "zx/modules/compiled/execute.rx", .name = "compiled_library", .abi = "compiled_library_abi" },
    .{ .path = "zx/modules/semantic_cache/restoring/native/restore.rx", .name = "native_restore", .abi = "native_restore_abi" },
    .{ .path = "lint/naming/check.rx", .name = "naming" },
};

/// Individual checkers that zxc reaches through the unified IR validation instead; only test builds import them.
pub const checks = [_]Entry{
    .{ .path = "zx/analysis/semantic/lookup.rx", .name = "type_lookup", .abi = "semantic_abi" },
    .{ .path = "zx/analysis/semantic/nominal.rx", .name = "nominal_lookup", .abi = "nominal_abi" },
    .{ .path = "zx/ir/canonical/body_check.rx", .name = "ir_body", .abi = "ir_body_abi" },
    .{ .path = "zx/ir/canonical/stores_check.rx", .name = "ir_stores", .abi = "ir_stores_abi" },
    .{ .path = "zx/ir/canonical/store_call_check.rx", .name = "ir_store_call", .abi = "ir_store_call_abi" },
    .{ .path = "zx/ir/canonical/tasks_check.rx", .name = "ir_tasks", .abi = "ir_tasks_abi" },
    .{ .path = "zx/ir/canonical/functions_check.rx", .name = "ir_functions", .abi = "ir_functions_abi" },
    .{ .path = "zx/ir/canonical/expressions_check.rx", .name = "ir_expressions", .abi = "ir_expressions_abi" },
    .{ .path = "zx/ir/canonical/contracts_check.rx", .name = "ir_contracts", .abi = "ir_contracts_abi" },
    .{ .path = "zx/ir/canonical/contract_tables_check.rx", .name = "ir_contract_tables", .abi = "ir_contract_tables_abi" },
    .{ .path = "zx/ir/canonical/scopes_check.rx", .name = "ir_scopes", .abi = "ir_scopes_abi" },
    .{ .path = "zx/ir/canonical/native_export_check.rx", .name = "native_export", .abi = "native_export_abi" },
    .{ .path = "zx/ir/canonical/native_type_check.rx", .name = "native_type", .abi = "native_type_abi" },
    .{ .path = "zx/modules/native_names.rx", .name = "native_names", .abi = "native_names_abi" },
};

pub fn of(set: Set) []const Entry {
    return switch (set) {
        .main => &main,
        .checks => &checks,
    };
}
