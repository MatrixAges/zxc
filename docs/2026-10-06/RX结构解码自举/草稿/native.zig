const ast = @import("dsl").ast;
const abi = @import("zxc_abi").native.@"zig:rx_ast";
const Node = abi.Node;
const Attribute = abi.Attribute;
const Text = abi.Text;

fn nodeView(value: Node) *const ast.Node {
    return @ptrCast(@alignCast(value));
}

fn attributeView(value: Attribute) *const ast.Attribute {
    return @ptrCast(@alignCast(value));
}

fn textView(value: Text) *const ast.Text {
    return @ptrCast(@alignCast(value));
}

pub fn fromNode(value: *const ast.Node) Node {
    return @ptrCast(value);
}

pub fn nodeName(value: Node) []const u8 {
    return nodeView(value).name;
}

pub fn attributeName(value: Attribute) []const u8 {
    return attributeView(value).name;
}

pub fn attributeValue(value: Attribute) []const u8 {
    return attributeView(value).value;
}

pub fn attributeBytes(value: Attribute) []const u8 {
    return attributeView(value).value;
}

pub fn attributeExpression(value: Attribute) bool {
    return attributeView(value).kind == .expression;
}

pub fn textBytes(value: Text) []const u8 {
    return textView(value).value;
}

pub fn nodeOffset(value: Node) u64 {
    return nodeView(value).location.offset;
}

pub fn nodeLine(value: Node) u64 {
    return nodeView(value).location.line;
}

pub fn nodeColumn(value: Node) u64 {
    return nodeView(value).location.column;
}

pub fn attributeOffset(value: Attribute) u64 {
    return attributeView(value).location.offset;
}

pub fn attributeLine(value: Attribute) u64 {
    return attributeView(value).location.line;
}

pub fn attributeColumn(value: Attribute) u64 {
    return attributeView(value).location.column;
}

pub fn valueOffset(value: Attribute) u64 {
    return attributeView(value).value_location.offset;
}

pub fn valueLine(value: Attribute) u64 {
    return attributeView(value).value_location.line;
}

pub fn valueColumn(value: Attribute) u64 {
    return attributeView(value).value_location.column;
}

pub fn textOffset(value: Text) u64 {
    return textView(value).location.offset;
}

pub fn textLine(value: Text) u64 {
    return textView(value).location.line;
}

pub fn textColumn(value: Text) u64 {
    return textView(value).location.column;
}

pub fn attributeCount(value: Node) u64 {
    return nodeView(value).attributes.len;
}

pub fn attributeAt(value: Node, index: u64) error{IndexOutOfBounds}!Attribute {
    const items = nodeView(value).attributes;

    if (index >= items.len) return error.IndexOutOfBounds;

    return @ptrCast(&items[@intCast(index)]);
}

pub fn childCount(value: Node) u64 {
    return nodeView(value).children.len;
}

pub fn childAt(value: Node, index: u64) error{IndexOutOfBounds}!Node {
    const items = nodeView(value).children;

    if (index >= items.len) return error.IndexOutOfBounds;

    return @ptrCast(&items[@intCast(index)]);
}

pub fn textCount(value: Node) u64 {
    return nodeView(value).text.len;
}

pub fn textAt(value: Node, index: u64) error{IndexOutOfBounds}!Text {
    const items = nodeView(value).text;

    if (index >= items.len) return error.IndexOutOfBounds;

    return @ptrCast(&items[@intCast(index)]);
}

pub fn attributeSlice(value: Attribute, start: u64, end: u64) error{IndexOutOfBounds}![]const u8 {
    const bytes = attributeView(value).value;

    if (start > end or end > bytes.len) return error.IndexOutOfBounds;

    return bytes[@intCast(start)..@intCast(end)];
}
