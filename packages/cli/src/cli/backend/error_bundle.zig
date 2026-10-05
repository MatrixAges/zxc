const std = @import("std");
const Bundle = std.zig.ErrorBundle;
const Node = struct { kind: enum { message, source }, index: u32 };
const Record = struct { children: []const Node, done: bool = false, height: usize = 1, expanded: usize = 1 };
const Frame = struct { node: Node, finish: bool = false };
const max_depth = 256;
const max_expanded = 1024 * 1024;

pub fn validate(allocator: std.mem.Allocator, bundle: Bundle) !void {
    if (bundle.extra.len == 0) {
        if (bundle.string_bytes.len != 0) return error.InvalidBackendProtocol;

        return;
    }

    _ = try region(bundle, 0, @typeInfo(Bundle.ErrorMessageList).@"struct".field_names.len);

    if (bundle.string_bytes.len == 0 or bundle.string_bytes[0] != 0) return error.InvalidBackendProtocol;

    const root = bundle.getErrorMessageList();
    const roots = try region(bundle, root.start, root.len);

    try string(bundle, root.compile_log_text);
    if (roots.len > max_expanded) return error.BackendDiagnosticsTooComplex;

    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const temporary = arena.allocator();
    var records: std.AutoHashMapUnmanaged(Node, Record) = .empty;
    var pending: std.ArrayList(Frame) = .empty;

    for (roots) |index| try pending.append(temporary, .{ .node = .{ .kind = .message, .index = index } });

    while (pending.pop()) |frame| {
        if (frame.finish) {
            const record = records.getPtr(frame.node).?;

            for (record.children) |child| {
                const nested = records.get(child).?;

                record.height = @max(record.height, nested.height + 1);

                if (nested.expanded > max_expanded - record.expanded) return error.BackendDiagnosticsTooComplex;

                record.expanded += nested.expanded;
            }

            if (record.height > max_depth) return error.BackendDiagnosticsTooComplex;

            record.done = true;

            continue;
        }

        if (records.get(frame.node)) |record| {
            if (!record.done) return error.InvalidBackendProtocol;

            continue;
        }

        const children = try references(temporary, bundle, frame.node);

        try records.put(temporary, frame.node, .{ .children = children });
        try pending.append(temporary, .{ .node = frame.node, .finish = true });
        for (children) |child| try pending.append(temporary, .{ .node = child });
    }

    var expanded: usize = 0;

    for (roots) |index| {
        const count = records.get(.{ .kind = .message, .index = index }).?.expanded;

        if (count > max_expanded - expanded) return error.BackendDiagnosticsTooComplex;

        expanded += count;
    }
}

fn references(allocator: std.mem.Allocator, bundle: Bundle, node: Node) ![]const Node {
    var children: std.ArrayList(Node) = .empty;

    switch (node.kind) {
        .message => {
            const size = @typeInfo(Bundle.ErrorMessage).@"struct".field_names.len;

            _ = try region(bundle, node.index, size);

            if (node.index > std.math.maxInt(u32) - size) return error.InvalidBackendProtocol;

            const message = bundle.getErrorMessage(@enumFromInt(node.index));
            const notes = try region(bundle, node.index + size, message.notes_len);

            try string(bundle, message.msg);

            if (notes.len > max_expanded) return error.BackendDiagnosticsTooComplex;
            if (message.src_loc != .none) try children.append(allocator, .{ .kind = .source, .index = @intFromEnum(message.src_loc) });
            for (notes) |index| try children.append(allocator, .{ .kind = .message, .index = index });
        },
        .source => {
            const size = @typeInfo(Bundle.SourceLocation).@"struct".field_names.len;
            const trace_size = @typeInfo(Bundle.ReferenceTrace).@"struct".field_names.len;

            if (node.index == 0) return error.InvalidBackendProtocol;

            _ = try region(bundle, node.index, size);

            const source = bundle.getSourceLocation(@enumFromInt(node.index));
            const start = @as(usize, node.index) + size;

            if (source.reference_trace_len > (bundle.extra.len - start) / trace_size) return error.InvalidBackendProtocol;
            if (source.reference_trace_len > max_expanded) return error.BackendDiagnosticsTooComplex;
            if (source.line == std.math.maxInt(u32) or source.column == std.math.maxInt(u32)) return error.InvalidBackendProtocol;
            try string(bundle, source.src_path);

            if (source.source_line != 0) {
                try string(bundle, source.source_line);
                if (source.span_main < source.span_start or source.column < source.span_main - source.span_start) return error.InvalidBackendProtocol;
            }

            for (0..source.reference_trace_len) |index| {
                const trace = bundle.extra[start + index * trace_size ..][0..trace_size];

                if (trace[1] == 0) {
                    if (trace[0] != 0 and trace[0] > std.math.maxInt(u32) - source.reference_trace_len) return error.InvalidBackendProtocol;

                    continue;
                }

                try string(bundle, trace[0]);
                try children.append(allocator, .{ .kind = .source, .index = trace[1] });
            }
        },
    }

    return children.toOwnedSlice(allocator);
}

fn region(bundle: Bundle, start: usize, length: usize) ![]const u32 {
    if (start > bundle.extra.len or length > bundle.extra.len - start) return error.InvalidBackendProtocol;

    return bundle.extra[start..][0..length];
}

fn string(bundle: Bundle, index: u32) !void {
    if (index >= bundle.string_bytes.len or std.mem.indexOfScalar(u8, bundle.string_bytes[index..], 0) == null) return error.InvalidBackendProtocol;
}
