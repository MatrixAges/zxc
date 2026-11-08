const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const generated = @import("genz_options").generated_analysis;
const seed = @import("elements_seed.zig");
const emission = @import("element_emission.zig");

pub fn inlineStored(self: *const Lower, list: ir.TypeId) bool {
    if (!generated) return seed.inlineStored(self, list);

    return emission.selected(self, list);
}

pub fn typeExpr(self: *Lower, list: ir.TypeId) Lower.Error!node.ExpressionId {
    if (!generated) return seed.typeExpr(self, list);

    return emission.elementType(self, list);
}

pub fn read(self: *Lower, body: *std.ArrayList(node.Statement), list: ir.TypeId, value: node.ExpressionId) Lower.Error!node.ExpressionId {
    if (!generated) return seed.read(self, body, list, value);

    return emission.lower(self, body, list, value, .Read);
}

pub fn write(self: *Lower, body: *std.ArrayList(node.Statement), list: ir.TypeId, value: node.ExpressionId) Lower.Error!node.ExpressionId {
    if (!generated) return seed.write(self, body, list, value);

    return emission.lower(self, body, list, value, .Write);
}

pub fn captureName(self: *Lower, body: *std.ArrayList(node.Statement), list: ir.TypeId, symbol: ir.SymbolId) Lower.Error![]const u8 {
    if (!generated) return seed.captureName(self, body, list, symbol);

    return emission.capture(self, body, list, symbol);
}

pub const convert = seed.convert;
