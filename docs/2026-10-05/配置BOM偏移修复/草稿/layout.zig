const std = @import("std");
const c = @import("yaml.zig").c;
const Field = @import("lint").configuration.yaml.Field;

pub fn collect(allocator: std.mem.Allocator, source: []const u8) ![]const Field {
    const offsets = try byteOffsets(allocator, source);

    defer allocator.free(offsets);

    var parser: c.yaml_parser_t = undefined;

    if (c.yaml_parser_initialize(&parser) == 0) return error.OutOfMemory;

    defer c.yaml_parser_delete(&parser);
    c.yaml_parser_set_input_string(&parser, source.ptr, source.len);

    var fields: std.ArrayList(Field) = .empty;

    errdefer fields.deinit(allocator);

    var depth: usize = 0;
    var root_block = false;
    var current: ?Field = null;

    while (true) {
        var token: c.yaml_token_t = undefined;

        if (c.yaml_parser_scan(&parser, &token) == 0) {
            return if (parser.@"error" == c.YAML_MEMORY_ERROR) error.OutOfMemory else error.InvalidYamlLayout;
        }

        defer c.yaml_token_delete(&token);

        if (token.type == c.YAML_STREAM_END_TOKEN) break;
        if (token.start_mark.index >= offsets.len or token.end_mark.index >= offsets.len) return error.InvalidYamlLayout;

        if (root_block and depth == 1 and token.type == c.YAML_KEY_TOKEN) {
            if (current) |field| try fields.append(allocator, field);

            const start = offsets[token.start_mark.index];

            current = .{ .span = .{ .start = start, .end = start }, .preserve_trailing = false };
        }

        if (material(token.type)) {
            if (current) |*field| {
                field.span.end = offsets[token.end_mark.index];
                field.preserve_trailing = token.type == c.YAML_SCALAR_TOKEN and (token.data.scalar.style == c.YAML_LITERAL_SCALAR_STYLE or token.data.scalar.style == c.YAML_FOLDED_SCALAR_STYLE);
            }
        }

        switch (token.type) {
            c.YAML_BLOCK_MAPPING_START_TOKEN, c.YAML_BLOCK_SEQUENCE_START_TOKEN, c.YAML_FLOW_MAPPING_START_TOKEN, c.YAML_FLOW_SEQUENCE_START_TOKEN => {
                if (depth == 0) root_block = token.type == c.YAML_BLOCK_MAPPING_START_TOKEN;

                depth += 1;
            },
            c.YAML_BLOCK_END_TOKEN, c.YAML_FLOW_MAPPING_END_TOKEN, c.YAML_FLOW_SEQUENCE_END_TOKEN => {
                if (depth == 0) return error.InvalidYamlLayout;

                if (root_block and depth == 1) {
                    if (current) |field| try fields.append(allocator, field);

                    current = null;
                    root_block = false;
                }

                depth -= 1;
            },
            else => {},
        }
    }

    return fields.toOwnedSlice(allocator);
}

fn material(kind: c.yaml_token_type_t) bool {
    return switch (kind) {
        c.YAML_SCALAR_TOKEN, c.YAML_ALIAS_TOKEN, c.YAML_ANCHOR_TOKEN, c.YAML_TAG_TOKEN, c.YAML_VALUE_TOKEN, c.YAML_BLOCK_ENTRY_TOKEN, c.YAML_FLOW_ENTRY_TOKEN, c.YAML_FLOW_MAPPING_START_TOKEN, c.YAML_FLOW_MAPPING_END_TOKEN, c.YAML_FLOW_SEQUENCE_START_TOKEN, c.YAML_FLOW_SEQUENCE_END_TOKEN => true,
        else => false,
    };
}

fn byteOffsets(allocator: std.mem.Allocator, source: []const u8) ![]const usize {
    const bom = "\xef\xbb\xbf";
    var offset: usize = if (std.mem.startsWith(u8, source, bom)) bom.len else 0;
    const view = try std.unicode.Utf8View.init(source[offset..]);
    var iterator = view.iterator();
    var offsets: std.ArrayList(usize) = .empty;

    errdefer offsets.deinit(allocator);

    while (iterator.nextCodepointSlice()) |character| {
        try offsets.append(allocator, offset);

        offset += character.len;
    }

    try offsets.append(allocator, offset);

    return offsets.toOwnedSlice(allocator);
}
