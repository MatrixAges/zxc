const std = @import("std");
const zx = @import("zx");
const State = @import("../state.zig");
const history = @import("../../history.zig");
const columns = @import("../../history/columns.zig");

pub fn matches(state: *const State, previous: *const history.Retained, start: history.Checkpoint, earlier: history.Checkpoint, current: history.Checkpoint) bool {
    const left = .{ previous.types, previous.origins };
    const right = .{ state.types.items.view(), state.types.origins.items.view() };

    if (!@import("rx_options").generated_graph) {
        return earlier.functions == current.functions and earlier.native_modules == current.native_modules and
            earlier.initializers == current.initializers and earlier.libraries == current.libraries and

            columns.equal(left[0], start.types, earlier.types, right[0], start.types, current.types) and
            columns.equal(left[1], start.origins, earlier.origins, right[1], start.origins, current.origins);
    }

    const rule = @import("generated_rx_mixed_history_alignment");
    const Input = std.meta.Child(rule.Input);
    const Pair = std.meta.Child(@FieldType(Input, "columns"));
    const View = std.meta.Child(@FieldType(Pair, "left"));
    const Extent = std.meta.Child(@FieldType(Input, "extent_left"));
    const starts = .{ start.types, start.origins };
    const a = borrow(left, starts, .{ earlier.types, earlier.origins });
    const b = borrow(right, starts, .{ current.types, current.origins });
    const a_view = a.view(View);
    const b_view = b.view(View);

    const input: Input = .{
        .extent_left = &extent(Extent, earlier),
        .extent_right = &extent(Extent, current),
        .columns = &.{ .left = &a_view, .right = &b_view, .masks = &.{} },
    };

    var empty = std.heap.FixedBufferAllocator.init(&.{});

    return zx.columns.invoke(rule.executeValue, empty.allocator(), &input) catch unreachable;
}

fn extent(comptime Target: type, value: history.Checkpoint) Target {
    return .{
        .functions = value.functions,
        .native_modules = value.native_modules,
        .initializers = value.initializers,
        .libraries = value.libraries,
    };
}

const ViewColumns = struct {
    words: [7][]const u8,
    text: [6][]const []const u8,
    fn view(self: *const ViewColumns, comptime Target: type) Target {
        return .{ .words = &self.words, .tags = &.{}, .options = &.{}, .text = &self.text };
    }
};

fn borrow(tables: anytype, start: anytype, end: @TypeOf(start)) ViewColumns {
    var result: ViewColumns = undefined;
    comptime var word = 0;
    comptime var text = 0;

    inline for (tables, 0..) |table, table_index| {
        inline for (@typeInfo(@TypeOf(table)).@"struct".field_names, 0..) |field, index| {
            const values = @field(table, field)[start[table_index][index]..end[table_index][index]];

            switch (std.meta.Elem(@TypeOf(values))) {
                u8, u32 => {
                    result.words[word] = std.mem.sliceAsBytes(values);
                    word += 1;
                },
                []const u8 => {
                    result.text[text] = values;
                    text += 1;
                },
                else => @compileError("unsupported history column"),
            }
        }
    }

    comptime {
        if (word != @typeInfo(@FieldType(ViewColumns, "words")).array.len or text != @typeInfo(@FieldType(ViewColumns, "text")).array.len) {
            @compileError("history comparison does not cover all columns");
        }
    }

    return result;
}
