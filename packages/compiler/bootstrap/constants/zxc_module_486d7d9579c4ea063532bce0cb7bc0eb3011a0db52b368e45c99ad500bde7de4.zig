const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn callValue(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_b22857c6d80394aafb96a5095c5262fe2a0bc132890c2999fadf486eda660b6f) error{ IndexOutOfBounds, OutOfMemory, Overflow, }!(zx_abi).value_796a3ab69572c0f62968f53a3980c48892357c21acd7d69f07657b6bccae24de {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_7172f221b5abe933ec705af5a9f87a7f7b6db5c720117ee4399833dfc85d12fb = (in).expressions;
    const value_2: u64 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, (in).root));

    const value_3: (zx_abi).value_796a3ab69572c0f62968f53a3980c48892357c21acd7d69f07657b6bccae24de = block_282: {
        const operand_278 = @as([]const u8, "");
        const operand_279 = @as(u64, 0);
        const operand_280 = @as(u64, 0);
        const operand_281 = @as([]const u8, "");

        break :block_282 @as((zx_abi).value_796a3ab69572c0f62968f53a3980c48892357c21acd7d69f07657b6bccae24de, (zx_abi).value_796a3ab69572c0f62968f53a3980c48892357c21acd7d69f07657b6bccae24de{ .code = operand_278, .start = operand_279, .end = operand_280, .message = operand_281, });
    };

    if ((block_271: {
        break :block_271 value_2;
    } >= @as(u64, ((block_272: {
        break :block_272 value_1;
    }).kinds).len))) {
        return block_277: {
            const operand_273 = @as([]const u8, "contract");
            const operand_274 = @as(u64, 0);
            const operand_275 = @as(u64, 0);
            const operand_276 = @as([]const u8, "constant expression root is out of bounds");

            break :block_277 @as((zx_abi).value_796a3ab69572c0f62968f53a3980c48892357c21acd7d69f07657b6bccae24de, (zx_abi).value_796a3ab69572c0f62968f53a3980c48892357c21acd7d69f07657b6bccae24de{ .code = operand_273, .start = operand_274, .end = operand_275, .message = operand_276, });
        };
    }

    return (block_270: {
        const operand_42 = block_41: {
            const operand_2 = block_3: {
                break :block_3 value_1;
            };
            const operand_4 = block_5: {
                break :block_5 value_2;
            };

            const operand_6 = (block_7: {
                break :block_7 value_2;
            } + @as(u64, 1));
            const operand_8 = block_39: {
                const value_5: (zx_abi).value_b749f46f9933b921e9ebd0358cdb7d25caa0da1a70c6752e94602a4c2fe1d9ba = (zx_abi).value_b749f46f9933b921e9ebd0358cdb7d25caa0da1a70c6752e94602a4c2fe1d9ba{ .items = (block_38: {
                    break :block_38 value_1;
                }).kinds, .headered = false, };

                break :block_39 block_37: {
                    const operand_15 = block_14: {
                        const operand_10 = value_5;
                        const operand_11 = @as(u64, 0);

                        const operand_12 = block_13: {
                            break :block_13 (zx_abi).value_6be18e6b8bff66e51366ca4eca851d93b716a0e9a2a911a6ac6eee34ab0f9e90{ .items = (&[_]bool{}), .headered = false, };
                        };

                        break :block_14 @as((zx_abi).value_f4eb87a03bc05a23dde3105c1a45777786d2fa256f6f7c64c15a2585268c8c00, (zx_abi).value_f4eb87a03bc05a23dde3105c1a45777786d2fa256f6f7c64c15a2585268c8c00{ .index = operand_11, .result = operand_12, .source = operand_10, });
                    };
                    const loop_fields_17 = struct {
                        index: u64,
                        result: (zx_abi).value_6be18e6b8bff66e51366ca4eca851d93b716a0e9a2a911a6ac6eee34ab0f9e90,
                        source: *const (zx_abi).value_b749f46f9933b921e9ebd0358cdb7d25caa0da1a70c6752e94602a4c2fe1d9ba,
                        zx_origin: ?*const (zx_abi).zx_type_f7c04f634ae5b2093751e64fbcd14059ec3f0109817b535637410782abe2f29d = null,
                    };

                    const loop_seed_16: (zx_abi).value_f4eb87a03bc05a23dde3105c1a45777786d2fa256f6f7c64c15a2585268c8c00 = operand_15;

                    break :block_37 (if (((loop_seed_16).index < @as(u64, (((loop_seed_16).source).items).len))) block_35: {
                        var state_9: loop_fields_17 = loop_fields_17{ .index = (loop_seed_16).index, .result = (loop_seed_16).result, .source = (&(loop_seed_16).source), .zx_origin = (loop_seed_16).zx_origin, };

                        while (true) {
                            state_9 = block_33: {
                                _ = block_32: {
                                    const operand_30 = (((state_9).source).*).items;
                                    const operand_31 = (state_9).index;

                                    if ((operand_31 >= (operand_30).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    break :block_32 (operand_30)[@intCast(operand_31)];
                                };
                                const value_9: bool = false;

                                break :block_33 block_29: {
                                    const operand_18 = ((state_9).source).*;
                                    const operand_19 = ((state_9).index + @as(u64, 1));

                                    const operand_20 = (block_27: {
                                        const operand_21 = (state_9).result;
                                        const operand_23 = block_22: {
                                            break :block_22 value_9;
                                        };

                                        const operand_24 = (try ((std).math).add(usize, ((operand_21).items).len, 1));

                                        break :block_27 @as((zx_abi).value_54590184f9eb36a4fbb5d772684604367e64a000990366136f68960087bda66c, .{ block_26: {
                                            const operand_25 = (try (zx_abi).zxReserve(bool, allocator, (operand_21).items, operand_24, true));

                                            (operand_25)[((operand_21).items).len] = operand_23;

                                            break :block_26 (zx_abi).value_6be18e6b8bff66e51366ca4eca851d93b716a0e9a2a911a6ac6eee34ab0f9e90{ .items = operand_25, .headered = true, };
                                        }, {}, null, });
                                    }).@"0";

                                    break :block_29 loop_fields_17{ .index = operand_19, .result = operand_20, .source = block_28: {
                                        _ = operand_18;

                                        break :block_28 (&(loop_seed_16).source);
                                    }, };
                                };
                            };

                            if ((!((state_9).index < @as(u64, ((((state_9).source).*).items).len)))) {
                                break;
                            }
                        }

                        const operand_34 = (zx_abi).value_f4eb87a03bc05a23dde3105c1a45777786d2fa256f6f7c64c15a2585268c8c00{ .index = (state_9).index, .result = (state_9).result, .source = ((state_9).source).*, .zx_origin = (state_9).zx_origin, };

                        break :block_35 (operand_34).result;
                    } else block_36: {
                        break :block_36 (loop_seed_16).result;
                    });
                };
            };

            const operand_40 = value_3;

            break :block_41 @as((zx_abi).value_3fcd3cda3c6203af2b98cb418207400fe9111d792353388c1180701c2f5358c5, (zx_abi).value_3fcd3cda3c6203af2b98cb418207400fe9111d792353388c1180701c2f5358c5{ .expressions = operand_2, .root = operand_4, .index = operand_6, .required = operand_8, .diagnostic = operand_40, });
        };

        var state_1: (zx_abi).value_3fcd3cda3c6203af2b98cb418207400fe9111d792353388c1180701c2f5358c5 = operand_42;
        var state_changed_44 = false;

        while ((((state_1).index != @as(u64, 0)) and block_47: {
            const operand_45 = ((state_1).diagnostic).message;
            const operand_46 = @as([]const u8, "");

            break :block_47 ((std).mem).eql(u8, operand_45, operand_46);
        })) {
            const operand_257 = block_256: {
                const value_13: u64 = (state_1).index;

                const value_14: (zx_abi).value_3fcd3cda3c6203af2b98cb418207400fe9111d792353388c1180701c2f5358c5 = block_255: {
                    break :block_255 @as((zx_abi).value_3fcd3cda3c6203af2b98cb418207400fe9111d792353388c1180701c2f5358c5, (zx_abi).value_3fcd3cda3c6203af2b98cb418207400fe9111d792353388c1180701c2f5358c5{ .diagnostic = (state_1).diagnostic, .expressions = (state_1).expressions, .index = (block_254: {
                        break :block_254 value_13;
                    } - @as(u64, 1)), .required = (state_1).required, .root = (state_1).root, });
                };

                const value_15: u64 = (value_14).index;

                const value_66: (zx_abi).value_3fcd3cda3c6203af2b98cb418207400fe9111d792353388c1180701c2f5358c5 = (if (((block_48: {
                    break :block_48 value_15;
                } == (value_14).root) or block_52: {
                    const operand_50 = ((value_14).required).items;

                    const operand_51 = block_49: {
                        break :block_49 value_15;
                    };

                    if ((operand_51 >= (operand_50).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_52 (operand_50)[@intCast(operand_51)];
                })) block_253: {
                    const value_16: (zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5 = block_252: {
                        const operand_250 = ((value_14).expressions).kinds;

                        const operand_251 = block_249: {
                            break :block_249 value_15;
                        };

                        if ((operand_251 >= (operand_250).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_252 (operand_250)[@intCast(operand_251)];
                    };
                    const value_17: u64 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, block_248: {
                        const operand_246 = ((value_14).expressions).payloads;

                        const operand_247 = block_245: {
                            break :block_245 value_15;
                        };

                        if ((operand_247 >= (operand_246).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_248 (operand_246)[@intCast(operand_247)];
                    }));

                    const value_18: bool = ((((((block_239: {
                        break :block_239 value_16;
                    } == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Integer)) or (block_240: {
                        break :block_240 value_16;
                    } == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .NegativeInteger))) or (block_241: {
                        break :block_241 value_16;
                    } == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Float))) or (block_242: {
                        break :block_242 value_16;
                    } == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .String))) or (block_243: {
                        break :block_243 value_16;
                    } == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Boolean))) or (block_244: {
                        break :block_244 value_16;
                    } == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .EnumValue)));

                    const value_19: bool = ((block_237: {
                        break :block_237 value_16;
                    } == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Unary)) or (block_238: {
                        break :block_238 value_16;
                    } == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Binary)));

                    const value_20: bool = ((block_235: {
                        break :block_235 value_16;
                    } == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Conditional)) or (block_236: {
                        break :block_236 value_16;
                    } == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Match)));

                    const value_21: bool = ((block_230: {
                        break :block_230 value_16;
                    } == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Binary)) and (block_234: {
                        const operand_232 = ((value_14).expressions).binary_operators;

                        const operand_233 = block_231: {
                            break :block_231 value_17;
                        };

                        if ((operand_233 >= (operand_232).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_234 (operand_232)[@intCast(operand_233)];
                    } == @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .Coalesce)));

                    const value_23: (zx_abi).value_3fcd3cda3c6203af2b98cb418207400fe9111d792353388c1180701c2f5358c5 = (if (((((!block_211: {
                        break :block_211 value_18;
                    }) and (!block_212: {
                        break :block_212 value_19;
                    })) and (!block_213: {
                        break :block_213 value_20;
                    })) or block_214: {
                        break :block_214 value_21;
                    })) block_229: {
                        const value_22: (zx_abi).value_3fcd3cda3c6203af2b98cb418207400fe9111d792353388c1180701c2f5358c5 = block_228: {
                            break :block_228 @as((zx_abi).value_3fcd3cda3c6203af2b98cb418207400fe9111d792353388c1180701c2f5358c5, (zx_abi).value_3fcd3cda3c6203af2b98cb418207400fe9111d792353388c1180701c2f5358c5{ .diagnostic = block_227: {
                                const operand_215 = @as([]const u8, "unsupported");

                                const operand_216 = block_220: {
                                    const operand_218 = ((value_14).expressions).span_start;

                                    const operand_219 = block_217: {
                                        break :block_217 value_15;
                                    };

                                    if ((operand_219 >= (operand_218).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    break :block_220 (operand_218)[@intCast(operand_219)];
                                };
                                const operand_221 = block_225: {
                                    const operand_223 = ((value_14).expressions).span_end;

                                    const operand_224 = block_222: {
                                        break :block_222 value_15;
                                    };

                                    if ((operand_224 >= (operand_223).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    break :block_225 (operand_223)[@intCast(operand_224)];
                                };
                                const operand_226 = @as([]const u8, "constant initializers require closed scalar expressions");

                                break :block_227 @as((zx_abi).value_796a3ab69572c0f62968f53a3980c48892357c21acd7d69f07657b6bccae24de, (zx_abi).value_796a3ab69572c0f62968f53a3980c48892357c21acd7d69f07657b6bccae24de{ .code = operand_215, .start = operand_216, .end = operand_221, .message = operand_226, });
                            }, .expressions = (value_14).expressions, .index = (value_14).index, .required = (value_14).required, .root = (value_14).root, });
                        };

                        break :block_229 value_22;
                    } else value_14);

                    const value_27: (zx_abi).value_3fcd3cda3c6203af2b98cb418207400fe9111d792353388c1180701c2f5358c5 = (if ((block_198: {
                        break :block_198 value_16;
                    } == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Unary))) block_210: {
                        const value_24: (zx_abi).value_6be18e6b8bff66e51366ca4eca851d93b716a0e9a2a911a6ac6eee34ab0f9e90 = (value_23).required;

                        const value_25: u64 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, block_209: {
                            const operand_207 = ((value_23).expressions).unary_operands;

                            const operand_208 = block_206: {
                                break :block_206 value_17;
                            };

                            if ((operand_208 >= (operand_207).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_209 (operand_207)[@intCast(operand_208)];
                        }));

                        const value_26: (zx_abi).value_3fcd3cda3c6203af2b98cb418207400fe9111d792353388c1180701c2f5358c5 = block_205: {
                            break :block_205 @as((zx_abi).value_3fcd3cda3c6203af2b98cb418207400fe9111d792353388c1180701c2f5358c5, (zx_abi).value_3fcd3cda3c6203af2b98cb418207400fe9111d792353388c1180701c2f5358c5{ .diagnostic = (value_23).diagnostic, .expressions = (value_23).expressions, .index = (value_23).index, .required = block_204: {
                                const operand_199 = value_24;
                                const operand_201 = block_200: {
                                    break :block_200 value_25;
                                };

                                if ((operand_201 >= ((operand_199).items).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                const operand_202 = true;
                                const operand_203 = @constCast((operand_199).items);

                                (operand_203)[@intCast(operand_201)] = operand_202;

                                break :block_204 (zx_abi).value_6be18e6b8bff66e51366ca4eca851d93b716a0e9a2a911a6ac6eee34ab0f9e90{ .items = operand_203, .headered = (operand_199).headered, };
                            }, .root = (value_23).root, });
                        };

                        break :block_210 value_26;
                    } else value_23);

                    const value_34: (zx_abi).value_3fcd3cda3c6203af2b98cb418207400fe9111d792353388c1180701c2f5358c5 = (if ((block_174: {
                        break :block_174 value_16;
                    } == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Binary))) block_197: {
                        const value_28: (zx_abi).value_6be18e6b8bff66e51366ca4eca851d93b716a0e9a2a911a6ac6eee34ab0f9e90 = (value_27).required;

                        const value_29: u64 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, block_196: {
                            const operand_194 = ((value_27).expressions).binary_left;

                            const operand_195 = block_193: {
                                break :block_193 value_17;
                            };

                            if ((operand_195 >= (operand_194).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_196 (operand_194)[@intCast(operand_195)];
                        }));

                        const value_30: (zx_abi).value_3fcd3cda3c6203af2b98cb418207400fe9111d792353388c1180701c2f5358c5 = block_192: {
                            break :block_192 @as((zx_abi).value_3fcd3cda3c6203af2b98cb418207400fe9111d792353388c1180701c2f5358c5, (zx_abi).value_3fcd3cda3c6203af2b98cb418207400fe9111d792353388c1180701c2f5358c5{ .diagnostic = (value_27).diagnostic, .expressions = (value_27).expressions, .index = (value_27).index, .required = block_191: {
                                const operand_186 = value_28;
                                const operand_188 = block_187: {
                                    break :block_187 value_29;
                                };

                                if ((operand_188 >= ((operand_186).items).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                const operand_189 = true;
                                const operand_190 = @constCast((operand_186).items);

                                (operand_190)[@intCast(operand_188)] = operand_189;

                                break :block_191 (zx_abi).value_6be18e6b8bff66e51366ca4eca851d93b716a0e9a2a911a6ac6eee34ab0f9e90{ .items = operand_190, .headered = (operand_186).headered, };
                            }, .root = (value_27).root, });
                        };

                        const value_31: (zx_abi).value_6be18e6b8bff66e51366ca4eca851d93b716a0e9a2a911a6ac6eee34ab0f9e90 = (value_30).required;

                        const value_32: u64 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, block_185: {
                            const operand_183 = ((value_30).expressions).binary_right;

                            const operand_184 = block_182: {
                                break :block_182 value_17;
                            };

                            if ((operand_184 >= (operand_183).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_185 (operand_183)[@intCast(operand_184)];
                        }));

                        const value_33: (zx_abi).value_3fcd3cda3c6203af2b98cb418207400fe9111d792353388c1180701c2f5358c5 = block_181: {
                            break :block_181 @as((zx_abi).value_3fcd3cda3c6203af2b98cb418207400fe9111d792353388c1180701c2f5358c5, (zx_abi).value_3fcd3cda3c6203af2b98cb418207400fe9111d792353388c1180701c2f5358c5{ .diagnostic = (value_30).diagnostic, .expressions = (value_30).expressions, .index = (value_30).index, .required = block_180: {
                                const operand_175 = value_31;

                                const operand_177 = block_176: {
                                    break :block_176 value_32;
                                };

                                if ((operand_177 >= ((operand_175).items).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                const operand_178 = true;
                                const operand_179 = @constCast((operand_175).items);

                                (operand_179)[@intCast(operand_177)] = operand_178;

                                break :block_180 (zx_abi).value_6be18e6b8bff66e51366ca4eca851d93b716a0e9a2a911a6ac6eee34ab0f9e90{ .items = operand_179, .headered = (operand_175).headered, };
                            }, .root = (value_30).root, });
                        };

                        break :block_197 value_33;
                    } else value_27);

                    const value_44: (zx_abi).value_3fcd3cda3c6203af2b98cb418207400fe9111d792353388c1180701c2f5358c5 = (if ((block_139: {
                        break :block_139 value_16;
                    } == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Conditional))) block_173: {
                        const value_35: (zx_abi).value_6be18e6b8bff66e51366ca4eca851d93b716a0e9a2a911a6ac6eee34ab0f9e90 = (value_34).required;

                        const value_36: u64 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, block_172: {
                            const operand_170 = ((value_34).expressions).conditional_conditions;

                            const operand_171 = block_169: {
                                break :block_169 value_17;
                            };

                            if ((operand_171 >= (operand_170).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_172 (operand_170)[@intCast(operand_171)];
                        }));

                        const value_37: (zx_abi).value_3fcd3cda3c6203af2b98cb418207400fe9111d792353388c1180701c2f5358c5 = block_168: {
                            break :block_168 @as((zx_abi).value_3fcd3cda3c6203af2b98cb418207400fe9111d792353388c1180701c2f5358c5, (zx_abi).value_3fcd3cda3c6203af2b98cb418207400fe9111d792353388c1180701c2f5358c5{ .diagnostic = (value_34).diagnostic, .expressions = (value_34).expressions, .index = (value_34).index, .required = block_167: {
                                const operand_162 = value_35;
                                const operand_164 = block_163: {
                                    break :block_163 value_36;
                                };

                                if ((operand_164 >= ((operand_162).items).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                const operand_165 = true;
                                const operand_166 = @constCast((operand_162).items);

                                (operand_166)[@intCast(operand_164)] = operand_165;

                                break :block_167 (zx_abi).value_6be18e6b8bff66e51366ca4eca851d93b716a0e9a2a911a6ac6eee34ab0f9e90{ .items = operand_166, .headered = (operand_162).headered, };
                            }, .root = (value_34).root, });
                        };
                        const value_38: (zx_abi).value_6be18e6b8bff66e51366ca4eca851d93b716a0e9a2a911a6ac6eee34ab0f9e90 = (value_37).required;

                        const value_39: u64 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, block_161: {
                            const operand_159 = ((value_37).expressions).conditional_yes;

                            const operand_160 = block_158: {
                                break :block_158 value_17;
                            };

                            if ((operand_160 >= (operand_159).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_161 (operand_159)[@intCast(operand_160)];
                        }));

                        const value_40: (zx_abi).value_3fcd3cda3c6203af2b98cb418207400fe9111d792353388c1180701c2f5358c5 = block_157: {
                            break :block_157 @as((zx_abi).value_3fcd3cda3c6203af2b98cb418207400fe9111d792353388c1180701c2f5358c5, (zx_abi).value_3fcd3cda3c6203af2b98cb418207400fe9111d792353388c1180701c2f5358c5{ .diagnostic = (value_37).diagnostic, .expressions = (value_37).expressions, .index = (value_37).index, .required = block_156: {
                                const operand_151 = value_38;
                                const operand_153 = block_152: {
                                    break :block_152 value_39;
                                };

                                if ((operand_153 >= ((operand_151).items).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                const operand_154 = true;
                                const operand_155 = @constCast((operand_151).items);

                                (operand_155)[@intCast(operand_153)] = operand_154;

                                break :block_156 (zx_abi).value_6be18e6b8bff66e51366ca4eca851d93b716a0e9a2a911a6ac6eee34ab0f9e90{ .items = operand_155, .headered = (operand_151).headered, };
                            }, .root = (value_37).root, });
                        };
                        const value_41: (zx_abi).value_6be18e6b8bff66e51366ca4eca851d93b716a0e9a2a911a6ac6eee34ab0f9e90 = (value_40).required;

                        const value_42: u64 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, block_150: {
                            const operand_148 = ((value_40).expressions).conditional_no;

                            const operand_149 = block_147: {
                                break :block_147 value_17;
                            };

                            if ((operand_149 >= (operand_148).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_150 (operand_148)[@intCast(operand_149)];
                        }));

                        const value_43: (zx_abi).value_3fcd3cda3c6203af2b98cb418207400fe9111d792353388c1180701c2f5358c5 = block_146: {
                            break :block_146 @as((zx_abi).value_3fcd3cda3c6203af2b98cb418207400fe9111d792353388c1180701c2f5358c5, (zx_abi).value_3fcd3cda3c6203af2b98cb418207400fe9111d792353388c1180701c2f5358c5{ .diagnostic = (value_40).diagnostic, .expressions = (value_40).expressions, .index = (value_40).index, .required = block_145: {
                                const operand_140 = value_41;
                                const operand_142 = block_141: {
                                    break :block_141 value_42;
                                };

                                if ((operand_142 >= ((operand_140).items).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                const operand_143 = true;
                                const operand_144 = @constCast((operand_140).items);

                                (operand_144)[@intCast(operand_142)] = operand_143;

                                break :block_145 (zx_abi).value_6be18e6b8bff66e51366ca4eca851d93b716a0e9a2a911a6ac6eee34ab0f9e90{ .items = operand_144, .headered = (operand_140).headered, };
                            }, .root = (value_40).root, });
                        };

                        break :block_173 value_43;
                    } else value_34);

                    const value_65: (zx_abi).value_3fcd3cda3c6203af2b98cb418207400fe9111d792353388c1180701c2f5358c5 = (if ((block_53: {
                        break :block_53 value_16;
                    } == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Match))) block_138: {
                        const value_45: ?u32 = block_137: {
                            const operand_135 = ((value_44).expressions).match_subjects;

                            const operand_136 = block_134: {
                                break :block_134 value_17;
                            };

                            if ((operand_136 >= (operand_135).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_137 (operand_135)[@intCast(operand_136)];
                        };
                        const value_49: (zx_abi).value_3fcd3cda3c6203af2b98cb418207400fe9111d792353388c1180701c2f5358c5 = (if ((block_124: {
                            break :block_124 value_45;
                        } != null)) block_133: {
                            const value_46: (zx_abi).value_6be18e6b8bff66e51366ca4eca851d93b716a0e9a2a911a6ac6eee34ab0f9e90 = (value_44).required;

                            const value_47: u64 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, block_132: {
                                break :block_132 value_45;
                            }.?));

                            const value_48: (zx_abi).value_3fcd3cda3c6203af2b98cb418207400fe9111d792353388c1180701c2f5358c5 = block_131: {
                                break :block_131 @as((zx_abi).value_3fcd3cda3c6203af2b98cb418207400fe9111d792353388c1180701c2f5358c5, (zx_abi).value_3fcd3cda3c6203af2b98cb418207400fe9111d792353388c1180701c2f5358c5{ .diagnostic = (value_44).diagnostic, .expressions = (value_44).expressions, .index = (value_44).index, .required = block_130: {
                                    const operand_125 = value_46;
                                    const operand_127 = block_126: {
                                        break :block_126 value_47;
                                    };

                                    if ((operand_127 >= ((operand_125).items).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    const operand_128 = true;
                                    const operand_129 = @constCast((operand_125).items);

                                    (operand_129)[@intCast(operand_127)] = operand_128;

                                    break :block_130 (zx_abi).value_6be18e6b8bff66e51366ca4eca851d93b716a0e9a2a911a6ac6eee34ab0f9e90{ .items = operand_129, .headered = (operand_125).headered, };
                                }, .root = (value_44).root, });
                            };

                            break :block_133 value_48;
                        } else value_44);

                        const value_50: (zx_abi).value_6be18e6b8bff66e51366ca4eca851d93b716a0e9a2a911a6ac6eee34ab0f9e90 = (value_49).required;

                        const value_51: u64 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, block_123: {
                            const operand_121 = ((value_49).expressions).match_fallbacks;
                            const operand_122 = block_120: {
                                break :block_120 value_17;
                            };

                            if ((operand_122 >= (operand_121).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_123 (operand_121)[@intCast(operand_122)];
                        }));

                        const value_52: (zx_abi).value_3fcd3cda3c6203af2b98cb418207400fe9111d792353388c1180701c2f5358c5 = block_119: {
                            break :block_119 @as((zx_abi).value_3fcd3cda3c6203af2b98cb418207400fe9111d792353388c1180701c2f5358c5, (zx_abi).value_3fcd3cda3c6203af2b98cb418207400fe9111d792353388c1180701c2f5358c5{ .diagnostic = (value_49).diagnostic, .expressions = (value_49).expressions, .index = (value_49).index, .required = block_118: {
                                const operand_113 = value_50;

                                const operand_115 = block_114: {
                                    break :block_114 value_51;
                                };

                                if ((operand_115 >= ((operand_113).items).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                const operand_116 = true;
                                const operand_117 = @constCast((operand_113).items);

                                (operand_117)[@intCast(operand_115)] = operand_116;

                                break :block_118 (zx_abi).value_6be18e6b8bff66e51366ca4eca851d93b716a0e9a2a911a6ac6eee34ab0f9e90{ .items = operand_117, .headered = (operand_113).headered, };
                            }, .root = (value_49).root, });
                        };
                        const value_63: (zx_abi).value_65b207f6b3e6f9ec7c71f1166547870be5a4eefd2e08e7d7a8778df71ff76d1d = block_112: {
                            const operand_74 = block_73: {
                                const operand_56 = (value_52).required;
                                const operand_57 = (zx_abi).value_3601a505cc029196b9f80a2e9e627c3124e337ad986f18c79a4a83913ccbbed1{ .items = ((value_52).expressions).match_conditions, .headered = false, };
                                const operand_58 = (zx_abi).value_3601a505cc029196b9f80a2e9e627c3124e337ad986f18c79a4a83913ccbbed1{ .items = ((value_52).expressions).match_results, .headered = false, };

                                const operand_59 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, block_63: {
                                    const operand_61 = ((value_52).expressions).match_first;

                                    const operand_62 = block_60: {
                                        break :block_60 value_17;
                                    };

                                    if ((operand_62 >= (operand_61).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    break :block_63 (operand_61)[@intCast(operand_62)];
                                }));
                                const operand_64 = ((try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, block_68: {
                                    const operand_66 = ((value_52).expressions).match_first;

                                    const operand_67 = block_65: {
                                        break :block_65 value_17;
                                    };

                                    if ((operand_67 >= (operand_66).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    break :block_68 (operand_66)[@intCast(operand_67)];
                                })) + (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, block_72: {
                                    const operand_70 = ((value_52).expressions).match_count;

                                    const operand_71 = block_69: {
                                        break :block_69 value_17;
                                    };

                                    if ((operand_71 >= (operand_70).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    break :block_72 (operand_70)[@intCast(operand_71)];
                                })));

                                break :block_73 @as((zx_abi).value_65b207f6b3e6f9ec7c71f1166547870be5a4eefd2e08e7d7a8778df71ff76d1d, (zx_abi).value_65b207f6b3e6f9ec7c71f1166547870be5a4eefd2e08e7d7a8778df71ff76d1d{ .required = operand_56, .conditions = operand_57, .results = operand_58, .index = operand_59, .end = operand_64, });
                            };
                            const loop_fields_76 = struct {
                                conditions: *const (zx_abi).value_3601a505cc029196b9f80a2e9e627c3124e337ad986f18c79a4a83913ccbbed1,
                                end: u64,
                                index: u64,
                                required: (zx_abi).value_6be18e6b8bff66e51366ca4eca851d93b716a0e9a2a911a6ac6eee34ab0f9e90,
                                results: *const (zx_abi).value_3601a505cc029196b9f80a2e9e627c3124e337ad986f18c79a4a83913ccbbed1,
                                zx_origin: ?*const (zx_abi).zx_type_146be0007f8aaf60d5231bd6f760aba6560eb7b10bc80c99c0dfac4bef434836 = null,
                            };
                            const loop_seed_75: (zx_abi).value_65b207f6b3e6f9ec7c71f1166547870be5a4eefd2e08e7d7a8778df71ff76d1d = operand_74;
                            var state_changed_77 = false;

                            break :block_112 (if (((loop_seed_75).index < (loop_seed_75).end)) block_109: {
                                var state_55: loop_fields_76 = loop_fields_76{ .conditions = (&(loop_seed_75).conditions), .end = (loop_seed_75).end, .index = (loop_seed_75).index, .required = (loop_seed_75).required, .results = (&(loop_seed_75).results), .zx_origin = (loop_seed_75).zx_origin, };

                                while (true) {
                                    state_55 = block_106: {
                                        const value_55: (zx_abi).value_6be18e6b8bff66e51366ca4eca851d93b716a0e9a2a911a6ac6eee34ab0f9e90 = (state_55).required;

                                        const value_56: u64 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, block_105: {
                                            const operand_103 = (((state_55).conditions).*).items;
                                            const operand_104 = (state_55).index;

                                            if ((operand_104 >= (operand_103).len)) {
                                                return error.IndexOutOfBounds;
                                            }

                                            break :block_105 (operand_103)[@intCast(operand_104)];
                                        }));
                                        const value_57: loop_fields_76 = block_102: {
                                            break :block_102 loop_fields_76{ .conditions = block_94: {
                                                _ = ((state_55).conditions).*;

                                                break :block_94 (&(loop_seed_75).conditions);
                                            }, .end = (state_55).end, .index = (state_55).index, .required = block_100: {
                                                const operand_95 = value_55;

                                                const operand_97 = block_96: {
                                                    break :block_96 value_56;
                                                };

                                                if ((operand_97 >= ((operand_95).items).len)) {
                                                    return error.IndexOutOfBounds;
                                                }

                                                const operand_98 = true;
                                                const operand_99 = @constCast((operand_95).items);

                                                (operand_99)[@intCast(operand_97)] = operand_98;

                                                break :block_100 (zx_abi).value_6be18e6b8bff66e51366ca4eca851d93b716a0e9a2a911a6ac6eee34ab0f9e90{ .items = operand_99, .headered = (operand_95).headered, };
                                            }, .results = block_101: {
                                                _ = ((state_55).results).*;

                                                break :block_101 (&(loop_seed_75).results);
                                            }, };
                                        };
                                        const value_58: (zx_abi).value_6be18e6b8bff66e51366ca4eca851d93b716a0e9a2a911a6ac6eee34ab0f9e90 = (value_57).required;

                                        const value_59: u64 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, block_93: {
                                            const operand_91 = (((value_57).results).*).items;
                                            const operand_92 = (value_57).index;

                                            if ((operand_92 >= (operand_91).len)) {
                                                return error.IndexOutOfBounds;
                                            }

                                            break :block_93 (operand_91)[@intCast(operand_92)];
                                        }));
                                        const value_60: loop_fields_76 = block_90: {
                                            break :block_90 loop_fields_76{ .conditions = block_82: {
                                                _ = ((value_57).conditions).*;

                                                break :block_82 (&(loop_seed_75).conditions);
                                            }, .end = (value_57).end, .index = (value_57).index, .required = block_88: {
                                                const operand_83 = value_58;
                                                const operand_85 = block_84: {
                                                    break :block_84 value_59;
                                                };

                                                if ((operand_85 >= ((operand_83).items).len)) {
                                                    return error.IndexOutOfBounds;
                                                }

                                                const operand_86 = true;
                                                const operand_87 = @constCast((operand_83).items);

                                                (operand_87)[@intCast(operand_85)] = operand_86;

                                                break :block_88 (zx_abi).value_6be18e6b8bff66e51366ca4eca851d93b716a0e9a2a911a6ac6eee34ab0f9e90{ .items = operand_87, .headered = (operand_83).headered, };
                                            }, .results = block_89: {
                                                _ = ((value_57).results).*;

                                                break :block_89 (&(loop_seed_75).results);
                                            }, };
                                        };
                                        const value_61: u64 = (value_60).index;

                                        const value_62: loop_fields_76 = block_81: {
                                            break :block_81 loop_fields_76{ .conditions = block_78: {
                                                _ = ((value_60).conditions).*;

                                                break :block_78 (&(loop_seed_75).conditions);
                                            }, .end = (value_60).end, .index = (block_79: {
                                                break :block_79 value_61;
                                            } + @as(u64, 1)), .required = (value_60).required, .results = block_80: {
                                                _ = ((value_60).results).*;

                                                break :block_80 (&(loop_seed_75).results);
                                            }, };
                                        };

                                        break :block_106 value_62;
                                    };

                                    state_changed_77 = true;

                                    if ((!((state_55).index < (state_55).end))) {
                                        break;
                                    }
                                }

                                const operand_107 = (zx_abi).value_65b207f6b3e6f9ec7c71f1166547870be5a4eefd2e08e7d7a8778df71ff76d1d{ .conditions = ((state_55).conditions).*, .end = (state_55).end, .index = (state_55).index, .required = (state_55).required, .results = ((state_55).results).*, .zx_origin = (state_55).zx_origin, };

                                break :block_109 (if (state_changed_77) operand_107 else operand_74);
                            } else block_111: {
                                break :block_111 (if (state_changed_77) loop_seed_75 else operand_74);
                            });
                        };
                        const value_64: (zx_abi).value_3fcd3cda3c6203af2b98cb418207400fe9111d792353388c1180701c2f5358c5 = block_54: {
                            break :block_54 @as((zx_abi).value_3fcd3cda3c6203af2b98cb418207400fe9111d792353388c1180701c2f5358c5, (zx_abi).value_3fcd3cda3c6203af2b98cb418207400fe9111d792353388c1180701c2f5358c5{ .diagnostic = (value_52).diagnostic, .expressions = (value_52).expressions, .index = (value_52).index, .required = (value_63).required, .root = (value_52).root, });
                        };

                        break :block_138 value_64;
                    } else value_44);

                    break :block_253 value_65;
                } else value_14);

                break :block_256 value_66;
            };

            const operand_258 = ((operand_257).diagnostic).code;
            const operand_259 = ((operand_257).diagnostic).end;
            const operand_260 = ((operand_257).diagnostic).message;
            const operand_261 = ((operand_257).diagnostic).start;
            const operand_262 = ((operand_257).diagnostic).zx_origin;
            const operand_263 = (operand_257).expressions;
            const operand_264 = (operand_257).index;
            const operand_265 = ((operand_257).required).items;
            const operand_266 = ((operand_257).required).headered;
            const operand_267 = (operand_257).root;
            const operand_268 = (operand_257).zx_origin;

            ((state_1).diagnostic).code = operand_258;
            ((state_1).diagnostic).end = operand_259;
            ((state_1).diagnostic).message = operand_260;
            ((state_1).diagnostic).start = operand_261;
            ((state_1).diagnostic).zx_origin = operand_262;
            (state_1).expressions = operand_263;
            (state_1).index = operand_264;
            ((state_1).required).items = operand_265;
            ((state_1).required).headered = operand_266;
            (state_1).root = operand_267;
            (state_1).zx_origin = operand_268;
            state_changed_44 = true;
        }

        break :block_270 (if (state_changed_44) state_1 else operand_42);
    }).diagnostic;
}

