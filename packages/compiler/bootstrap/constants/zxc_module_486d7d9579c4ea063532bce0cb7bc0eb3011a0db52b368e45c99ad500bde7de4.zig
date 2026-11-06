const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn callValue(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_a2f55696926fa6cae227a00b4b0c8ef9b9fe8830a5393ec29139ceff8a5bc53c) error{ IndexOutOfBounds, OutOfMemory, Overflow, }!(zx_abi).value_70b6fe56ec1433c7db12ad7fe8b6ec16c18b25aaba658db9e05b52cea4a95808 {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_7ffdc377160738ae985ed900d2d45ddfa5421b61324d50b3486bb087ea9c2a78 = (in).expressions;
    const value_2: u64 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, (in).root));

    const value_3: (zx_abi).value_70b6fe56ec1433c7db12ad7fe8b6ec16c18b25aaba658db9e05b52cea4a95808 = block_292: {
        const operand_288 = @as([]const u8, "");
        const operand_289 = @as(u64, 0);
        const operand_290 = @as(u64, 0);
        const operand_291 = @as([]const u8, "");

        break :block_292 @as((zx_abi).value_70b6fe56ec1433c7db12ad7fe8b6ec16c18b25aaba658db9e05b52cea4a95808, (zx_abi).value_70b6fe56ec1433c7db12ad7fe8b6ec16c18b25aaba658db9e05b52cea4a95808{ .code = operand_288, .start = operand_289, .end = operand_290, .message = operand_291, });
    };

    if ((block_281: {
        break :block_281 value_2;
    } >= @as(u64, ((block_282: {
        break :block_282 value_1;
    }).kinds).len))) {
        return block_287: {
            const operand_283 = @as([]const u8, "contract");
            const operand_284 = @as(u64, 0);
            const operand_285 = @as(u64, 0);
            const operand_286 = @as([]const u8, "constant expression root is out of bounds");

            break :block_287 @as((zx_abi).value_70b6fe56ec1433c7db12ad7fe8b6ec16c18b25aaba658db9e05b52cea4a95808, (zx_abi).value_70b6fe56ec1433c7db12ad7fe8b6ec16c18b25aaba658db9e05b52cea4a95808{ .code = operand_283, .start = operand_284, .end = operand_285, .message = operand_286, });
        };
    }

    return (block_280: {
        const operand_46 = block_45: {
            const operand_2 = block_3: {
                break :block_3 value_1;
            };
            const operand_4 = block_5: {
                break :block_5 value_2;
            };

            const operand_6 = (block_7: {
                break :block_7 value_2;
            } + @as(u64, 1));
            const operand_8 = block_43: {
                const value_5: (zx_abi).value_02644af81ff06785112d2893fa4d9a0a010d1d41f29ed957ae6316dd680a6080 = (zx_abi).value_02644af81ff06785112d2893fa4d9a0a010d1d41f29ed957ae6316dd680a6080{ .items = (block_42: {
                    break :block_42 value_1;
                }).kinds, .storage = .plain, };

                break :block_43 block_41: {
                    const operand_15 = block_14: {
                        const operand_10 = value_5;
                        const operand_11 = @as(u64, 0);

                        const operand_12 = block_13: {
                            break :block_13 (zx_abi).value_c92c000109b741fe69221f5cd67fb0680f37c213f585227f95c1c319008691c9{ .items = (&[_]bool{}), .storage = .plain, };
                        };

                        break :block_14 @as((zx_abi).value_8324fa02a6095466a844c99c1e15660b69578e49f7e23c4b2f0c5958a28098b6, (zx_abi).value_8324fa02a6095466a844c99c1e15660b69578e49f7e23c4b2f0c5958a28098b6{ .index = operand_11, .result = operand_12, .source = operand_10, });
                    };
                    const loop_fields_17 = struct {
                        index: u64,
                        result: (zx_abi).value_c92c000109b741fe69221f5cd67fb0680f37c213f585227f95c1c319008691c9,
                        source: *const (zx_abi).value_02644af81ff06785112d2893fa4d9a0a010d1d41f29ed957ae6316dd680a6080,
                        zx_origin: ?*const (zx_abi).zx_type_f7c04f634ae5b2093751e64fbcd14059ec3f0109817b535637410782abe2f29d = null,
                    };

                    var qualified_18: (zx_abi).value_8324fa02a6095466a844c99c1e15660b69578e49f7e23c4b2f0c5958a28098b6 = operand_15;

                    ((qualified_18).source).storage = (if ((@intFromEnum(((qualified_18).source).storage) >= 2)) .shared else .plain);
                    const loop_seed_16: (zx_abi).value_8324fa02a6095466a844c99c1e15660b69578e49f7e23c4b2f0c5958a28098b6 = qualified_18;

                    break :block_41 (if (((loop_seed_16).index < @as(u64, (((loop_seed_16).source).items).len))) block_39: {
                        var qualified_35: (zx_abi).value_02644af81ff06785112d2893fa4d9a0a010d1d41f29ed957ae6316dd680a6080 = (loop_seed_16).source;

                        (qualified_35).storage = (if ((@intFromEnum((qualified_35).storage) >= 2)) .shared else .plain);
                        const operand_36 = (zx_abi).value_8324fa02a6095466a844c99c1e15660b69578e49f7e23c4b2f0c5958a28098b6{ .index = (loop_seed_16).index, .result = (loop_seed_16).result, .source = qualified_35, .zx_origin = (loop_seed_16).zx_origin, };
                        var state_9: loop_fields_17 = loop_fields_17{ .index = (operand_36).index, .result = (operand_36).result, .source = (&(operand_36).source), .zx_origin = (operand_36).zx_origin, };

                        while (true) {
                            const operand_37 = block_34: {
                                _ = block_33: {
                                    const operand_31 = (((state_9).source).*).items;
                                    const operand_32 = (state_9).index;

                                    if ((operand_32 >= (operand_31).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    break :block_33 (operand_31)[@intCast(operand_32)];
                                };
                                const value_9: bool = false;

                                break :block_34 block_30: {
                                    const operand_19 = ((state_9).source).*;
                                    const operand_20 = ((state_9).index + @as(u64, 1));

                                    const operand_21 = (block_28: {
                                        const operand_22 = (state_9).result;

                                        const operand_24 = block_23: {
                                            break :block_23 value_9;
                                        };

                                        const operand_25 = (try ((std).math).add(usize, ((operand_22).items).len, 1));

                                        break :block_28 @as((zx_abi).value_03820fc4aa3f9b6144cbcf8d718ea27ff53eb9c555fb4f164ffecf2faa07befb, .{ block_27: {
                                            const operand_26 = (try (zx_abi).zxReserveBounded(bool, allocator, (operand_22).items, operand_25, (((loop_seed_16).source).items).len));

                                            (operand_26)[((operand_22).items).len] = operand_24;

                                            break :block_27 (zx_abi).value_c92c000109b741fe69221f5cd67fb0680f37c213f585227f95c1c319008691c9{ .items = operand_26, .storage = (if (((((operand_22).items).len == 0) or ((operand_22).storage == .exclusive))) .exclusive else .shared), };
                                        }, {}, null, });
                                    }).@"0";

                                    break :block_30 loop_fields_17{ .index = operand_20, .result = operand_21, .source = block_29: {
                                        _ = operand_19;

                                        break :block_29 (&(loop_seed_16).source);
                                    }, };
                                };
                            };

                            state_9 = loop_fields_17{ .index = (operand_37).index, .result = (operand_37).result, .source = (operand_37).source, .zx_origin = (operand_37).zx_origin, };

                            if ((!((state_9).index < @as(u64, ((((state_9).source).*).items).len)))) {
                                break;
                            }
                        }

                        const operand_38 = (zx_abi).value_8324fa02a6095466a844c99c1e15660b69578e49f7e23c4b2f0c5958a28098b6{ .index = (state_9).index, .result = (state_9).result, .source = ((state_9).source).*, .zx_origin = (state_9).zx_origin, };

                        break :block_39 (operand_38).result;
                    } else block_40: {
                        break :block_40 (loop_seed_16).result;
                    });
                };
            };

            const operand_44 = value_3;

            break :block_45 @as((zx_abi).value_7b8270d6a72fc47f5bdab3df507f6a882c4c11c531d5d08c7e73b12855f7393f, (zx_abi).value_7b8270d6a72fc47f5bdab3df507f6a882c4c11c531d5d08c7e73b12855f7393f{ .expressions = operand_2, .root = operand_4, .index = operand_6, .required = operand_8, .diagnostic = operand_44, });
        };

        var state_1: (zx_abi).value_7b8270d6a72fc47f5bdab3df507f6a882c4c11c531d5d08c7e73b12855f7393f = operand_46;
        var state_changed_48 = false;

        while ((((state_1).index != @as(u64, 0)) and block_51: {
            const operand_49 = ((state_1).diagnostic).message;
            const operand_50 = @as([]const u8, "");

            break :block_51 ((std).mem).eql(u8, operand_49, operand_50);
        })) {
            const operand_267 = block_266: {
                const value_13: u64 = (state_1).index;

                const value_14: (zx_abi).value_7b8270d6a72fc47f5bdab3df507f6a882c4c11c531d5d08c7e73b12855f7393f = block_265: {
                    break :block_265 @as((zx_abi).value_7b8270d6a72fc47f5bdab3df507f6a882c4c11c531d5d08c7e73b12855f7393f, (zx_abi).value_7b8270d6a72fc47f5bdab3df507f6a882c4c11c531d5d08c7e73b12855f7393f{ .diagnostic = (state_1).diagnostic, .expressions = (state_1).expressions, .index = (block_264: {
                        break :block_264 value_13;
                    } - @as(u64, 1)), .required = (state_1).required, .root = (state_1).root, });
                };

                const value_15: u64 = (value_14).index;

                const value_67: (zx_abi).value_7b8270d6a72fc47f5bdab3df507f6a882c4c11c531d5d08c7e73b12855f7393f = (if (((block_52: {
                    break :block_52 value_15;
                } == (value_14).root) or block_56: {
                    const operand_54 = ((value_14).required).items;

                    const operand_55 = block_53: {
                        break :block_53 value_15;
                    };

                    if ((operand_55 >= (operand_54).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_56 (operand_54)[@intCast(operand_55)];
                })) block_263: {
                    const value_16: (zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5 = block_262: {
                        const operand_260 = ((value_14).expressions).kinds;

                        const operand_261 = block_259: {
                            break :block_259 value_15;
                        };

                        if ((operand_261 >= (operand_260).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_262 (operand_260)[@intCast(operand_261)];
                    };
                    const value_17: u64 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, block_258: {
                        const operand_256 = ((value_14).expressions).payloads;

                        const operand_257 = block_255: {
                            break :block_255 value_15;
                        };

                        if ((operand_257 >= (operand_256).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_258 (operand_256)[@intCast(operand_257)];
                    }));

                    const value_18: bool = ((((((!(!(block_249: {
                        break :block_249 value_16;
                    } == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Integer)))) or (block_250: {
                        break :block_250 value_16;
                    } == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .NegativeInteger))) or (block_251: {
                        break :block_251 value_16;
                    } == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Float))) or (block_252: {
                        break :block_252 value_16;
                    } == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .String))) or (block_253: {
                        break :block_253 value_16;
                    } == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Boolean))) or (block_254: {
                        break :block_254 value_16;
                    } == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .EnumValue)));

                    const value_19: bool = ((block_247: {
                        break :block_247 value_16;
                    } == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Unary)) or (block_248: {
                        break :block_248 value_16;
                    } == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Binary)));

                    const value_20: bool = ((block_245: {
                        break :block_245 value_16;
                    } == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Conditional)) or (block_246: {
                        break :block_246 value_16;
                    } == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Match)));

                    const value_21: bool = ((block_240: {
                        break :block_240 value_16;
                    } == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Binary)) and (block_244: {
                        const operand_242 = ((value_14).expressions).binary_operators;

                        const operand_243 = block_241: {
                            break :block_241 value_17;
                        };

                        if ((operand_243 >= (operand_242).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_244 (operand_242)[@intCast(operand_243)];
                    } == @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .Coalesce)));

                    const value_22: bool = ((((!(!(!block_236: {
                        break :block_236 value_18;
                    }))) and (!block_237: {
                        break :block_237 value_19;
                    })) and (!block_238: {
                        break :block_238 value_20;
                    })) or block_239: {
                        break :block_239 value_21;
                    });

                    const value_24: (zx_abi).value_7b8270d6a72fc47f5bdab3df507f6a882c4c11c531d5d08c7e73b12855f7393f = (if (block_220: {
                        break :block_220 value_22;
                    }) block_235: {
                        const value_23: (zx_abi).value_7b8270d6a72fc47f5bdab3df507f6a882c4c11c531d5d08c7e73b12855f7393f = block_234: {
                            break :block_234 @as((zx_abi).value_7b8270d6a72fc47f5bdab3df507f6a882c4c11c531d5d08c7e73b12855f7393f, (zx_abi).value_7b8270d6a72fc47f5bdab3df507f6a882c4c11c531d5d08c7e73b12855f7393f{ .diagnostic = block_233: {
                                const operand_221 = @as([]const u8, "unsupported");
                                const operand_222 = block_226: {
                                    const operand_224 = ((value_14).expressions).span_start;

                                    const operand_225 = block_223: {
                                        break :block_223 value_15;
                                    };

                                    if ((operand_225 >= (operand_224).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    break :block_226 (operand_224)[@intCast(operand_225)];
                                };
                                const operand_227 = block_231: {
                                    const operand_229 = ((value_14).expressions).span_end;

                                    const operand_230 = block_228: {
                                        break :block_228 value_15;
                                    };

                                    if ((operand_230 >= (operand_229).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    break :block_231 (operand_229)[@intCast(operand_230)];
                                };
                                const operand_232 = @as([]const u8, "constant initializers require closed scalar expressions");

                                break :block_233 @as((zx_abi).value_70b6fe56ec1433c7db12ad7fe8b6ec16c18b25aaba658db9e05b52cea4a95808, (zx_abi).value_70b6fe56ec1433c7db12ad7fe8b6ec16c18b25aaba658db9e05b52cea4a95808{ .code = operand_221, .start = operand_222, .end = operand_227, .message = operand_232, });
                            }, .expressions = (value_14).expressions, .index = (value_14).index, .required = (value_14).required, .root = (value_14).root, });
                        };

                        break :block_235 value_23;
                    } else value_14);

                    const value_28: (zx_abi).value_7b8270d6a72fc47f5bdab3df507f6a882c4c11c531d5d08c7e73b12855f7393f = (if ((block_207: {
                        break :block_207 value_16;
                    } == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Unary))) block_219: {
                        const value_25: (zx_abi).value_c92c000109b741fe69221f5cd67fb0680f37c213f585227f95c1c319008691c9 = (value_24).required;

                        const value_26: u64 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, block_218: {
                            const operand_216 = ((value_24).expressions).unary_operands;

                            const operand_217 = block_215: {
                                break :block_215 value_17;
                            };

                            if ((operand_217 >= (operand_216).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_218 (operand_216)[@intCast(operand_217)];
                        }));

                        const value_27: (zx_abi).value_7b8270d6a72fc47f5bdab3df507f6a882c4c11c531d5d08c7e73b12855f7393f = block_214: {
                            break :block_214 @as((zx_abi).value_7b8270d6a72fc47f5bdab3df507f6a882c4c11c531d5d08c7e73b12855f7393f, (zx_abi).value_7b8270d6a72fc47f5bdab3df507f6a882c4c11c531d5d08c7e73b12855f7393f{ .diagnostic = (value_24).diagnostic, .expressions = (value_24).expressions, .index = (value_24).index, .required = block_213: {
                                const operand_208 = value_25;
                                const operand_210 = block_209: {
                                    break :block_209 value_26;
                                };

                                if ((operand_210 >= ((operand_208).items).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                const operand_211 = true;
                                const operand_212 = @constCast((operand_208).items);

                                (operand_212)[@intCast(operand_210)] = operand_211;

                                break :block_213 (zx_abi).value_c92c000109b741fe69221f5cd67fb0680f37c213f585227f95c1c319008691c9{ .items = operand_212, .storage = (if ((@intFromEnum((operand_208).storage) >= 2)) .exclusive else .owned), };
                            }, .root = (value_24).root, });
                        };

                        break :block_219 value_27;
                    } else value_24);

                    const value_35: (zx_abi).value_7b8270d6a72fc47f5bdab3df507f6a882c4c11c531d5d08c7e73b12855f7393f = (if ((block_183: {
                        break :block_183 value_16;
                    } == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Binary))) block_206: {
                        const value_29: (zx_abi).value_c92c000109b741fe69221f5cd67fb0680f37c213f585227f95c1c319008691c9 = (value_28).required;

                        const value_30: u64 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, block_205: {
                            const operand_203 = ((value_28).expressions).binary_left;

                            const operand_204 = block_202: {
                                break :block_202 value_17;
                            };

                            if ((operand_204 >= (operand_203).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_205 (operand_203)[@intCast(operand_204)];
                        }));

                        const value_31: (zx_abi).value_7b8270d6a72fc47f5bdab3df507f6a882c4c11c531d5d08c7e73b12855f7393f = block_201: {
                            break :block_201 @as((zx_abi).value_7b8270d6a72fc47f5bdab3df507f6a882c4c11c531d5d08c7e73b12855f7393f, (zx_abi).value_7b8270d6a72fc47f5bdab3df507f6a882c4c11c531d5d08c7e73b12855f7393f{ .diagnostic = (value_28).diagnostic, .expressions = (value_28).expressions, .index = (value_28).index, .required = block_200: {
                                const operand_195 = value_29;

                                const operand_197 = block_196: {
                                    break :block_196 value_30;
                                };

                                if ((operand_197 >= ((operand_195).items).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                const operand_198 = true;
                                const operand_199 = @constCast((operand_195).items);

                                (operand_199)[@intCast(operand_197)] = operand_198;

                                break :block_200 (zx_abi).value_c92c000109b741fe69221f5cd67fb0680f37c213f585227f95c1c319008691c9{ .items = operand_199, .storage = (if ((@intFromEnum((operand_195).storage) >= 2)) .exclusive else .owned), };
                            }, .root = (value_28).root, });
                        };
                        const value_32: (zx_abi).value_c92c000109b741fe69221f5cd67fb0680f37c213f585227f95c1c319008691c9 = (value_31).required;

                        const value_33: u64 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, block_194: {
                            const operand_192 = ((value_31).expressions).binary_right;

                            const operand_193 = block_191: {
                                break :block_191 value_17;
                            };

                            if ((operand_193 >= (operand_192).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_194 (operand_192)[@intCast(operand_193)];
                        }));

                        const value_34: (zx_abi).value_7b8270d6a72fc47f5bdab3df507f6a882c4c11c531d5d08c7e73b12855f7393f = block_190: {
                            break :block_190 @as((zx_abi).value_7b8270d6a72fc47f5bdab3df507f6a882c4c11c531d5d08c7e73b12855f7393f, (zx_abi).value_7b8270d6a72fc47f5bdab3df507f6a882c4c11c531d5d08c7e73b12855f7393f{ .diagnostic = (value_31).diagnostic, .expressions = (value_31).expressions, .index = (value_31).index, .required = block_189: {
                                const operand_184 = value_32;
                                const operand_186 = block_185: {
                                    break :block_185 value_33;
                                };

                                if ((operand_186 >= ((operand_184).items).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                const operand_187 = true;
                                const operand_188 = @constCast((operand_184).items);

                                (operand_188)[@intCast(operand_186)] = operand_187;

                                break :block_189 (zx_abi).value_c92c000109b741fe69221f5cd67fb0680f37c213f585227f95c1c319008691c9{ .items = operand_188, .storage = (if ((@intFromEnum((operand_184).storage) >= 2)) .exclusive else .owned), };
                            }, .root = (value_31).root, });
                        };

                        break :block_206 value_34;
                    } else value_28);

                    const value_45: (zx_abi).value_7b8270d6a72fc47f5bdab3df507f6a882c4c11c531d5d08c7e73b12855f7393f = (if ((block_148: {
                        break :block_148 value_16;
                    } == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Conditional))) block_182: {
                        const value_36: (zx_abi).value_c92c000109b741fe69221f5cd67fb0680f37c213f585227f95c1c319008691c9 = (value_35).required;

                        const value_37: u64 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, block_181: {
                            const operand_179 = ((value_35).expressions).conditional_conditions;

                            const operand_180 = block_178: {
                                break :block_178 value_17;
                            };

                            if ((operand_180 >= (operand_179).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_181 (operand_179)[@intCast(operand_180)];
                        }));
                        const value_38: (zx_abi).value_7b8270d6a72fc47f5bdab3df507f6a882c4c11c531d5d08c7e73b12855f7393f = block_177: {
                            break :block_177 @as((zx_abi).value_7b8270d6a72fc47f5bdab3df507f6a882c4c11c531d5d08c7e73b12855f7393f, (zx_abi).value_7b8270d6a72fc47f5bdab3df507f6a882c4c11c531d5d08c7e73b12855f7393f{ .diagnostic = (value_35).diagnostic, .expressions = (value_35).expressions, .index = (value_35).index, .required = block_176: {
                                const operand_171 = value_36;
                                const operand_173 = block_172: {
                                    break :block_172 value_37;
                                };

                                if ((operand_173 >= ((operand_171).items).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                const operand_174 = true;
                                const operand_175 = @constCast((operand_171).items);
                                (operand_175)[@intCast(operand_173)] = operand_174;

                                break :block_176 (zx_abi).value_c92c000109b741fe69221f5cd67fb0680f37c213f585227f95c1c319008691c9{ .items = operand_175, .storage = (if ((@intFromEnum((operand_171).storage) >= 2)) .exclusive else .owned), };
                            }, .root = (value_35).root, });
                        };
                        const value_39: (zx_abi).value_c92c000109b741fe69221f5cd67fb0680f37c213f585227f95c1c319008691c9 = (value_38).required;

                        const value_40: u64 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, block_170: {
                            const operand_168 = ((value_38).expressions).conditional_yes;

                            const operand_169 = block_167: {
                                break :block_167 value_17;
                            };

                            if ((operand_169 >= (operand_168).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_170 (operand_168)[@intCast(operand_169)];
                        }));

                        const value_41: (zx_abi).value_7b8270d6a72fc47f5bdab3df507f6a882c4c11c531d5d08c7e73b12855f7393f = block_166: {
                            break :block_166 @as((zx_abi).value_7b8270d6a72fc47f5bdab3df507f6a882c4c11c531d5d08c7e73b12855f7393f, (zx_abi).value_7b8270d6a72fc47f5bdab3df507f6a882c4c11c531d5d08c7e73b12855f7393f{ .diagnostic = (value_38).diagnostic, .expressions = (value_38).expressions, .index = (value_38).index, .required = block_165: {
                                const operand_160 = value_39;
                                const operand_162 = block_161: {
                                    break :block_161 value_40;
                                };

                                if ((operand_162 >= ((operand_160).items).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                const operand_163 = true;
                                const operand_164 = @constCast((operand_160).items);

                                (operand_164)[@intCast(operand_162)] = operand_163;

                                break :block_165 (zx_abi).value_c92c000109b741fe69221f5cd67fb0680f37c213f585227f95c1c319008691c9{ .items = operand_164, .storage = (if ((@intFromEnum((operand_160).storage) >= 2)) .exclusive else .owned), };
                            }, .root = (value_38).root, });
                        };

                        const value_42: (zx_abi).value_c92c000109b741fe69221f5cd67fb0680f37c213f585227f95c1c319008691c9 = (value_41).required;

                        const value_43: u64 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, block_159: {
                            const operand_157 = ((value_41).expressions).conditional_no;

                            const operand_158 = block_156: {
                                break :block_156 value_17;
                            };

                            if ((operand_158 >= (operand_157).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_159 (operand_157)[@intCast(operand_158)];
                        }));
                        const value_44: (zx_abi).value_7b8270d6a72fc47f5bdab3df507f6a882c4c11c531d5d08c7e73b12855f7393f = block_155: {
                            break :block_155 @as((zx_abi).value_7b8270d6a72fc47f5bdab3df507f6a882c4c11c531d5d08c7e73b12855f7393f, (zx_abi).value_7b8270d6a72fc47f5bdab3df507f6a882c4c11c531d5d08c7e73b12855f7393f{ .diagnostic = (value_41).diagnostic, .expressions = (value_41).expressions, .index = (value_41).index, .required = block_154: {
                                const operand_149 = value_42;
                                const operand_151 = block_150: {
                                    break :block_150 value_43;
                                };

                                if ((operand_151 >= ((operand_149).items).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                const operand_152 = true;
                                const operand_153 = @constCast((operand_149).items);

                                (operand_153)[@intCast(operand_151)] = operand_152;

                                break :block_154 (zx_abi).value_c92c000109b741fe69221f5cd67fb0680f37c213f585227f95c1c319008691c9{ .items = operand_153, .storage = (if ((@intFromEnum((operand_149).storage) >= 2)) .exclusive else .owned), };
                            }, .root = (value_41).root, });
                        };

                        break :block_182 value_44;
                    } else value_35);

                    const value_66: (zx_abi).value_7b8270d6a72fc47f5bdab3df507f6a882c4c11c531d5d08c7e73b12855f7393f = (if ((block_57: {
                        break :block_57 value_16;
                    } == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Match))) block_147: {
                        const value_46: ?u32 = block_146: {
                            const operand_144 = ((value_45).expressions).match_subjects;

                            const operand_145 = block_143: {
                                break :block_143 value_17;
                            };

                            if ((operand_145 >= (operand_144).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_146 (operand_144)[@intCast(operand_145)];
                        };
                        const value_50: (zx_abi).value_7b8270d6a72fc47f5bdab3df507f6a882c4c11c531d5d08c7e73b12855f7393f = (if ((block_133: {
                            break :block_133 value_46;
                        } != null)) block_142: {
                            const value_47: (zx_abi).value_c92c000109b741fe69221f5cd67fb0680f37c213f585227f95c1c319008691c9 = (value_45).required;

                            const value_48: u64 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, block_141: {
                                break :block_141 value_46;
                            }.?));
                            const value_49: (zx_abi).value_7b8270d6a72fc47f5bdab3df507f6a882c4c11c531d5d08c7e73b12855f7393f = block_140: {
                                break :block_140 @as((zx_abi).value_7b8270d6a72fc47f5bdab3df507f6a882c4c11c531d5d08c7e73b12855f7393f, (zx_abi).value_7b8270d6a72fc47f5bdab3df507f6a882c4c11c531d5d08c7e73b12855f7393f{ .diagnostic = (value_45).diagnostic, .expressions = (value_45).expressions, .index = (value_45).index, .required = block_139: {
                                    const operand_134 = value_47;
                                    const operand_136 = block_135: {
                                        break :block_135 value_48;
                                    };

                                    if ((operand_136 >= ((operand_134).items).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    const operand_137 = true;
                                    const operand_138 = @constCast((operand_134).items);

                                    (operand_138)[@intCast(operand_136)] = operand_137;

                                    break :block_139 (zx_abi).value_c92c000109b741fe69221f5cd67fb0680f37c213f585227f95c1c319008691c9{ .items = operand_138, .storage = (if ((@intFromEnum((operand_134).storage) >= 2)) .exclusive else .owned), };
                                }, .root = (value_45).root, });
                            };

                            break :block_142 value_49;
                        } else value_45);

                        const value_51: (zx_abi).value_c92c000109b741fe69221f5cd67fb0680f37c213f585227f95c1c319008691c9 = (value_50).required;

                        const value_52: u64 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, block_132: {
                            const operand_130 = ((value_50).expressions).match_fallbacks;

                            const operand_131 = block_129: {
                                break :block_129 value_17;
                            };

                            if ((operand_131 >= (operand_130).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_132 (operand_130)[@intCast(operand_131)];
                        }));

                        const value_53: (zx_abi).value_7b8270d6a72fc47f5bdab3df507f6a882c4c11c531d5d08c7e73b12855f7393f = block_128: {
                            break :block_128 @as((zx_abi).value_7b8270d6a72fc47f5bdab3df507f6a882c4c11c531d5d08c7e73b12855f7393f, (zx_abi).value_7b8270d6a72fc47f5bdab3df507f6a882c4c11c531d5d08c7e73b12855f7393f{ .diagnostic = (value_50).diagnostic, .expressions = (value_50).expressions, .index = (value_50).index, .required = block_127: {
                                const operand_122 = value_51;
                                const operand_124 = block_123: {
                                    break :block_123 value_52;
                                };

                                if ((operand_124 >= ((operand_122).items).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                const operand_125 = true;
                                const operand_126 = @constCast((operand_122).items);

                                (operand_126)[@intCast(operand_124)] = operand_125;

                                break :block_127 (zx_abi).value_c92c000109b741fe69221f5cd67fb0680f37c213f585227f95c1c319008691c9{ .items = operand_126, .storage = (if ((@intFromEnum((operand_122).storage) >= 2)) .exclusive else .owned), };
                            }, .root = (value_50).root, });
                        };
                        const value_64: (zx_abi).value_51c7ae2890c137e1e5142626759d18fa4d8058932b94950f415cbd8b9e929182 = block_121: {
                            const operand_78 = block_77: {
                                const operand_60 = (value_53).required;
                                const operand_61 = (zx_abi).value_33852a8fbab30244ede08e3240b24724da5df4d16cab4ef72522d42b694006e6{ .items = ((value_53).expressions).match_conditions, .storage = .plain, };
                                const operand_62 = (zx_abi).value_33852a8fbab30244ede08e3240b24724da5df4d16cab4ef72522d42b694006e6{ .items = ((value_53).expressions).match_results, .storage = .plain, };

                                const operand_63 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, block_67: {
                                    const operand_65 = ((value_53).expressions).match_first;

                                    const operand_66 = block_64: {
                                        break :block_64 value_17;
                                    };

                                    if ((operand_66 >= (operand_65).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    break :block_67 (operand_65)[@intCast(operand_66)];
                                }));
                                const operand_68 = ((try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, block_72: {
                                    const operand_70 = ((value_53).expressions).match_first;
                                    const operand_71 = block_69: {
                                        break :block_69 value_17;
                                    };

                                    if ((operand_71 >= (operand_70).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    break :block_72 (operand_70)[@intCast(operand_71)];
                                })) + (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, block_76: {
                                    const operand_74 = ((value_53).expressions).match_count;

                                    const operand_75 = block_73: {
                                        break :block_73 value_17;
                                    };

                                    if ((operand_75 >= (operand_74).len)) {
                                        return error.IndexOutOfBounds;
                                    }

                                    break :block_76 (operand_74)[@intCast(operand_75)];
                                })));

                                break :block_77 @as((zx_abi).value_51c7ae2890c137e1e5142626759d18fa4d8058932b94950f415cbd8b9e929182, (zx_abi).value_51c7ae2890c137e1e5142626759d18fa4d8058932b94950f415cbd8b9e929182{ .required = operand_60, .conditions = operand_61, .results = operand_62, .index = operand_63, .end = operand_68, });
                            };
                            const loop_fields_80 = struct {
                                conditions: *const (zx_abi).value_33852a8fbab30244ede08e3240b24724da5df4d16cab4ef72522d42b694006e6,
                                end: u64,
                                index: u64,
                                required: (zx_abi).value_c92c000109b741fe69221f5cd67fb0680f37c213f585227f95c1c319008691c9,
                                results: *const (zx_abi).value_33852a8fbab30244ede08e3240b24724da5df4d16cab4ef72522d42b694006e6,
                                zx_origin: ?*const (zx_abi).zx_type_146be0007f8aaf60d5231bd6f760aba6560eb7b10bc80c99c0dfac4bef434836 = null,
                            };
                            var qualified_82: (zx_abi).value_51c7ae2890c137e1e5142626759d18fa4d8058932b94950f415cbd8b9e929182 = operand_78;
                            ((qualified_82).conditions).storage = (if ((@intFromEnum(((qualified_82).conditions).storage) >= 2)) .shared else .plain);
                            ((qualified_82).results).storage = (if ((@intFromEnum(((qualified_82).results).storage) >= 2)) .shared else .plain);
                            const loop_seed_79: (zx_abi).value_51c7ae2890c137e1e5142626759d18fa4d8058932b94950f415cbd8b9e929182 = qualified_82;
                            var state_changed_81 = false;

                            break :block_121 (if (((loop_seed_79).index < (loop_seed_79).end)) block_118: {
                                var qualified_112: (zx_abi).value_33852a8fbab30244ede08e3240b24724da5df4d16cab4ef72522d42b694006e6 = (loop_seed_79).conditions;

                                (qualified_112).storage = (if ((@intFromEnum((qualified_112).storage) >= 2)) .shared else .plain);
                                var qualified_113: (zx_abi).value_33852a8fbab30244ede08e3240b24724da5df4d16cab4ef72522d42b694006e6 = (loop_seed_79).results;

                                (qualified_113).storage = (if ((@intFromEnum((qualified_113).storage) >= 2)) .shared else .plain);
                                const operand_114 = (zx_abi).value_51c7ae2890c137e1e5142626759d18fa4d8058932b94950f415cbd8b9e929182{ .conditions = qualified_112, .end = (loop_seed_79).end, .index = (loop_seed_79).index, .required = (loop_seed_79).required, .results = qualified_113, .zx_origin = (loop_seed_79).zx_origin, };
                                var state_59: loop_fields_80 = loop_fields_80{ .conditions = (&(operand_114).conditions), .end = (operand_114).end, .index = (operand_114).index, .required = (operand_114).required, .results = (&(operand_114).results), .zx_origin = (operand_114).zx_origin, };

                                while (true) {
                                    const operand_115 = block_111: {
                                        const value_56: (zx_abi).value_c92c000109b741fe69221f5cd67fb0680f37c213f585227f95c1c319008691c9 = (state_59).required;

                                        const value_57: u64 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, block_110: {
                                            const operand_108 = (((state_59).conditions).*).items;
                                            const operand_109 = (state_59).index;

                                            if ((operand_109 >= (operand_108).len)) {
                                                return error.IndexOutOfBounds;
                                            }

                                            break :block_110 (operand_108)[@intCast(operand_109)];
                                        }));
                                        const value_58: loop_fields_80 = block_107: {
                                            break :block_107 loop_fields_80{ .conditions = block_99: {
                                                _ = ((state_59).conditions).*;

                                                break :block_99 (&(loop_seed_79).conditions);
                                            }, .end = (state_59).end, .index = (state_59).index, .required = block_105: {
                                                const operand_100 = value_56;

                                                const operand_102 = block_101: {
                                                    break :block_101 value_57;
                                                };

                                                if ((operand_102 >= ((operand_100).items).len)) {
                                                    return error.IndexOutOfBounds;
                                                }

                                                const operand_103 = true;
                                                const operand_104 = @constCast((operand_100).items);

                                                (operand_104)[@intCast(operand_102)] = operand_103;

                                                break :block_105 (zx_abi).value_c92c000109b741fe69221f5cd67fb0680f37c213f585227f95c1c319008691c9{ .items = operand_104, .storage = (if ((@intFromEnum((operand_100).storage) >= 2)) .exclusive else .owned), };
                                            }, .results = block_106: {
                                                _ = ((state_59).results).*;

                                                break :block_106 (&(loop_seed_79).results);
                                            }, };
                                        };
                                        const value_59: (zx_abi).value_c92c000109b741fe69221f5cd67fb0680f37c213f585227f95c1c319008691c9 = (value_58).required;

                                        const value_60: u64 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, block_98: {
                                            const operand_96 = (((value_58).results).*).items;
                                            const operand_97 = (value_58).index;

                                            if ((operand_97 >= (operand_96).len)) {
                                                return error.IndexOutOfBounds;
                                            }

                                            break :block_98 (operand_96)[@intCast(operand_97)];
                                        }));
                                        const value_61: loop_fields_80 = block_95: {
                                            break :block_95 loop_fields_80{ .conditions = block_87: {
                                                _ = ((value_58).conditions).*;

                                                break :block_87 (&(loop_seed_79).conditions);
                                            }, .end = (value_58).end, .index = (value_58).index, .required = block_93: {
                                                const operand_88 = value_59;
                                                const operand_90 = block_89: {
                                                    break :block_89 value_60;
                                                };

                                                if ((operand_90 >= ((operand_88).items).len)) {
                                                    return error.IndexOutOfBounds;
                                                }

                                                const operand_91 = true;
                                                const operand_92 = @constCast((operand_88).items);

                                                (operand_92)[@intCast(operand_90)] = operand_91;

                                                break :block_93 (zx_abi).value_c92c000109b741fe69221f5cd67fb0680f37c213f585227f95c1c319008691c9{ .items = operand_92, .storage = (if ((@intFromEnum((operand_88).storage) >= 2)) .exclusive else .owned), };
                                            }, .results = block_94: {
                                                _ = ((value_58).results).*;

                                                break :block_94 (&(loop_seed_79).results);
                                            }, };
                                        };
                                        const value_62: u64 = (value_61).index;

                                        const value_63: loop_fields_80 = block_86: {
                                            break :block_86 loop_fields_80{ .conditions = block_83: {
                                                _ = ((value_61).conditions).*;

                                                break :block_83 (&(loop_seed_79).conditions);
                                            }, .end = (value_61).end, .index = (block_84: {
                                                break :block_84 value_62;
                                            } + @as(u64, 1)), .required = (value_61).required, .results = block_85: {
                                                _ = ((value_61).results).*;

                                                break :block_85 (&(loop_seed_79).results);
                                            }, };
                                        };

                                        break :block_111 value_63;
                                    };

                                    state_59 = loop_fields_80{ .conditions = (operand_115).conditions, .end = (operand_115).end, .index = (operand_115).index, .required = (operand_115).required, .results = (operand_115).results, .zx_origin = (operand_115).zx_origin, };
                                    state_changed_81 = true;

                                    if ((!((state_59).index < (state_59).end))) {
                                        break;
                                    }
                                }

                                const operand_116 = (zx_abi).value_51c7ae2890c137e1e5142626759d18fa4d8058932b94950f415cbd8b9e929182{ .conditions = ((state_59).conditions).*, .end = (state_59).end, .index = (state_59).index, .required = (state_59).required, .results = ((state_59).results).*, .zx_origin = (state_59).zx_origin, };

                                break :block_118 (if (state_changed_81) operand_116 else operand_78);
                            } else block_120: {
                                break :block_120 (if (state_changed_81) loop_seed_79 else operand_78);
                            });
                        };
                        const value_65: (zx_abi).value_7b8270d6a72fc47f5bdab3df507f6a882c4c11c531d5d08c7e73b12855f7393f = block_58: {
                            break :block_58 @as((zx_abi).value_7b8270d6a72fc47f5bdab3df507f6a882c4c11c531d5d08c7e73b12855f7393f, (zx_abi).value_7b8270d6a72fc47f5bdab3df507f6a882c4c11c531d5d08c7e73b12855f7393f{ .diagnostic = (value_53).diagnostic, .expressions = (value_53).expressions, .index = (value_53).index, .required = (value_64).required, .root = (value_53).root, });
                        };

                        break :block_147 value_65;
                    } else value_45);

                    break :block_263 value_66;
                } else value_14);

                break :block_266 value_67;
            };

            const operand_268 = ((operand_267).diagnostic).code;
            const operand_269 = ((operand_267).diagnostic).end;
            const operand_270 = ((operand_267).diagnostic).message;
            const operand_271 = ((operand_267).diagnostic).start;
            const operand_272 = ((operand_267).diagnostic).zx_origin;
            const operand_273 = (operand_267).expressions;
            const operand_274 = (operand_267).index;
            const operand_275 = ((operand_267).required).items;
            const operand_276 = ((operand_267).required).storage;
            const operand_277 = (operand_267).root;
            const operand_278 = (operand_267).zx_origin;

            ((state_1).diagnostic).code = operand_268;
            ((state_1).diagnostic).end = operand_269;
            ((state_1).diagnostic).message = operand_270;
            ((state_1).diagnostic).start = operand_271;
            ((state_1).diagnostic).zx_origin = operand_272;
            (state_1).expressions = operand_273;
            (state_1).index = operand_274;
            ((state_1).required).items = operand_275;
            ((state_1).required).storage = operand_276;
            (state_1).root = operand_277;
            (state_1).zx_origin = operand_278;
            state_changed_48 = true;
        }

        break :block_280 (if (state_changed_48) state_1 else operand_46);
    }).diagnostic;
}

