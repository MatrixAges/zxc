const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const External = @import("interface.zig").External;
const Types = @import("../analysis/types.zig");
const Result = struct { types: []const ir.Type, function: ir.Function };

pub fn load(allocator: std.mem.Allocator, entry: External, module: ir.NativeModuleId, span: zx.Span, existing: []const ir.Type, shared: Types.Shared, reporter: *zx.Reporter) zx.Error!Result {
    var parsed = try @import("../frontend/parse.zig").parse(allocator, entry.signature, entry.specifier);

    defer parsed.deinit();

    if (parsed.value == .diagnostic or parsed.value.parsed.ast.body != null or parsed.value.parsed.ast.imports.len != 0) return reporter.fail(.module, span, "a reviewed external signature must be a self-contained pure type module");

    var types = Types{ .allocator = allocator, .reporter = reporter, .declarations = parsed.value.parsed.ast.declarations, .shared = shared };

    try types.items.appendSlice(allocator, existing);
    try types.initialize();

    const input_type = try types.named(.{ .text = "Input", .span = span });
    const output_type = try types.named(.{ .text = "Output", .span = span });
    const implementation = entry.implementation;

    if (implementation.expand_tuple and types.get(input_type) != .tuple) return reporter.fail(.module, span, "positional external signatures require tuple Input");

    var members: std.ArrayList([]const u8) = .empty;
    var parts = std.mem.splitScalar(u8, implementation.member, '.');

    while (parts.next()) |part| {
        if (part.len == 0 or std.mem.indexOfScalar(u8, part, 0) != null or !std.unicode.utf8ValidateSlice(part)) return reporter.fail(.module, span, "native member paths require nonempty UTF-8 names");
        try members.append(allocator, try allocator.dupe(u8, part));
    }

    return .{ .types = try types.items.toOwnedSlice(allocator), .function = .{
        .file_name = try allocator.dupe(u8, entry.specifier),
        .input_type = input_type,
        .output_type = output_type,
        .symbols = &.{},
        .expressions = &.{},
        .body = &.{},
        .external = .{
            .module = module,
            .member = members.items,
            .export_name = if (entry.export_name) |name| try allocator.dupe(u8, name) else null,
            .allocator_argument = implementation.allocator_argument,
            .expand_tuple = implementation.expand_tuple,
            .fallible = implementation.fallible,
        },
    } };
}
