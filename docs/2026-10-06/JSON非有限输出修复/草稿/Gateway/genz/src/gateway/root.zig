pub const Slot = struct { index: usize, writable: bool };
pub const Service = struct { name: []const u8, module_name: []const u8, slots: []const Slot, requires_io: bool, requires_process: bool, output: @import("../host/json_output.zig").Output };
pub const Route = struct { path: []const u8, method: ?[]const u8, service: usize };
pub const storage = @import("storage.zig");
pub const adapter = @import("adapter.zig");
pub const entry = @import("entry.zig");
