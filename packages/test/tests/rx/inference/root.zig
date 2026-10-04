comptime {
    _ = @import("store/lifetime_test.zig");
    _ = @import("store/function_test.zig");
    _ = @import("store/callback_test.zig");
    _ = @import("store/scope_test.zig");
    _ = @import("store/setter_test.zig");
    _ = @import("store/identity_test.zig");
    _ = @import("control/rejection_test.zig");
    _ = @import("control/resources_test.zig");
    _ = @import("control/scope_test.zig");
    _ = @import("project/ownership_test.zig");
    _ = @import("project/position_test.zig");
    _ = @import("project/diamond/optional_test.zig");
    _ = @import("project/resources_test.zig");
    _ = @import("project/order_test.zig");
    _ = @import("optional/contract_test.zig");
    _ = @import("ownership/root.zig");
    _ = @import("bindings_test.zig");
    _ = @import("position_test.zig");
    _ = @import("contract_test.zig");
    _ = @import("resources_test.zig");
}
