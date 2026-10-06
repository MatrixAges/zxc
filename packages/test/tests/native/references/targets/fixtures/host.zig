pub const Node = @import("zxc_abi").native.@"zig:host".Node;
pub const HostNode = struct { value: u64 };

pub fn identity(node: Node) Node {
    return node;
}

pub fn read(node: Node) u64 {
    const value: *const HostNode = @ptrCast(@alignCast(node));

    return value.value;
}
