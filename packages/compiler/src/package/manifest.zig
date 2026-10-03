const std = @import("std");
const c = @import("manifest/yaml.zig").c;
const model = @import("manifest/model.zig");
const Decoder = @import("manifest/decode.zig");

pub const Result = struct {
    arena: std.heap.ArenaAllocator,
    value: union(enum) { data: model.Manifest, diagnostic: model.Diagnostic },
    pub fn deinit(self: *Result) void {
        self.arena.deinit();

        self.* = undefined;
    }
};

pub fn parse(allocator: std.mem.Allocator, source: []const u8) !Result {
    var arena = std.heap.ArenaAllocator.init(allocator);

    errdefer arena.deinit();

    var parser: c.yaml_parser_t = undefined;

    if (c.yaml_parser_initialize(&parser) == 0) return error.OutOfMemory;

    defer c.yaml_parser_delete(&parser);
    c.yaml_parser_set_input_string(&parser, source.ptr, source.len);

    var document: c.yaml_document_t = undefined;

    if (c.yaml_parser_load(&parser, &document) == 0) return failure(&arena, parser);

    defer c.yaml_document_delete(&document);

    const root = c.yaml_document_get_root_node(&document);

    if (root == null) return .{ .arena = arena, .value = .{ .diagnostic = .{ .line = 1, .column = 1, .message = "pkg.yaml must contain one mapping document" } } };

    var decoder = Decoder{ .allocator = arena.allocator(), .document = &document };

    const data = decoder.decode(root) catch |err| {
        if (err == error.OutOfMemory) return err;

        return .{ .arena = arena, .value = .{ .diagnostic = decoder.diagnostic.? } };
    };

    var next: c.yaml_document_t = undefined;

    if (c.yaml_parser_load(&parser, &next) == 0) return failure(&arena, parser);

    defer c.yaml_document_delete(&next);

    if (c.yaml_document_get_root_node(&next) != null) {
        return .{ .arena = arena, .value = .{ .diagnostic = .{ .line = next.start_mark.line + 1, .column = next.start_mark.column + 1, .message = "pkg.yaml must contain exactly one document" } } };
    }

    return .{ .arena = arena, .value = .{ .data = data } };
}

fn failure(arena: *std.heap.ArenaAllocator, parser: c.yaml_parser_t) !Result {
    if (parser.@"error" == c.YAML_MEMORY_ERROR) return error.OutOfMemory;

    const message = try arena.allocator().dupe(u8, if (parser.problem == null) "invalid YAML" else std.mem.span(parser.problem));

    return .{ .arena = arena.*, .value = .{ .diagnostic = .{ .line = parser.problem_mark.line + 1, .column = parser.problem_mark.column + 1, .message = message } } };
}
