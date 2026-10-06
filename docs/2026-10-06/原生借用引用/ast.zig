const ast = @import("dsl").ast;
const Node = @import("zxc_abi").native.@"zig:ast".Node;

pub fn childCount(node: Node) u64 {
    return view(node).children.len;
}

pub fn childAt(node: Node, index: u64) error{IndexOutOfBounds}!Node {
    const children = view(node).children;

    if (index >= children.len) return error.IndexOutOfBounds;

    return @ptrCast(&children[@intCast(index)]);
}

fn view(node: Node) *const ast.Node {
    return @ptrCast(@alignCast(node));
}
