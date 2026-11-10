const node = @import("../../../node.zig");
const Types = @import("types.zig");

pub fn lower(types: Types, id: @import("zx").ir.TypeId) Types.Error!node.Declaration {
    if (comptime !@import("genz_options").generated_analysis) return @import("read_seed.zig").lower(types, id);

    return @import("codec.zig").lower(types, id, true);
}
