const std = @import("std");
const api = @import("zxc_abi").native.@"std:child_process";
const Self = @This();

allocator: std.mem.Allocator,
argv: []const []const u8,

environment: ?std.process.Environ.Map = null,
pub fn init(allocator: std.mem.Allocator, input: api.Options) !Self {
    try validate(input.command);

    if (input.command.len == 0) return error.EmptyCommand;
    if (input.cwd) |cwd| try validate(cwd);
    for (input.args) |argument| try validate(argument);

    const argv = try allocator.alloc([]const u8, try std.math.add(usize, input.args.len, 1));

    argv[0] = input.command;

    @memcpy(argv[1..], input.args);

    var self = Self{ .allocator = allocator, .argv = argv };

    errdefer self.deinit();

    if (input.env) |entries| {
        self.environment = std.process.Environ.Map.init(allocator);

        for (entries) |entry| {
            try validate(entry.name);
            try validate(entry.value);
            if (entry.name.len == 0 or std.mem.indexOfScalar(u8, entry.name, '=') != null) return error.InvalidEnvironmentName;
            try self.environment.?.put(entry.name, entry.value);
        }
    }

    return self;
}

pub fn deinit(self: *Self) void {
    if (self.environment) |*environment| environment.deinit();

    self.allocator.free(self.argv);
}

fn validate(value: []const u8) !void {
    if (std.mem.indexOfScalar(u8, value, 0) != null) return error.InvalidProcessArgument;
    if (!std.unicode.utf8ValidateSlice(value)) return error.InvalidUtf8;
}
