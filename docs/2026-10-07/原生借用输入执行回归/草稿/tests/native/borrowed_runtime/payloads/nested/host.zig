pub const Impl = @import("native_impl").Native([]const []const u64);
pub const first = Impl.first;
pub const echo = Impl.echo;
pub const second = Impl.second;
pub const allocated = Impl.allocated;
