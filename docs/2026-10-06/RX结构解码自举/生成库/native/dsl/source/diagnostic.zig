const ast = @import("ast.zig");

pub const Code = enum {
    syntax,
    unexpected_element,
    unknown_attribute,
    duplicate_attribute,
    missing_attribute,
    invalid_attribute,
    unexpected_text,
    child_count,
    context,
};

pub const Diagnostic = struct {
    code: Code,
    location: ast.Location,
    element: []const u8,
    attribute: ?[]const u8 = null,
    expected: ?[]const u8 = null,
    child_count: ?struct { min: usize, max: usize, actual: usize } = null,
    message: []const u8,
};

pub const Error = error{ InvalidDsl, OutOfMemory };

pub const Reporter = struct {
    diagnostic: ?Diagnostic = null,
    pub fn fail(self: *Reporter, diagnostic: Diagnostic) Error {
        if (self.diagnostic == null) self.diagnostic = diagnostic;

        return error.InvalidDsl;
    }
};
