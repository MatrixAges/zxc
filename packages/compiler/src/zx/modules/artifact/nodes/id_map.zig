const Error = @import("../model.zig").Error;

pub fn Map(comptime Id: type) type {
    return union(enum) {
        indexed: []const ?Id,
        planned: []const u64,
        pub fn get(self: @This(), id: Id) Error!Id {
            const index = @backingInt(id);

            return switch (self) {
                .indexed => |values| if (index < values.len) values[index] orelse error.InvalidModule else error.InvalidModule,
                .planned => |values| if (index < values.len and values[index] != 0) @fromBackingInt(@intCast(values[index] - 1)) else error.InvalidModule,
            };
        }
    };
}
