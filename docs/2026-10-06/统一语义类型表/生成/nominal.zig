const std = @import("std");
const zx_native_0 = @import("integers");
const zx_abi = @import("zxc_abi");
pub const requires_io = false;
pub const requires_process = false;
const zx_shape_0 = .{ .kind = .scalar, };
const zx_shape_1 = .{ .kind = .scalar, };
const zx_shape_2 = .{ .kind = .scalar, };
const zx_shape_3 = .{ .kind = .scalar, };
const zx_shape_4 = .{ .kind = .scalar, };
const zx_shape_5 = .{ .kind = .scalar, };
const zx_shape_6 = .{ .kind = .scalar, };
const zx_shape_7 = .{ .kind = .scalar, };
const zx_shape_8 = .{ .kind = .scalar, };
const zx_shape_9 = .{ .kind = .scalar, };
const zx_shape_10 = .{ .kind = .string, };
const zx_shape_11 = .{ .kind = .scalar, };
const zx_shape_12 = .{ .kind = .list, .child = zx_shape_5, };
const zx_shape_13 = .{ .kind = .list, .child = zx_shape_11, };
const zx_shape_14 = .{ .kind = .object, .fields = .{ .issues = zx_shape_13, .offsets = zx_shape_12, .targets = zx_shape_12, }, };
const zx_shape_15 = .{ .kind = .object, .fields = .{ .count = zx_shape_5, .cursors = zx_shape_12, .depth = zx_shape_5, .edge = zx_shape_5, .frames = zx_shape_12, .graph = zx_shape_14, .issue = zx_shape_11, .marks = zx_shape_12, .order = zx_shape_12, .root = zx_shape_5, }, };
const zx_shape_16 = .{ .kind = .optional, .child = zx_shape_5, };
const zx_shape_17 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_12, .@"1" = zx_shape_16, }, };
const zx_shape_18 = .{ .kind = .object, .fields = .{ .count = zx_shape_5, .edge = zx_shape_5, .issue = zx_shape_11, .order = zx_shape_12, }, };
const zx_shape_19 = .{ .kind = .list, .child = zx_shape_2, };
const zx_shape_20 = .{ .kind = .object, .fields = .{ .offset = zx_shape_5, .source = zx_shape_19, .text = zx_shape_19, }, };
const zx_shape_21 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .matches = zx_shape_1, .offset = zx_shape_5, .source = zx_shape_19, .text = zx_shape_19, }, };
const zx_shape_22 = .{ .kind = .object, .fields = .{ .pattern = zx_shape_19, .source = zx_shape_19, }, };
const zx_shape_23 = .{ .kind = .object, .fields = .{ .pattern = zx_shape_19, .source = zx_shape_19, .start = zx_shape_5, }, };
const zx_shape_24 = .{ .kind = .scalar, };
const zx_shape_25 = .{ .kind = .object, .fields = .{ .source = zx_shape_19, .start = zx_shape_5, }, };
const zx_shape_26 = .{ .kind = .object, .fields = .{ .offset = zx_shape_5, .source = zx_shape_19, .start = zx_shape_5, .valid = zx_shape_1, }, };
const zx_shape_27 = .{ .kind = .object, .fields = .{ .kind = zx_shape_24, .path = zx_shape_19, .suffix = zx_shape_19, }, };
const zx_shape_28 = .{ .kind = .object, .fields = .{ .end = zx_shape_5, .parent = zx_shape_1, .start = zx_shape_5, }, };
const zx_shape_29 = .{ .kind = .list, .child = zx_shape_28, };
const zx_shape_30 = .{ .kind = .object, .fields = .{ .dots = zx_shape_1, .offset = zx_shape_5, .segments = zx_shape_29, .start = zx_shape_5, }, };
const zx_shape_31 = .{ .kind = .object, .fields = .{ .parents = zx_shape_5, .segments = zx_shape_29, }, };
const zx_shape_32 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_29, .@"1" = zx_shape_0, }, };
const zx_shape_33 = .{ .kind = .object, .fields = .{ .byte = zx_shape_2, .state = zx_shape_30, }, };
const zx_shape_34 = .{ .kind = .object, .fields = .{ .end = zx_shape_5, .parent = zx_shape_1, .start = zx_shape_5, .state = zx_shape_31, }, };
const zx_shape_35 = .{ .kind = .object, .fields = .{ .segments = zx_shape_29, .valid = zx_shape_1, }, };
const zx_shape_36 = .{ .kind = .scalar, };
const zx_shape_37 = .{ .kind = .object, .fields = .{ .attribute = zx_shape_10, .element = zx_shape_10, }, };
const zx_shape_38 = .{ .kind = .scalar, };
const zx_shape_39 = .{ .kind = .object, .fields = .{ .has_function = zx_shape_1, .has_input = zx_shape_1, .has_module = zx_shape_1, .has_setter = zx_shape_1, }, };
const zx_shape_40 = .{ .kind = .object, .fields = .{ .offset = zx_shape_5, .source = zx_shape_19, }, };
const zx_shape_41 = .{ .kind = .scalar, };
const zx_shape_42 = .{ .kind = .object, .fields = .{ .expressions = zx_shape_1, .source = zx_shape_19, }, };
const zx_shape_43 = .{ .kind = .object, .fields = .{ .high = zx_shape_2, .low = zx_shape_2, .remaining = zx_shape_2, .valid = zx_shape_1, }, };
const zx_shape_44 = .{ .kind = .object, .fields = .{ .byte = zx_shape_2, .state = zx_shape_43, }, };
const zx_shape_45 = .{ .kind = .object, .fields = .{ .first = zx_shape_2, .second = zx_shape_2, .valid = zx_shape_1, }, };
const zx_shape_46 = .{ .kind = .object, .fields = .{ .end = zx_shape_5, .start = zx_shape_5, }, };
const zx_shape_47 = .{ .kind = .object, .fields = .{ .column = zx_shape_5, .line = zx_shape_5, .offset = zx_shape_5, }, };
const zx_shape_48 = .{ .kind = .object, .fields = .{ .character = zx_shape_1, .codepoint = zx_shape_5, .previous = zx_shape_5, .span = zx_shape_46, }, };
const zx_shape_49 = .{ .kind = .object, .fields = .{ .count = zx_shape_5, .head = zx_shape_5, .span = zx_shape_46, }, };
const zx_shape_50 = .{ .kind = .scalar, };
const zx_shape_51 = .{ .kind = .scalar, };
const zx_shape_52 = .{ .kind = .object, .fields = .{ .expression = zx_shape_1, .location = zx_shape_47, .name = zx_shape_46, .previous = zx_shape_5, .value = zx_shape_49, .value_location = zx_shape_47, }, };
const zx_shape_53 = .{ .kind = .object, .fields = .{ .location = zx_shape_47, .previous = zx_shape_5, .value = zx_shape_49, }, };
const zx_shape_54 = .{ .kind = .object, .fields = .{ .previous = zx_shape_5, .value = zx_shape_5, }, };
const zx_shape_55 = .{ .kind = .object, .fields = .{ .attribute_count = zx_shape_5, .attributes = zx_shape_5, .child_count = zx_shape_5, .children = zx_shape_5, .location = zx_shape_47, .name = zx_shape_46, .text = zx_shape_5, .text_count = zx_shape_5, }, };
const zx_shape_56 = .{ .kind = .list, .child = zx_shape_55, };
const zx_shape_57 = .{ .kind = .list, .child = zx_shape_52, };
const zx_shape_58 = .{ .kind = .list, .child = zx_shape_53, };
const zx_shape_59 = .{ .kind = .list, .child = zx_shape_54, };
const zx_shape_60 = .{ .kind = .list, .child = zx_shape_48, };
const zx_shape_61 = .{ .kind = .object, .fields = .{ .attributes = zx_shape_57, .children = zx_shape_59, .nodes = zx_shape_56, .parts = zx_shape_60, .text = zx_shape_58, }, };
const zx_shape_62 = .{ .kind = .object, .fields = .{ .attribute = zx_shape_46, .attribute_location = zx_shape_47, .expressions = zx_shape_1, .issue = zx_shape_47, .location = zx_shape_47, .message = zx_shape_10, .phase = zx_shape_50, .result = zx_shape_5, .terminator = zx_shape_2, .text_start = zx_shape_5, .value_count = zx_shape_5, .value_head = zx_shape_5, .value_kind = zx_shape_51, .value_location = zx_shape_47, .value_start = zx_shape_5, }, };
const zx_shape_63 = .{ .kind = .object, .fields = .{ .control = zx_shape_62, .frame = zx_shape_55, .frames = zx_shape_56, .source = zx_shape_19, .tree = zx_shape_61, }, };
const zx_shape_64 = .{ .kind = .object, .fields = .{ .expressions = zx_shape_1, .message = zx_shape_10, .source = zx_shape_19, }, };
const zx_shape_65 = .{ .kind = .object, .fields = .{ .done = zx_shape_1, .offset = zx_shape_5, .source = zx_shape_19, }, };
const zx_shape_66 = .{ .kind = .object, .fields = .{ .count = zx_shape_5, .location = zx_shape_47, .source = zx_shape_19, }, };
const zx_shape_67 = .{ .kind = .object, .fields = .{ .column = zx_shape_5, .end = zx_shape_5, .line = zx_shape_5, .offset = zx_shape_5, .previous_cr = zx_shape_1, .source = zx_shape_19, }, };
const zx_shape_68 = .{ .kind = .object, .fields = .{ .count = zx_shape_5, .state = zx_shape_63, }, };
const zx_shape_69 = .{ .kind = .object, .fields = .{ .end = zx_shape_5, .message = zx_shape_10, }, };
const zx_shape_70 = .{ .kind = .object, .fields = .{ .left = zx_shape_46, .right = zx_shape_46, .source = zx_shape_19, }, };
const zx_shape_71 = .{ .kind = .object, .fields = .{ .end = zx_shape_5, .left = zx_shape_5, .matches = zx_shape_1, .right = zx_shape_5, .source = zx_shape_19, }, };
const zx_shape_72 = .{ .kind = .object, .fields = .{ .attributes = zx_shape_57, .head = zx_shape_5, .name = zx_shape_46, .source = zx_shape_19, }, };
const zx_shape_73 = .{ .kind = .object, .fields = .{ .attributes = zx_shape_57, .found = zx_shape_1, .head = zx_shape_5, .name = zx_shape_46, .source = zx_shape_19, }, };
const zx_shape_74 = .{ .kind = .scalar, };
const zx_shape_75 = .{ .kind = .object, .fields = .{ .braces = zx_shape_5, .depth = zx_shape_5, .mode = zx_shape_74, .start = zx_shape_5, }, };
const zx_shape_76 = .{ .kind = .list, .child = zx_shape_75, };
const zx_shape_77 = .{ .kind = .object, .fields = .{ .comment_start = zx_shape_5, .done = zx_shape_1, .frame = zx_shape_75, .frames = zx_shape_76, .issue = zx_shape_5, .message = zx_shape_10, .offset = zx_shape_5, .source = zx_shape_19, }, };
const zx_shape_78 = .{ .kind = .object, .fields = .{ .message = zx_shape_10, .offset = zx_shape_5, .state = zx_shape_77, }, };
const zx_shape_79 = .{ .kind = .optional, .child = zx_shape_75, };
const zx_shape_80 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_76, .@"1" = zx_shape_79, }, };
const zx_shape_81 = .{ .kind = .object, .fields = .{ .depth = zx_shape_5, .mode = zx_shape_74, .offset = zx_shape_5, .start = zx_shape_5, .state = zx_shape_77, }, };
const zx_shape_82 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_76, .@"1" = zx_shape_0, }, };
const zx_shape_83 = .{ .kind = .object, .fields = .{ .end = zx_shape_5, .message = zx_shape_10, .offset = zx_shape_5, .source = zx_shape_19, }, };
const zx_shape_84 = .{ .kind = .object, .fields = .{ .message = zx_shape_10, .state = zx_shape_63, }, };
const zx_shape_85 = .{ .kind = .object, .fields = .{ .expression = zx_shape_1, .state = zx_shape_63, .value = zx_shape_49, }, };
const zx_shape_86 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_57, .@"1" = zx_shape_0, }, };
const zx_shape_87 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_58, .@"1" = zx_shape_0, }, };
const zx_shape_88 = .{ .kind = .object, .fields = .{ .kind = zx_shape_51, .state = zx_shape_63, .terminator = zx_shape_2, }, };
const zx_shape_89 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_56, .@"1" = zx_shape_0, }, };
const zx_shape_90 = .{ .kind = .optional, .child = zx_shape_55, };
const zx_shape_91 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_56, .@"1" = zx_shape_90, }, };
const zx_shape_92 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_59, .@"1" = zx_shape_0, }, };
const zx_shape_93 = .{ .kind = .object, .fields = .{ .phase = zx_shape_50, .state = zx_shape_63, }, };
const zx_shape_94 = .{ .kind = .scalar, };
const zx_shape_95 = .{ .kind = .object, .fields = .{ .done = zx_shape_1, .issue = zx_shape_94, .offset = zx_shape_5, .source = zx_shape_19, }, };
const zx_shape_96 = .{ .kind = .scalar, };
const zx_shape_97 = .{ .kind = .object, .fields = .{ .count = zx_shape_5, .done = zx_shape_1, .encoding = zx_shape_1, .issue = zx_shape_96, .offset = zx_shape_5, .source = zx_shape_19, .standalone = zx_shape_1, }, };
const zx_shape_98 = .{ .kind = .object, .fields = .{ .ignore_case = zx_shape_1, .source = zx_shape_19, .span = zx_shape_46, .text = zx_shape_19, }, };
const zx_shape_99 = .{ .kind = .object, .fields = .{ .ignore_case = zx_shape_1, .index = zx_shape_5, .matches = zx_shape_1, .offset = zx_shape_5, .source = zx_shape_19, .text = zx_shape_19, }, };
const zx_shape_100 = .{ .kind = .object, .fields = .{ .byte = zx_shape_2, .offset = zx_shape_5, .source = zx_shape_19, }, };
const zx_shape_101 = .{ .kind = .object, .fields = .{ .end = zx_shape_5, .hexadecimal = zx_shape_1, .source = zx_shape_19, .start = zx_shape_5, }, };
const zx_shape_102 = .{ .kind = .object, .fields = .{ .codepoint = zx_shape_5, .message = zx_shape_10, }, };
const zx_shape_103 = .{ .kind = .object, .fields = .{ .end = zx_shape_5, .offset = zx_shape_5, .overflow = zx_shape_1, .radix = zx_shape_5, .source = zx_shape_19, .valid = zx_shape_1, .value = zx_shape_5, }, };
const zx_shape_104 = .{ .kind = .object, .fields = .{ .end = zx_shape_5, .source = zx_shape_19, .start = zx_shape_5, }, };
const zx_shape_105 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_60, .@"1" = zx_shape_0, }, };
const zx_shape_106 = .{ .kind = .object, .fields = .{ .codepoint = zx_shape_5, .count = zx_shape_5, .state = zx_shape_63, }, };
const zx_shape_107 = .{ .kind = .object, .fields = .{ .negative = zx_shape_1, .offset = zx_shape_5, .seen = zx_shape_1, .source = zx_shape_19, .started = zx_shape_1, .valid = zx_shape_1, .value = zx_shape_5, }, };
const zx_shape_108 = .{ .kind = .scalar, };
const zx_shape_109 = .{ .kind = .list, .child = zx_shape_4, };
const zx_shape_110 = .{ .kind = .list, .child = zx_shape_10, };
const zx_shape_111 = .{ .kind = .object, .fields = .{ .children = zx_shape_109, .field_names = zx_shape_110, .field_types = zx_shape_109, .first = zx_shape_109, .kinds = zx_shape_19, .labels = zx_shape_110, .names = zx_shape_110, .second = zx_shape_109, }, };
const zx_shape_112 = .{ .kind = .object, .fields = .{ .base = zx_shape_111, .delta = zx_shape_111, }, };
const zx_shape_113 = .{ .kind = .object, .fields = .{ .delta = zx_shape_1, .first = zx_shape_4, .kind = zx_shape_108, .label = zx_shape_10, .second = zx_shape_4, }, };
const zx_shape_114 = .{ .kind = .object, .fields = .{ .names = zx_shape_110, .types = zx_shape_109, }, };
const zx_shape_115 = .{ .kind = .object, .fields = .{ .children = zx_shape_109, .fields = zx_shape_114, .first = zx_shape_4, .kind = zx_shape_108, .label = zx_shape_10, .names = zx_shape_110, .second = zx_shape_4, }, };
const zx_shape_116 = .{ .kind = .object, .fields = .{ .found = zx_shape_1, .id = zx_shape_4, }, };
const zx_shape_117 = .{ .kind = .object, .fields = .{ .delta = zx_shape_111, .id = zx_shape_4, }, };
const zx_shape_118 = .{ .kind = .object, .fields = .{ .id = zx_shape_4, .tables = zx_shape_112, }, };
const zx_shape_119 = .{ .kind = .object, .fields = .{ .candidate = zx_shape_115, .id = zx_shape_4, .tables = zx_shape_112, }, };
const zx_shape_120 = .{ .kind = .object, .fields = .{ .candidate = zx_shape_115, .count = zx_shape_5, .equal = zx_shape_1, .first = zx_shape_5, .index = zx_shape_5, .table = zx_shape_111, }, };
const zx_shape_121 = .{ .kind = .object, .fields = .{ .candidate = zx_shape_115, .tables = zx_shape_112, }, };
const zx_shape_122 = .{ .kind = .object, .fields = .{ .candidate = zx_shape_115, .count = zx_shape_5, .found = zx_shape_1, .id = zx_shape_4, .index = zx_shape_5, .tables = zx_shape_112, }, };
const zx_shape_123 = .{ .kind = .object, .fields = .{ .kind = zx_shape_2, .member = zx_shape_10, .owner = zx_shape_10, }, };
const zx_shape_124 = .{ .kind = .object, .fields = .{ .ids = zx_shape_109, .kinds = zx_shape_19, .members = zx_shape_110, .owners = zx_shape_110, }, };
const zx_shape_125 = .{ .kind = .object, .fields = .{ .base = zx_shape_124, .delta = zx_shape_124, }, };
const zx_shape_126 = .{ .kind = .scalar, };
const zx_shape_127 = .{ .kind = .object, .fields = .{ .id = zx_shape_4, .status = zx_shape_126, }, };
const zx_shape_128 = .{ .kind = .object, .fields = .{ .candidate = zx_shape_115, .origin = zx_shape_123, .origins = zx_shape_125, .tables = zx_shape_112, }, };
const zx_shape_129 = .{ .kind = .object, .fields = .{ .candidate = zx_shape_115, .count = zx_shape_5, .id = zx_shape_4, .index = zx_shape_5, .origin = zx_shape_123, .origins = zx_shape_125, .status = zx_shape_126, .tables = zx_shape_112, }, };
const zx_shape_130 = .{ .kind = .scalar, };
const zx_shape_131 = .{ .kind = .scalar, };
const zx_shape_132 = .{ .kind = .scalar, };
const zx_shape_133 = .{ .kind = .object, .fields = .{ .dollar = zx_shape_1, .kind = zx_shape_131, .line_break = zx_shape_1, .span = zx_shape_46, .symbol = zx_shape_132, .word = zx_shape_130, }, };
const zx_shape_134 = .{ .kind = .scalar, };
const zx_shape_135 = .{ .kind = .object, .fields = .{ .end = zx_shape_5, .last_byte = zx_shape_2, .phase = zx_shape_134, .separators_valid = zx_shape_1, }, };
const zx_shape_136 = .{ .kind = .object, .fields = .{ .diagnostic = zx_shape_10, .end = zx_shape_5, }, };
const zx_shape_137 = .{ .kind = .scalar, };
const zx_shape_138 = .{ .kind = .object, .fields = .{ .code = zx_shape_10, .end = zx_shape_5, .message = zx_shape_10, .start = zx_shape_5, }, };
const zx_shape_139 = .{ .kind = .object, .fields = .{ .braces = zx_shape_5, .depth = zx_shape_5, .mode = zx_shape_137, .start = zx_shape_5, }, };
const zx_shape_140 = .{ .kind = .list, .child = zx_shape_139, };
const zx_shape_141 = .{ .kind = .list, .child = zx_shape_133, };
const zx_shape_142 = .{ .kind = .list, .child = zx_shape_46, };
const zx_shape_143 = .{ .kind = .object, .fields = .{ .ahead_one = zx_shape_2, .ahead_two = zx_shape_2, .braces = zx_shape_5, .comments = zx_shape_142, .depth = zx_shape_5, .diagnostic = zx_shape_138, .dollar = zx_shape_1, .frames = zx_shape_140, .keyword = zx_shape_130, .line_break = zx_shape_1, .mode = zx_shape_137, .number = zx_shape_135, .offset = zx_shape_5, .skip_until = zx_shape_5, .source_length = zx_shape_5, .start = zx_shape_5, .symbol = zx_shape_132, .tokens = zx_shape_141, .warmed = zx_shape_2, }, };
const zx_shape_144 = .{ .kind = .object, .fields = .{ .after = zx_shape_2, .byte = zx_shape_2, .has_after = zx_shape_1, .has_next = zx_shape_1, .next = zx_shape_2, .state = zx_shape_143, }, };
const zx_shape_145 = .{ .kind = .object, .fields = .{ .comments = zx_shape_142, .diagnostic = zx_shape_138, .tokens = zx_shape_141, }, };
const zx_shape_146 = .{ .kind = .scalar, };
const zx_shape_147 = .{ .kind = .scalar, };
const zx_shape_148 = .{ .kind = .object, .fields = .{ .interpolation = zx_shape_5, .kind = zx_shape_146, .previous = zx_shape_5, .span = zx_shape_46, }, };
const zx_shape_149 = .{ .kind = .object, .fields = .{ .kind = zx_shape_147, .offset = zx_shape_5, .reference = zx_shape_5, }, };
const zx_shape_150 = .{ .kind = .list, .child = zx_shape_49, };
const zx_shape_151 = .{ .kind = .list, .child = zx_shape_148, };
const zx_shape_152 = .{ .kind = .list, .child = zx_shape_149, };
const zx_shape_153 = .{ .kind = .object, .fields = .{ .events = zx_shape_152, .lexed = zx_shape_145, .parts = zx_shape_151, .templates = zx_shape_150, .token_templates = zx_shape_12, }, };
const zx_shape_154 = .{ .kind = .object, .fields = .{ .lexed = zx_shape_145, .span = zx_shape_46, .token_templates = zx_shape_12, }, };
const zx_shape_155 = .{ .kind = .list, .child = zx_shape_154, };
const zx_shape_156 = .{ .kind = .object, .fields = .{ .interpolations = zx_shape_155, .lexed = zx_shape_145, .parts = zx_shape_151, .templates = zx_shape_150, .token_templates = zx_shape_12, }, };
const zx_shape_157 = .{ .kind = .object, .fields = .{ .comment = zx_shape_1, .end = zx_shape_5, .kind = zx_shape_10, .start = zx_shape_5, .state = zx_shape_143, }, };
const zx_shape_158 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_142, .@"1" = zx_shape_0, }, };
const zx_shape_159 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_141, .@"1" = zx_shape_0, }, };
const zx_shape_160 = .{ .kind = .object, .fields = .{ .code = zx_shape_10, .end = zx_shape_5, .message = zx_shape_10, .start = zx_shape_5, .state = zx_shape_143, }, };
const zx_shape_161 = .{ .kind = .object, .fields = .{ .count = zx_shape_5, .ids = zx_shape_12, .template = zx_shape_5, }, };
const zx_shape_162 = .{ .kind = .object, .fields = .{ .ids = zx_shape_12, }, };
const zx_shape_163 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_12, .@"1" = zx_shape_0, }, };
const zx_shape_164 = .{ .kind = .object, .fields = .{ .count = zx_shape_5, .head = zx_shape_5, .start = zx_shape_5, .text_start = zx_shape_5, }, };
const zx_shape_165 = .{ .kind = .list, .child = zx_shape_164, };
const zx_shape_166 = .{ .kind = .object, .fields = .{ .events = zx_shape_152, .frames = zx_shape_165, .interpolations = zx_shape_5, .parts = zx_shape_151, .templates = zx_shape_150, .token_templates = zx_shape_12, }, };
const zx_shape_167 = .{ .kind = .object, .fields = .{ .graph = zx_shape_166, .lexer = zx_shape_143, }, };
const zx_shape_168 = .{ .kind = .object, .fields = .{ .after = zx_shape_2, .byte = zx_shape_2, .has_after = zx_shape_1, .has_next = zx_shape_1, .next = zx_shape_2, .state = zx_shape_167, }, };
const zx_shape_169 = .{ .kind = .object, .fields = .{ .byte = zx_shape_2, .keyword = zx_shape_130, }, };
const zx_shape_170 = .{ .kind = .object, .fields = .{ .after = zx_shape_2, .byte = zx_shape_2, .has_after = zx_shape_1, .has_next = zx_shape_1, .next = zx_shape_2, }, };
const zx_shape_171 = .{ .kind = .object, .fields = .{ .byte = zx_shape_2, .length = zx_shape_5, .next = zx_shape_2, }, };
const zx_shape_172 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_140, .@"1" = zx_shape_0, }, };
const zx_shape_173 = .{ .kind = .object, .fields = .{ .byte = zx_shape_2, .state = zx_shape_135, }, };
const zx_shape_174 = .{ .kind = .optional, .child = zx_shape_139, };
const zx_shape_175 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_140, .@"1" = zx_shape_174, }, };
const zx_shape_176 = .{ .kind = .object, .fields = .{ .graph = zx_shape_166, .interpolation = zx_shape_5, .kind = zx_shape_146, .span = zx_shape_46, .text_start = zx_shape_5, }, };
const zx_shape_177 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_151, .@"1" = zx_shape_0, }, };
const zx_shape_178 = .{ .kind = .optional, .child = zx_shape_164, };
const zx_shape_179 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_165, .@"1" = zx_shape_178, }, };
const zx_shape_180 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_165, .@"1" = zx_shape_0, }, };
const zx_shape_181 = .{ .kind = .object, .fields = .{ .graph = zx_shape_166, .offset = zx_shape_5, }, };
const zx_shape_182 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_152, .@"1" = zx_shape_0, }, };
const zx_shape_183 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_150, .@"1" = zx_shape_0, }, };
const zx_shape_184 = .{ .kind = .object, .fields = .{ .braces = zx_shape_5, .byte = zx_shape_2, .graph = zx_shape_166, .has_next = zx_shape_1, .mode = zx_shape_137, .next = zx_shape_2, .offset = zx_shape_5, }, };
const zx_shape_185 = .{ .kind = .object, .fields = .{ .byte = zx_shape_2, .state = zx_shape_167, }, };
const zx_shape_186 = .{ .kind = .object, .fields = .{ .lexer = zx_shape_143, .present = zx_shape_1, .start = zx_shape_5, .token_templates = zx_shape_12, }, };
const zx_shape_187 = .{ .kind = .object, .fields = .{ .session = zx_shape_186, .start = zx_shape_5, }, };
const zx_shape_188 = .{ .kind = .list, .child = zx_shape_187, };
const zx_shape_189 = .{ .kind = .object, .fields = .{ .active = zx_shape_186, .event_index = zx_shape_5, .events = zx_shape_152, .interpolations = zx_shape_155, .length = zx_shape_5, .offset = zx_shape_5, .parents = zx_shape_188, .skip = zx_shape_1, }, };
const zx_shape_190 = .{ .kind = .object, .fields = .{ .end = zx_shape_5, .present = zx_shape_1, .start = zx_shape_5, }, };
const zx_shape_191 = .{ .kind = .object, .fields = .{ .events = zx_shape_152, .length = zx_shape_5, }, };
const zx_shape_192 = .{ .kind = .object, .fields = .{ .end = zx_shape_5, .session = zx_shape_186, }, };
const zx_shape_193 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_155, .@"1" = zx_shape_0, }, };
const zx_shape_194 = .{ .kind = .object, .fields = .{ .end = zx_shape_5, .session = zx_shape_186, .start = zx_shape_5, .template = zx_shape_5, }, };
const zx_shape_195 = .{ .kind = .object, .fields = .{ .state = zx_shape_189, .template = zx_shape_5, }, };
const zx_shape_196 = .{ .kind = .optional, .child = zx_shape_187, };
const zx_shape_197 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_188, .@"1" = zx_shape_196, }, };
const zx_shape_198 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_188, .@"1" = zx_shape_0, }, };
const zx_shape_199 = .{ .kind = .object, .fields = .{ .byte = zx_shape_2, .state = zx_shape_143, }, };
const zx_shape_200 = .{ .kind = .object, .fields = .{ .byte = zx_shape_2, .state = zx_shape_189, }, };
const zx_shape_201 = .{ .kind = .scalar, };
const zx_shape_202 = .{ .kind = .scalar, };
const zx_shape_203 = .{ .kind = .object, .fields = .{ .child = zx_shape_5, .count = zx_shape_5, .head = zx_shape_5, .kind = zx_shape_201, .name = zx_shape_46, }, };
const zx_shape_204 = .{ .kind = .object, .fields = .{ .name = zx_shape_46, .previous = zx_shape_5, .value = zx_shape_5, }, };
const zx_shape_205 = .{ .kind = .list, .child = zx_shape_203, };
const zx_shape_206 = .{ .kind = .list, .child = zx_shape_204, };
const zx_shape_207 = .{ .kind = .object, .fields = .{ .fields = zx_shape_206, .items = zx_shape_59, .nodes = zx_shape_205, }, };
const zx_shape_208 = .{ .kind = .object, .fields = .{ .count = zx_shape_5, .field = zx_shape_46, .head = zx_shape_5, .kind = zx_shape_201, .name = zx_shape_46, .optional = zx_shape_1, }, };
const zx_shape_209 = .{ .kind = .object, .fields = .{ .depth = zx_shape_5, .diagnostic = zx_shape_138, .index = zx_shape_5, .name = zx_shape_46, .phase = zx_shape_202, .result = zx_shape_5, .start = zx_shape_5, .token = zx_shape_133, }, };
const zx_shape_210 = .{ .kind = .list, .child = zx_shape_208, };
const zx_shape_211 = .{ .kind = .object, .fields = .{ .control = zx_shape_209, .frames = zx_shape_210, .tree = zx_shape_207, }, };
const zx_shape_212 = .{ .kind = .object, .fields = .{ .depth = zx_shape_5, .start = zx_shape_5, }, };
const zx_shape_213 = .{ .kind = .scalar, };
const zx_shape_214 = .{ .kind = .scalar, };
const zx_shape_215 = .{ .kind = .object, .fields = .{ .family = zx_shape_214, .operator = zx_shape_213, .precedence = zx_shape_2, }, };
const zx_shape_216 = .{ .kind = .object, .fields = .{ .binary = zx_shape_215, .generic = zx_shape_1, .lambda = zx_shape_1, }, };
const zx_shape_217 = .{ .kind = .list, .child = zx_shape_216, };
const zx_shape_218 = .{ .kind = .object, .fields = .{ .after_identifier = zx_shape_1, .arrow = zx_shape_1, .hints = zx_shape_217, .parameter_start = zx_shape_1, }, };
const zx_shape_219 = .{ .kind = .list, .child = zx_shape_217, };
const zx_shape_220 = .{ .kind = .object, .fields = .{ .hints = zx_shape_217, .interpolation_hints = zx_shape_219, .lexical = zx_shape_156, }, };
const zx_shape_221 = .{ .kind = .scalar, };
const zx_shape_222 = .{ .kind = .scalar, };
const zx_shape_223 = .{ .kind = .scalar, };
const zx_shape_224 = .{ .kind = .object, .fields = .{ .count = zx_shape_5, .depth = zx_shape_5, .first = zx_shape_5, .flag = zx_shape_1, .head = zx_shape_5, .kind = zx_shape_221, .name = zx_shape_46, .operator = zx_shape_213, .second = zx_shape_5, .span = zx_shape_46, .third = zx_shape_5, .type_argument = zx_shape_5, }, };
const zx_shape_225 = .{ .kind = .object, .fields = .{ .name = zx_shape_46, .previous = zx_shape_5, .spread = zx_shape_1, .value = zx_shape_5, }, };
const zx_shape_226 = .{ .kind = .object, .fields = .{ .name = zx_shape_46, .previous = zx_shape_5, }, };
const zx_shape_227 = .{ .kind = .object, .fields = .{ .expression = zx_shape_1, .previous = zx_shape_5, .span = zx_shape_46, .value = zx_shape_5, }, };
const zx_shape_228 = .{ .kind = .object, .fields = .{ .condition = zx_shape_5, .previous = zx_shape_5, .result = zx_shape_5, }, };
const zx_shape_229 = .{ .kind = .list, .child = zx_shape_224, };
const zx_shape_230 = .{ .kind = .list, .child = zx_shape_225, };
const zx_shape_231 = .{ .kind = .list, .child = zx_shape_226, };
const zx_shape_232 = .{ .kind = .list, .child = zx_shape_227, };
const zx_shape_233 = .{ .kind = .list, .child = zx_shape_228, };
const zx_shape_234 = .{ .kind = .object, .fields = .{ .arms = zx_shape_233, .fields = zx_shape_230, .items = zx_shape_59, .nodes = zx_shape_229, .parameters = zx_shape_231, .parts = zx_shape_232, }, };
const zx_shape_235 = .{ .kind = .object, .fields = .{ .allow_lambda = zx_shape_1, .callback = zx_shape_1, .condition = zx_shape_1, .count = zx_shape_5, .cursor = zx_shape_5, .depth = zx_shape_5, .end = zx_shape_5, .family = zx_shape_214, .first = zx_shape_5, .flag = zx_shape_1, .head = zx_shape_5, .index = zx_shape_5, .kind = zx_shape_223, .maximum = zx_shape_5, .minimum = zx_shape_2, .name = zx_shape_46, .operator = zx_shape_213, .reset_family = zx_shape_1, .second = zx_shape_5, .start = zx_shape_5, .stream = zx_shape_5, }, };
const zx_shape_236 = .{ .kind = .object, .fields = .{ .allow_lambda = zx_shape_1, .base_depth = zx_shape_5, .cursor = zx_shape_5, .depth = zx_shape_5, .diagnostic = zx_shape_138, .family = zx_shape_214, .fresh_family = zx_shape_1, .hint = zx_shape_216, .index = zx_shape_5, .last_end = zx_shape_5, .lexical_diagnostic = zx_shape_5, .minimum = zx_shape_2, .phase = zx_shape_222, .primary_start = zx_shape_5, .result = zx_shape_5, .root_index = zx_shape_5, .stream = zx_shape_5, .template = zx_shape_5, .template_count = zx_shape_5, .template_head = zx_shape_5, .template_maximum = zx_shape_5, .token = zx_shape_133, .type_argument = zx_shape_5, .type_diagnostic = zx_shape_1, }, };
const zx_shape_237 = .{ .kind = .list, .child = zx_shape_235, };
const zx_shape_238 = .{ .kind = .object, .fields = .{ .control = zx_shape_236, .frames = zx_shape_237, .prepared = zx_shape_220, .tree = zx_shape_234, .types = zx_shape_211, }, };
const zx_shape_239 = .{ .kind = .object, .fields = .{ .allow_lambda = zx_shape_1, .depth = zx_shape_5, .minimum = zx_shape_2, .prepared = zx_shape_220, .start = zx_shape_5, .tree = zx_shape_234, .types = zx_shape_211, }, };
const zx_shape_240 = .{ .kind = .object, .fields = .{ .allow_lambda = zx_shape_1, .depth = zx_shape_5, .minimum = zx_shape_2, .prepared = zx_shape_220, .start = zx_shape_5, }, };
const zx_shape_241 = .{ .kind = .scalar, };
const zx_shape_242 = .{ .kind = .scalar, };
const zx_shape_243 = .{ .kind = .scalar, };
const zx_shape_244 = .{ .kind = .object, .fields = .{ .annotation = zx_shape_5, .count = zx_shape_5, .first = zx_shape_5, .head = zx_shape_5, .kind = zx_shape_241, .name = zx_shape_46, .operator = zx_shape_213, .second = zx_shape_5, .span = zx_shape_46, .third = zx_shape_5, }, };
const zx_shape_245 = .{ .kind = .object, .fields = .{ .previous = zx_shape_5, .span = zx_shape_46, }, };
const zx_shape_246 = .{ .kind = .object, .fields = .{ .body = zx_shape_5, .previous = zx_shape_5, .span = zx_shape_46, .value = zx_shape_5, }, };
const zx_shape_247 = .{ .kind = .list, .child = zx_shape_244, };
const zx_shape_248 = .{ .kind = .list, .child = zx_shape_245, };
const zx_shape_249 = .{ .kind = .list, .child = zx_shape_246, };
const zx_shape_250 = .{ .kind = .object, .fields = .{ .blocks = zx_shape_150, .cases = zx_shape_249, .items = zx_shape_59, .names = zx_shape_248, .statements = zx_shape_247, }, };
const zx_shape_251 = .{ .kind = .object, .fields = .{ .annotation = zx_shape_5, .count = zx_shape_5, .depth = zx_shape_5, .first = zx_shape_5, .head = zx_shape_5, .kind = zx_shape_242, .name = zx_shape_46, .operator = zx_shape_213, .phase = zx_shape_243, .second = zx_shape_5, .start = zx_shape_5, .statement = zx_shape_241, .third = zx_shape_5, }, };
const zx_shape_252 = .{ .kind = .object, .fields = .{ .diagnostic = zx_shape_138, .expression_diagnostic = zx_shape_1, .phase = zx_shape_243, .result = zx_shape_5, .@"resume" = zx_shape_243, .state_block = zx_shape_1, }, };
const zx_shape_253 = .{ .kind = .list, .child = zx_shape_251, };
const zx_shape_254 = .{ .kind = .object, .fields = .{ .control = zx_shape_252, .expression = zx_shape_236, .expression_frames = zx_shape_237, .frame = zx_shape_251, .frames = zx_shape_253, }, };
const zx_shape_255 = .{ .kind = .list, .child = zx_shape_254, };
const zx_shape_256 = .{ .kind = .object, .fields = .{ .control = zx_shape_252, .expression = zx_shape_238, .frame = zx_shape_251, .frames = zx_shape_253, .suspended = zx_shape_255, .tree = zx_shape_250, }, };
const zx_shape_257 = .{ .kind = .object, .fields = .{ .depth = zx_shape_5, .kind = zx_shape_242, .start = zx_shape_5, }, };
const zx_shape_258 = .{ .kind = .object, .fields = .{ .expression = zx_shape_238, .expression_only = zx_shape_1, .state_block = zx_shape_1, .tree = zx_shape_250, }, };
const zx_shape_259 = .{ .kind = .object, .fields = .{ .hint = zx_shape_216, .template = zx_shape_5, .token = zx_shape_133, }, };
const zx_shape_260 = .{ .kind = .object, .fields = .{ .phase = zx_shape_222, .state = zx_shape_238, }, };
const zx_shape_261 = .{ .kind = .object, .fields = .{ .phase = zx_shape_243, .state = zx_shape_256, }, };
const zx_shape_262 = .{ .kind = .object, .fields = .{ .code = zx_shape_10, .message = zx_shape_10, .state = zx_shape_256, }, };
const zx_shape_263 = .{ .kind = .object, .fields = .{ .kind = zx_shape_242, .nested = zx_shape_1, .phase = zx_shape_243, .@"resume" = zx_shape_243, .state = zx_shape_256, }, };
const zx_shape_264 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_253, .@"1" = zx_shape_0, }, };
const zx_shape_265 = .{ .kind = .object, .fields = .{ .message = zx_shape_10, .phase = zx_shape_243, .state = zx_shape_256, .symbol = zx_shape_132, }, };
const zx_shape_266 = .{ .kind = .object, .fields = .{ .depth = zx_shape_5, .minimum = zx_shape_2, .state = zx_shape_238, }, };
const zx_shape_267 = .{ .kind = .object, .fields = .{ .minimum = zx_shape_2, .@"resume" = zx_shape_243, .state = zx_shape_256, }, };
const zx_shape_268 = .{ .kind = .optional, .child = zx_shape_251, };
const zx_shape_269 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_253, .@"1" = zx_shape_268, }, };
const zx_shape_270 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_249, .@"1" = zx_shape_0, }, };
const zx_shape_271 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_248, .@"1" = zx_shape_0, }, };
const zx_shape_272 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_247, .@"1" = zx_shape_0, }, };
const zx_shape_273 = .{ .kind = .object, .fields = .{ .depth = zx_shape_5, .kind = zx_shape_223, .start = zx_shape_5, }, };
const zx_shape_274 = .{ .kind = .object, .fields = .{ .frame = zx_shape_235, .state = zx_shape_238, }, };
const zx_shape_275 = .{ .kind = .optional, .child = zx_shape_235, };
const zx_shape_276 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_237, .@"1" = zx_shape_275, }, };
const zx_shape_277 = .{ .kind = .object, .fields = .{ .node = zx_shape_224, .state = zx_shape_238, }, };
const zx_shape_278 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_229, .@"1" = zx_shape_0, }, };
const zx_shape_279 = .{ .kind = .object, .fields = .{ .depth = zx_shape_5, .end = zx_shape_5, .kind = zx_shape_221, .start = zx_shape_5, }, };
const zx_shape_280 = .{ .kind = .object, .fields = .{ .code = zx_shape_10, .message = zx_shape_10, .state = zx_shape_238, }, };
const zx_shape_281 = .{ .kind = .object, .fields = .{ .state = zx_shape_238, .updating = zx_shape_1, }, };
const zx_shape_282 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_237, .@"1" = zx_shape_0, }, };
const zx_shape_283 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_231, .@"1" = zx_shape_0, }, };
const zx_shape_284 = .{ .kind = .object, .fields = .{ .child = zx_shape_5, .count = zx_shape_5, .head = zx_shape_5, .kind = zx_shape_201, .name = zx_shape_46, .state = zx_shape_211, }, };
const zx_shape_285 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_205, .@"1" = zx_shape_0, }, };
const zx_shape_286 = .{ .kind = .object, .fields = .{ .phase = zx_shape_202, .state = zx_shape_211, }, };
const zx_shape_287 = .{ .kind = .optional, .child = zx_shape_208, };
const zx_shape_288 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_210, .@"1" = zx_shape_287, }, };
const zx_shape_289 = .{ .kind = .object, .fields = .{ .code = zx_shape_10, .message = zx_shape_10, .state = zx_shape_211, }, };
const zx_shape_290 = .{ .kind = .object, .fields = .{ .frame = zx_shape_208, .state = zx_shape_211, }, };
const zx_shape_291 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_210, .@"1" = zx_shape_0, }, };
const zx_shape_292 = .{ .kind = .object, .fields = .{ .kind = zx_shape_201, .name = zx_shape_46, .phase = zx_shape_202, .state = zx_shape_211, }, };
const zx_shape_293 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_206, .@"1" = zx_shape_0, }, };
const zx_shape_294 = .{ .kind = .object, .fields = .{ .state = zx_shape_211, .token = zx_shape_133, }, };
const zx_shape_295 = .{ .kind = .object, .fields = .{ .state = zx_shape_238, .type_argument = zx_shape_5, }, };
const zx_shape_296 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_230, .@"1" = zx_shape_0, }, };
const zx_shape_297 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_232, .@"1" = zx_shape_0, }, };
const zx_shape_298 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_233, .@"1" = zx_shape_0, }, };
const zx_shape_299 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_255, .@"1" = zx_shape_0, }, };
const zx_shape_300 = .{ .kind = .optional, .child = zx_shape_254, };
const zx_shape_301 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_255, .@"1" = zx_shape_300, }, };
const zx_shape_302 = .{ .kind = .object, .fields = .{ .depth = zx_shape_5, .prepared = zx_shape_220, .start = zx_shape_5, .state_block = zx_shape_1, }, };
const zx_shape_303 = .{ .kind = .object, .fields = .{ .expression = zx_shape_238, .tree = zx_shape_250, }, };
const zx_shape_304 = .{ .kind = .object, .fields = .{ .body = zx_shape_250, .control = zx_shape_236, .frames = zx_shape_237, .prepared = zx_shape_220, .tree = zx_shape_234, .types = zx_shape_211, }, };
const zx_shape_305 = .{ .kind = .scalar, };
const zx_shape_306 = .{ .kind = .object, .fields = .{ .count = zx_shape_5, .enumeration = zx_shape_1, .first = zx_shape_5, .name = zx_shape_46, .span = zx_shape_46, .value = zx_shape_5, }, };
const zx_shape_307 = .{ .kind = .object, .fields = .{ .count = zx_shape_5, .depth = zx_shape_5, .diagnostic = zx_shape_138, .enumeration = zx_shape_1, .first = zx_shape_5, .index = zx_shape_5, .last_end = zx_shape_5, .name = zx_shape_46, .opening = zx_shape_5, .opening_index = zx_shape_5, .phase = zx_shape_305, .start = zx_shape_5, .token = zx_shape_133, .type_diagnostic = zx_shape_1, }, };
const zx_shape_308 = .{ .kind = .list, .child = zx_shape_306, };
const zx_shape_309 = .{ .kind = .object, .fields = .{ .control = zx_shape_307, .declarations = zx_shape_308, .members = zx_shape_142, .types = zx_shape_211, }, };
const zx_shape_310 = .{ .kind = .scalar, };
const zx_shape_311 = .{ .kind = .object, .fields = .{ .ensures = zx_shape_1, .predicate = zx_shape_5, .span = zx_shape_46, }, };
const zx_shape_312 = .{ .kind = .object, .fields = .{ .contract_start = zx_shape_5, .diagnostic = zx_shape_138, .ensures = zx_shape_1, .expression_diagnostic = zx_shape_1, .has_ensures = zx_shape_1, .has_store = zx_shape_1, .phase = zx_shape_310, .token = zx_shape_133, }, };
const zx_shape_313 = .{ .kind = .list, .child = zx_shape_311, };
const zx_shape_314 = .{ .kind = .object, .fields = .{ .body = zx_shape_250, .contracts = zx_shape_313, .control = zx_shape_312, .expression = zx_shape_238, }, };
const zx_shape_315 = .{ .kind = .scalar, };
const zx_shape_316 = .{ .kind = .scalar, };
const zx_shape_317 = .{ .kind = .object, .fields = .{ .count = zx_shape_5, .first = zx_shape_5, .kind = zx_shape_316, .path = zx_shape_46, .span = zx_shape_46, }, };
const zx_shape_318 = .{ .kind = .object, .fields = .{ .count = zx_shape_5, .diagnostic = zx_shape_138, .first = zx_shape_5, .index = zx_shape_5, .named = zx_shape_1, .opening = zx_shape_46, .path = zx_shape_46, .phase = zx_shape_315, .start = zx_shape_5, .token = zx_shape_133, .type_only = zx_shape_1, }, };
const zx_shape_319 = .{ .kind = .list, .child = zx_shape_317, };
const zx_shape_320 = .{ .kind = .object, .fields = .{ .control = zx_shape_318, .imports = zx_shape_319, .names = zx_shape_142, }, };
const zx_shape_321 = .{ .kind = .object, .fields = .{ .blocks = zx_shape_250, .body = zx_shape_16, .comments = zx_shape_142, .contracts = zx_shape_313, .declarations = zx_shape_308, .diagnostic = zx_shape_138, .expressions = zx_shape_234, .function_start = zx_shape_5, .has_store = zx_shape_1, .import_names = zx_shape_142, .imports = zx_shape_319, .members = zx_shape_142, .tokens = zx_shape_141, .types = zx_shape_207, }, };
const zx_shape_322 = .{ .kind = .object, .fields = .{ .blocks = zx_shape_250, .comments = zx_shape_142, .diagnostic = zx_shape_138, .expressions = zx_shape_234, .result = zx_shape_5, .tokens = zx_shape_141, .types = zx_shape_207, }, };
const zx_shape_323 = .{ .kind = .object, .fields = .{ .phase = zx_shape_310, .state = zx_shape_314, }, };
const zx_shape_324 = .{ .kind = .object, .fields = .{ .code = zx_shape_10, .message = zx_shape_10, .state = zx_shape_314, }, };
const zx_shape_325 = .{ .kind = .object, .fields = .{ .message = zx_shape_10, .phase = zx_shape_310, .state = zx_shape_314, .symbol = zx_shape_132, .word = zx_shape_130, }, };
const zx_shape_326 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_313, .@"1" = zx_shape_0, }, };
const zx_shape_327 = .{ .kind = .object, .fields = .{ .depth = zx_shape_5, .prepared = zx_shape_220, .start = zx_shape_5, }, };
const zx_shape_328 = .{ .kind = .scalar, };
const zx_shape_329 = .{ .kind = .object, .fields = .{ .allocator_argument = zx_shape_1, .concurrent = zx_shape_1, .count = zx_shape_5, .error_count = zx_shape_5, .errors_present = zx_shape_1, .fallible = zx_shape_1, .first_error = zx_shape_5, .first_parameter = zx_shape_5, .io_argument = zx_shape_1, .name = zx_shape_46, .output = zx_shape_5, .process_argument = zx_shape_1, }, };
const zx_shape_330 = .{ .kind = .object, .fields = .{ .name = zx_shape_46, .value = zx_shape_5, }, };
const zx_shape_331 = .{ .kind = .object, .fields = .{ .current = zx_shape_329, .diagnostic = zx_shape_138, .index = zx_shape_5, .injected = zx_shape_5, .parameter = zx_shape_46, .phase = zx_shape_328, }, };
const zx_shape_332 = .{ .kind = .list, .child = zx_shape_329, };
const zx_shape_333 = .{ .kind = .list, .child = zx_shape_330, };
const zx_shape_334 = .{ .kind = .object, .fields = .{ .control = zx_shape_331, .declarations = zx_shape_309, .errors = zx_shape_142, .functions = zx_shape_332, .lexed = zx_shape_145, .parameters = zx_shape_333, }, };
const zx_shape_335 = .{ .kind = .object, .fields = .{ .declarations = zx_shape_308, .diagnostic = zx_shape_138, .errors = zx_shape_142, .functions = zx_shape_332, .members = zx_shape_142, .parameters = zx_shape_333, .types = zx_shape_207, }, };
const zx_shape_336 = .{ .kind = .object, .fields = .{ .phase = zx_shape_305, .state = zx_shape_309, }, };
const zx_shape_337 = .{ .kind = .object, .fields = .{ .message = zx_shape_10, .state = zx_shape_309, }, };
const zx_shape_338 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_308, .@"1" = zx_shape_0, }, };
const zx_shape_339 = .{ .kind = .object, .fields = .{ .state = zx_shape_309, .token = zx_shape_133, }, };
const zx_shape_340 = .{ .kind = .object, .fields = .{ .count = zx_shape_5, .phase = zx_shape_328, .state = zx_shape_334, }, };
const zx_shape_341 = .{ .kind = .object, .fields = .{ .code = zx_shape_10, .message = zx_shape_10, .state = zx_shape_334, }, };
const zx_shape_342 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_332, .@"1" = zx_shape_0, }, };
const zx_shape_343 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_333, .@"1" = zx_shape_0, }, };
const zx_shape_344 = .{ .kind = .object, .fields = .{ .kind = zx_shape_131, .state = zx_shape_218, .symbol = zx_shape_132, .word = zx_shape_130, }, };
const zx_shape_345 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_217, .@"1" = zx_shape_0, }, };
const zx_shape_346 = .{ .kind = .object, .fields = .{ .kind = zx_shape_131, .symbol = zx_shape_132, .word = zx_shape_130, }, };
const zx_shape_347 = .{ .kind = .list, .child = zx_shape_346, };
const zx_shape_348 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_347, .@"1" = zx_shape_0, }, };
const zx_shape_349 = .{ .kind = .object, .fields = .{ .imports = zx_shape_320, .prepared = zx_shape_220, }, };
const zx_shape_350 = .{ .kind = .object, .fields = .{ .message = zx_shape_10, .span = zx_shape_46, .state = zx_shape_320, }, };
const zx_shape_351 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_319, .@"1" = zx_shape_0, }, };
const zx_shape_352 = .{ .kind = .object, .fields = .{ .state = zx_shape_320, .token = zx_shape_133, }, };
const zx_shape_353 = .{ .kind = .object, .fields = .{ .index = zx_shape_5, .prepared = zx_shape_220, }, };
const zx_shape_354 = .{ .kind = .object, .fields = .{ .declarations = zx_shape_309, .prefix = zx_shape_349, }, };
const zx_shape_355 = .{ .kind = .object, .fields = .{ .diagnostic = zx_shape_138, .index = zx_shape_5, .present = zx_shape_1, .start = zx_shape_5, }, };
const zx_shape_356 = .{ .kind = .object, .fields = .{ .declaration_diagnostic = zx_shape_138, .declarations = zx_shape_308, .diagnostic = zx_shape_138, .function_start = zx_shape_5, .import_diagnostic = zx_shape_138, .imports = zx_shape_319, .members = zx_shape_142, .names = zx_shape_142, .present = zx_shape_1, .type_diagnostic = zx_shape_1, }, };
const zx_shape_357 = .{ .kind = .object, .fields = .{ .header = zx_shape_314, .prefix = zx_shape_356, }, };
const zx_shape_358 = .{ .kind = .object, .fields = .{ .body = zx_shape_256, .contracts = zx_shape_313, .header = zx_shape_312, .prefix = zx_shape_356, }, };
const zx_shape_359 = .{ .kind = .object, .fields = .{ .depth = zx_shape_5, .start = zx_shape_5, .tokens = zx_shape_141, }, };
const zx_shape_360 = .{ .kind = .object, .fields = .{ .depth = zx_shape_5, .diagnostic = zx_shape_138, .start = zx_shape_5, }, };
const zx_shape_361 = .{ .kind = .scalar, };
const zx_shape_362 = .{ .kind = .object, .fields = .{ .offset = zx_shape_5, .separator = zx_shape_5, .source = zx_shape_19, .valid = zx_shape_1, }, };
const zx_shape_363 = .{ .kind = .optional, .child = zx_shape_4, };
const zx_shape_364 = .{ .kind = .object, .fields = .{ .allow_lambda = zx_shape_1, .depth = zx_shape_5, .minimum = zx_shape_2, .source = zx_shape_19, .start = zx_shape_5, }, };
const zx_shape_365 = .{ .kind = .object, .fields = .{ .depth = zx_shape_5, .source = zx_shape_19, .start = zx_shape_5, .state_block = zx_shape_1, }, };
const zx_shape_366 = .{ .kind = .object, .fields = .{ .depth = zx_shape_5, .source = zx_shape_19, .start = zx_shape_5, }, };
const zx_shape_367 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_14, }, };
const zx_shape_368 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_14, .@"1" = zx_shape_18, }, };
const zx_shape_369 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_27, }, };
const zx_shape_370 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_27, .@"1" = zx_shape_1, }, };
const zx_shape_371 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_19, }, };
const zx_shape_372 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_19, .@"1" = zx_shape_29, }, };
const zx_shape_373 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_19, .@"1" = zx_shape_29, .@"2" = zx_shape_35, }, };
const zx_shape_374 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_37, }, };
const zx_shape_375 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_37, .@"1" = zx_shape_36, }, };
const zx_shape_376 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_39, }, };
const zx_shape_377 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_39, .@"1" = zx_shape_38, }, };
const zx_shape_378 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_19, .@"1" = zx_shape_1, }, };
const zx_shape_379 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_19, .@"1" = zx_shape_41, }, };
const zx_shape_380 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_42, }, };
const zx_shape_381 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_42, .@"1" = zx_shape_42, }, };
const zx_shape_382 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_42, .@"1" = zx_shape_42, .@"2" = zx_shape_10, }, };
const zx_shape_383 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_42, .@"1" = zx_shape_42, .@"2" = zx_shape_10, .@"3" = zx_shape_63, }, };
const zx_shape_384 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_19, .@"1" = zx_shape_16, }, };
const zx_shape_385 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_121, }, };
const zx_shape_386 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_121, .@"1" = zx_shape_116, }, };
const zx_shape_387 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_128, }, };
const zx_shape_388 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_128, .@"1" = zx_shape_127, }, };
const zx_shape_389 = .{ .kind = .object, .fields = .{ .@"0" = zx_shape_128, .@"1" = zx_shape_127, .@"2" = zx_shape_5, }, };
pub const input_shape = zx_shape_128;
pub const output_shape = zx_shape_5;
pub const Input = *const (zx_abi).zx_type_128;
pub const Output = u64;

