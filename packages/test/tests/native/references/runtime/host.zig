pub const Node = @import("zxc_abi").native.@"zig:host".Node;
pub const HostNode = struct { value: u64, payload: []const u8 = "", children: []const HostNode = &.{} };
pub const Event = struct { node: Node, marker: u64 };
pub var calls: usize = 0;
pub var fail_at: usize = 0;
pub var events: [16]Event = undefined;

pub fn reset(failure: usize) void {
    calls = 0;
    fail_at = failure;
    events = undefined;
}

pub fn fromNode(value: *const HostNode) Node {
    return @ptrCast(value);
}

fn view(node: Node) *const HostNode {
    return @ptrCast(@alignCast(node));
}

fn note(node: Node, marker: u64) void {
    events[calls] = .{ .node = node, .marker = marker };
    calls += 1;
}

pub fn identity(node: Node) Node {
    note(node, 1);

    return node;
}

pub fn read(node: Node) u64 {
    note(node, 2);

    return view(node).value;
}

pub fn first(node: Node) ?Node {
    note(node, 3);

    const children = view(node).children;

    return if (children.len == 0) null else fromNode(&children[0]);
}

pub fn childAt(node: Node, index: u64) error{IndexOutOfBounds}!Node {
    note(node, 4);

    const children = view(node).children;

    if (index >= children.len) return error.IndexOutOfBounds;

    return fromNode(&children[@intCast(index)]);
}

pub fn record(node: Node, marker: u64) error{NativeFailure}!Node {
    note(node, marker);

    if (calls == fail_at) return error.NativeFailure;

    return node;
}
