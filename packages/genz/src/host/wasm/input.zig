const std = @import("std");
const node = @import("../../node.zig");
const Builder = @import("../../builder.zig");
const common = @import("common.zig");

pub fn lower(builder: Builder) std.mem.Allocator.Error!node.Declaration {
    const length = try builder.identifier("length");
    const u32_type = try builder.expression(.{ .primitive = .u32 });
    const u64_type = try builder.expression(.{ .primitive = .u64 });
    const one = try builder.integer(1);
    const page_size = try builder.path(&.{ "std", "heap", "page_size_max" });
    const metadata = try builder.builtin(.typeInfo, &.{try builder.builtin(.FieldType, &.{ try builder.path(&.{ "std", "heap", "BrkAllocator" }), try builder.string("big_frees") })});
    const classes = try builder.field(try builder.field(metadata, "array"), "len");
    const largest = try builder.binary(.multiply, try builder.binary(.shift_left, try builder.builtin(.as, &.{ u64_type, one }), try builder.binary(.subtract, try builder.identifier("classes"), one)), page_size);
    const overhead = try builder.binary(.subtract, try builder.binary(.add, page_size, try builder.binary(.multiply, try builder.integer(2), try builder.builtin(.sizeOf, &.{try builder.expression(.{ .primitive = .usize })}))), one);
    const allocate = try builder.call(try builder.path(&.{ "std", "heap", "wasm_allocator", "alloc" }), &.{ try builder.expression(.{ .primitive = .u8 }), try builder.builtin(.max, &.{ length, one }) });

    return .{ .function = .{
        .name = "zxc_alloc",
        .parameters = try builder.allocator.dupe(node.Field, &.{.{ .name = "length", .value = u32_type }}),
        .return_type = u32_type,
        .abi_export = true,
        .body = try builder.statements(&.{
            try builder.branch(try builder.identifier("executing"), &.{.{ .result = try builder.integer(0) }}, &.{}),
            .{ .expression = try common.invoke(builder, "zxc_reset") },
            .{ .constant = .{ .name = "classes", .value = classes } },
            .{ .constant = .{ .name = "largest_block", .value = largest } },
            .{ .constant = .{ .name = "overhead", .value = overhead } },
            try builder.branch(try builder.binary(.greater, try builder.binary(.add, try builder.builtin(.as, &.{ u64_type, length }), try builder.identifier("overhead")), try builder.identifier("largest_block")), &.{
                try common.assign(builder, "result", try builder.string("OutOfMemory")),
                .{ .result = try builder.integer(0) },
            }, &.{}),
            .{ .expression = try common.failure(builder, try common.invoke(builder, "prepare"), 0) },
            try common.assign(builder, "input_storage", try common.failure(builder, allocate, 0)),
            try common.assign(builder, "input", try builder.expression(.{ .slice = .{ .target = try builder.identifier("input_storage"), .start = try builder.integer(0), .end = length } })),
            try common.assign(builder, "ready", try builder.expression(.{ .boolean = true })),
            .{ .result = try builder.builtin(.intFromPtr, &.{try builder.path(&.{ "input", "ptr" })}) },
        }),
    } };
}
