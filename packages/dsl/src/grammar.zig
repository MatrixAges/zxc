const std = @import("std");

pub fn grammar(comptime Parser: type, comptime Token: type, comptime Error: type) type {
    return struct {
        pub fn Match(comptime T: type) type {
            return union(enum) { miss, hit: T };
        }
        pub fn token(comptime spelling: []const u8) type {
            return struct {
                pub const Value = Token;

                pub fn parse(parser: *Parser) Error!Match(Value) {
                    const current = parser.current();

                    if (current.kind == .eof) return .miss;
                    if (!parser.take(spelling)) return .miss;

                    return .{ .hit = current };
                }
            };
        }

        pub fn peek(comptime Rule: type) type {
            return struct {
                pub const Value = Rule.Value;

                pub fn parse(parser: *Parser) Error!Match(Value) {
                    const start = parser.index;
                    defer parser.index = start;

                    return Rule.parse(parser);
                }
            };
        }

        pub fn separated(comptime Rule: type, comptime separator: []const u8, comptime closing: []const u8) type {
            return struct {
                pub const Value = []const Rule.Value;

                pub fn parse(parser: *Parser) Error!Match(Value) {
                    var values: std.ArrayList(Rule.Value) = .empty;

                    defer values.deinit(parser.allocator);

                    while (!parser.at(closing)) {
                        const start = parser.index;
                        const value = try run(Rule, parser, "expected a list element");

                        if (parser.index == start) return parser.reporter.fail(.contract, parser.current().span, "a list element must consume a token");
                        try values.append(parser.allocator, value);
                        if (!parser.take(separator)) break;
                    }

                    return .{ .hit = try values.toOwnedSlice(parser.allocator) };
                }
            };
        }

        pub fn reference(comptime T: type, comptime callback: fn (*Parser) Error!T) type {
            return struct {
                pub const Value = T;

                pub fn parse(parser: *Parser) Error!Match(Value) {
                    return .{ .hit = try callback(parser) };
                }
            };
        }
        pub fn required(comptime Rule: type, comptime message: []const u8) type {
            return struct {
                pub const Value = Rule.Value;

                pub fn parse(parser: *Parser) Error!Match(Value) {
                    return switch (try Rule.parse(parser)) {
                        .hit => |value| .{ .hit = value },
                        .miss => parser.reporter.fail(.syntax, parser.current().span, message),
                    };
                }
            };
        }
        pub fn sequence(comptime rules: anytype) type {
            const value_types = comptime blk: {
                var types: [rules.len]type = undefined;

                for (rules, 0..) |Rule, index| types[index] = Rule.Value;

                break :blk types;
            };

            return struct {
                pub const Value = std.meta.Tuple(&value_types);

                pub fn parse(parser: *Parser) Error!Match(Value) {
                    const start = parser.index;
                    var values: Value = undefined;

                    inline for (rules, 0..) |Rule, index| {
                        switch (try Rule.parse(parser)) {
                            .hit => |value| values[index] = value,
                            .miss => {
                                parser.index = start;

                                return .miss;
                            },
                        }
                    }

                    return .{ .hit = values };
                }
            };
        }
        pub fn choice(comptime rules: anytype) type {
            if (rules.len == 0) @compileError("choice requires at least one alternative");

            return struct {
                pub const Value = rules[0].Value;

                pub fn parse(parser: *Parser) Error!Match(Value) {
                    const start = parser.index;

                    inline for (rules) |Rule| {
                        if (Rule.Value != Value) @compileError("choice alternatives must return the same type");

                        switch (try Rule.parse(parser)) {
                            .hit => |value| return .{ .hit = value },
                            .miss => parser.index = start,
                        }
                    }

                    return .miss;
                }
            };
        }

        pub fn optional(comptime Rule: type) type {
            return struct {
                pub const Value = ?Rule.Value;

                pub fn parse(parser: *Parser) Error!Match(Value) {
                    const start = parser.index;

                    return switch (try Rule.parse(parser)) {
                        .hit => |value| .{ .hit = value },
                        .miss => blk: {
                            parser.index = start;

                            break :blk .{ .hit = null };
                        },
                    };
                }
            };
        }

        pub fn many(comptime Rule: type) type {
            return struct {
                pub const Value = []const Rule.Value;

                pub fn parse(parser: *Parser) Error!Match(Value) {
                    var values: std.ArrayList(Rule.Value) = .empty;

                    defer values.deinit(parser.allocator);

                    while (true) {
                        const start = parser.index;

                        switch (try Rule.parse(parser)) {
                            .hit => |value| {
                                if (parser.index == start) return parser.reporter.fail(.contract, parser.current().span, "a repeated grammar rule must consume a token");
                                try values.append(parser.allocator, value);
                            },
                            .miss => {
                                parser.index = start;

                                break;
                            },
                        }
                    }

                    return .{ .hit = try values.toOwnedSlice(parser.allocator) };
                }
            };
        }

        pub fn map(comptime Rule: type, comptime T: type, comptime callback: fn (*Parser, Rule.Value) Error!T) type {
            return struct {
                pub const Value = T;

                pub fn parse(parser: *Parser) Error!Match(Value) {
                    return switch (try Rule.parse(parser)) {
                        .miss => .miss,
                        .hit => |value| .{ .hit = try callback(parser, value) },
                    };
                }
            };
        }

        pub fn run(comptime Rule: type, parser: *Parser, message: []const u8) Error!Rule.Value {
            return switch (try Rule.parse(parser)) {
                .hit => |value| value,
                .miss => parser.reporter.fail(.syntax, parser.current().span, message),
            };
        }
    };
}
