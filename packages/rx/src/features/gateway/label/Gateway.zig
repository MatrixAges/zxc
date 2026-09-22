const dsl = @import("dsl");
const checks = @import("../../../checks.zig");
const Entry = @import("../entries.zig").Entry;
pub const Protocol = enum { http, grpc, websocket, tcp, mqtt };

pub const Gateway = checks.nonEmptySchema(dsl.element("Gateway", struct {
    name: []const u8,
    protocol: ?Protocol = null,
    listen: ?[]const u8 = null,
}, dsl.list(Entry, .{})));
