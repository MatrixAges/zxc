const std = @import("std");
const zx = @import("zx");
const Analyzer = @import("../analysis/analyzer.zig");
const parser = @import("../frontend/parse.zig");
const module_result = @import("../frontend/module_result.zig");

pub const Native = struct {
    value: parser.Parsed,
    pub fn source(self: Native) []const u8 {
        return self.value.source;
    }
    pub fn header(self: Native) zx.syntax.header.Native {
        return .{ .program = self.value.ast };
    }
    pub fn analyze(self: Native, analyzer: *Analyzer, file_name: []const u8) zx.Error!zx.ir.Program {
        analyzer.types.declarations = self.value.ast.declarations;

        return analyzer.run(self.value.ast, file_name);
    }
};

pub const Indexed = if (module_result.indexed_enabled) struct {
    const Self = @This();

    value: *const module_result.Indexed,
    pub fn source(self: Self) []const u8 {
        return self.value.source;
    }

    pub fn header(self: Self) @import("../frontend/syntax/header.zig").View(@FieldType(module_result.Indexed, "output")) {
        return .{ .source = self.value.source, .storage = self.value.output };
    }
    pub fn analyze(self: Self, analyzer: *Analyzer, file_name: []const u8) zx.Error!zx.ir.Program {
        var scratch = std.heap.ArenaAllocator.init(self.value.syntax_arena.child_allocator);

        defer scratch.deinit();

        const output = self.value.output;
        const View = @import("../analysis/types/indexed_view.zig").View(@TypeOf(output));

        const view = View{
            .source = self.value.source,
            .storage = output,
            .order = try @import("../analysis/types/indexed_view/order.zig").create(scratch.allocator(), output.types),
        };

        return analyzer.runTypes(view, file_name, .{ .has_store = output.has_store, .consumes_input = output.consumes_input });
    }
} else void;
