const std = @import("std");
const zx = @import("zx");
const Types = @import("../analysis/types.zig");
const Signature = @import("source_signature.zig");
const Analyzer = @import("../analysis/analyzer.zig");
const parser = @import("../frontend/parse.zig");
const module_result = @import("../frontend/module_result.zig");

pub const Native = struct {
    pub const completes_ownership = false;

    value: parser.Parsed,
    pub fn source(self: Native) []const u8 {
        return self.value.source;
    }
    pub fn header(self: Native) zx.syntax.header.Native {
        return .{ .program = self.value.ast };
    }

    pub fn signature(self: Native, types: *Types) zx.Error!Signature.Result {
        types.declarations = self.value.ast.declarations;

        try types.initialize();

        return Signature.resolve(types, self.value.ast, @import("type_views").Native{ .items = self.value.ast.declarations });
    }
    pub fn analyze(self: Native, analyzer: *Analyzer, file_name: []const u8) zx.Error!zx.ir.Program {
        analyzer.types.declarations = self.value.ast.declarations;

        return analyzer.run(self.value.ast, file_name);
    }
};

pub const Indexed = if (module_result.indexed_enabled) struct {
    const Self = @This();
    pub const completes_ownership = true;
    value: *const module_result.Indexed,
    pub fn source(self: Self) []const u8 {
        return self.value.source;
    }

    pub fn header(self: Self) @import("../frontend/syntax/header.zig").View(@FieldType(module_result.Indexed, "output")) {
        return .{ .source = self.value.source, .storage = self.value.output };
    }
    pub fn signature(self: Self, types: *Types) zx.Error!Signature.Result {
        var scratch = std.heap.ArenaAllocator.init(self.value.syntax_arena.child_allocator);

        defer scratch.deinit();

        const View = @import("../frontend/syntax/program.zig").View(@TypeOf(self.value.output));
        const view = try View.init(scratch.allocator(), self.value.source, self.value.output);

        try @import("../analysis/types/resolve.zig").initialize(types, view.types);

        return Signature.resolve(types, view.program(), view.types);
    }
    pub fn analyze(self: Self, analyzer: *Analyzer, file_name: []const u8) zx.Error!zx.ir.Program {
        return @import("../analysis/analyzer/host/root.zig").analyze(analyzer, self.value.source, self.value.output, file_name);
    }
} else void;