fn function_0(allocator: ((std).mem).Allocator, in: u32) error{ }!u64 {
    const native_result = (zx_native_0).widen(in);

    _ = allocator;

    return native_result;
}

fn function_1(allocator: ((std).mem).Allocator, in: u64) error{ IntegerOverflow, }!u32 {
    const native_result = (try (zx_native_0).narrow(in));

    _ = allocator;

    return native_result;
}

fn function_2(allocator: ((std).mem).Allocator, in: u8) error{ }!(zx_abi).zx_type_108 {
    @setRuntimeSafety(true);

    _ = allocator;

    return block_2: {
        const operand_1 = in;

        break :block_2 (if ((operand_1 == @as(u8, 0))) @as((zx_abi).zx_type_108, .Scalar) else (if ((operand_1 == @as(u8, 1))) @as((zx_abi).zx_type_108, .Object) else (if ((operand_1 == @as(u8, 2))) @as((zx_abi).zx_type_108, .Optional) else (if ((operand_1 == @as(u8, 3))) @as((zx_abi).zx_type_108, .List) else (if ((operand_1 == @as(u8, 4))) @as((zx_abi).zx_type_108, .Tuple) else (if ((operand_1 == @as(u8, 5))) @as((zx_abi).zx_type_108, .ErrorSet) else (if ((operand_1 == @as(u8, 6))) @as((zx_abi).zx_type_108, .Task) else (if ((operand_1 == @as(u8, 7))) @as((zx_abi).zx_type_108, .Enumeration) else @as((zx_abi).zx_type_108, .NativeReference)))))))));
    };
}

