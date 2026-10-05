const std = @import("std");
const compiler = @import("compiler");
const rx = @import("rx");
const analysis = @import("rx_analysis");
const frontend = @import("frontend");
pub const Case = struct { value: []const u8, expected: bool, helper: bool = false, service: bool = false, forge_summary: bool = false };
const types = "export type State = { count: u64, rows: u64[][], labels: string[] }\n\nexport type Input = State\n\n";
const direct = "<Module><Store from='state' as='jobs'/><Call fn='write' in={store.jobs.snapshot} setter={[store.jobs.snapshot]}/></Module>";
const outer = "<Module><Call service='leaf' in={0}/></Module>";
const store = "<Store name='proof' version={1}><Object name='snapshot'><Field name='count' type='u64' value={3}/><Field name='rows' type='u64[][]' value={[[1,2]]}/><Field name='labels' type='string[]' value={[\"seed\"]}/></Object></Store>";

pub fn run(case: Case) !void {
    try allocated(std.testing.allocator, case);
}

pub fn allocated(allocator: std.mem.Allocator, case: Case) !void {
    const writer = try std.fmt.allocPrint(allocator, "{s}{s}export type Output = void\n\nexport default function (in: Input, {{ store }}): Output {{\n  store.jobs.snapshot = {s}\n\n  return\n}}\n", .{ if (case.helper) "import make from \"./make.zx\"\n\n" else "", types, if (case.helper) "make(in)" else case.value });

    defer allocator.free(writer);

    const helper = try std.fmt.allocPrint(allocator, "{s}export type Output = State\n\nexport default function (in: Input): Output {{\n  return {s}\n}}\n", .{ types, case.value });

    defer allocator.free(helper);

    var main = try rx.parseXml(allocator, if (case.service) outer else direct);

    defer main.deinit();

    var leaf = try rx.parseXml(allocator, direct);

    defer leaf.deinit();

    var stored = try rx.parseXml(allocator, store);

    defer stored.deinit();

    try std.testing.expect(main.value == .node and leaf.value == .node and stored.value == .node);

    const modules = [_]rx.ModuleSource{ .{ .path = "main.rx", .node = main.value.node }, .{ .path = "leaf.rx", .node = leaf.value.node } };
    const sources = [_]compiler.project.Source{ .{ .path = "write.zx", .source = writer }, .{ .path = "make.zx", .source = helper } };

    var result = try analysis.project.infer(allocator, .{
        .entry = "main.rx",
        .modules = modules[0..if (case.service) @as(usize, 2) else 1],
        .stores = &.{.{ .path = "state.store.rx", .node = stored.value.node }},
        .sources = sources[0..if (case.helper) @as(usize, 2) else 1],
    });

    defer result.deinit();

    if (result.value == .diagnostic) {
        const issue = result.value.diagnostic;

        std.debug.print("{s}:{s}: {s}\n", .{ issue.path, issue.code, issue.message });

        return error.UnexpectedDiagnostic;
    }

    const contract = result.value.contract;

    try std.testing.expect(try compiler.validateIr(allocator, contract.program) == null);
    try std.testing.expectEqual(case.expected, try frontend.storesOwnValues(allocator, contract.program));

    var analyzed = compiler.AnalysisResult{ .arena = std.heap.ArenaAllocator.init(allocator), .value = .{ .ir = contract.program }, .nominal_types = contract.nominal_types };

    defer analyzed.deinit();

    try std.testing.expectEqual(@as(usize, 1), contract.program.stores.len);
    try std.testing.expectEqual(@as(usize, 1), contract.store_definitions.len);
    try std.testing.expectEqual(@as(usize, 1), contract.store_definitions[0].objects.len);

    var library = try compiler.library.link(allocator, &.{.{
        .name = "run",
        .analysis = &analyzed,
        .initializers = &.{.{
            .identity = contract.program.stores[0].path,
            .schema_version = contract.store_definitions[0].version,
            .program = contract.store_definitions[0].objects[0].initial,
        }},
    }});

    defer library.deinit();

    const bytes = try compiler.library.codec.encode(allocator, &library);

    defer allocator.free(bytes);

    var decoded = try compiler.library.codec.decode(allocator, bytes);

    defer decoded.deinit();

    try std.testing.expectEqual(@as(usize, 1), decoded.store_initializers.len);

    const module = try decoded.module(0);

    try std.testing.expect(try compiler.validateIr(allocator, module) == null);
    try std.testing.expectEqual(case.expected, try frontend.storesOwnValues(allocator, module));
    if (case.forge_summary) try @import("forgery.zig").check(allocator, &library, bytes);
}
