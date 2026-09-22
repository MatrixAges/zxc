const dsl = @import("dsl");
const checks = @import("../checks.zig");
const paths = @import("../paths.zig");
const ImportBase = dsl.element("Import", struct { from: []const u8 }, dsl.empty);
pub const Import = dsl.refine(ImportBase, checkImport);

fn checkImport(data: ImportBase.Data, node: dsl.ast.Node, _: anytype, reporter: *dsl.Reporter) dsl.Error!void {
    if (!paths.isModuleReference(data.attributes.from)) return checks.fail(node, "from", "Import must reference a relative module file path", reporter);
}
