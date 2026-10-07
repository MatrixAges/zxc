const std = @import("std");
const compiler = @import("compiler");
const save = @import("save.zig");

pub fn emit(io: std.Io, allocator: std.mem.Allocator, library: *const compiler.library.Result, directory: []const u8) !void {
    var output = save.Output{ .io = io, .allocator = allocator, .directory = directory };

    for (library.exports, 0..) |exported, index| {
        var analysis = compiler.AnalysisResult{ .arena = std.heap.ArenaAllocator.init(allocator), .value = .{ .ir = try library.module(index) }, .nominal_types = library.nominal_types };

        defer analysis.deinit();

        var bundle = try compiler.zig.emitModules(allocator, &analysis);

        defer bundle.deinit();

        try output.module(exported.name, bundle.entry.source, bundle.entry.imports);
        for (bundle.modules) |module| try output.module(module.name, module.source, module.imports);
        try output.file("types.zig", bundle.types);

        for (0..bundle.native_modules.count()) |module_row| {
            const module = bundle.native_modules.at(module_row);

            if (module.identity == null) continue;

            const view = try compiler.zig.abi_view.render(allocator, bundle.type_names, &.{.{ .name = module.specifier, .identity = module.key() }}, true);
            const path = try std.fmt.allocPrint(allocator, "{s}_abi.zig", .{module.import_name});

            try output.file(path, view);
        }

        try output.file("native.json", try std.json.Stringify.valueAlloc(allocator, bundle.native_modules.jsonRows(), .{ .whitespace = .indent_2 }));
    }

    try output.file("modules.json", try std.json.Stringify.valueAlloc(allocator, output.modules.items, .{ .whitespace = .indent_2 }));
}
