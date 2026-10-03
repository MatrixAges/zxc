const std = @import("std");
const ast = @import("../ast.zig");
const diagnostics = @import("../diagnostic.zig");
const Self = @This();

allocator: std.mem.Allocator,
source: []const u8,
reporter: *diagnostics.Reporter,

offset: usize = 0,

line: usize = 1,
column: usize = 1,
pub fn document(self: *Self) diagnostics.Error!ast.Node {
    if (!std.unicode.utf8ValidateSlice(self.source)) return self.fail("XML source must be valid UTF-8");

    var characters = std.unicode.Utf8View.initUnchecked(self.source).iterator();

    while (characters.nextCodepoint()) |character| {
        if (!validCharacter(character)) return self.fail("XML source contains a forbidden character");
    }

    if (self.starts("\xef\xbb\xbf")) self.advance(3);
    if (self.take("<?xml")) try self.declaration();
    try self.trivia();

    const root = try self.element(0);

    try self.trivia();
    if (self.offset != self.source.len) return self.fail("XML requires exactly one root element");

    return root;
}

fn element(self: *Self, depth: usize) diagnostics.Error!ast.Node {
    if (depth >= 256) return self.fail("XML nesting exceeds 256 elements");

    const node_location = self.location();

    try self.require("<");

    const element_name = try self.name();
    var attributes: std.ArrayList(ast.Attribute) = .empty;

    while (true) {
        const separated = self.whitespace();

        if (self.take("/>")) return .{ .name = element_name, .location = node_location, .attributes = try attributes.toOwnedSlice(self.allocator) };
        if (self.take(">")) break;
        if (!separated) return self.fail("XML attributes require separating whitespace");

        const attribute_location = self.location();
        const attribute_name = try self.name();

        for (attributes.items) |previous| {
            if (std.mem.eql(u8, previous.name, attribute_name)) return self.fail("duplicate XML attribute");
        }

        _ = self.whitespace();

        try self.require("=");

        _ = self.whitespace();

        if (self.offset == self.source.len or (self.source[self.offset] != '\'' and self.source[self.offset] != '"')) return self.fail("XML attribute values must be quoted");

        const quote = self.source[self.offset];

        self.advance(1);

        const value_location = self.location();
        const attribute_value = try self.value(quote);

        if (self.offset == self.source.len) return self.fail("unterminated XML attribute");

        self.advance(1);

        try attributes.append(self.allocator, .{ .name = attribute_name, .value = attribute_value, .location = attribute_location, .value_location = value_location });
    }

    var children: std.ArrayList(ast.Node) = .empty;
    var text: std.ArrayList(ast.Text) = .empty;

    while (!self.starts("</")) {
        if (self.offset == self.source.len) return self.fail("missing XML closing tag");

        if (self.starts("<!--")) {
            try self.comment();
        } else if (self.take("<![CDATA[")) {
            const text_location = self.location();
            const start = self.offset;

            while (!self.starts("]]>")) {
                if (self.offset == self.source.len) return self.fail("unterminated XML CDATA section");

                self.advance(1);
            }

            const content = try normalizeText(self.allocator, self.source[start..self.offset]);

            try text.append(self.allocator, .{ .value = content, .location = text_location });

            self.advance(3);
        } else if (self.starts("<")) {
            try children.append(self.allocator, try self.element(depth + 1));
        } else {
            const text_location = self.location();
            const content = try self.value('<');

            try text.append(self.allocator, .{ .value = content, .location = text_location });
        }
    }

    self.advance(2);

    const closing = try self.name();

    if (!std.mem.eql(u8, element_name, closing)) return self.fail("XML closing tag does not match opening tag");

    _ = self.whitespace();

    try self.require(">");

    return .{ .name = element_name, .location = node_location, .attributes = try attributes.toOwnedSlice(self.allocator), .children = try children.toOwnedSlice(self.allocator), .text = try text.toOwnedSlice(self.allocator) };
}

fn value(self: *Self, terminator: u8) diagnostics.Error![]const u8 {
    var result: std.ArrayList(u8) = .empty;

    while (self.offset < self.source.len and self.source[self.offset] != terminator) {
        const byte = self.source[self.offset];

        if (byte == '<') return self.fail("literal < is forbidden in XML attributes");
        if (terminator == '<' and self.starts("]]>")) return self.fail("literal ]]> is forbidden in XML text");

        if (byte == '&') {
            self.advance(1);

            const start = self.offset;

            while (self.offset < self.source.len and self.source[self.offset] != ';') self.advance(1);
            if (self.offset == self.source.len) return self.fail("unterminated XML entity reference");

            const entity = self.source[start..self.offset];

            const character: u21 = if (std.mem.eql(u8, entity, "amp")) '&' else if (std.mem.eql(u8, entity, "lt")) '<' else if (std.mem.eql(u8, entity, "gt")) '>' else if (std.mem.eql(u8, entity, "quot")) '"' else if (std.mem.eql(u8, entity, "apos")) '\'' else blk: {
                if (entity.len < 2 or entity[0] != '#') return self.fail("unsupported XML entity reference");

                const hexadecimal = entity[1] == 'x';
                const digits = entity[if (hexadecimal) @as(usize, 2) else 1..];

                if (digits.len == 0) return self.fail("empty XML character reference");

                for (digits) |digit| {
                    if (if (hexadecimal) !std.ascii.isHex(digit) else !std.ascii.isDigit(digit)) return self.fail("invalid XML character reference");
                }

                break :blk std.fmt.parseInt(u21, digits, if (hexadecimal) 16 else 10) catch return self.fail("XML character reference is out of range");
            };

            if (!validCharacter(character)) return self.fail("forbidden XML character reference");

            var buffer: [4]u8 = undefined;
            const length = std.unicode.utf8Encode(character, &buffer) catch return self.fail("invalid XML character reference");

            try result.appendSlice(self.allocator, buffer[0..length]);

            self.advance(1);
        } else {
            const normalized: u8 = if (byte == '\r') (if (terminator == '<') @as(u8, '\n') else ' ') else if (terminator != '<' and (byte == '\n' or byte == '\t')) ' ' else byte;

            try result.append(self.allocator, normalized);

            const crlf = self.starts("\r\n");

            self.advance(if (crlf) 2 else 1);
        }
    }

    return result.toOwnedSlice(self.allocator);
}

