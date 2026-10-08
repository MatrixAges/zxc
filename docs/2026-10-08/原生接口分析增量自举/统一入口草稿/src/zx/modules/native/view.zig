const declarations = @import("../declarations.zig");

pub const Native = struct {
    value: declarations.Program,
    pub fn typeView(self: @This()) @import("type_views").Native {
        return .{ .items = self.value.types };
    }
    pub fn functionCount(self: @This()) usize {
        return self.value.functions.len;
    }

    pub fn functionAt(self: @This(), index: usize) declarations.Function {
        return self.value.functions[index];
    }
};
