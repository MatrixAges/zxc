const std = @import("std");
pub const compiler = @import("compiler");
pub const artifact = compiler.project.artifact;
pub const main_source = @embedFile("runtime/main.zx");
pub const consume_source = @embedFile("runtime/consume.zx");
pub const borrowed_source = "export type Input = u64[]\nexport type Output = u64[]\nexport default function (in: Input): Output { return in.map(item => item) }\n";

pub fn analyze(allocator: std.mem.Allocator, helper: []const u8) !compiler.AnalysisResult {
    var result = try compiler.project.analyze(allocator, &.{
        .{ .path = "main.zx", .source = main_source },
        .{ .path = "consume.zx", .source = helper },
    }, .{ .entry = "main.zx", .root_dir = "/project" });

    errdefer result.deinit();

    if (result.value != .ir) return error.UnexpectedDiagnostic;

    return result;
}

pub fn library(allocator: std.mem.Allocator) !compiler.library.Result {
    var analysis = try compiler.project.analyze(allocator, &.{.{ .path = "consume.zx", .source = consume_source }}, .{ .entry = "consume.zx", .root_dir = "/library" });

    defer analysis.deinit();

    if (analysis.value != .ir) return error.UnexpectedDiagnostic;

    return compiler.library.link(allocator, &.{.{ .name = "consume", .analysis = &analysis }});
}

pub fn consumer(allocator: std.mem.Allocator, value: *const compiler.library.Result, source: []const u8) !compiler.AnalysisResult {
    return compiler.project.analyze(allocator, &.{.{ .path = "main.zx", .source = source }}, .{
        .entry = "main.zx",
        .root_dir = "/consumer",
        .packages = &.{.{ .specifier = "owned", .compiled = .{ .instance = "owned@1", .artifact = "owned.zxlib", .name = "consume" } }},
        .compiled_libraries = &.{.{ .instance = "owned@1", .artifact = "owned.zxlib", .program = value.program, .exports = value.exports, .nominal_types = value.nominal_types }},
    });
}

pub fn restored(allocator: std.mem.Allocator) !compiler.library.Result {
    var original = try library(allocator);

    defer original.deinit();

    const bytes = try compiler.library.codec.encode(allocator, &original);

    defer allocator.free(bytes);

    return compiler.library.codec.decode(allocator, bytes);
}

pub const Modules = struct {
    results: [2]artifact.Result,
    values: [2]artifact.Module,
    pub fn init(allocator: std.mem.Allocator, helper: []const u8) !Modules {
        var analysis = try analyze(allocator, helper);

        defer analysis.deinit();

        var result: Modules = undefined;
        var count: usize = 0;

        errdefer for (result.results[0..count]) |*item| item.deinit();

        if (analysis.modules.len != 2) return error.UnexpectedModuleCount;

        for (&result.results, &result.values, 0..) |*item, *value, index| {
            item.* = try artifact.extract(allocator, &analysis, index);
            value.* = item.value;
            count += 1;
        }

        return result;
    }

    pub fn deinit(self: *Modules) void {
        for (&self.results) |*item| item.deinit();
    }
};