fn name(self: *Self) diagnostics.Error![]const u8 {
    const start = self.offset;

    if (start == self.source.len or (!std.ascii.isAlphabetic(self.source[start]) and self.source[start] != '_')) return self.fail("expected an ASCII XML name; declarations and namespaces are unsupported");

    self.advance(1);

    while (self.offset < self.source.len) {
        const byte = self.source[self.offset];

        if (!std.ascii.isAlphanumeric(byte) and byte != '_' and byte != '-' and byte != '.') break;

        self.advance(1);
    }

    return self.source[start..self.offset];
}

fn declaration(self: *Self) diagnostics.Error!void {
    var count: usize = 0;
    var standalone = false;
    var encoding = false;

    while (true) {
        const separated = self.whitespace();

        if (self.take("?>")) {
            if (count == 0) return self.fail("XML declaration requires version 1.0");

            return;
        }

        if (!separated) return self.fail("XML declaration fields require separating whitespace");

        const field = try self.name();

        _ = self.whitespace();

        try self.require("=");

        _ = self.whitespace();

        if (self.offset == self.source.len or (self.source[self.offset] != '\'' and self.source[self.offset] != '"')) return self.fail("XML declaration values must be quoted");

        const quote = self.source[self.offset];

        self.advance(1);

        const start = self.offset;

        while (self.offset < self.source.len and self.source[self.offset] != quote) self.advance(1);
        if (self.offset == self.source.len) return self.fail("unterminated XML declaration");

        const content = self.source[start..self.offset];

        self.advance(1);

        if (count == 0) {
            if (!std.mem.eql(u8, field, "version") or !std.mem.eql(u8, content, "1.0")) return self.fail("XML declaration must begin with version 1.0");
        } else if (std.mem.eql(u8, field, "encoding") and !encoding and !standalone) {
            if (!std.ascii.eqlIgnoreCase(content, "UTF-8")) return self.fail("only UTF-8 XML encoding is supported");

            encoding = true;
        } else if (std.mem.eql(u8, field, "standalone") and !standalone) {
            if (!std.mem.eql(u8, content, "yes") and !std.mem.eql(u8, content, "no")) return self.fail("XML standalone must be yes or no");

            standalone = true;
        } else return self.fail("invalid or duplicate XML declaration field");

        count += 1;
    }
}

fn normalizeText(allocator: std.mem.Allocator, source: []const u8) std.mem.Allocator.Error![]const u8 {
    var text: std.ArrayList(u8) = .empty;

    for (source, 0..) |byte, index| {
        if (byte == '\n' and index > 0 and source[index - 1] == '\r') continue;
        try text.append(allocator, if (byte == '\r') '\n' else byte);
    }

    return text.toOwnedSlice(allocator);
}

fn trivia(self: *Self) diagnostics.Error!void {
    while (true) {
        _ = self.whitespace();

        if (!self.starts("<!--")) return;
        try self.comment();
    }
}

fn comment(self: *Self) diagnostics.Error!void {
    self.advance(4);

    while (!self.starts("-->")) {
        if (self.offset == self.source.len) return self.fail("unterminated XML comment");
        if (self.starts("--")) return self.fail("XML comments cannot contain --");

        self.advance(1);
    }

    self.advance(3);
}

fn whitespace(self: *Self) bool {
    const start = self.offset;

    while (self.offset < self.source.len and std.mem.indexOfScalar(u8, " \t\r\n", self.source[self.offset]) != null) self.advance(1);

    return self.offset != start;
}

fn starts(self: *Self, text: []const u8) bool {
    return std.mem.startsWith(u8, self.source[self.offset..], text);
}

fn take(self: *Self, text: []const u8) bool {
    if (!self.starts(text)) return false;

    self.advance(text.len);

    return true;
}

fn require(self: *Self, text: []const u8) diagnostics.Error!void {
    if (!self.take(text)) return self.fail("unexpected XML token");
}

fn advance(self: *Self, count: usize) void {
    for (self.source[self.offset..][0..count], self.offset..) |byte, index| {
        if (byte == '\r' or (byte == '\n' and (index == 0 or self.source[index - 1] != '\r'))) {
            self.line += 1;
            self.column = 1;
        } else if (byte != '\n') self.column += 1;
    }

    self.offset += count;
}

fn location(self: *Self) ast.Location {
    return .{ .offset = self.offset, .line = self.line, .column = self.column };
}

fn fail(self: *Self, message: []const u8) diagnostics.Error {
    return self.reporter.fail(.{ .code = .syntax, .location = self.location(), .element = "", .message = message });
}

fn validCharacter(character: u21) bool {
    return character == 9 or character == 10 or character == 13 or (character >= 0x20 and character <= 0xd7ff) or (character >= 0xe000 and character <= 0xfffd) or (character >= 0x10000 and character <= 0x10ffff);
}
