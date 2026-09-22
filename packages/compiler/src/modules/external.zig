const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const External = @import("project.zig").External;
const Types = @import("../analysis/types.zig");
const Result = struct { types: []const ir.Type, function: ir.Function };

pub fn load(allocator: std.mem.Allocator, registry: []const External, item: zx.ast.Import, existing: []const ir.Type, reporter: *zx.Reporter) zx.Error!Result {
    for (registry) |entry| {
        if (!std.mem.eql(u8, item.path, entry.specifier)) continue;

        var parsed = try @import("../frontend/parse.zig").parse(allocator, entry.signature, entry.specifier);

        defer parsed.deinit();

        if (parsed.value == .diagnostic or parsed.value.parsed.ast.body != null or parsed.value.parsed.ast.imports.len != 0) return reporter.fail(.module, item.span, "a reviewed external signature must be a self-contained pure type module");

        var types = Types{ .allocator = allocator, .reporter = reporter, .declarations = parsed.value.parsed.ast.declarations };

        try types.items.appendSlice(allocator, existing);
        try types.initialize();

        const input_type = try types.named(.{ .text = "Input", .span = item.span });
        const output_type = try types.named(.{ .text = "Output", .span = item.span });
        var implementation = entry.implementation;

        if (implementation.expand_tuple and types.get(input_type) != .tuple) return reporter.fail(.module, item.span, "positional external signatures require tuple Input");

        implementation.module = try allocator.dupe(u8, implementation.module);
        implementation.member = try allocator.dupe(u8, implementation.member);

        return .{ .types = try types.items.toOwnedSlice(allocator), .function = .{
            .file_name = try allocator.dupe(u8, entry.specifier),
            .input_type = input_type,
            .output_type = output_type,
            .symbols = &.{},
            .expressions = &.{},
            .body = &.{},
            .external = implementation,
        } };
    }

    return reporter.fail(.capability, item.span, "this external interface is not registered as a reviewed pure function");
}
