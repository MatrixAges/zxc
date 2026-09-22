const Span = @import("source.zig").Span;

pub const Code = enum {
    lexical,
    syntax,
    unsupported,
    contract,
    name,
    type_mismatch,
    return_path,
    naming,
    spacing,
    ownership,
    module,
    capability,
};

pub const Diagnostic = struct {
    code: Code,
    span: Span,
    message: []const u8,
    source_index: ?usize = null,
};

pub const Error = error{ InvalidSource, OutOfMemory };

pub const Reporter = struct {
    diagnostic: ?Diagnostic = null,
    pub fn fail(self: *Reporter, code: Code, span: Span, message: []const u8) Error {
        if (self.diagnostic == null) {
            self.diagnostic = .{ .code = code, .span = span, .message = message };
        }

        return error.InvalidSource;
    }
};
