const std = @import("std");

/// Single entry manifest for public generation and build module wiring.
/// `name` selects the public module and its compatibility import.
pub const Entry = struct {
    path: []const u8,
    name: []const u8,
    owner: enum { frontend, compiler, rx, lint, genz } = .frontend,
    import_name: ?[]const u8 = null,
    pub fn importName(comptime self: Entry) []const u8 {
        return self.import_name orelse "generated_" ++ self.name;
    }
    pub fn jsonStringify(self: Entry, writer: anytype) !void {
        try writer.write(.{ .path = self.path, .name = self.name });
    }
};

pub const Set = enum { main, checks, constant_seed };
const constant_fold = Entry{ .path = "zx/analysis/constants/evaluate.rx", .name = "constant_fold" };

/// Entries linked into zxc.
pub const main = [_]Entry{
    .{ .path = "lint/layout/attribute_required.rx", .name = "attribute_required", .owner = .lint },
    .{ .path = "zx/frontend/resources/scan.rx", .name = "resource_scan" },
    .{ .path = "lint/layout/layout.rx", .name = "layout_rule", .owner = .lint },
    .{ .path = "zx/modules/external/load.rx", .name = "external" },
    .{ .path = "zx/frontend/parser/program.rx", .name = "program", .import_name = "generated_parser" },
    .{ .path = "zx/frontend/parser/expression_text.rx", .name = "expression" },
    .{ .path = "rx/syntax/parse.rx", .name = "xml" },
    .{ .path = "rx/path_segments/normalize.rx", .name = "paths", .owner = .rx },
    .{ .path = "rx/dependency_graph/validate.rx", .name = "graph", .owner = .rx },
    .{ .path = "rx/schema/attribute/classify.rx", .name = "attribute_role", .owner = .rx },
    .{ .path = "rx/schema/content/validate.rx", .name = "attribute_content", .owner = .rx },
    .{ .path = "rx/schema/call/validate.rx", .name = "call_rule", .owner = .rx },
    .{ .path = "rx/path_kind/validate.rx", .name = "path_kind", .owner = .rx },
    .{ .path = "rx/schema/file/classify.rx", .name = "file_kind", .owner = .rx },
    .{ .path = "zx/modules/specifier/classify.rx", .name = "specifier" },
    .{ .path = "zx/modules/path/load.rx", .name = "module_path" },
    .{ .path = "zx/modules/binding/bind.rx", .name = "project_binding" },
    .{ .path = "zx/modules/binding/public_names.rx", .name = "public_names" },
    .{ .path = "zx/analysis/integer/decode.rx", .name = "integer" },
    constant_fold,
    .{ .path = "zx/analysis/constants/validate.rx", .name = "constant_values" },
    .{ .path = "zx/analysis/constants/bindings.rx", .name = "constant_bindings" },
    .{ .path = "zx/analysis/semantic/origins.rx", .name = "origin_validation" },
    .{ .path = "zx/analysis/semantic/produce.rx", .name = "origin_production" },
    .{ .path = "zx/analysis/semantic/preflight.rx", .name = "merge_preflight" },
    .{ .path = "zx/analysis/semantic/merge.rx", .name = "type_merge" },
    .{ .path = "zx/analysis/semantic/validate_types.rx", .name = "type_validation" },
    .{ .path = "zx/analysis/semantic/resolve.rx", .name = "type_resolution" },
    .{ .path = "zx/analysis/semantic/construct_type.rx", .name = "type_construction" },
    .{ .path = "zx/analysis/semantic/query_types.rx", .name = "type_query" },
    .{ .path = "zx/ownership/check.rx", .name = "ownership" },
    .{ .path = "zx/ir/canonical/task_call_check.rx", .name = "ir_task_call" },
    .{ .path = "zx/ir/canonical/program_pure_check.rx", .name = "ir_program_pure" },
    .{ .path = "zx/ir/canonical/refinement_assume.rx", .name = "refinement_assume" },
    .{ .path = "zx/ir/canonical/refinement_bind.rx", .name = "refinement_bind" },
    .{ .path = "zx/ir/canonical/refinement_type_of.rx", .name = "refinement_type" },
    .{ .path = "zx/ir/canonical/refinement/facts/contains_value.rx", .name = "refinement_contains" },
    .{ .path = "zx/ir/canonical/refinement/facts/add_value.rx", .name = "refinement_add_value" },
    .{ .path = "zx/ir/canonical/native_modules_check.rx", .name = "native_modules" },
    .{ .path = "zx/modules/native/load.rx", .name = "native_interface" },
    .{ .path = "zx/modules/artifact/roots.rx", .name = "artifact_roots" },
    .{ .path = "zx/modules/artifact/planning/materialize.rx", .name = "artifact_prepare" },
    .{ .path = "zx/modules/artifact/remapping/columns.rx", .name = "artifact_remap" },
    .{ .path = "zx/ir/canonical/refinement/facts/mark.rx", .name = "refinement_mark" },
    .{ .path = "zx/ir/canonical/refinement/facts/restore.rx", .name = "refinement_restore" },
    .{ .path = "zx/ir/canonical/refinement/facts/add.rx", .name = "refinement_add" },
    .{ .path = "zx/analysis/analyzer/analyze.rx", .name = "analyzer" },
    .{ .path = "zx/modules/source_signature/analyze.rx", .name = "source_signature" },
    .{ .path = "zx/analysis/expression_program/compile.rx", .name = "expression_analysis" },
    .{ .path = "zx/ir/canonical/validation/validate.rx", .name = "ir_validation" },
    .{ .path = "zx/modules/compiled/execute.rx", .name = "compiled_library" },
    .{ .path = "zx/modules/compiled/validation/publication.zx", .name = "compiled_header" },
    .{ .path = "zx/modules/semantic_cache/restoring/native/restore.rx", .name = "native_restore" },
    .{ .path = "verification/query/build.rx", .name = "verification_query", .owner = .compiler },
    .{ .path = "lint/naming/check.rx", .name = "naming", .owner = .lint },
    .{ .path = "lint/length/check.rx", .name = "length", .owner = .lint },
    .{ .path = "lint/indentation/line/line.rx", .name = "indentation_line", .owner = .lint },
    .{ .path = "lint/spacing/boundary/boundary.rx", .name = "spacing_boundary", .owner = .lint },
    .{ .path = "lint/rx/bounds/resolve.rx", .name = "rx_bounds", .owner = .lint },
    .{ .path = "lint/imports/order/compare.rx", .name = "import_order", .owner = .lint },
    .{ .path = "lint/configuration/yaml/gap/resolve.rx", .name = "yaml_gap", .owner = .lint },
    .{ .path = "genz/printer/render.rx", .name = "printer", .owner = .genz },
    .{ .path = "genz/analysis/facts/analyze.rx", .name = "function_facts", .owner = .genz },
    .{ .path = "genz/analysis/uniqueness/slots/build.rx", .name = "uniqueness_slots", .owner = .genz },
    .{ .path = "genz/analysis/uniqueness/layers/plan.rx", .name = "uniqueness_layers", .owner = .genz },
    .{ .path = "genz/analysis/shape/plan.rx", .name = "shape_plan", .owner = .genz },
    .{ .path = "genz/analysis/inline/prepare.rx", .name = "inline_prepare", .owner = .genz },
    .{ .path = "genz/analysis/iteration/analyze.rx", .name = "iteration_layout", .owner = .genz },
    .{ .path = "genz/analysis/types/layout/query.zx", .name = "layout_query", .owner = .genz },
    .{ .path = "genz/analysis/entry/analyze.rx", .name = "entry_flags", .owner = .genz },
    .{ .path = "genz/analysis/names/analyze.rx", .name = "stable_names", .owner = .genz },
    .{ .path = "genz/analysis/native_namespaces/plan.rx", .name = "native_namespaces", .owner = .genz },
    .{ .path = "genz/analysis/native_namespaces/emit/build.rx", .name = "native_declarations", .owner = .genz },
    .{ .path = "genz/analysis/simd/analyze.rx", .name = "simd_plan", .owner = .genz },
    .{ .path = "genz/analysis/simd/emit/build.rx", .name = "simd_emit", .owner = .genz },
    .{ .path = "genz/analysis/references/discover.rx", .name = "reference_graph", .owner = .genz },
    .{ .path = "genz/analysis/references/imports.rx", .name = "reference_imports", .owner = .genz },
    .{ .path = "genz/analysis/iteration/fields/plan.rx", .name = "loop_fields", .owner = .genz },
};

