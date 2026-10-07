pub const source = @embedFile("resolution.d.zx")
    ++ @embedFile("resolution/source.d.zx")
    ++ @embedFile("resolution/traversal.d.zx")
    ++ @embedFile("resolution/diagnostics.d.zx")
    ++ @embedFile("resolution/construction.d.zx");
