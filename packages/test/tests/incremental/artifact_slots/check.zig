const std = @import("std");
const compiler = @import("compiler");

const main = "import helper from \"./helper.zx\"\n export type State = { count: u64 }\n export type Input = u64\n export type Output = u64\n export default function (in: Input): Output { $store_a.value = { count: $store_a.value.count + in }\n return helper($store_a.value.count + $store_b.value.count) }";
const helper = "export enum Noise { Tag } export type Input = u64\n export type Output = u64\n export default function (in: Input): Output { return in }";

pub fn analyze(allocator: std.mem.Allocator) !compiler.AnalysisResult {
    return compiler.project.analyze(allocator, &.{
        .{ .path = "main.zx", .source = main },
        .{ .path = "helper.zx", .source = helper },
    }, .{
        .entry = "main.zx",
        .root_dir = "/project",
        .context = .{
            .stores = &.{
                .{ .handle = "$store_a", .path = "store.primary.state", .type_name = "State" },
                .{ .handle = "$store_b", .path = "store.secondary.state", .type_name = "State", .writable = false },
            },
        },
    });
}

pub fn check(module: compiler.project.artifact.Module) !void {
    try std.testing.expectEqual(@as(usize, 2), module.stores.len);
    try std.testing.expectEqualStrings("store.primary.state", module.stores[0].path);
    try std.testing.expectEqualStrings("store.secondary.state", module.stores[1].path);
    try std.testing.expectEqualStrings("$store_a", module.stores[0].handle);
    try std.testing.expectEqualStrings("$store_b", module.stores[1].handle);
    try std.testing.expect(module.stores[0].readable and module.stores[0].writable);
    try std.testing.expect(module.stores[1].readable and !module.stores[1].writable);
    try std.testing.expectEqual(module.stores[0].type_id, module.stores[1].type_id);
    try std.testing.expectEqualStrings("count", module.types[@intFromEnum(module.stores[0].type_id)].object[0].name);
}
