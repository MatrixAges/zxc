const std = @import("std");
const enabled = @import("rx_options").generated_rules;
const Kind = if (enabled) @import("generated_file_kind").Output else enum { App, Gateway, Store, Module, Invalid };

pub fn classify(name: []const u8) Kind {
    if (enabled) return @import("../scalar.zig").execute(@import("generated_file_kind"), name);
    if (std.mem.eql(u8, name, "app.rx")) return .App;
    if (std.mem.endsWith(u8, name, ".gateway.rx")) return .Gateway;
    if (std.mem.endsWith(u8, name, ".store.rx")) return .Store;

    return if (std.mem.endsWith(u8, name, ".rx")) .Module else .Invalid;
}
