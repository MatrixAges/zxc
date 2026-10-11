const std = @import("std");
const zx = @import("zx");
const Analyzer = @import("../analyzer.zig");
const Options = @import("../expression.zig").Options;
const refinement = @import("../refinement.zig");

pub fn add(analyzer: *Analyzer, options: Options, name: []const u8, span: zx.Span) zx.Error!void {
    var selected: ?zx.ir.SymbolId = null;
    var prefix: usize = 0;

    for (options.bindings, analyzer.expression_bindings.items) |binding, symbol| {
        const length = binding.name.len;

        if (length < prefix or length > name.len or !std.mem.startsWith(u8, name, binding.name)) continue;
        if (length != name.len and name[length] != '.') continue;

        selected = symbol;
        prefix = length;
    }

    const symbol = selected orelse return analyzer.reporter.fail(.contract, span, "branch fact requires a visible binding");

    if (prefix == name.len) return analyzer.refinement.add(analyzer.allocator, symbol);

    var value = try refinement.reference(analyzer, symbol, span);
    var parts = std.mem.splitScalar(u8, name[prefix + 1 ..], '.');

    while (parts.next()) |part| {
        const target = analyzer.types.get(analyzer.node(value).type_id);

        if (target != .object) return analyzer.reporter.fail(.contract, span, "branch fact requires a valid field path");

        for (0..target.object.len) |index| {
            const field = target.object.at(index);

            if (!std.mem.eql(u8, field.name, part)) continue;

            const projection = try analyzer.append(.{
                .span = span,
                .type_id = field.type_id,
                .value = .{ .field = .{ .target = value, .index = @intCast(index) } },
            });

            value = try refinement.project(analyzer, projection);

            break;
        } else return analyzer.reporter.fail(.contract, span, "branch fact requires a valid field path");
    }

    try analyzer.refinement.addValue(analyzer.allocator, analyzer.nodes.view(), value);
}
