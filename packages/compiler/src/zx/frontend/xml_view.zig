const std = @import("std");
const ast = @import("dsl").ast;
const dsl = @import("dsl");
const lint = @import("lint");
const adapter = @import("xml_adapter");
const syntax = @import("xml_syntax.zig");
const layout = @import("generated_xml_links");
const Attribute = lint.rx.NodeView.Attribute;
const RawTree = @FieldType(std.meta.Child(syntax.Document), "tree");
const Tree = if (@typeInfo(RawTree) == .pointer) std.meta.Child(RawTree) else RawTree;
const Row = std.meta.Child(@FieldType(Tree, "nodes"));

pub const Result = struct {
    arena: std.heap.ArenaAllocator,
    value: union(enum) { document: Document, diagnostic: dsl.Diagnostic },
    pub fn deinit(self: *Result) void {
        self.arena.deinit();

        self.* = undefined;
    }
};

const Document = struct {
    source: []const u8,
    syntax: syntax.Document,
    first: []const u64,
    next: []const u64,
    decoded: []const u8,
    pub fn root(self: *const Document) Node {
        return .{ .document = self, .index = @intCast(self.syntax.control.result) };
    }
};

pub fn parse(allocator: std.mem.Allocator, source: []const u8, comptime schema: bool) std.mem.Allocator.Error!Result {
    var parsed = try syntax.parse(allocator, source);

    errdefer parsed.deinit();

    if (parsed.value == .diagnostic) return .{ .arena = parsed.arena, .value = .{ .diagnostic = parsed.value.diagnostic } };

    const input = parsed.value.document;
    const temporary = parsed.arena.allocator();
    const count = input.tree.nodes.len;
    const links = try temporary.alloc(u64, count * 2);
    const first = links[0..count];
    const next = links[count..];
    const execute = layout.executeValue;
    const Parameter = @typeInfo(@TypeOf(execute)).@"fn".param_types[1].?;
    const Input = if (@typeInfo(Parameter) == .pointer) std.meta.Child(Parameter) else Parameter;
    const args: Input = .{ .nodes = input.tree.nodes, .first = @ptrCast(&first), .next = @ptrCast(&next) };
    var empty = std.heap.FixedBufferAllocator.init(&.{});

    execute(empty.allocator(), if (@typeInfo(Parameter) == .pointer) &args else args) catch unreachable;

    const decoded: []const u8 = if (schema)
        try adapter.values.materialize(@import("generated_xml_decode").executeValue, temporary, source, input.tree.parts, input.control.decoded_length)

    else for (input.tree.text) |item| {
        if (item.value.decoded_start == item.value.decoded_end) continue;

        break try adapter.values.materialize(@import("generated_xml_decode").executeValue, temporary, source, input.tree.parts, input.control.decoded_length);
    } else &.{};

    return .{ .arena = parsed.arena, .value = .{ .document = .{ .source = source, .syntax = input, .first = first, .next = next, .decoded = decoded } } };
}

pub const Node = struct {
    document: *const Document,
    index: usize,
    pub const Child = Node;

    fn row(self: Node) Row {
        return self.document.syntax.tree.nodes[self.index];
    }
    pub fn name(self: Node) []const u8 {
        return slice(self.document.source, self.row().name);
    }

    pub fn location(self: Node) ast.Location {
        return adapter.location(self.row().location);
    }

    pub fn attributeCount(self: Node) usize {
        return @intCast(self.row().attribute_count);
    }

    pub fn attribute(self: Node, index: usize) Attribute {
        const source = self.document.source;
        const start: usize = @intCast(self.row().attribute_start);
        const item = self.document.syntax.tree.attributes[start + index];

        return .{
            .name = slice(source, item.name),
            .offset = @intCast(item.location.offset),
            .value_offset = @intCast(item.value_location.offset),
            .raw = adapter.values.raw(source, item.value),
            .expression = item.expression,
        };
    }

    pub fn schemaAttribute(self: Node, index: usize) ast.Attribute {
        const source = self.document.source;
        const start: usize = @intCast(self.row().attribute_start);
        const item = self.document.syntax.tree.attributes[start + index];
        const raw = adapter.values.raw(source, item.value);

        return .{
            .name = slice(source, item.name),
            .kind = if (item.expression) .expression else .string,
            .value = adapter.values.select(raw, self.document.decoded, item.value),
            .location = adapter.location(item.location),
            .value_location = adapter.location(item.value_location),
            .raw_value = raw,
        };
    }

    pub fn childCount(self: Node) usize {
        return @intCast(self.row().child_count);
    }

    pub fn children(self: Node) Children {
        return .{ .document = self.document, .head = self.document.first[self.index] };
    }

    pub fn whitespaceOnly(self: Node) bool {
        return self.findText(true) == null;
    }

    pub fn unexpectedText(self: Node) ?ast.Location {
        return self.findText(false);
    }
    fn findText(self: Node, comptime any: bool) ?ast.Location {
        const document = self.document;
        var head = self.row().text;
        var first: ?ast.Location = null;

        while (head != 0) {
            const item = document.syntax.tree.text[@intCast(head - 1)];
            const raw = adapter.values.raw(document.source, item.value);
            const text = adapter.values.select(raw, document.decoded, item.value);

            if (std.mem.trim(u8, text, " \t\r\n").len != 0) {
                first = adapter.location(item.location);

                if (any) return first;
            }

            head = item.previous;
        }

        return first;
    }
};

const Children = struct {
    document: *const Document,
    head: u64,
    pub fn next(self: *Children) ?Node {
        if (self.head == 0) return null;

        const index: usize = @intCast(self.head - 1);
        self.head = self.document.next[index];

        return .{ .document = self.document, .index = index };
    }
};

fn slice(source: []const u8, span: anytype) []const u8 {
    return source[@intCast(span.start)..@intCast(span.end)];
}
