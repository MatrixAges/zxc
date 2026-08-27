pub const Location = struct {
    offset: usize,
    line: usize,
    column: usize,
};

pub const Diagnostic = struct {
    file_name: []const u8,
    location: Location,
    message: []const u8,
};

pub const Reporter = struct {
    file_name: []const u8,
    diagnostic: ?Diagnostic = null,

    pub fn fail(self: *Reporter, location: Location, message: []const u8) Error {
        if (self.diagnostic == null) {
            self.diagnostic = .{
                .file_name = self.file_name,
                .location = location,
                .message = message,
            };
        }

        return error.InvalidSource;
    }
};

pub const Error = error{
    InvalidSource,
    OutOfMemory,
};
