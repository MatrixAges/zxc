test {
    _ = @import("modules/negative_test.zig");
    _ = @import("ownership/operations_test.zig");
    _ = @import("language/operators/u8_test.zig");
    _ = @import("language/operators/u16_test.zig");
    _ = @import("language/operators/u32_test.zig");
    _ = @import("language/operators/u64_test.zig");
    _ = @import("language/operators/i32_test.zig");
    _ = @import("language/operators/i64_test.zig");
    _ = @import("language/operators/f32_test.zig");
    _ = @import("language/operators/f64_test.zig");
    _ = @import("language/operators/invalid_test.zig");
    _ = @import("language/lexical_test.zig");
    _ = @import("language/declarations_test.zig");
    _ = @import("language/negative_parse_test.zig");
    _ = @import("language/negative_semantics_test.zig");
    _ = @import("language/positive_semantics_test.zig");
    _ = @import("language/types_test.zig");
    _ = @import("language/store_test.zig");
    _ = @import("modules/project_test.zig");
    _ = @import("ownership/consumption_test.zig");
    _ = @import("ir/validate_test.zig");
    _ = @import("frontend/combinators_test.zig");
    _ = @import("frontend/lifetime/program_test.zig");
    _ = @import("frontend/lifetime/expression_test.zig");
    _ = @import("language/parser_test.zig");
    _ = @import("language/callback_scope_test.zig");
}
