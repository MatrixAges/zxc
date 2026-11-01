const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn callValue(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_057e50111bfa250342387d83a66d48e7af04e8fed236e4b8c0699205da05c08a) error{ IndexOutOfBounds, OutOfMemory, Overflow, }!(zx_abi).value_912a4a8fc24d14874528dc850925c7f2228a0995db064bc8c2fb361a41721320 {
    @setRuntimeSafety(true);

    const value_1: (zx_abi).zx_type_3a713b7f1a7f30d962aa6fe24fb9c2564ae93bb56dd45463864f9f4a742b599c = ((in).expressions).*;
    const value_2: u64 = (try (@import("zxc_module_03685fb27fcc6f02d805a9f9d6b50d67090f3367551a4132692450cae75d6f8d.zig")).call(allocator, (in).root));

    const value_3: (zx_abi).value_912a4a8fc24d14874528dc850925c7f2228a0995db064bc8c2fb361a41721320 = block_261: {
        const operand_257 = @as([]const u8, "");
        const operand_258 = @as(u64, 0);
        const operand_259 = @as(u64, 0);
        const operand_260 = @as([]const u8, "");

        break :block_261 @as((zx_abi).value_912a4a8fc24d14874528dc850925c7f2228a0995db064bc8c2fb361a41721320, (zx_abi).value_912a4a8fc24d14874528dc850925c7f2228a0995db064bc8c2fb361a41721320{ .code = operand_257, .start = operand_258, .end = operand_259, .message = operand_260, });
    };

    if ((block_250: {
        break :block_250 value_2;
    } >= @as(u64, ((block_251: {
        break :block_251 (&value_1);
    }).kinds).len))) {
        return block_256: {
            const operand_252 = @as([]const u8, "contract");
            const operand_253 = @as(u64, 0);
            const operand_254 = @as(u64, 0);
            const operand_255 = @as([]const u8, "constant expression root is out of bounds");

            break :block_256 @as((zx_abi).value_912a4a8fc24d14874528dc850925c7f2228a0995db064bc8c2fb361a41721320, (zx_abi).value_912a4a8fc24d14874528dc850925c7f2228a0995db064bc8c2fb361a41721320{ .code = operand_252, .start = operand_253, .end = operand_254, .message = operand_255, });
        };
    }

    return (block_249: {
        const operand_36 = block_35: {
            const operand_2 = block_3: {
                break :block_3 (&value_1);
            };
            const operand_4 = block_5: {
                break :block_5 value_2;
            };

            const operand_6 = (block_7: {
                break :block_7 value_2;
            } + @as(u64, 1));
            const operand_8 = block_33: {
                const value_5: []const (zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5 = (block_32: {
                    break :block_32 (&value_1);
                }).kinds;

                break :block_33 block_31: {
                    const operand_16 = block_15: {
                        const operand_10 = block_11: {
                            break :block_11 value_5;
                        };

                        const operand_12 = @as(u64, 0);

                        const operand_13 = block_14: {
                            break :block_14 (try (allocator).dupe(bool, (&[_]bool{})));
                        };

                        break :block_15 @as((zx_abi).value_3490a51121f47ba93f02724b04e2f8efba87c912caa0654c8a469aef9112f0c7, (zx_abi).value_3490a51121f47ba93f02724b04e2f8efba87c912caa0654c8a469aef9112f0c7{ .index = operand_12, .result = operand_13, .source = operand_10, });
                    };

                    var state_9: (zx_abi).value_3490a51121f47ba93f02724b04e2f8efba87c912caa0654c8a469aef9112f0c7 = operand_16;

                    while (((state_9).index < @as(u64, ((state_9).source).len))) {
                        state_9 = block_30: {
                            _ = block_29: {
                                const operand_27 = (state_9).source;
                                const operand_28 = (state_9).index;

                                if ((operand_28 >= (operand_27).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_29 (operand_27)[@intCast(operand_28)];
                            };

                            const value_9: bool = false;

                            break :block_30 block_26: {
                                const operand_17 = (state_9).source;
                                const operand_18 = ((state_9).index + @as(u64, 1));
                                const operand_19 = (block_25: {
                                    const operand_20 = (state_9).result;

                                    const operand_22 = block_21: {
                                        break :block_21 value_9;
                                    };

                                    const operand_23 = (try ((std).math).add(usize, (operand_20).len, 1));
                                    const operand_24 = (try (zx_abi).zxReserve(bool, allocator, operand_20, operand_23, true));

                                    (operand_24)[(operand_20).len] = operand_22;

                                    break :block_25 @as((zx_abi).value_6a282f8e7c0212f76daa60106fe90427f3ae895d34edd0dad552701c12a05ae2, .{ operand_24, {}, null, });
                                }).@"0";

                                break :block_26 @as((zx_abi).value_3490a51121f47ba93f02724b04e2f8efba87c912caa0654c8a469aef9112f0c7, (zx_abi).value_3490a51121f47ba93f02724b04e2f8efba87c912caa0654c8a469aef9112f0c7{ .index = operand_18, .result = operand_19, .source = operand_17, });
                            };
                        };
                    }

                    break :block_31 (state_9).result;
                };
            };

            const operand_34 = value_3;

            break :block_35 @as((zx_abi).value_b28da97ff2f12834ccb370df3a64853641b5fe1608f640e58f33e9b84a6db56d, (zx_abi).value_b28da97ff2f12834ccb370df3a64853641b5fe1608f640e58f33e9b84a6db56d{ .expressions = operand_2, .root = operand_4, .index = operand_6, .required = operand_8, .diagnostic = operand_34, });
        };

        var state_1: (zx_abi).value_b28da97ff2f12834ccb370df3a64853641b5fe1608f640e58f33e9b84a6db56d = operand_36;
        var state_changed_37 = false;

        while ((((state_1).index != @as(u64, 0)) and block_40: {
            const operand_38 = ((state_1).diagnostic).message;
            const operand_39 = @as([]const u8, "");

            break :block_40 ((std).mem).eql(u8, operand_38, operand_39);
        })) {
            state_1 = block_247: {
                const value_13: u64 = (state_1).index;

                const value_14: (zx_abi).value_b28da97ff2f12834ccb370df3a64853641b5fe1608f640e58f33e9b84a6db56d = block_246: {
                    break :block_246 @as((zx_abi).value_b28da97ff2f12834ccb370df3a64853641b5fe1608f640e58f33e9b84a6db56d, (zx_abi).value_b28da97ff2f12834ccb370df3a64853641b5fe1608f640e58f33e9b84a6db56d{ .diagnostic = (state_1).diagnostic, .expressions = (state_1).expressions, .index = (block_245: {
                        break :block_245 value_13;
                    } - @as(u64, 1)), .required = (state_1).required, .root = (state_1).root, });
                };

                const value_15: u64 = (value_14).index;

                const value_66: (zx_abi).value_b28da97ff2f12834ccb370df3a64853641b5fe1608f640e58f33e9b84a6db56d = (if (((block_41: {
                    break :block_41 value_15;
                } == (value_14).root) or block_45: {
                    const operand_43 = (value_14).required;

                    const operand_44 = block_42: {
                        break :block_42 value_15;
                    };

                    if ((operand_44 >= (operand_43).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_45 (operand_43)[@intCast(operand_44)];
                })) block_244: {
                    const value_16: (zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5 = block_243: {
                        const operand_241 = ((value_14).expressions).kinds;

                        const operand_242 = block_240: {
                            break :block_240 value_15;
                        };

                        if ((operand_242 >= (operand_241).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_243 (operand_241)[@intCast(operand_242)];
                    };
                    const value_17: u64 = (try (@import("zxc_module_03685fb27fcc6f02d805a9f9d6b50d67090f3367551a4132692450cae75d6f8d.zig")).call(allocator, block_239: {
                        const operand_237 = ((value_14).expressions).payloads;

                        const operand_238 = block_236: {
                            break :block_236 value_15;
                        };

                        if ((operand_238 >= (operand_237).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_239 (operand_237)[@intCast(operand_238)];
                    }));

                    const value_18: bool = ((((((block_230: {
                        break :block_230 value_16;
                    } == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Integer)) or (block_231: {
                        break :block_231 value_16;
                    } == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .NegativeInteger))) or (block_232: {
                        break :block_232 value_16;
                    } == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Float))) or (block_233: {
                        break :block_233 value_16;
                    } == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .String))) or (block_234: {
                        break :block_234 value_16;
                    } == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Boolean))) or (block_235: {
                        break :block_235 value_16;
                    } == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .EnumValue)));

                    const value_19: bool = ((block_228: {
                        break :block_228 value_16;
                    } == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Unary)) or (block_229: {
                        break :block_229 value_16;
                    } == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Binary)));

                    const value_20: bool = ((block_226: {
                        break :block_226 value_16;
                    } == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Conditional)) or (block_227: {
                        break :block_227 value_16;
                    } == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Match)));

                    const value_21: bool = ((block_221: {
                        break :block_221 value_16;
                    } == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Binary)) and (block_225: {
                        const operand_223 = ((value_14).expressions).binary_operators;

                        const operand_224 = block_222: {
                            break :block_222 value_17;
                        };

                        if ((operand_224 >= (operand_223).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_225 (operand_223)[@intCast(operand_224)];
                    } == @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .Coalesce)));

                    const value_23: (zx_abi).value_b28da97ff2f12834ccb370df3a64853641b5fe1608f640e58f33e9b84a6db56d = (if (((((!block_202: {
                        break :block_202 value_18;
                    }) and (!block_203: {
                        break :block_203 value_19;
                    })) and (!block_204: {
                        break :block_204 value_20;
                    })) or block_205: {
                        break :block_205 value_21;
                    })) block_220: {
                        const value_22: (zx_abi).value_b28da97ff2f12834ccb370df3a64853641b5fe1608f640e58f33e9b84a6db56d = block_219: {
                            break :block_219 @as((zx_abi).value_b28da97ff2f12834ccb370df3a64853641b5fe1608f640e58f33e9b84a6db56d, (zx_abi).value_b28da97ff2f12834ccb370df3a64853641b5fe1608f640e58f33e9b84a6db56d{ .diagnostic = block_218: {
                                const operand_206 = @as([]const u8, "unsupported");
                                const operand_207 = block_211: {
                                    const operand_209 = ((value_14).expressions).span_start;

                                    const operand_210 = block_208: {
                                        break :block_208 value_15;
                                    };

                                    if ((operand_210 >= (operand_209).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    break :block_211 (operand_209)[@intCast(operand_210)];
                                };
                                const operand_212 = block_216: {
                                    const operand_214 = ((value_14).expressions).span_end;

                                    const operand_215 = block_213: {
                                        break :block_213 value_15;
                                    };

                                    if ((operand_215 >= (operand_214).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    break :block_216 (operand_214)[@intCast(operand_215)];
                                };
                                const operand_217 = @as([]const u8, "constant initializers require closed scalar expressions");

                                break :block_218 @as((zx_abi).value_912a4a8fc24d14874528dc850925c7f2228a0995db064bc8c2fb361a41721320, (zx_abi).value_912a4a8fc24d14874528dc850925c7f2228a0995db064bc8c2fb361a41721320{ .code = operand_206, .start = operand_207, .end = operand_212, .message = operand_217, });
                            }, .expressions = (value_14).expressions, .index = (value_14).index, .required = (value_14).required, .root = (value_14).root, });
                        };

                        break :block_220 value_22;
                    } else value_14);

                    const value_27: (zx_abi).value_b28da97ff2f12834ccb370df3a64853641b5fe1608f640e58f33e9b84a6db56d = (if ((block_188: {
                        break :block_188 value_16;
                    } == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Unary))) block_201: {
                        const value_24: []const bool = (value_23).required;

                        const value_25: u64 = (try (@import("zxc_module_03685fb27fcc6f02d805a9f9d6b50d67090f3367551a4132692450cae75d6f8d.zig")).call(allocator, block_200: {
                            const operand_198 = ((value_23).expressions).unary_operands;

                            const operand_199 = block_197: {
                                break :block_197 value_17;
                            };

                            if ((operand_199 >= (operand_198).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_200 (operand_198)[@intCast(operand_199)];
                        }));

                        const value_26: (zx_abi).value_b28da97ff2f12834ccb370df3a64853641b5fe1608f640e58f33e9b84a6db56d = block_196: {
                            break :block_196 @as((zx_abi).value_b28da97ff2f12834ccb370df3a64853641b5fe1608f640e58f33e9b84a6db56d, (zx_abi).value_b28da97ff2f12834ccb370df3a64853641b5fe1608f640e58f33e9b84a6db56d{ .diagnostic = (value_23).diagnostic, .expressions = (value_23).expressions, .index = (value_23).index, .required = block_195: {
                                const operand_190 = block_189: {
                                    break :block_189 value_24;
                                };
                                const operand_192 = block_191: {
                                    break :block_191 value_25;
                                };

                                if ((operand_192 >= (operand_190).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                const operand_193 = true;
                                const operand_194 = @constCast(operand_190);

                                (operand_194)[@intCast(operand_192)] = operand_193;

                                break :block_195 operand_194;
                            }, .root = (value_23).root, });
                        };

                        break :block_201 value_26;
                    } else value_23);

                    const value_34: (zx_abi).value_b28da97ff2f12834ccb370df3a64853641b5fe1608f640e58f33e9b84a6db56d = (if ((block_162: {
                        break :block_162 value_16;
                    } == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Binary))) block_187: {
                        const value_28: []const bool = (value_27).required;

                        const value_29: u64 = (try (@import("zxc_module_03685fb27fcc6f02d805a9f9d6b50d67090f3367551a4132692450cae75d6f8d.zig")).call(allocator, block_186: {
                            const operand_184 = ((value_27).expressions).binary_left;

                            const operand_185 = block_183: {
                                break :block_183 value_17;
                            };

                            if ((operand_185 >= (operand_184).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_186 (operand_184)[@intCast(operand_185)];
                        }));

                        const value_30: (zx_abi).value_b28da97ff2f12834ccb370df3a64853641b5fe1608f640e58f33e9b84a6db56d = block_182: {
                            break :block_182 @as((zx_abi).value_b28da97ff2f12834ccb370df3a64853641b5fe1608f640e58f33e9b84a6db56d, (zx_abi).value_b28da97ff2f12834ccb370df3a64853641b5fe1608f640e58f33e9b84a6db56d{ .diagnostic = (value_27).diagnostic, .expressions = (value_27).expressions, .index = (value_27).index, .required = block_181: {
                                const operand_176 = block_175: {
                                    break :block_175 value_28;
                                };
                                const operand_178 = block_177: {
                                    break :block_177 value_29;
                                };

                                if ((operand_178 >= (operand_176).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                const operand_179 = true;
                                const operand_180 = @constCast(operand_176);

                                (operand_180)[@intCast(operand_178)] = operand_179;

                                break :block_181 operand_180;
                            }, .root = (value_27).root, });
                        };
                        const value_31: []const bool = (value_30).required;

                        const value_32: u64 = (try (@import("zxc_module_03685fb27fcc6f02d805a9f9d6b50d67090f3367551a4132692450cae75d6f8d.zig")).call(allocator, block_174: {
                            const operand_172 = ((value_30).expressions).binary_right;

                            const operand_173 = block_171: {
                                break :block_171 value_17;
                            };

                            if ((operand_173 >= (operand_172).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_174 (operand_172)[@intCast(operand_173)];
                        }));

                        const value_33: (zx_abi).value_b28da97ff2f12834ccb370df3a64853641b5fe1608f640e58f33e9b84a6db56d = block_170: {
                            break :block_170 @as((zx_abi).value_b28da97ff2f12834ccb370df3a64853641b5fe1608f640e58f33e9b84a6db56d, (zx_abi).value_b28da97ff2f12834ccb370df3a64853641b5fe1608f640e58f33e9b84a6db56d{ .diagnostic = (value_30).diagnostic, .expressions = (value_30).expressions, .index = (value_30).index, .required = block_169: {
                                const operand_164 = block_163: {
                                    break :block_163 value_31;
                                };
                                const operand_166 = block_165: {
                                    break :block_165 value_32;
                                };

                                if ((operand_166 >= (operand_164).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                const operand_167 = true;
                                const operand_168 = @constCast(operand_164);

                                (operand_168)[@intCast(operand_166)] = operand_167;

                                break :block_169 operand_168;
                            }, .root = (value_30).root, });
                        };

                        break :block_187 value_33;
                    } else value_27);

                    const value_44: (zx_abi).value_b28da97ff2f12834ccb370df3a64853641b5fe1608f640e58f33e9b84a6db56d = (if ((block_124: {
                        break :block_124 value_16;
                    } == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Conditional))) block_161: {
                        const value_35: []const bool = (value_34).required;

                        const value_36: u64 = (try (@import("zxc_module_03685fb27fcc6f02d805a9f9d6b50d67090f3367551a4132692450cae75d6f8d.zig")).call(allocator, block_160: {
                            const operand_158 = ((value_34).expressions).conditional_conditions;

                            const operand_159 = block_157: {
                                break :block_157 value_17;
                            };

                            if ((operand_159 >= (operand_158).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_160 (operand_158)[@intCast(operand_159)];
                        }));

                        const value_37: (zx_abi).value_b28da97ff2f12834ccb370df3a64853641b5fe1608f640e58f33e9b84a6db56d = block_156: {
                            break :block_156 @as((zx_abi).value_b28da97ff2f12834ccb370df3a64853641b5fe1608f640e58f33e9b84a6db56d, (zx_abi).value_b28da97ff2f12834ccb370df3a64853641b5fe1608f640e58f33e9b84a6db56d{ .diagnostic = (value_34).diagnostic, .expressions = (value_34).expressions, .index = (value_34).index, .required = block_155: {
                                const operand_150 = block_149: {
                                    break :block_149 value_35;
                                };
                                const operand_152 = block_151: {
                                    break :block_151 value_36;
                                };

                                if ((operand_152 >= (operand_150).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                const operand_153 = true;
                                const operand_154 = @constCast(operand_150);

                                (operand_154)[@intCast(operand_152)] = operand_153;

                                break :block_155 operand_154;
                            }, .root = (value_34).root, });
                        };
                        const value_38: []const bool = (value_37).required;

                        const value_39: u64 = (try (@import("zxc_module_03685fb27fcc6f02d805a9f9d6b50d67090f3367551a4132692450cae75d6f8d.zig")).call(allocator, block_148: {
                            const operand_146 = ((value_37).expressions).conditional_yes;

                            const operand_147 = block_145: {
                                break :block_145 value_17;
                            };

                            if ((operand_147 >= (operand_146).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_148 (operand_146)[@intCast(operand_147)];
                        }));

                        const value_40: (zx_abi).value_b28da97ff2f12834ccb370df3a64853641b5fe1608f640e58f33e9b84a6db56d = block_144: {
                            break :block_144 @as((zx_abi).value_b28da97ff2f12834ccb370df3a64853641b5fe1608f640e58f33e9b84a6db56d, (zx_abi).value_b28da97ff2f12834ccb370df3a64853641b5fe1608f640e58f33e9b84a6db56d{ .diagnostic = (value_37).diagnostic, .expressions = (value_37).expressions, .index = (value_37).index, .required = block_143: {
                                const operand_138 = block_137: {
                                    break :block_137 value_38;
                                };
                                const operand_140 = block_139: {
                                    break :block_139 value_39;
                                };

                                if ((operand_140 >= (operand_138).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                const operand_141 = true;
                                const operand_142 = @constCast(operand_138);
                                (operand_142)[@intCast(operand_140)] = operand_141;

                                break :block_143 operand_142;
                            }, .root = (value_37).root, });
                        };
                        const value_41: []const bool = (value_40).required;

                        const value_42: u64 = (try (@import("zxc_module_03685fb27fcc6f02d805a9f9d6b50d67090f3367551a4132692450cae75d6f8d.zig")).call(allocator, block_136: {
                            const operand_134 = ((value_40).expressions).conditional_no;

                            const operand_135 = block_133: {
                                break :block_133 value_17;
                            };

                            if ((operand_135 >= (operand_134).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_136 (operand_134)[@intCast(operand_135)];
                        }));

                        const value_43: (zx_abi).value_b28da97ff2f12834ccb370df3a64853641b5fe1608f640e58f33e9b84a6db56d = block_132: {
                            break :block_132 @as((zx_abi).value_b28da97ff2f12834ccb370df3a64853641b5fe1608f640e58f33e9b84a6db56d, (zx_abi).value_b28da97ff2f12834ccb370df3a64853641b5fe1608f640e58f33e9b84a6db56d{ .diagnostic = (value_40).diagnostic, .expressions = (value_40).expressions, .index = (value_40).index, .required = block_131: {
                                const operand_126 = block_125: {
                                    break :block_125 value_41;
                                };
                                const operand_128 = block_127: {
                                    break :block_127 value_42;
                                };

                                if ((operand_128 >= (operand_126).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                const operand_129 = true;
                                const operand_130 = @constCast(operand_126);

                                (operand_130)[@intCast(operand_128)] = operand_129;

                                break :block_131 operand_130;
                            }, .root = (value_40).root, });
                        };

                        break :block_161 value_43;
                    } else value_34);

                    const value_65: (zx_abi).value_b28da97ff2f12834ccb370df3a64853641b5fe1608f640e58f33e9b84a6db56d = (if ((block_46: {
                        break :block_46 value_16;
                    } == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Match))) block_123: {
                        const value_45: ?u32 = block_122: {
                            const operand_120 = ((value_44).expressions).match_subjects;

                            const operand_121 = block_119: {
                                break :block_119 value_17;
                            };

                            if ((operand_121 >= (operand_120).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_122 (operand_120)[@intCast(operand_121)];
                        };
                        const value_49: (zx_abi).value_b28da97ff2f12834ccb370df3a64853641b5fe1608f640e58f33e9b84a6db56d = (if ((block_108: {
                            break :block_108 value_45;
                        } != null)) block_118: {
                            const value_46: []const bool = (value_44).required;

                            const value_47: u64 = (try (@import("zxc_module_03685fb27fcc6f02d805a9f9d6b50d67090f3367551a4132692450cae75d6f8d.zig")).call(allocator, block_117: {
                                break :block_117 value_45;
                            }.?));

                            const value_48: (zx_abi).value_b28da97ff2f12834ccb370df3a64853641b5fe1608f640e58f33e9b84a6db56d = block_116: {
                                break :block_116 @as((zx_abi).value_b28da97ff2f12834ccb370df3a64853641b5fe1608f640e58f33e9b84a6db56d, (zx_abi).value_b28da97ff2f12834ccb370df3a64853641b5fe1608f640e58f33e9b84a6db56d{ .diagnostic = (value_44).diagnostic, .expressions = (value_44).expressions, .index = (value_44).index, .required = block_115: {
                                    const operand_110 = block_109: {
                                        break :block_109 value_46;
                                    };
                                    const operand_112 = block_111: {
                                        break :block_111 value_47;
                                    };

                                    if ((operand_112 >= (operand_110).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    const operand_113 = true;
                                    const operand_114 = @constCast(operand_110);

                                    (operand_114)[@intCast(operand_112)] = operand_113;

                                    break :block_115 operand_114;
                                }, .root = (value_44).root, });
                            };

                            break :block_118 value_48;
                        } else value_44);

                        const value_50: []const bool = (value_49).required;

                        const value_51: u64 = (try (@import("zxc_module_03685fb27fcc6f02d805a9f9d6b50d67090f3367551a4132692450cae75d6f8d.zig")).call(allocator, block_107: {
                            const operand_105 = ((value_49).expressions).match_fallbacks;

                            const operand_106 = block_104: {
                                break :block_104 value_17;
                            };

                            if ((operand_106 >= (operand_105).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_107 (operand_105)[@intCast(operand_106)];
                        }));

                        const value_52: (zx_abi).value_b28da97ff2f12834ccb370df3a64853641b5fe1608f640e58f33e9b84a6db56d = block_103: {
                            break :block_103 @as((zx_abi).value_b28da97ff2f12834ccb370df3a64853641b5fe1608f640e58f33e9b84a6db56d, (zx_abi).value_b28da97ff2f12834ccb370df3a64853641b5fe1608f640e58f33e9b84a6db56d{ .diagnostic = (value_49).diagnostic, .expressions = (value_49).expressions, .index = (value_49).index, .required = block_102: {
                                const operand_97 = block_96: {
                                    break :block_96 value_50;
                                };
                                const operand_99 = block_98: {
                                    break :block_98 value_51;
                                };

                                if ((operand_99 >= (operand_97).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                const operand_100 = true;
                                const operand_101 = @constCast(operand_97);

                                (operand_101)[@intCast(operand_99)] = operand_100;
                                break :block_102 operand_101;
                            }, .root = (value_49).root, });
                        };
                        const value_63: (zx_abi).value_a2e27c18be4dccc59709ceb855bedc804c1f225f9042d2ec8b0588c3d96ec7fa = block_95: {
                            const operand_67 = block_66: {
                                const operand_49 = (value_52).required;
                                const operand_50 = ((value_52).expressions).match_conditions;
                                const operand_51 = ((value_52).expressions).match_results;

                                const operand_52 = (try (@import("zxc_module_03685fb27fcc6f02d805a9f9d6b50d67090f3367551a4132692450cae75d6f8d.zig")).call(allocator, block_56: {
                                    const operand_54 = ((value_52).expressions).match_first;
                                    const operand_55 = block_53: {
                                        break :block_53 value_17;
                                    };

                                    if ((operand_55 >= (operand_54).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    break :block_56 (operand_54)[@intCast(operand_55)];
                                }));
                                const operand_57 = ((try (@import("zxc_module_03685fb27fcc6f02d805a9f9d6b50d67090f3367551a4132692450cae75d6f8d.zig")).call(allocator, block_61: {
                                    const operand_59 = ((value_52).expressions).match_first;

                                    const operand_60 = block_58: {
                                        break :block_58 value_17;
                                    };

                                    if ((operand_60 >= (operand_59).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    break :block_61 (operand_59)[@intCast(operand_60)];
                                })) + (try (@import("zxc_module_03685fb27fcc6f02d805a9f9d6b50d67090f3367551a4132692450cae75d6f8d.zig")).call(allocator, block_65: {
                                    const operand_63 = ((value_52).expressions).match_count;

                                    const operand_64 = block_62: {
                                        break :block_62 value_17;
                                    };

                                    if ((operand_64 >= (operand_63).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    break :block_65 (operand_63)[@intCast(operand_64)];
                                })));

                                break :block_66 @as((zx_abi).value_a2e27c18be4dccc59709ceb855bedc804c1f225f9042d2ec8b0588c3d96ec7fa, (zx_abi).value_a2e27c18be4dccc59709ceb855bedc804c1f225f9042d2ec8b0588c3d96ec7fa{ .required = operand_49, .conditions = operand_50, .results = operand_51, .index = operand_52, .end = operand_57, });
                            };
                            var state_48: (zx_abi).value_a2e27c18be4dccc59709ceb855bedc804c1f225f9042d2ec8b0588c3d96ec7fa = operand_67;
                            var state_changed_68 = false;

                            while (((state_48).index < (state_48).end)) {
                                state_48 = block_93: {
                                    const value_55: []const bool = (state_48).required;

                                    const value_56: u64 = (try (@import("zxc_module_03685fb27fcc6f02d805a9f9d6b50d67090f3367551a4132692450cae75d6f8d.zig")).call(allocator, block_92: {
                                        const operand_90 = (state_48).conditions;
                                        const operand_91 = (state_48).index;

                                        if ((operand_91 >= (operand_90).len)) {
                                            return error.IndexOutOfBounds;
                                        }

                                        break :block_92 (operand_90)[@intCast(operand_91)];
                                    }));
                                    const value_57: (zx_abi).value_a2e27c18be4dccc59709ceb855bedc804c1f225f9042d2ec8b0588c3d96ec7fa = block_89: {
                                        break :block_89 @as((zx_abi).value_a2e27c18be4dccc59709ceb855bedc804c1f225f9042d2ec8b0588c3d96ec7fa, (zx_abi).value_a2e27c18be4dccc59709ceb855bedc804c1f225f9042d2ec8b0588c3d96ec7fa{ .conditions = (state_48).conditions, .end = (state_48).end, .index = (state_48).index, .required = block_88: {
                                            const operand_83 = block_82: {
                                                break :block_82 value_55;
                                            };
                                            const operand_85 = block_84: {
                                                break :block_84 value_56;
                                            };

                                            if ((operand_85 >= (operand_83).len)) {
                                                return error.IndexOutOfBounds;
                                            }

                                            const operand_86 = true;
                                            const operand_87 = @constCast(operand_83);

                                            (operand_87)[@intCast(operand_85)] = operand_86;

                                            break :block_88 operand_87;
                                        }, .results = (state_48).results, });
                                    };
                                    const value_58: []const bool = (value_57).required;

                                    const value_59: u64 = (try (@import("zxc_module_03685fb27fcc6f02d805a9f9d6b50d67090f3367551a4132692450cae75d6f8d.zig")).call(allocator, block_81: {
                                        const operand_79 = (value_57).results;
                                        const operand_80 = (value_57).index;

                                        if ((operand_80 >= (operand_79).len)) {
                                            return error.IndexOutOfBounds;
                                        }

                                        break :block_81 (operand_79)[@intCast(operand_80)];
                                    }));
                                    const value_60: (zx_abi).value_a2e27c18be4dccc59709ceb855bedc804c1f225f9042d2ec8b0588c3d96ec7fa = block_78: {
                                        break :block_78 @as((zx_abi).value_a2e27c18be4dccc59709ceb855bedc804c1f225f9042d2ec8b0588c3d96ec7fa, (zx_abi).value_a2e27c18be4dccc59709ceb855bedc804c1f225f9042d2ec8b0588c3d96ec7fa{ .conditions = (value_57).conditions, .end = (value_57).end, .index = (value_57).index, .required = block_77: {
                                            const operand_72 = block_71: {
                                                break :block_71 value_58;
                                            };
                                            const operand_74 = block_73: {
                                                break :block_73 value_59;
                                            };

                                            if ((operand_74 >= (operand_72).len)) {
                                                return error.IndexOutOfBounds;
                                            }

                                            const operand_75 = true;
                                            const operand_76 = @constCast(operand_72);
                                            (operand_76)[@intCast(operand_74)] = operand_75;
                                            break :block_77 operand_76;
                                        }, .results = (value_57).results, });
                                    };
                                    const value_61: u64 = (value_60).index;

                                    const value_62: (zx_abi).value_a2e27c18be4dccc59709ceb855bedc804c1f225f9042d2ec8b0588c3d96ec7fa = block_70: {
                                        break :block_70 @as((zx_abi).value_a2e27c18be4dccc59709ceb855bedc804c1f225f9042d2ec8b0588c3d96ec7fa, (zx_abi).value_a2e27c18be4dccc59709ceb855bedc804c1f225f9042d2ec8b0588c3d96ec7fa{ .conditions = (value_60).conditions, .end = (value_60).end, .index = (block_69: {
                                            break :block_69 value_61;
                                        } + @as(u64, 1)), .required = (value_60).required, .results = (value_60).results, });
                                    };

                                    break :block_93 value_62;
                                };

                                state_changed_68 = true;
                            }

                            break :block_95 (if (state_changed_68) state_48 else operand_67);
                        };

                        const value_64: (zx_abi).value_b28da97ff2f12834ccb370df3a64853641b5fe1608f640e58f33e9b84a6db56d = block_47: {
                            break :block_47 @as((zx_abi).value_b28da97ff2f12834ccb370df3a64853641b5fe1608f640e58f33e9b84a6db56d, (zx_abi).value_b28da97ff2f12834ccb370df3a64853641b5fe1608f640e58f33e9b84a6db56d{ .diagnostic = (value_52).diagnostic, .expressions = (value_52).expressions, .index = (value_52).index, .required = (value_63).required, .root = (value_52).root, });
                        };

                        break :block_123 value_64;
                    } else value_44);

                    break :block_244 value_65;
                } else value_14);

                break :block_247 value_66;
            };

            state_changed_37 = true;
        }

        break :block_249 (if (state_changed_37) state_1 else operand_36);
    }).diagnostic;
}

