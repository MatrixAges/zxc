const std = @import("std");
const compiler = @import("compiler");
const source = @import("record_fixture");
const artifact = compiler.project.artifact;

pub const Fixture = struct {
    results: [4]artifact.Result,
    modules: [4]artifact.Module,

    pub fn init(allocator: std.mem.Allocator) !Fixture {
        var analysis = try source.analyze(allocator);

        defer analysis.deinit();

        try source.check(analysis);

        var result: Fixture = undefined;
        var count: usize = 0;

        errdefer for (result.results[0..count]) |*item| item.deinit();

        for (&result.results, &result.modules, 0..) |*item, *module, index| {
            item.* = try artifact.extract(allocator, &analysis, index);
            module.* = item.value;
            count += 1;
        }

        return result;
    }

    pub fn deinit(self: *Fixture) void {
        for (&self.results) |*item| item.deinit();
    }

    pub fn expectError(self: *const Fixture, expected: anyerror) !void {
        try std.testing.expectError(expected, artifact.linker.link(std.testing.allocator, &self.modules, "/project/main.zx"));
    }
};