fn function_3(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_118) error{ IndexOutOfBounds, OutOfMemory, }!*const (zx_abi).zx_type_113 {
    @setRuntimeSafety(true);

    const value_1: u64 = @as(u64, ((((in).tables).base).kinds).len);
    const value_2: u64 = (try function_0(allocator, (in).id));
    const value_3: bool = (value_2 >= value_1);
    const value_4: *const (zx_abi).zx_type_111 = (if (value_3) ((in).tables).delta else ((in).tables).base);
    const value_5: u64 = (if (value_3) (value_2 - value_1) else value_2);

    return block_20: {
        const operand_1 = (try function_2(allocator, block_4: {
            const operand_2 = (value_4).kinds;
            const operand_3 = value_5;

            if ((operand_3 >= (operand_2).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_4 (operand_2)[@intCast(operand_3)];
        }));

        const operand_5 = block_8: {
            const operand_6 = (value_4).first;
            const operand_7 = value_5;

            if ((operand_7 >= (operand_6).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_8 (operand_6)[@intCast(operand_7)];
        };
        const operand_9 = block_12: {
            const operand_10 = (value_4).second;
            const operand_11 = value_5;

            if ((operand_11 >= (operand_10).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_12 (operand_10)[@intCast(operand_11)];
        };
        const operand_13 = block_16: {
            const operand_14 = (value_4).labels;
            const operand_15 = value_5;

            if ((operand_15 >= (operand_14).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_16 (operand_14)[@intCast(operand_15)];
        };

        const operand_17 = value_3;

        break :block_20 block_19: {
            const operand_18 = (try (allocator).create((zx_abi).zx_type_113));

            (operand_18).* = @as((zx_abi).zx_type_113, (zx_abi).zx_type_113{ .kind = operand_1, .first = operand_5, .second = operand_9, .label = operand_13, .delta = operand_17, });

            break :block_19 @as(*const (zx_abi).zx_type_113, operand_18);
        };
    };
}

fn function_3_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_118_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec) error{ IndexOutOfBounds, OutOfMemory, }!(zx_abi).value_zx_type_113_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce {
    @setRuntimeSafety(true);

    const value_1: u64 = @as(u64, ((((in).tables).base).kinds).len);

    const value_2: u64 = block_58: {
        const operand_57 = (in).id;

        break :block_58 (try function_0(allocator, operand_57));
    };

    const value_3: bool = (block_55: {
        break :block_55 value_2;
    } >= block_56: {
        break :block_56 value_1;
    });

    const value_4: (zx_abi).zx_type_111 = (if (block_54: {
        break :block_54 value_3;
    }) (((in).tables).delta).* else (((in).tables).base).*);

    const value_5: u64 = (if (block_50: {
        break :block_50 value_3;
    }) (block_51: {
        break :block_51 value_2;
    } - block_52: {
        break :block_52 value_1;
    }) else block_53: {
        break :block_53 value_2;
    });

    return block_49: {
        const operand_21 = block_28: {
            const operand_27 = block_26: {
                const operand_24 = (block_22: {
                    break :block_22 (&value_4);
                }).kinds;

                const operand_25 = block_23: {
                    break :block_23 value_5;
                };

                if ((operand_25 >= (operand_24).len)) {
                    return error.IndexOutOfBounds;
                }

                break :block_26 (operand_24)[@intCast(operand_25)];
            };

            break :block_28 (try function_2(allocator, operand_27));
        };

        const operand_29 = block_34: {
            const operand_32 = (block_30: {
                break :block_30 (&value_4);
            }).first;

            const operand_33 = block_31: {
                break :block_31 value_5;
            };

            if ((operand_33 >= (operand_32).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_34 (operand_32)[@intCast(operand_33)];
        };
        const operand_35 = block_40: {
            const operand_38 = (block_36: {
                break :block_36 (&value_4);
            }).second;

            const operand_39 = block_37: {
                break :block_37 value_5;
            };

            if ((operand_39 >= (operand_38).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_40 (operand_38)[@intCast(operand_39)];
        };
        const operand_41 = block_46: {
            const operand_44 = (block_42: {
                break :block_42 (&value_4);
            }).labels;

            const operand_45 = block_43: {
                break :block_43 value_5;
            };

            if ((operand_45 >= (operand_44).len)) {
                return error.IndexOutOfBounds;
            }

            break :block_46 (operand_44)[@intCast(operand_45)];
        };

        const operand_47 = block_48: {
            break :block_48 value_3;
        };

        break :block_49 @as((zx_abi).value_zx_type_113_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce, (zx_abi).value_zx_type_113_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce{ .kind = operand_21, .first = operand_29, .second = operand_35, .label = operand_41, .delta = operand_47, });
    };
}

fn function_4(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_119) error{ IndexOutOfBounds, OutOfMemory, }!bool {
    @setRuntimeSafety(true);

    const value_1: (zx_abi).zx_type_113 = block_74: {
        const operand_70 = block_69: {
            const operand_67 = (in).tables;
            const operand_68 = (in).id;

            break :block_69 (zx_abi).zx_type_118{ .tables = operand_67, .id = operand_68, };
        };

        const operand_71 = (&operand_70);
        const operand_72 = (try function_3_value(allocator, (zx_abi).value_zx_type_118_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec{ .id = (operand_71).id, .tables = (zx_abi).value_zx_type_112_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .base = ((operand_71).tables).base, .delta = ((operand_71).tables).delta, .zx_origin = (operand_71).tables, }, .zx_origin = operand_71, }));

        break :block_74 (if (((operand_72).zx_origin != null)) ((operand_72).zx_origin.?).* else block_73: {
            break :block_73 (zx_abi).zx_type_113{ .delta = (operand_72).delta, .first = (operand_72).first, .kind = (operand_72).kind, .label = (operand_72).label, .second = (operand_72).second, };
        });
    };

    const value_2: (zx_abi).zx_type_115 = ((in).candidate).*;

    if ((((&value_1)).kind != ((&value_2)).kind)) {
        return false;
    }

    if ((((((&value_1)).kind == @as((zx_abi).zx_type_108, .Scalar)) or (((&value_1)).kind == @as((zx_abi).zx_type_108, .Optional))) or (((&value_1)).kind == @as((zx_abi).zx_type_108, .List)))) {
        return (((&value_1)).first == ((&value_2)).first);
    }

    if ((((&value_1)).kind == @as((zx_abi).zx_type_108, .Task))) {
        return ((((&value_1)).first == ((&value_2)).first) and (((&value_1)).second == ((&value_2)).second));
    }

    if ((((&value_1)).kind == @as((zx_abi).zx_type_108, .NativeReference))) {
        return block_66: {
            const operand_64 = ((&value_1)).label;
            const operand_65 = ((&value_2)).label;

            break :block_66 ((std).mem).eql(u8, operand_64, operand_65);
        };
    }

    if (((((&value_1)).kind == @as((zx_abi).zx_type_108, .Enumeration)) and (!block_63: {
        const operand_61 = ((&value_1)).label;
        const operand_62 = ((&value_2)).label;

        break :block_63 ((std).mem).eql(u8, operand_61, operand_62);
    }))) {
        return false;
    }

    const value_3: (zx_abi).zx_type_111 = (if (((&value_1)).delta) (((in).tables).delta).* else (((in).tables).base).*);
    const value_4: u64 = (try function_0(allocator, ((&value_1)).first));
    const value_5: u64 = (try function_0(allocator, ((&value_1)).second));

    const value_6: u64 = block_60: {
        const operand_59 = ((&value_1)).kind;

        break :block_60 (if ((operand_59 == @as((zx_abi).zx_type_108, .Object))) @as(u64, ((((&value_2)).fields).names).len) else (if ((operand_59 == @as((zx_abi).zx_type_108, .Tuple))) @as(u64, (((&value_2)).children).len) else @as(u64, (((&value_2)).names).len)));
    };

    if ((value_5 != value_6)) {
        return false;
    }

    const value_12: (zx_abi).zx_type_120 = block_58: {
        const operand_9 = block_8: {
            const operand_2 = (&value_3);
            const operand_3 = (&value_2);
            const operand_4 = value_4;
            const operand_5 = value_5;
            const operand_6 = @as(u64, 0);
            const operand_7 = true;

            break :block_8 (zx_abi).zx_type_120{ .table = operand_2, .candidate = operand_3, .first = operand_4, .count = operand_5, .index = operand_6, .equal = operand_7, };
        };

        var state_1: (zx_abi).value_zx_type_120_24cb83be264601bd878a3a89f4dc79e53724e5f2364f209841a04e7a327c23bf = (zx_abi).value_zx_type_120_24cb83be264601bd878a3a89f4dc79e53724e5f2364f209841a04e7a327c23bf{ .candidate = (zx_abi).value_zx_type_115_733f63291ddde64b1bc83a721ebf685a0d9d5fe955b56f62c3e2ecdaa3727384{ .children = ((operand_9).candidate).children, .fields = (zx_abi).value_zx_type_114_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .names = (((operand_9).candidate).fields).names, .types = (((operand_9).candidate).fields).types, .zx_origin = ((operand_9).candidate).fields, }, .first = ((operand_9).candidate).first, .kind = ((operand_9).candidate).kind, .label = ((operand_9).candidate).label, .names = ((operand_9).candidate).names, .second = ((operand_9).candidate).second, .zx_origin = (operand_9).candidate, }, .count = (operand_9).count, .equal = (operand_9).equal, .first = (operand_9).first, .index = (operand_9).index, .table = (operand_9).table, .zx_origin = (&operand_9), };

        while (((state_1).equal and ((state_1).index < (state_1).count))) {
            state_1 = block_51: {
                const value_9: u64 = ((state_1).first + (state_1).index);

                const value_10: bool = block_50: {
                    const operand_15 = ((state_1).candidate).kind;

                    break :block_50 (if ((operand_15 == @as((zx_abi).zx_type_108, .Object))) (block_42: {
                        const operand_40 = block_36: {
                            const operand_34 = ((state_1).table).field_names;

                            const operand_35 = block_33: {
                                break :block_33 value_9;
                            };

                            if ((operand_35 >= (operand_34).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_36 (operand_34)[@intCast(operand_35)];
                        };
                        const operand_41 = block_39: {
                            const operand_37 = (((state_1).candidate).fields).names;
                            const operand_38 = (state_1).index;

                            if ((operand_38 >= (operand_37).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_39 (operand_37)[@intCast(operand_38)];
                        };

                        break :block_42 ((std).mem).eql(u8, operand_40, operand_41);
                    } and (block_46: {
                        const operand_44 = ((state_1).table).field_types;

                        const operand_45 = block_43: {
                            break :block_43 value_9;
                        };

                        if ((operand_45 >= (operand_44).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_46 (operand_44)[@intCast(operand_45)];
                    } == block_49: {
                        const operand_47 = (((state_1).candidate).fields).types;
                        const operand_48 = (state_1).index;

                        if ((operand_48 >= (operand_47).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_49 (operand_47)[@intCast(operand_48)];
                    })) else (if ((operand_15 == @as((zx_abi).zx_type_108, .Tuple))) (block_29: {
                        const operand_27 = ((state_1).table).children;

                        const operand_28 = block_26: {
                            break :block_26 value_9;
                        };

                        if ((operand_28 >= (operand_27).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_29 (operand_27)[@intCast(operand_28)];
                    } == block_32: {
                        const operand_30 = ((state_1).candidate).children;
                        const operand_31 = (state_1).index;

                        if ((operand_31 >= (operand_30).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_32 (operand_30)[@intCast(operand_31)];
                    }) else block_25: {
                        const operand_23 = block_19: {
                            const operand_17 = ((state_1).table).names;

                            const operand_18 = block_16: {
                                break :block_16 value_9;
                            };

                            if ((operand_18 >= (operand_17).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_19 (operand_17)[@intCast(operand_18)];
                        };
                        const operand_24 = block_22: {
                            const operand_20 = ((state_1).candidate).names;
                            const operand_21 = (state_1).index;

                            if ((operand_21 >= (operand_20).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_22 (operand_20)[@intCast(operand_21)];
                        };

                        break :block_25 ((std).mem).eql(u8, operand_23, operand_24);
                    }));
                };
                const value_11: (zx_abi).value_zx_type_120_24cb83be264601bd878a3a89f4dc79e53724e5f2364f209841a04e7a327c23bf = block_14: {
                    const operand_10 = state_1;
                    const operand_11 = ((state_1).index + @as(u64, 1));

                    const operand_12 = block_13: {
                        break :block_13 value_10;
                    };

                    break :block_14 @as((zx_abi).value_zx_type_120_24cb83be264601bd878a3a89f4dc79e53724e5f2364f209841a04e7a327c23bf, (zx_abi).value_zx_type_120_24cb83be264601bd878a3a89f4dc79e53724e5f2364f209841a04e7a327c23bf{ .candidate = (operand_10).candidate, .count = (operand_10).count, .equal = operand_12, .first = (operand_10).first, .index = operand_11, .table = (operand_10).table, });
                };

                break :block_51 value_11;
            };
        }

        break :block_58 block_57: {
            break :block_57 (if (((state_1).zx_origin != null)) ((state_1).zx_origin.?).* else block_56: {
                break :block_56 (zx_abi).zx_type_120{ .candidate = (if ((((state_1).candidate).zx_origin != null)) ((state_1).candidate).zx_origin.? else block_55: {
                    const operand_54 = (try (allocator).create((zx_abi).zx_type_115));

                    (operand_54).* = (zx_abi).zx_type_115{ .children = ((state_1).candidate).children, .fields = (if (((((state_1).candidate).fields).zx_origin != null)) (((state_1).candidate).fields).zx_origin.? else block_53: {
                        const operand_52 = (try (allocator).create((zx_abi).zx_type_114));

                        (operand_52).* = (zx_abi).zx_type_114{ .names = (((state_1).candidate).fields).names, .types = (((state_1).candidate).fields).types, };

                        break :block_53 @as(*const (zx_abi).zx_type_114, operand_52);
                    }), .first = ((state_1).candidate).first, .kind = ((state_1).candidate).kind, .label = ((state_1).candidate).label, .names = ((state_1).candidate).names, .second = ((state_1).candidate).second, };

                    break :block_55 @as(*const (zx_abi).zx_type_115, operand_54);
                }), .count = (state_1).count, .equal = (state_1).equal, .first = (state_1).first, .index = (state_1).index, .table = (state_1).table, };
            });
        };
    };

    return ((&value_12)).equal;
}

fn function_5(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_128) error{ IndexOutOfBounds, OutOfMemory, }!*const (zx_abi).zx_type_127 {
    @setRuntimeSafety(true);

    const value_1: u64 = (@as(u64, ((((in).origins).base).ids).len) + @as(u64, ((((in).origins).delta).ids).len));
    const value_2: u32 = @as(u32, 0);

    const value_14: *const (zx_abi).zx_type_129 = block_106: {
        const operand_18 = block_17: {
            const operand_7 = (in).tables;
            const operand_8 = (in).origins;
            const operand_9 = (in).origin;
            const operand_10 = (in).candidate;
            const operand_11 = value_1;
            const operand_12 = @as(u64, 0);
            const operand_13 = @as((zx_abi).zx_type_126, .Missing);
            const operand_14 = value_2;

            break :block_17 block_16: {
                const operand_15 = (try (allocator).create((zx_abi).zx_type_129));

                (operand_15).* = @as((zx_abi).zx_type_129, (zx_abi).zx_type_129{ .tables = operand_7, .origins = operand_8, .origin = operand_9, .candidate = operand_10, .count = operand_11, .index = operand_12, .status = operand_13, .id = operand_14, });

                break :block_16 @as(*const (zx_abi).zx_type_129, operand_15);
            };
        };
        const state_type_20 = struct {
            names: []const []const u8,
            types: []const u32,
        };
        const state_type_21 = struct {
            children: []const u32,
            fields: state_type_20,
            first: u32,
            kind: (zx_abi).zx_type_108,
            label: []const u8,
            names: []const []const u8,
            second: u32,
        };

        const state_type_22 = struct {
            kind: u8,
            member: []const u8,
            owner: []const u8,
        };
        const state_type_23 = struct {
            ids: []const u32,
            kinds: []const u8,
            members: []const []const u8,
            owners: []const []const u8,
        };

        const state_type_24 = struct {
            base: state_type_23,
            delta: state_type_23,
        };
        const state_type_25 = struct {
            children: []const u32,
            field_names: []const []const u8,
            field_types: []const u32,
            first: []const u32,
            kinds: []const u8,
            labels: []const []const u8,
            names: []const []const u8,
            second: []const u32,
        };
        const state_type_26 = struct {
            base: state_type_25,
            delta: state_type_25,
        };

        const state_type_27 = struct {
            candidate: state_type_21,
            count: u64,
            id: u32,
            index: u64,
            origin: state_type_22,
            origins: state_type_24,
            status: (zx_abi).zx_type_126,
            tables: state_type_26,
        };
        const state_type_33 = struct {
            candidate: state_type_21,
            id: u32,
            tables: state_type_26,
        };
        const state_type_47 = struct {
            id: u32,
            tables: state_type_26,
        };

        const state_type_61 = struct {
            delta: bool,
            first: u32,
            kind: (zx_abi).zx_type_108,
            label: []const u8,
            second: u32,
        };

        var state_6: state_type_27 = state_type_27{ .candidate = state_type_21{ .children = ((operand_18).candidate).children, .fields = state_type_20{ .names = (((operand_18).candidate).fields).names, .types = (((operand_18).candidate).fields).types, }, .first = ((operand_18).candidate).first, .kind = ((operand_18).candidate).kind, .label = ((operand_18).candidate).label, .names = ((operand_18).candidate).names, .second = ((operand_18).candidate).second, }, .count = (operand_18).count, .id = (operand_18).id, .index = (operand_18).index, .origin = state_type_22{ .kind = ((operand_18).origin).kind, .member = ((operand_18).origin).member, .owner = ((operand_18).origin).owner, }, .origins = state_type_24{ .base = state_type_23{ .ids = (((operand_18).origins).base).ids, .kinds = (((operand_18).origins).base).kinds, .members = (((operand_18).origins).base).members, .owners = (((operand_18).origins).base).owners, }, .delta = state_type_23{ .ids = (((operand_18).origins).delta).ids, .kinds = (((operand_18).origins).delta).kinds, .members = (((operand_18).origins).delta).members, .owners = (((operand_18).origins).delta).owners, }, }, .status = (operand_18).status, .tables = state_type_26{ .base = state_type_25{ .children = (((operand_18).tables).base).children, .field_names = (((operand_18).tables).base).field_names, .field_types = (((operand_18).tables).base).field_types, .first = (((operand_18).tables).base).first, .kinds = (((operand_18).tables).base).kinds, .labels = (((operand_18).tables).base).labels, .names = (((operand_18).tables).base).names, .second = (((operand_18).tables).base).second, }, .delta = state_type_25{ .children = (((operand_18).tables).delta).children, .field_names = (((operand_18).tables).delta).field_names, .field_types = (((operand_18).tables).delta).field_types, .first = (((operand_18).tables).delta).first, .kinds = (((operand_18).tables).delta).kinds, .labels = (((operand_18).tables).delta).labels, .names = (((operand_18).tables).delta).names, .second = (((operand_18).tables).delta).second, }, }, };
        var state_changed_19 = false;

        while ((((state_6).status == @as((zx_abi).zx_type_126, .Missing)) and ((state_6).index < (state_6).count))) {
            state_6 = block_84: {
                const value_5: u64 = @as(u64, ((((state_6).origins).base).ids).len);
                const value_6: bool = ((state_6).index >= value_5);
                const value_7: state_type_23 = (if (value_6) ((state_6).origins).delta else ((state_6).origins).base);
                const value_8: u64 = (if (value_6) ((state_6).index - value_5) else (state_6).index);

                const value_9: u32 = block_83: {
                    const operand_81 = (value_7).ids;
                    const operand_82 = value_8;

                    if ((operand_82 >= (operand_81).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_83 (operand_81)[@intCast(operand_82)];
                };
                const value_10: bool = (((block_68: {
                    const operand_66 = (value_7).kinds;
                    const operand_67 = value_8;

                    if ((operand_67 >= (operand_66).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_68 (operand_66)[@intCast(operand_67)];
                } == ((state_6).origin).kind) and block_74: {
                    const operand_72 = block_71: {
                        const operand_69 = (value_7).owners;
                        const operand_70 = value_8;

                        if ((operand_70 >= (operand_69).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_71 (operand_69)[@intCast(operand_70)];
                    };

                    const operand_73 = ((state_6).origin).owner;

                    break :block_74 ((std).mem).eql(u8, operand_72, operand_73);
                }) and block_80: {
                    const operand_78 = block_77: {
                        const operand_75 = (value_7).members;
                        const operand_76 = value_8;

                        if ((operand_76 >= (operand_75).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_77 (operand_75)[@intCast(operand_76)];
                    };

                    const operand_79 = ((state_6).origin).member;

                    break :block_80 ((std).mem).eql(u8, operand_78, operand_79);
                });

                const value_11: bool = (value_10 and block_65: {
                    const operand_63 = (block_62: {
                        const operand_51 = block_50: {
                            const operand_48 = (state_6).tables;
                            const operand_49 = value_9;

                            break :block_50 state_type_47{ .tables = operand_48, .id = operand_49, };
                        };

                        const operand_52 = (zx_abi).zx_type_111{ .children = (((operand_51).tables).base).children, .field_names = (((operand_51).tables).base).field_names, .field_types = (((operand_51).tables).base).field_types, .first = (((operand_51).tables).base).first, .kinds = (((operand_51).tables).base).kinds, .labels = (((operand_51).tables).base).labels, .names = (((operand_51).tables).base).names, .second = (((operand_51).tables).base).second, };
                        const operand_53 = (zx_abi).zx_type_111{ .children = (((operand_51).tables).delta).children, .field_names = (((operand_51).tables).delta).field_names, .field_types = (((operand_51).tables).delta).field_types, .first = (((operand_51).tables).delta).first, .kinds = (((operand_51).tables).delta).kinds, .labels = (((operand_51).tables).delta).labels, .names = (((operand_51).tables).delta).names, .second = (((operand_51).tables).delta).second, };
                        const operand_54 = (zx_abi).zx_type_112{ .base = (&operand_52), .delta = (&operand_53), };
                        const operand_55 = (zx_abi).zx_type_118{ .id = (operand_51).id, .tables = (&operand_54), };
                        const operand_60 = block_59: {
                            const operand_56 = (&operand_55);
                            const operand_57 = (try function_3_value(allocator, (zx_abi).value_zx_type_118_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec{ .id = (operand_56).id, .tables = (zx_abi).value_zx_type_112_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .base = ((operand_56).tables).base, .delta = ((operand_56).tables).delta, .zx_origin = (operand_56).tables, }, .zx_origin = operand_56, }));

                            break :block_59 (if (((operand_57).zx_origin != null)) ((operand_57).zx_origin.?).* else block_58: {
                                break :block_58 (zx_abi).zx_type_113{ .delta = (operand_57).delta, .first = (operand_57).first, .kind = (operand_57).kind, .label = (operand_57).label, .second = (operand_57).second, };
                            });
                        };

                        break :block_62 state_type_61{ .delta = (operand_60).delta, .first = (operand_60).first, .kind = (operand_60).kind, .label = (operand_60).label, .second = (operand_60).second, };
                    }).label;

                    const operand_64 = ((state_6).candidate).label;

                    break :block_65 ((std).mem).eql(u8, operand_63, operand_64);
                });

                const value_12: (zx_abi).zx_type_126 = (if ((!value_11)) @as((zx_abi).zx_type_126, .Missing) else (if (block_46: {
                    const operand_38 = block_37: {
                        const operand_34 = (state_6).tables;
                        const operand_35 = value_9;
                        const operand_36 = (state_6).candidate;

                        break :block_37 state_type_33{ .tables = operand_34, .id = operand_35, .candidate = operand_36, };
                    };

                    const operand_39 = (zx_abi).zx_type_114{ .names = (((operand_38).candidate).fields).names, .types = (((operand_38).candidate).fields).types, };
                    const operand_40 = (zx_abi).zx_type_115{ .children = ((operand_38).candidate).children, .fields = (&operand_39), .first = ((operand_38).candidate).first, .kind = ((operand_38).candidate).kind, .label = ((operand_38).candidate).label, .names = ((operand_38).candidate).names, .second = ((operand_38).candidate).second, };
                    const operand_41 = (zx_abi).zx_type_111{ .children = (((operand_38).tables).base).children, .field_names = (((operand_38).tables).base).field_names, .field_types = (((operand_38).tables).base).field_types, .first = (((operand_38).tables).base).first, .kinds = (((operand_38).tables).base).kinds, .labels = (((operand_38).tables).base).labels, .names = (((operand_38).tables).base).names, .second = (((operand_38).tables).base).second, };
                    const operand_42 = (zx_abi).zx_type_111{ .children = (((operand_38).tables).delta).children, .field_names = (((operand_38).tables).delta).field_names, .field_types = (((operand_38).tables).delta).field_types, .first = (((operand_38).tables).delta).first, .kinds = (((operand_38).tables).delta).kinds, .labels = (((operand_38).tables).delta).labels, .names = (((operand_38).tables).delta).names, .second = (((operand_38).tables).delta).second, };
                    const operand_43 = (zx_abi).zx_type_112{ .base = (&operand_41), .delta = (&operand_42), };
                    const operand_44 = (zx_abi).zx_type_119{ .candidate = (&operand_40), .id = (operand_38).id, .tables = (&operand_43), };
                    const operand_45 = (try function_4(allocator, (&operand_44)));

                    break :block_46 operand_45;
                }) @as((zx_abi).zx_type_126, .Found) else @as((zx_abi).zx_type_126, .Conflict)));

                const value_13: state_type_27 = block_32: {
                    const operand_28 = state_6;
                    const operand_29 = ((state_6).index + @as(u64, 1));
                    const operand_30 = value_12;
                    const operand_31 = (if (value_11) value_9 else (state_6).id);

                    break :block_32 state_type_27{ .candidate = (operand_28).candidate, .count = (operand_28).count, .id = operand_31, .index = operand_29, .origin = (operand_28).origin, .origins = (operand_28).origins, .status = operand_30, .tables = (operand_28).tables, };
                };

                break :block_84 value_13;
            };

            state_changed_19 = true;
        }

        break :block_106 (if (state_changed_19) block_105: {
            const operand_104 = (try (allocator).create((zx_abi).zx_type_129));

            (operand_104).* = @as((zx_abi).zx_type_129, (zx_abi).zx_type_129{ .candidate = block_89: {
                const operand_88 = (try (allocator).create((zx_abi).zx_type_115));

                (operand_88).* = @as((zx_abi).zx_type_115, (zx_abi).zx_type_115{ .children = ((state_6).candidate).children, .fields = block_87: {
                    const operand_86 = (try (allocator).create((zx_abi).zx_type_114));

                    (operand_86).* = @as((zx_abi).zx_type_114, (zx_abi).zx_type_114{ .names = (((state_6).candidate).fields).names, .types = (((state_6).candidate).fields).types, });

                    break :block_87 @as(*const (zx_abi).zx_type_114, operand_86);
                }, .first = ((state_6).candidate).first, .kind = ((state_6).candidate).kind, .label = ((state_6).candidate).label, .names = ((state_6).candidate).names, .second = ((state_6).candidate).second, });

                break :block_89 @as(*const (zx_abi).zx_type_115, operand_88);
            }, .count = (state_6).count, .id = (state_6).id, .index = (state_6).index, .origin = block_91: {
                const operand_90 = (try (allocator).create((zx_abi).zx_type_123));

                (operand_90).* = @as((zx_abi).zx_type_123, (zx_abi).zx_type_123{ .kind = ((state_6).origin).kind, .member = ((state_6).origin).member, .owner = ((state_6).origin).owner, });

                break :block_91 @as(*const (zx_abi).zx_type_123, operand_90);
            }, .origins = block_97: {
                const operand_96 = (try (allocator).create((zx_abi).zx_type_125));

                (operand_96).* = @as((zx_abi).zx_type_125, (zx_abi).zx_type_125{ .base = block_93: {
                    const operand_92 = (try (allocator).create((zx_abi).zx_type_124));

                    (operand_92).* = @as((zx_abi).zx_type_124, (zx_abi).zx_type_124{ .ids = (((state_6).origins).base).ids, .kinds = (((state_6).origins).base).kinds, .members = (((state_6).origins).base).members, .owners = (((state_6).origins).base).owners, });

                    break :block_93 @as(*const (zx_abi).zx_type_124, operand_92);
                }, .delta = block_95: {
                    const operand_94 = (try (allocator).create((zx_abi).zx_type_124));

                    (operand_94).* = @as((zx_abi).zx_type_124, (zx_abi).zx_type_124{ .ids = (((state_6).origins).delta).ids, .kinds = (((state_6).origins).delta).kinds, .members = (((state_6).origins).delta).members, .owners = (((state_6).origins).delta).owners, });

                    break :block_95 @as(*const (zx_abi).zx_type_124, operand_94);
                }, });

                break :block_97 @as(*const (zx_abi).zx_type_125, operand_96);
            }, .status = (state_6).status, .tables = block_103: {
                const operand_102 = (try (allocator).create((zx_abi).zx_type_112));

                (operand_102).* = @as((zx_abi).zx_type_112, (zx_abi).zx_type_112{ .base = block_99: {
                    const operand_98 = (try (allocator).create((zx_abi).zx_type_111));

                    (operand_98).* = @as((zx_abi).zx_type_111, (zx_abi).zx_type_111{ .children = (((state_6).tables).base).children, .field_names = (((state_6).tables).base).field_names, .field_types = (((state_6).tables).base).field_types, .first = (((state_6).tables).base).first, .kinds = (((state_6).tables).base).kinds, .labels = (((state_6).tables).base).labels, .names = (((state_6).tables).base).names, .second = (((state_6).tables).base).second, });

                    break :block_99 @as(*const (zx_abi).zx_type_111, operand_98);
                }, .delta = block_101: {
                    const operand_100 = (try (allocator).create((zx_abi).zx_type_111));

                    (operand_100).* = @as((zx_abi).zx_type_111, (zx_abi).zx_type_111{ .children = (((state_6).tables).delta).children, .field_names = (((state_6).tables).delta).field_names, .field_types = (((state_6).tables).delta).field_types, .first = (((state_6).tables).delta).first, .kinds = (((state_6).tables).delta).kinds, .labels = (((state_6).tables).delta).labels, .names = (((state_6).tables).delta).names, .second = (((state_6).tables).delta).second, });

                    break :block_101 @as(*const (zx_abi).zx_type_111, operand_100);
                }, });

                break :block_103 @as(*const (zx_abi).zx_type_112, operand_102);
            }, });

            break :block_105 @as(*const (zx_abi).zx_type_129, operand_104);
        } else operand_18);
    };

    return block_5: {
        const operand_1 = (value_14).status;
        const operand_2 = (value_14).id;

        break :block_5 block_4: {
            const operand_3 = (try (allocator).create((zx_abi).zx_type_127));

            (operand_3).* = @as((zx_abi).zx_type_127, (zx_abi).zx_type_127{ .status = operand_1, .id = operand_2, });

            break :block_4 @as(*const (zx_abi).zx_type_127, operand_3);
        };
    };
}

fn function_5_value(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_128_acd242b5c93e20e093dd81a667a3d7c9764b5a40f4eee9242afa9dcc2e5de3d1) error{ IndexOutOfBounds, OutOfMemory, }!(zx_abi).value_zx_type_127_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 {
    @setRuntimeSafety(true);

    const value_1: u64 = (@as(u64, ((((in).origins).base).ids).len) + @as(u64, ((((in).origins).delta).ids).len));
    const value_2: u32 = @as(u32, 0);

    const value_14: (zx_abi).value_zx_type_129_aa62a11140e1915685b421cc9795c0cfe65297e265c3d8673f3f8d6eadcf7d34 = block_185: {
        const operand_122 = block_121: {
            const operand_111 = (in).tables;
            const operand_112 = (in).origins;
            const operand_113 = (in).origin;
            const operand_114 = (in).candidate;

            const operand_115 = block_116: {
                break :block_116 value_1;
            };

            const operand_117 = @as(u64, 0);
            const operand_118 = @as((zx_abi).zx_type_126, .Missing);

            const operand_119 = block_120: {
                break :block_120 value_2;
            };

            break :block_121 @as((zx_abi).value_zx_type_129_aa62a11140e1915685b421cc9795c0cfe65297e265c3d8673f3f8d6eadcf7d34, (zx_abi).value_zx_type_129_aa62a11140e1915685b421cc9795c0cfe65297e265c3d8673f3f8d6eadcf7d34{ .tables = operand_111, .origins = operand_112, .origin = operand_113, .candidate = operand_114, .count = operand_115, .index = operand_117, .status = operand_118, .id = operand_119, });
        };

        var state_110: (zx_abi).value_zx_type_129_aa62a11140e1915685b421cc9795c0cfe65297e265c3d8673f3f8d6eadcf7d34 = operand_122;
        var state_changed_123 = false;

        while ((((state_110).status == @as((zx_abi).zx_type_126, .Missing)) and ((state_110).index < (state_110).count))) {
            state_110 = block_183: {
                const value_5: u64 = @as(u64, ((((state_110).origins).base).ids).len);

                const value_6: bool = ((state_110).index >= block_182: {
                    break :block_182 value_5;
                });

                const value_7: *const (zx_abi).zx_type_124 = (if (block_181: {
                    break :block_181 value_6;
                }) ((state_110).origins).delta else ((state_110).origins).base);

                const value_8: u64 = (if (block_179: {
                    break :block_179 value_6;
                }) ((state_110).index - block_180: {
                    break :block_180 value_5;
                }) else (state_110).index);

                const value_9: u32 = block_178: {
                    const operand_176 = (block_174: {
                        break :block_174 value_7;
                    }).ids;

                    const operand_177 = block_175: {
                        break :block_175 value_8;
                    };

                    if ((operand_177 >= (operand_176).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_178 (operand_176)[@intCast(operand_177)];
                };
                const value_10: bool = (((block_157: {
                    const operand_155 = (block_153: {
                        break :block_153 value_7;
                    }).kinds;
                    const operand_156 = block_154: {
                        break :block_154 value_8;
                    };

                    if ((operand_156 >= (operand_155).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_157 (operand_155)[@intCast(operand_156)];
                } == ((state_110).origin).kind) and block_165: {
                    const operand_163 = block_162: {
                        const operand_160 = (block_158: {
                            break :block_158 value_7;
                        }).owners;

                        const operand_161 = block_159: {
                            break :block_159 value_8;
                        };

                        if ((operand_161 >= (operand_160).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_162 (operand_160)[@intCast(operand_161)];
                    };

                    const operand_164 = ((state_110).origin).owner;

                    break :block_165 ((std).mem).eql(u8, operand_163, operand_164);
                }) and block_173: {
                    const operand_171 = block_170: {
                        const operand_168 = (block_166: {
                            break :block_166 value_7;
                        }).members;
                        const operand_169 = block_167: {
                            break :block_167 value_8;
                        };

                        if ((operand_169 >= (operand_168).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_170 (operand_168)[@intCast(operand_169)];
                    };

                    const operand_172 = ((state_110).origin).member;

                    break :block_173 ((std).mem).eql(u8, operand_171, operand_172);
                });

                const value_11: bool = (block_144: {
                    break :block_144 value_10;
                } and block_152: {
                    const operand_150 = (block_149: {
                        break :block_149 (try function_3_value(allocator, block_148: {
                            const operand_145 = (state_110).tables;

                            const operand_146 = block_147: {
                                break :block_147 value_9;
                            };

                            break :block_148 @as((zx_abi).value_zx_type_118_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec, (zx_abi).value_zx_type_118_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec{ .tables = operand_145, .id = operand_146, });
                        }));
                    }).label;

                    const operand_151 = ((state_110).candidate).label;

                    break :block_152 ((std).mem).eql(u8, operand_150, operand_151);
                });

                const value_12: (zx_abi).zx_type_126 = (if ((!block_143: {
                    break :block_143 value_11;
                })) @as((zx_abi).zx_type_126, .Missing) else (if (block_142: {
                    const operand_137 = block_136: {
                        const operand_132 = (state_110).tables;

                        const operand_133 = block_134: {
                            break :block_134 value_9;
                        };

                        const operand_135 = (state_110).candidate;

                        break :block_136 @as((zx_abi).value_zx_type_119_2c4a87f781c651962259ae1ef67d878ae312a61c3d14b66307e5fd0a9c7f1e1e, (zx_abi).value_zx_type_119_2c4a87f781c651962259ae1ef67d878ae312a61c3d14b66307e5fd0a9c7f1e1e{ .tables = operand_132, .id = operand_133, .candidate = operand_135, });
                    };

                    var state_borrow_138: (zx_abi).zx_type_114 = undefined;

                    state_borrow_138 = (zx_abi).zx_type_114{ .names = (((operand_137).candidate).fields).names, .types = (((operand_137).candidate).fields).types, };

                    var state_borrow_139: (zx_abi).zx_type_115 = undefined;
                    state_borrow_139 = (zx_abi).zx_type_115{ .children = ((operand_137).candidate).children, .fields = ((((operand_137).candidate).fields).zx_origin orelse (&state_borrow_138)), .first = ((operand_137).candidate).first, .kind = ((operand_137).candidate).kind, .label = ((operand_137).candidate).label, .names = ((operand_137).candidate).names, .second = ((operand_137).candidate).second, };

                    var state_borrow_140: (zx_abi).zx_type_112 = undefined;
                    state_borrow_140 = (zx_abi).zx_type_112{ .base = ((operand_137).tables).base, .delta = ((operand_137).tables).delta, };

                    var state_borrow_141: (zx_abi).zx_type_119 = undefined;

                    state_borrow_141 = (zx_abi).zx_type_119{ .candidate = (((operand_137).candidate).zx_origin orelse (&state_borrow_139)), .id = (operand_137).id, .tables = (((operand_137).tables).zx_origin orelse (&state_borrow_140)), };

                    break :block_142 (try function_4(allocator, ((operand_137).zx_origin orelse (&state_borrow_141))));
                }) @as((zx_abi).zx_type_126, .Found) else @as((zx_abi).zx_type_126, .Conflict)));

                const value_13: (zx_abi).value_zx_type_129_aa62a11140e1915685b421cc9795c0cfe65297e265c3d8673f3f8d6eadcf7d34 = block_131: {
                    const operand_124 = state_110;
                    const operand_125 = ((state_110).index + @as(u64, 1));

                    const operand_126 = block_127: {
                        break :block_127 value_12;
                    };

                    const operand_128 = (if (block_129: {
                        break :block_129 value_11;
                    }) block_130: {
                        break :block_130 value_9;
                    } else (state_110).id);

                    break :block_131 @as((zx_abi).value_zx_type_129_aa62a11140e1915685b421cc9795c0cfe65297e265c3d8673f3f8d6eadcf7d34, (zx_abi).value_zx_type_129_aa62a11140e1915685b421cc9795c0cfe65297e265c3d8673f3f8d6eadcf7d34{ .candidate = (operand_124).candidate, .count = (operand_124).count, .id = operand_128, .index = operand_125, .origin = (operand_124).origin, .origins = (operand_124).origins, .status = operand_126, .tables = (operand_124).tables, });
                };

                break :block_183 value_13;
            };

            state_changed_123 = true;
        }

        break :block_185 (if (state_changed_123) state_110 else operand_122);
    };

    return block_109: {
        const operand_107 = (value_14).status;
        const operand_108 = (value_14).id;

        break :block_109 @as((zx_abi).value_zx_type_127_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_127_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .status = operand_107, .id = operand_108, });
    };
}

fn function_6(allocator: ((std).mem).Allocator, in: u32) error{ }!u64 {
    const native_result = (zx_native_0).widen(in);

    _ = allocator;

    return native_result;
}

fn function_7(allocator: ((std).mem).Allocator, in: u64) error{ IntegerOverflow, }!u32 {
    const native_result = (try (zx_native_0).narrow(in));

    _ = allocator;

    return native_result;
}

fn function_8(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_127) error{ }!u64 {
    @setRuntimeSafety(true);

    return block_2: {
        const operand_1 = (in).status;

        break :block_2 (if ((operand_1 == @as((zx_abi).zx_type_126, .Missing))) @as(u64, 0) else (if ((operand_1 == @as((zx_abi).zx_type_126, .Conflict))) @as(u64, 1) else ((try function_6(allocator, (in).id)) + @as(u64, 2))));
    };
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_128) error{ IndexOutOfBounds, OutOfMemory, }!u64 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    const value_1: (zx_abi).zx_type_127 = block_4: {
        const operand_1 = in;
        const operand_2 = (try function_5_value(allocator, (zx_abi).value_zx_type_128_acd242b5c93e20e093dd81a667a3d7c9764b5a40f4eee9242afa9dcc2e5de3d1{ .candidate = (zx_abi).value_zx_type_115_733f63291ddde64b1bc83a721ebf685a0d9d5fe955b56f62c3e2ecdaa3727384{ .children = ((operand_1).candidate).children, .fields = (zx_abi).value_zx_type_114_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .names = (((operand_1).candidate).fields).names, .types = (((operand_1).candidate).fields).types, .zx_origin = ((operand_1).candidate).fields, }, .first = ((operand_1).candidate).first, .kind = ((operand_1).candidate).kind, .label = ((operand_1).candidate).label, .names = ((operand_1).candidate).names, .second = ((operand_1).candidate).second, .zx_origin = (operand_1).candidate, }, .origin = (zx_abi).value_zx_type_123_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292{ .kind = ((operand_1).origin).kind, .member = ((operand_1).origin).member, .owner = ((operand_1).origin).owner, .zx_origin = (operand_1).origin, }, .origins = (zx_abi).value_zx_type_125_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .base = ((operand_1).origins).base, .delta = ((operand_1).origins).delta, .zx_origin = (operand_1).origins, }, .tables = (zx_abi).value_zx_type_112_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .base = ((operand_1).tables).base, .delta = ((operand_1).tables).delta, .zx_origin = (operand_1).tables, }, .zx_origin = operand_1, }));

        break :block_4 (if (((operand_2).zx_origin != null)) ((operand_2).zx_origin.?).* else block_3: {
            break :block_3 (zx_abi).zx_type_127{ .id = (operand_2).id, .status = (operand_2).status, };
        });
    };

    const value_2: u64 = (try function_8(allocator, (&value_1)));

    return value_2;
}
