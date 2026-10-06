const zx = @import("zx");
const declarations = @import("../declarations.zig");

pub const Native = struct {
    value: declarations.Program,
    pub fn typeView(self: @This()) @import("type_views").Native {
        return .{ .items = self.value.types };
    }
    pub fn functionCount(self: @This()) usize {
        return self.value.functions.len;
    }

    pub fn functionAt(self: @This(), index: usize) declarations.Function {
        return self.value.functions[index];
    }
};

pub fn Indexed(comptime Storage: type) type {
    return struct {
        const Self = @This();
        pub const Types = @import("type_views").Indexed(Storage);

        source: []const u8,
        storage: Storage,
        types: Types,
        pub fn typeView(self: Self) Types {
            return self.types;
        }
        pub fn functionCount(self: Self) usize {
            return self.storage.functions.len;
        }
        pub fn name(self: Self, position: anytype) zx.ast.Name {
            const span = zx.syntax.header.span(position);

            return .{ .text = self.source[span.start..span.end], .span = span };
        }
        pub const Function = struct {
            name: zx.ast.Name,
            parameters: Parameters,
            output: Types.Ref,
            allocator_argument: bool,
            io_argument: bool,
            process_argument: bool,
            fallible: bool,
            errors: ?Errors,
            concurrent: bool,
        };
        pub fn functionAt(self: Self, index: usize) Function {
            const item = self.storage.functions[index];

            return .{
                .name = self.name(item.name),
                .parameters = .{ .view = self, .first = @intCast(item.first_parameter), .len = @intCast(item.count) },
                .output = .{ .node = @intCast(item.output) },
                .allocator_argument = item.allocator_argument,
                .io_argument = item.io_argument,
                .process_argument = item.process_argument,
                .fallible = item.fallible,
                .errors = if (item.errors_present) .{ .view = self, .first = @intCast(item.first_error), .len = @intCast(item.error_count) } else null,
                .concurrent = item.concurrent,
            };
        }

        const Parameters = struct {
            view: Self,
            first: usize,
            len: usize,
            pub const Item = Types.Ref;

            pub fn at(self: @This(), index: usize) Item {
                return .{ .node = @intCast(self.view.storage.parameters[self.first + index].value) };
            }
        };
        const Errors = struct {
            view: Self,
            first: usize,
            len: usize,
            pub const Item = []const u8;

            pub fn at(self: @This(), index: usize) Item {
                return self.view.name(self.view.storage.errors[self.first + index]).text;
            }
        };
    };
}