/// Individual checkers that zxc reaches through the unified IR validation instead; only test builds import them.
pub const checks = [_]Entry{
    .{ .path = "zx/analysis/semantic/lookup.rx", .name = "type_lookup" },
    .{ .path = "zx/analysis/semantic/nominal.rx", .name = "nominal_lookup" },
    .{ .path = "zx/ir/canonical/body_check.rx", .name = "ir_body" },
    .{ .path = "zx/ir/canonical/stores_check.rx", .name = "ir_stores" },
    .{ .path = "zx/ir/canonical/store_call_check.rx", .name = "ir_store_call" },
    .{ .path = "zx/ir/canonical/tasks_check.rx", .name = "ir_tasks" },
    .{ .path = "zx/ir/canonical/functions_check.rx", .name = "ir_functions" },
    .{ .path = "zx/ir/canonical/expressions_check.rx", .name = "ir_expressions" },
    .{ .path = "zx/ir/canonical/contracts_check.rx", .name = "ir_contracts" },
    .{ .path = "zx/ir/canonical/contract_tables_check.rx", .name = "ir_contract_tables" },
    .{ .path = "zx/ir/canonical/scopes_check.rx", .name = "ir_scopes" },
    .{ .path = "zx/ir/canonical/native_export_check.rx", .name = "native_export" },
    .{ .path = "zx/ir/canonical/native_type_check.rx", .name = "native_type" },
    .{ .path = "zx/modules/native_names.rx", .name = "native_names" },
};

pub fn of(set: Set) []const Entry {
    return switch (set) {
        .main => &main,
        .checks => &checks,
        .constant_seed => &.{constant_fold},
    };
}

pub fn ParserModules() type {
    comptime var names: []const []const u8 = &.{ "type_views", "nominal_data" };

    for (main) |entry| {
        if (entry.owner == .frontend or entry.owner == .compiler or entry.owner == .genz) names = names ++ .{entry.name};
    }

    return @Struct(.auto, null, names, &@splat(*std.Build.Module), &@splat(.{}));
}
