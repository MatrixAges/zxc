const std = @import("std");
const Types = @import("../link/types.zig");
const ir = @import("zx").ir;
const model = @import("../compiled.zig");
pub const Error = std.mem.Allocator.Error || error{InvalidLibrary};

pub fn validate(allocator: std.mem.Allocator, library: model.Graph) Error!void {
    const program = library.program;

    if (!program.type_only or program.exports.len != 0 or program.stores.len != 0 or library.exports.len == 0) return error.InvalidLibrary;
    if (try @import("../../ir/validate.zig").validate(allocator, program) != null) return error.InvalidLibrary;

    var temporary = std.heap.ArenaAllocator.init(allocator);

    defer temporary.deinit();

    const scratch = temporary.allocator();

    var types = Types.init(scratch) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return error.InvalidLibrary;
    };

    types.origins.seed(program.types, library.nominal_types) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return error.InvalidLibrary;
    };

    const declared = try scratch.alloc(bool, program.types.len);

    @memset(declared, false);

    for (library.nominal_types) |item| declared[@intFromEnum(item.type_id)] = true;

    for (program.types, declared) |value, present| {
        if (value == .enumeration and !present) return error.InvalidLibrary;
    }

    var names: std.StringHashMapUnmanaged(void) = .empty;

    for (library.exports) |exported| {
        if (!text(exported.name) or !text(exported.path)) return error.InvalidLibrary;
        if ((try names.getOrPut(scratch, exported.name)).found_existing) return error.InvalidLibrary;

        if (exported.function) |id| {
            if (@intFromEnum(id) >= program.functions.len) return error.InvalidLibrary;

            const function = program.functions[@intFromEnum(id)];

            if (function.external != null or !std.mem.eql(u8, function.file_name, exported.path)) return error.InvalidLibrary;
        }

        var type_names: std.StringHashMapUnmanaged(void) = .empty;

        for (exported.types) |item| {
            if (!text(item.name) or @intFromEnum(item.type_id) >= program.types.len) return error.InvalidLibrary;

            if (exported.function) |id| {
                const function = program.functions[@intFromEnum(id)];

                if (std.mem.eql(u8, item.name, "Input") and item.type_id != function.input_type) return error.InvalidLibrary;
                if (std.mem.eql(u8, item.name, "Output") and item.type_id != function.output_type) return error.InvalidLibrary;
            }

            if ((try type_names.getOrPut(scratch, item.name)).found_existing) return error.InvalidLibrary;
        }
    }

    var stores: std.StringHashMapUnmanaged(ir.TypeId) = .empty;

    for (program.functions) |function| for (function.stores) |slot| {
        const entry = try stores.getOrPut(scratch, slot.path);

        if (entry.found_existing and entry.value_ptr.* != slot.type_id) return error.InvalidLibrary;

        entry.value_ptr.* = slot.type_id;
    };
}

fn text(value: []const u8) bool {
    return value.len != 0 and std.mem.indexOfScalar(u8, value, 0) == null and std.unicode.utf8ValidateSlice(value);
}
