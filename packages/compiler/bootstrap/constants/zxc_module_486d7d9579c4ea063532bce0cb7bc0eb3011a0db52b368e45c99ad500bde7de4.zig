const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn callValue(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_bb5ac0a090cbfc56770e29e52ee3affea81f2679589f8ac90263c86cdaa71ddd) error{ IndexOutOfBounds, OutOfMemory, Overflow, }!(zx_abi).value_eee96ba051c35569fd3c2a5d2fadfd1b84c88fa281b1fb5d5d04a6553b7650e7 {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_e3df2773ec38c11e222c378af0279c373709148d1499df93406032dbe44d4cfd = (in).expressions;
    const value_2: u64 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, (in).root));

    const value_3: (zx_abi).value_eee96ba051c35569fd3c2a5d2fadfd1b84c88fa281b1fb5d5d04a6553b7650e7 = block_307: {
        const operand_303 = @as([]const u8, "");
        const operand_304 = @as(u64, 0);
        const operand_305 = @as(u64, 0);
        const operand_306 = @as([]const u8, "");

        break :block_307 @as((zx_abi).value_eee96ba051c35569fd3c2a5d2fadfd1b84c88fa281b1fb5d5d04a6553b7650e7, (zx_abi).value_eee96ba051c35569fd3c2a5d2fadfd1b84c88fa281b1fb5d5d04a6553b7650e7{ .code = operand_303, .start = operand_304, .end = operand_305, .message = operand_306, });
    };

    if ((block_296: {
        break :block_296 value_2;
    } >= @as(u64, ((block_297: {
        break :block_297 value_1;
    }).kinds).len))) {
        return block_302: {
            const operand_298 = @as([]const u8, "contract");
            const operand_299 = @as(u64, 0);
            const operand_300 = @as(u64, 0);
            const operand_301 = @as([]const u8, "constant expression root is out of bounds");

            break :block_302 @as((zx_abi).value_eee96ba051c35569fd3c2a5d2fadfd1b84c88fa281b1fb5d5d04a6553b7650e7, (zx_abi).value_eee96ba051c35569fd3c2a5d2fadfd1b84c88fa281b1fb5d5d04a6553b7650e7{ .code = operand_298, .start = operand_299, .end = operand_300, .message = operand_301, });
        };
    }

    return block_295: {
        const value_68: (zx_abi).value_a29c09cfae49cb5bb8320c83532c8b1b6feafb4e12a3c0f646b035967891c873 = block_294: {
            const operand_45 = block_44: {
                const operand_2 = block_3: {
                    break :block_3 value_1;
                };
                const operand_4 = block_5: {
                    break :block_5 value_2;
                };

                const operand_6 = (block_7: {
                    break :block_7 value_2;
                } + @as(u64, 1));
                const operand_8 = block_42: {
                    const value_5: (zx_abi).value_30e789c2b45c11d7de38fe9a6ca7a55fafb0d1efdc7ee68427f0d437930b1560 = (zx_abi).value_30e789c2b45c11d7de38fe9a6ca7a55fafb0d1efdc7ee68427f0d437930b1560{ .items = (block_41: {
                        break :block_41 value_1;
                    }).kinds, .storage = .plain, };

                    break :block_42 block_40: {
                        const operand_14 = block_13: {
                            const operand_10 = value_5;
                            const operand_11 = @as(u64, 0);
                            const operand_12 = (zx_abi).value_ef10e8daf842213dbf67d860744b8c2b0aee2449d39e98e360757ec527f0a4ed{ .items = @as([]const bool, (comptime (&[_]bool{}))), .storage = .plain, };

                            break :block_13 @as((zx_abi).value_d9c7c5fb94b649a00b17459c9961663edb7a717f6f622deba2e8757996784bea, (zx_abi).value_d9c7c5fb94b649a00b17459c9961663edb7a717f6f622deba2e8757996784bea{ .index = operand_11, .result = operand_12, .source = operand_10, });
                        };
                        const loop_fields_16 = struct {
                            index: u64,
                            result: (zx_abi).value_ef10e8daf842213dbf67d860744b8c2b0aee2449d39e98e360757ec527f0a4ed,
                            source: *const (zx_abi).value_30e789c2b45c11d7de38fe9a6ca7a55fafb0d1efdc7ee68427f0d437930b1560,
                            zx_origin: ?*const (zx_abi).zx_type_f7c04f634ae5b2093751e64fbcd14059ec3f0109817b535637410782abe2f29d = null,
                        };

                        var qualified_17: (zx_abi).value_d9c7c5fb94b649a00b17459c9961663edb7a717f6f622deba2e8757996784bea = operand_14;

                        ((qualified_17).source).storage = (if ((@intFromEnum(((qualified_17).source).storage) >= 2)) .shared else .plain);
                        const loop_seed_15: (zx_abi).value_d9c7c5fb94b649a00b17459c9961663edb7a717f6f622deba2e8757996784bea = qualified_17;

                        break :block_40 (if (((loop_seed_15).index < @as(u64, (((loop_seed_15).source).items).len))) block_38: {
                            var qualified_34: (zx_abi).value_30e789c2b45c11d7de38fe9a6ca7a55fafb0d1efdc7ee68427f0d437930b1560 = (loop_seed_15).source;

                            (qualified_34).storage = (if ((@intFromEnum((qualified_34).storage) >= 2)) .shared else .plain);
                            const operand_35 = (zx_abi).value_d9c7c5fb94b649a00b17459c9961663edb7a717f6f622deba2e8757996784bea{ .index = (loop_seed_15).index, .result = (loop_seed_15).result, .source = qualified_34, .zx_origin = (loop_seed_15).zx_origin, };
                            var state_9: loop_fields_16 = loop_fields_16{ .index = (operand_35).index, .result = (operand_35).result, .source = (&(operand_35).source), .zx_origin = (operand_35).zx_origin, };

                            while (true) {
                                const operand_36 = block_33: {
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

                                            break :block_27 @as((zx_abi).value_37009340549c7f80c4a77d79bb140e30b0936b6060ff6f02a771fb3c7f5d90a0, .{ block_26: {
                                                const operand_25 = (try (zx_abi).zxReserveBounded(bool, allocator, (operand_21).items, operand_24, (((loop_seed_15).source).items).len));

                                                (operand_25)[((operand_21).items).len] = operand_23;

                                                break :block_26 (zx_abi).value_ef10e8daf842213dbf67d860744b8c2b0aee2449d39e98e360757ec527f0a4ed{ .items = operand_25, .storage = (if ((((((operand_21).items).len == 0) or ((operand_25).ptr != ((operand_21).items).ptr)) or ((operand_21).storage == .exclusive))) .exclusive else .shared), };
                                            }, {}, null, });
                                        }).@"0";

                                        break :block_29 loop_fields_16{ .index = operand_19, .result = operand_20, .source = block_28: {
                                            _ = operand_18;

                                            break :block_28 (&(loop_seed_15).source);
                                        }, };
                                    };
                                };

                                state_9 = loop_fields_16{ .index = (operand_36).index, .result = (operand_36).result, .source = (operand_36).source, .zx_origin = (operand_36).zx_origin, };

                                if ((!((state_9).index < @as(u64, ((((state_9).source).*).items).len)))) {
                                    break;
                                }
                            }

                            const operand_37 = (zx_abi).value_d9c7c5fb94b649a00b17459c9961663edb7a717f6f622deba2e8757996784bea{ .index = (state_9).index, .result = (state_9).result, .source = ((state_9).source).*, .zx_origin = (state_9).zx_origin, };

                            break :block_38 (operand_37).result;
                        } else block_39: {
                            break :block_39 (loop_seed_15).result;
                        });
                    };
                };

                const operand_43 = value_3;

                break :block_44 @as((zx_abi).value_a29c09cfae49cb5bb8320c83532c8b1b6feafb4e12a3c0f646b035967891c873, (zx_abi).value_a29c09cfae49cb5bb8320c83532c8b1b6feafb4e12a3c0f646b035967891c873{ .expressions = operand_2, .root = operand_4, .index = operand_6, .required = operand_8, .diagnostic = operand_43, });
            };

            var state_1: (zx_abi).value_a29c09cfae49cb5bb8320c83532c8b1b6feafb4e12a3c0f646b035967891c873 = operand_45;
            var state_changed_47 = false;

            while ((((state_1).index != @as(u64, 0)) and block_50: {
                const operand_48 = ((state_1).diagnostic).message;
                const operand_49 = @as([]const u8, "");

                break :block_50 ((std).mem).eql(u8, operand_48, operand_49);
            })) {
                const operand_281 = block_280: {
                    const value_13: u64 = (state_1).index;

                    const value_14: (zx_abi).value_a29c09cfae49cb5bb8320c83532c8b1b6feafb4e12a3c0f646b035967891c873 = block_279: {
                        break :block_279 block_278: {
                            var updated_275: (zx_abi).value_a29c09cfae49cb5bb8320c83532c8b1b6feafb4e12a3c0f646b035967891c873 = state_1;

                            const operand_277 = (block_276: {
                                break :block_276 value_13;
                            } - @as(u64, 1));

                            (updated_275).index = operand_277;
                            (updated_275).zx_origin = null;

                            break :block_278 updated_275;
                        };
                    };

                    const value_15: u64 = (value_14).index;

                    const value_67: (zx_abi).value_a29c09cfae49cb5bb8320c83532c8b1b6feafb4e12a3c0f646b035967891c873 = (if (((block_51: {
                        break :block_51 value_15;
                    } == (value_14).root) or block_55: {
                        const operand_53 = ((value_14).required).items;

                        const operand_54 = block_52: {
                            break :block_52 value_15;
                        };

                        if ((operand_54 >= (operand_53).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_55 (operand_53)[@intCast(operand_54)];
                    })) block_274: {
                        const value_16: (zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5 = block_273: {
                            const operand_271 = ((value_14).expressions).kinds;

                            const operand_272 = block_270: {
                                break :block_270 value_15;
                            };

                            if ((operand_272 >= (operand_271).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_273 (operand_271)[@intCast(operand_272)];
                        };
                        const value_17: u64 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, block_269: {
                            const operand_267 = ((value_14).expressions).payloads;

                            const operand_268 = block_266: {
                                break :block_266 value_15;
                            };

                            if ((operand_268 >= (operand_267).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_269 (operand_267)[@intCast(operand_268)];
                        }));
                        const value_18: bool = block_265: {
                            const operand_264 = block_263: {
                                break :block_263 value_16;
                            };

                            break :block_265 switch (operand_264) { @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Integer) => true, @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .NegativeInteger) => true, @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Float) => true, @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .String) => true, @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Boolean) => true, else => (if ((operand_264 == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .EnumValue))) true else false), };
                        };
                        const value_19: bool = ((block_261: {
                            break :block_261 value_16;
                        } == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Unary)) or (block_262: {
                            break :block_262 value_16;
                        } == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Binary)));

                        const value_20: bool = ((block_259: {
                            break :block_259 value_16;
                        } == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Conditional)) or (block_260: {
                            break :block_260 value_16;
                        } == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Match)));

                        const value_21: bool = ((block_254: {
                            break :block_254 value_16;
                        } == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Binary)) and (block_258: {
                            const operand_256 = ((value_14).expressions).binary_operators;

                            const operand_257 = block_255: {
                                break :block_255 value_17;
                            };

                            if ((operand_257 >= (operand_256).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_258 (operand_256)[@intCast(operand_257)];
                        } == @as((zx_abi).zx_type_c2cf793e3172a7ed4a668fba2693ad110a34623e2f0f6b109fb61f2967243a7a, .Coalesce)));

                        const value_22: bool = ((((!(!(!block_250: {
                            break :block_250 value_18;
                        }))) and (!block_251: {
                            break :block_251 value_19;
                        })) and (!block_252: {
                            break :block_252 value_20;
                        })) or block_253: {
                            break :block_253 value_21;
                        });

                        const value_24: (zx_abi).value_a29c09cfae49cb5bb8320c83532c8b1b6feafb4e12a3c0f646b035967891c873 = (if (block_231: {
                            break :block_231 value_22;
                        }) block_249: {
                            const value_23: (zx_abi).value_a29c09cfae49cb5bb8320c83532c8b1b6feafb4e12a3c0f646b035967891c873 = block_248: {
                                break :block_248 block_247: {
                                    var updated_232: (zx_abi).value_a29c09cfae49cb5bb8320c83532c8b1b6feafb4e12a3c0f646b035967891c873 = value_14;

                                    const operand_246 = block_245: {
                                        const operand_233 = @as([]const u8, "unsupported");
                                        const operand_234 = block_238: {
                                            const operand_236 = ((value_14).expressions).span_start;
                                            const operand_237 = block_235: {
                                                break :block_235 value_15;
                                            };

                                            if ((operand_237 >= (operand_236).len)) {
                                                return error.IndexOutOfBounds;
                                            }

                                            break :block_238 (operand_236)[@intCast(operand_237)];
                                        };
                                        const operand_239 = block_243: {
                                            const operand_241 = ((value_14).expressions).span_end;

                                            const operand_242 = block_240: {
                                                break :block_240 value_15;
                                            };

                                            if ((operand_242 >= (operand_241).len)) {
                                                return error.IndexOutOfBounds;
                                            }

                                            break :block_243 (operand_241)[@intCast(operand_242)];
                                        };

                                        const operand_244 = @as([]const u8, "constant initializers require closed scalar expressions");

                                        break :block_245 @as((zx_abi).value_eee96ba051c35569fd3c2a5d2fadfd1b84c88fa281b1fb5d5d04a6553b7650e7, (zx_abi).value_eee96ba051c35569fd3c2a5d2fadfd1b84c88fa281b1fb5d5d04a6553b7650e7{ .code = operand_233, .start = operand_234, .end = operand_239, .message = operand_244, });
                                    };
                                    (updated_232).diagnostic = operand_246;
                                    (updated_232).zx_origin = null;

                                    break :block_247 updated_232;
                                };
                            };

                            break :block_249 value_23;
                        } else value_14);

                        const value_28: (zx_abi).value_a29c09cfae49cb5bb8320c83532c8b1b6feafb4e12a3c0f646b035967891c873 = (if ((block_215: {
                            break :block_215 value_16;
                        } == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Unary))) block_230: {
                            const value_25: (zx_abi).value_ef10e8daf842213dbf67d860744b8c2b0aee2449d39e98e360757ec527f0a4ed = (value_24).required;

                            const value_26: u64 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, block_229: {
                                const operand_227 = ((value_24).expressions).unary_operands;

                                const operand_228 = block_226: {
                                    break :block_226 value_17;
                                };

                                if ((operand_228 >= (operand_227).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_229 (operand_227)[@intCast(operand_228)];
                            }));

                            const value_27: (zx_abi).value_a29c09cfae49cb5bb8320c83532c8b1b6feafb4e12a3c0f646b035967891c873 = block_225: {
                                break :block_225 block_224: {
                                    var updated_216: (zx_abi).value_a29c09cfae49cb5bb8320c83532c8b1b6feafb4e12a3c0f646b035967891c873 = value_24;

                                    const operand_223 = block_222: {
                                        const operand_217 = value_25;
                                        const operand_219 = block_218: {
                                            break :block_218 value_26;
                                        };

                                        if ((operand_219 >= ((operand_217).items).len)) {
                                            return error.IndexOutOfBounds;
                                        }

                                        const operand_220 = true;
                                        const operand_221 = @constCast((operand_217).items);

                                        (operand_221)[@intCast(operand_219)] = operand_220;

                                        break :block_222 (zx_abi).value_ef10e8daf842213dbf67d860744b8c2b0aee2449d39e98e360757ec527f0a4ed{ .items = operand_221, .storage = (if ((@intFromEnum((operand_217).storage) >= 2)) .exclusive else .owned), };
                                    };

                                    (updated_216).required = operand_223;
                                    (updated_216).zx_origin = null;

                                    break :block_224 updated_216;
                                };
                            };

                            break :block_230 value_27;
                        } else value_24);

                        const value_35: (zx_abi).value_a29c09cfae49cb5bb8320c83532c8b1b6feafb4e12a3c0f646b035967891c873 = (if ((block_188: {
                            break :block_188 value_16;
                        } == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Binary))) block_214: {
                            const value_29: (zx_abi).value_ef10e8daf842213dbf67d860744b8c2b0aee2449d39e98e360757ec527f0a4ed = (value_28).required;

                            const value_30: u64 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, block_213: {
                                const operand_211 = ((value_28).expressions).binary_left;

                                const operand_212 = block_210: {
                                    break :block_210 value_17;
                                };

                                if ((operand_212 >= (operand_211).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_213 (operand_211)[@intCast(operand_212)];
                            }));

                            var value_31: (zx_abi).value_a29c09cfae49cb5bb8320c83532c8b1b6feafb4e12a3c0f646b035967891c873 = block_209: {
                                break :block_209 block_208: {
                                    var updated_200: (zx_abi).value_a29c09cfae49cb5bb8320c83532c8b1b6feafb4e12a3c0f646b035967891c873 = value_28;

                                    const operand_207 = block_206: {
                                        const operand_201 = value_29;
                                        const operand_203 = block_202: {
                                            break :block_202 value_30;
                                        };

                                        if ((operand_203 >= ((operand_201).items).len)) {
                                            return error.IndexOutOfBounds;
                                        }

                                        const operand_204 = true;
                                        const operand_205 = @constCast((operand_201).items);

                                        (operand_205)[@intCast(operand_203)] = operand_204;

                                        break :block_206 (zx_abi).value_ef10e8daf842213dbf67d860744b8c2b0aee2449d39e98e360757ec527f0a4ed{ .items = operand_205, .storage = (if ((@intFromEnum((operand_201).storage) >= 2)) .exclusive else .owned), };
                                    };

                                    (updated_200).required = operand_207;
                                    (updated_200).zx_origin = null;

                                    break :block_208 updated_200;
                                };
                            };
                            const value_32: (zx_abi).value_ef10e8daf842213dbf67d860744b8c2b0aee2449d39e98e360757ec527f0a4ed = (value_31).required;

                            const value_33: u64 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, block_199: {
                                const operand_197 = ((value_31).expressions).binary_right;

                                const operand_198 = block_196: {
                                    break :block_196 value_17;
                                };

                                if ((operand_198 >= (operand_197).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_199 (operand_197)[@intCast(operand_198)];
                            }));
                            const operand_195 = block_194: {
                                const operand_189 = value_32;
                                const operand_191 = block_190: {
                                    break :block_190 value_33;
                                };

                                if ((operand_191 >= ((operand_189).items).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                const operand_192 = true;
                                const operand_193 = @constCast((operand_189).items);

                                (operand_193)[@intCast(operand_191)] = operand_192;
                                break :block_194 (zx_abi).value_ef10e8daf842213dbf67d860744b8c2b0aee2449d39e98e360757ec527f0a4ed{ .items = operand_193, .storage = (if ((@intFromEnum((operand_189).storage) >= 2)) .exclusive else .owned), };
                            };

                            (value_31).required = operand_195;
                            (value_31).zx_origin = null;

                            break :block_214 value_31;
                        } else value_28);
                        const value_45: (zx_abi).value_a29c09cfae49cb5bb8320c83532c8b1b6feafb4e12a3c0f646b035967891c873 = (if ((block_150: {
                            break :block_150 value_16;
                        } == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Conditional))) block_187: {
                            const value_36: (zx_abi).value_ef10e8daf842213dbf67d860744b8c2b0aee2449d39e98e360757ec527f0a4ed = (value_35).required;

                            const value_37: u64 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, block_186: {
                                const operand_184 = ((value_35).expressions).conditional_conditions;

                                const operand_185 = block_183: {
                                    break :block_183 value_17;
                                };

                                if ((operand_185 >= (operand_184).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_186 (operand_184)[@intCast(operand_185)];
                            }));
                            var value_38: (zx_abi).value_a29c09cfae49cb5bb8320c83532c8b1b6feafb4e12a3c0f646b035967891c873 = block_182: {
                                break :block_182 block_181: {
                                    var updated_173: (zx_abi).value_a29c09cfae49cb5bb8320c83532c8b1b6feafb4e12a3c0f646b035967891c873 = value_35;

                                    const operand_180 = block_179: {
                                        const operand_174 = value_36;
                                        const operand_176 = block_175: {
                                            break :block_175 value_37;
                                        };

                                        if ((operand_176 >= ((operand_174).items).len)) {
                                            return error.IndexOutOfBounds;
                                        }

                                        const operand_177 = true;
                                        const operand_178 = @constCast((operand_174).items);

                                        (operand_178)[@intCast(operand_176)] = operand_177;

                                        break :block_179 (zx_abi).value_ef10e8daf842213dbf67d860744b8c2b0aee2449d39e98e360757ec527f0a4ed{ .items = operand_178, .storage = (if ((@intFromEnum((operand_174).storage) >= 2)) .exclusive else .owned), };
                                    };

                                    (updated_173).required = operand_180;
                                    (updated_173).zx_origin = null;

                                    break :block_181 updated_173;
                                };
                            };
                            const value_39: (zx_abi).value_ef10e8daf842213dbf67d860744b8c2b0aee2449d39e98e360757ec527f0a4ed = (value_38).required;

                            const value_40: u64 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, block_172: {
                                const operand_170 = ((value_38).expressions).conditional_yes;

                                const operand_171 = block_169: {
                                    break :block_169 value_17;
                                };

                                if ((operand_171 >= (operand_170).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_172 (operand_170)[@intCast(operand_171)];
                            }));
                            const operand_168 = block_167: {
                                const operand_162 = value_39;
                                const operand_164 = block_163: {
                                    break :block_163 value_40;
                                };

                                if ((operand_164 >= ((operand_162).items).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                const operand_165 = true;
                                const operand_166 = @constCast((operand_162).items);

                                (operand_166)[@intCast(operand_164)] = operand_165;

                                break :block_167 (zx_abi).value_ef10e8daf842213dbf67d860744b8c2b0aee2449d39e98e360757ec527f0a4ed{ .items = operand_166, .storage = (if ((@intFromEnum((operand_162).storage) >= 2)) .exclusive else .owned), };
                            };
                            (value_38).required = operand_168;
                            (value_38).zx_origin = null;
                            const value_42: (zx_abi).value_ef10e8daf842213dbf67d860744b8c2b0aee2449d39e98e360757ec527f0a4ed = (value_38).required;

                            const value_43: u64 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, block_161: {
                                const operand_159 = ((value_38).expressions).conditional_no;

                                const operand_160 = block_158: {
                                    break :block_158 value_17;
                                };

                                if ((operand_160 >= (operand_159).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_161 (operand_159)[@intCast(operand_160)];
                            }));
                            const operand_157 = block_156: {
                                const operand_151 = value_42;

                                const operand_153 = block_152: {
                                    break :block_152 value_43;
                                };

                                if ((operand_153 >= ((operand_151).items).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                const operand_154 = true;
                                const operand_155 = @constCast((operand_151).items);

                                (operand_155)[@intCast(operand_153)] = operand_154;

                                break :block_156 (zx_abi).value_ef10e8daf842213dbf67d860744b8c2b0aee2449d39e98e360757ec527f0a4ed{ .items = operand_155, .storage = (if ((@intFromEnum((operand_151).storage) >= 2)) .exclusive else .owned), };
                            };
                            (value_38).required = operand_157;
                            (value_38).zx_origin = null;

                            break :block_187 value_38;
                        } else value_35);
                        const value_66: (zx_abi).value_a29c09cfae49cb5bb8320c83532c8b1b6feafb4e12a3c0f646b035967891c873 = (if ((block_56: {
                            break :block_56 value_16;
                        } == @as((zx_abi).zx_type_2af9665120767ed61dc0e8028c12ae89cfa0b236b6cd3a6cef89b0359def17b5, .Match))) block_149: {
                            const value_46: ?u32 = block_148: {
                                const operand_146 = ((value_45).expressions).match_subjects;

                                const operand_147 = block_145: {
                                    break :block_145 value_17;
                                };

                                if ((operand_147 >= (operand_146).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_148 (operand_146)[@intCast(operand_147)];
                            };
                            var value_50: (zx_abi).value_a29c09cfae49cb5bb8320c83532c8b1b6feafb4e12a3c0f646b035967891c873 = (if ((block_132: {
                                break :block_132 value_46;
                            } != null)) block_144: {
                                const value_47: (zx_abi).value_ef10e8daf842213dbf67d860744b8c2b0aee2449d39e98e360757ec527f0a4ed = (value_45).required;

                                const value_48: u64 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, block_143: {
                                    break :block_143 value_46;
                                }.?));
                                const value_49: (zx_abi).value_a29c09cfae49cb5bb8320c83532c8b1b6feafb4e12a3c0f646b035967891c873 = block_142: {
                                    break :block_142 block_141: {
                                        var updated_133: (zx_abi).value_a29c09cfae49cb5bb8320c83532c8b1b6feafb4e12a3c0f646b035967891c873 = value_45;

                                        const operand_140 = block_139: {
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

                                            break :block_139 (zx_abi).value_ef10e8daf842213dbf67d860744b8c2b0aee2449d39e98e360757ec527f0a4ed{ .items = operand_138, .storage = (if ((@intFromEnum((operand_134).storage) >= 2)) .exclusive else .owned), };
                                        };
                                        (updated_133).required = operand_140;
                                        (updated_133).zx_origin = null;

                                        break :block_141 updated_133;
                                    };
                                };

                                break :block_144 value_49;
                            } else value_45);

                            const value_51: (zx_abi).value_ef10e8daf842213dbf67d860744b8c2b0aee2449d39e98e360757ec527f0a4ed = (value_50).required;

                            const value_52: u64 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, block_131: {
                                const operand_129 = ((value_50).expressions).match_fallbacks;

                                const operand_130 = block_128: {
                                    break :block_128 value_17;
                                };

                                if ((operand_130 >= (operand_129).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                break :block_131 (operand_129)[@intCast(operand_130)];
                            }));
                            const operand_127 = block_126: {
                                const operand_121 = value_51;
                                const operand_123 = block_122: {
                                    break :block_122 value_52;
                                };

                                if ((operand_123 >= ((operand_121).items).len)) {
                                    return error.IndexOutOfBounds;
                                }

                                const operand_124 = true;
                                const operand_125 = @constCast((operand_121).items);

                                (operand_125)[@intCast(operand_123)] = operand_124;

                                break :block_126 (zx_abi).value_ef10e8daf842213dbf67d860744b8c2b0aee2449d39e98e360757ec527f0a4ed{ .items = operand_125, .storage = (if ((@intFromEnum((operand_121).storage) >= 2)) .exclusive else .owned), };
                            };

                            (value_50).required = operand_127;
                            (value_50).zx_origin = null;

                            const value_64: (zx_abi).value_15a7a10a04e2c4d581d0744fec6933473be603fe3ed55d9199d96fd7200bee54 = block_120: {
                                const operand_77 = block_76: {
                                    const operand_59 = (value_50).required;
                                    const operand_60 = (zx_abi).value_1ebf1fe3843450ac449e4fe2375bb537b210fa9f03c9825ec6719b2cc82e77dd{ .items = ((value_50).expressions).match_conditions, .storage = .plain, };
                                    const operand_61 = (zx_abi).value_1ebf1fe3843450ac449e4fe2375bb537b210fa9f03c9825ec6719b2cc82e77dd{ .items = ((value_50).expressions).match_results, .storage = .plain, };

                                    const operand_62 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, block_66: {
                                        const operand_64 = ((value_50).expressions).match_first;
                                        const operand_65 = block_63: {
                                            break :block_63 value_17;
                                        };

                                        if ((operand_65 >= (operand_64).len)) {
                                            return error.IndexOutOfBounds;
                                        }

                                        break :block_66 (operand_64)[@intCast(operand_65)];
                                    }));
                                    const operand_67 = ((try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, block_71: {
                                        const operand_69 = ((value_50).expressions).match_first;

                                        const operand_70 = block_68: {
                                            break :block_68 value_17;
                                        };

                                        if ((operand_70 >= (operand_69).len)) {
                                            return error.IndexOutOfBounds;
                                        }

                                        break :block_71 (operand_69)[@intCast(operand_70)];
                                    })) + (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, block_75: {
                                        const operand_73 = ((value_50).expressions).match_count;

                                        const operand_74 = block_72: {
                                            break :block_72 value_17;
                                        };

                                        if ((operand_74 >= (operand_73).len)) {
                                            return error.IndexOutOfBounds;
                                        }

                                        break :block_75 (operand_73)[@intCast(operand_74)];
                                    })));

                                    break :block_76 @as((zx_abi).value_15a7a10a04e2c4d581d0744fec6933473be603fe3ed55d9199d96fd7200bee54, (zx_abi).value_15a7a10a04e2c4d581d0744fec6933473be603fe3ed55d9199d96fd7200bee54{ .required = operand_59, .conditions = operand_60, .results = operand_61, .index = operand_62, .end = operand_67, });
                                };
                                const loop_fields_79 = struct {
                                    conditions: *const (zx_abi).value_1ebf1fe3843450ac449e4fe2375bb537b210fa9f03c9825ec6719b2cc82e77dd,
                                    end: u64,
                                    index: u64,
                                    required: (zx_abi).value_ef10e8daf842213dbf67d860744b8c2b0aee2449d39e98e360757ec527f0a4ed,
                                    results: *const (zx_abi).value_1ebf1fe3843450ac449e4fe2375bb537b210fa9f03c9825ec6719b2cc82e77dd,
                                    zx_origin: ?*const (zx_abi).zx_type_146be0007f8aaf60d5231bd6f760aba6560eb7b10bc80c99c0dfac4bef434836 = null,
                                };
                                var qualified_81: (zx_abi).value_15a7a10a04e2c4d581d0744fec6933473be603fe3ed55d9199d96fd7200bee54 = operand_77;

                                zx_weaken_c5776d9db8bcc12cc15b883e99397e5bf9da80be1e8f81aa6ea525c9b839ef5e((&qualified_81));

                                const loop_seed_78: (zx_abi).value_15a7a10a04e2c4d581d0744fec6933473be603fe3ed55d9199d96fd7200bee54 = qualified_81;
                                var state_changed_80 = false;

                                break :block_120 (if (((loop_seed_78).index < (loop_seed_78).end)) block_117: {
                                    var qualified_111: (zx_abi).value_1ebf1fe3843450ac449e4fe2375bb537b210fa9f03c9825ec6719b2cc82e77dd = (loop_seed_78).conditions;

                                    (qualified_111).storage = (if ((@intFromEnum((qualified_111).storage) >= 2)) .shared else .plain);
                                    var qualified_112: (zx_abi).value_1ebf1fe3843450ac449e4fe2375bb537b210fa9f03c9825ec6719b2cc82e77dd = (loop_seed_78).results;
                                    (qualified_112).storage = (if ((@intFromEnum((qualified_112).storage) >= 2)) .shared else .plain);
                                    const operand_113 = (zx_abi).value_15a7a10a04e2c4d581d0744fec6933473be603fe3ed55d9199d96fd7200bee54{ .conditions = qualified_111, .end = (loop_seed_78).end, .index = (loop_seed_78).index, .required = (loop_seed_78).required, .results = qualified_112, .zx_origin = (loop_seed_78).zx_origin, };
                                    var state_58: loop_fields_79 = loop_fields_79{ .conditions = (&(operand_113).conditions), .end = (operand_113).end, .index = (operand_113).index, .required = (operand_113).required, .results = (&(operand_113).results), .zx_origin = (operand_113).zx_origin, };

                                    while (true) {
                                        const operand_114 = block_110: {
                                            const value_56: (zx_abi).value_ef10e8daf842213dbf67d860744b8c2b0aee2449d39e98e360757ec527f0a4ed = (state_58).required;

                                            const value_57: u64 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, block_109: {
                                                const operand_107 = (((state_58).conditions).*).items;
                                                const operand_108 = (state_58).index;

                                                if ((operand_108 >= (operand_107).len)) {
                                                    return error.IndexOutOfBounds;
                                                }

                                                break :block_109 (operand_107)[@intCast(operand_108)];
                                            }));
                                            const value_58: loop_fields_79 = block_106: {
                                                break :block_106 loop_fields_79{ .conditions = block_98: {
                                                    _ = ((state_58).conditions).*;

                                                    break :block_98 (&(loop_seed_78).conditions);
                                                }, .end = (state_58).end, .index = (state_58).index, .required = block_104: {
                                                    const operand_99 = value_56;

                                                    const operand_101 = block_100: {
                                                        break :block_100 value_57;
                                                    };

                                                    if ((operand_101 >= ((operand_99).items).len)) {
                                                        return error.IndexOutOfBounds;
                                                    }

                                                    const operand_102 = true;
                                                    const operand_103 = @constCast((operand_99).items);

                                                    (operand_103)[@intCast(operand_101)] = operand_102;

                                                    break :block_104 (zx_abi).value_ef10e8daf842213dbf67d860744b8c2b0aee2449d39e98e360757ec527f0a4ed{ .items = operand_103, .storage = (if ((@intFromEnum((operand_99).storage) >= 2)) .exclusive else .owned), };
                                                }, .results = block_105: {
                                                    _ = ((state_58).results).*;

                                                    break :block_105 (&(loop_seed_78).results);
                                                }, };
                                            };
                                            const value_59: (zx_abi).value_ef10e8daf842213dbf67d860744b8c2b0aee2449d39e98e360757ec527f0a4ed = (value_58).required;

                                            const value_60: u64 = (try (@import("zxc_module_1556558f3553681db94a81603f876ffbf274fcc003da60e284e06b42ec076761.zig")).call(allocator, block_97: {
                                                const operand_95 = (((value_58).results).*).items;
                                                const operand_96 = (value_58).index;

                                                if ((operand_96 >= (operand_95).len)) {
                                                    return error.IndexOutOfBounds;
                                                }

                                                break :block_97 (operand_95)[@intCast(operand_96)];
                                            }));
                                            const value_61: loop_fields_79 = block_94: {
                                                break :block_94 loop_fields_79{ .conditions = block_86: {
                                                    _ = ((value_58).conditions).*;

                                                    break :block_86 (&(loop_seed_78).conditions);
                                                }, .end = (value_58).end, .index = (value_58).index, .required = block_92: {
                                                    const operand_87 = value_59;
                                                    const operand_89 = block_88: {
                                                        break :block_88 value_60;
                                                    };

                                                    if ((operand_89 >= ((operand_87).items).len)) {
                                                        return error.IndexOutOfBounds;
                                                    }

                                                    const operand_90 = true;
                                                    const operand_91 = @constCast((operand_87).items);

                                                    (operand_91)[@intCast(operand_89)] = operand_90;

                                                    break :block_92 (zx_abi).value_ef10e8daf842213dbf67d860744b8c2b0aee2449d39e98e360757ec527f0a4ed{ .items = operand_91, .storage = (if ((@intFromEnum((operand_87).storage) >= 2)) .exclusive else .owned), };
                                                }, .results = block_93: {
                                                    _ = ((value_58).results).*;

                                                    break :block_93 (&(loop_seed_78).results);
                                                }, };
                                            };
                                            const value_62: u64 = (value_61).index;

                                            const value_63: loop_fields_79 = block_85: {
                                                break :block_85 loop_fields_79{ .conditions = block_82: {
                                                    _ = ((value_61).conditions).*;

                                                    break :block_82 (&(loop_seed_78).conditions);
                                                }, .end = (value_61).end, .index = (block_83: {
                                                    break :block_83 value_62;
                                                } + @as(u64, 1)), .required = (value_61).required, .results = block_84: {
                                                    _ = ((value_61).results).*;

                                                    break :block_84 (&(loop_seed_78).results);
                                                }, };
                                            };

                                            break :block_110 value_63;
                                        };

                                        state_58 = loop_fields_79{ .conditions = (operand_114).conditions, .end = (operand_114).end, .index = (operand_114).index, .required = (operand_114).required, .results = (operand_114).results, .zx_origin = (operand_114).zx_origin, };
                                        state_changed_80 = true;

                                        if ((!((state_58).index < (state_58).end))) {
                                            break;
                                        }
                                    }

                                    const operand_115 = (zx_abi).value_15a7a10a04e2c4d581d0744fec6933473be603fe3ed55d9199d96fd7200bee54{ .conditions = ((state_58).conditions).*, .end = (state_58).end, .index = (state_58).index, .required = (state_58).required, .results = ((state_58).results).*, .zx_origin = (state_58).zx_origin, };

                                    break :block_117 (if (state_changed_80) operand_115 else operand_77);
                                } else block_119: {
                                    break :block_119 (if (state_changed_80) loop_seed_78 else operand_77);
                                });
                            };

                            const operand_57 = (value_64).required;

                            (value_50).required = operand_57;
                            (value_50).zx_origin = null;

                            break :block_149 value_50;
                        } else value_45);

                        break :block_274 value_66;
                    } else value_14);

                    break :block_280 value_67;
                };

                const operand_282 = ((operand_281).diagnostic).code;
                const operand_283 = ((operand_281).diagnostic).end;
                const operand_284 = ((operand_281).diagnostic).message;
                const operand_285 = ((operand_281).diagnostic).start;
                const operand_286 = ((operand_281).diagnostic).zx_origin;
                const operand_287 = (operand_281).expressions;
                const operand_288 = (operand_281).index;
                const operand_289 = ((operand_281).required).items;
                const operand_290 = ((operand_281).required).storage;
                const operand_291 = (operand_281).root;
                const operand_292 = (operand_281).zx_origin;
                ((state_1).diagnostic).code = operand_282;
                ((state_1).diagnostic).end = operand_283;
                ((state_1).diagnostic).message = operand_284;
                ((state_1).diagnostic).start = operand_285;
                ((state_1).diagnostic).zx_origin = operand_286;
                (state_1).expressions = operand_287;
                (state_1).index = operand_288;
                ((state_1).required).items = operand_289;
                ((state_1).required).storage = operand_290;
                (state_1).root = operand_291;
                (state_1).zx_origin = operand_292;
                state_changed_47 = true;
            }

            break :block_294 (if (state_changed_47) state_1 else operand_45);
        };

        break :block_295 (value_68).diagnostic;
    };
}

fn zx_weaken_c5776d9db8bcc12cc15b883e99397e5bf9da80be1e8f81aa6ea525c9b839ef5e(value: *(zx_abi).value_15a7a10a04e2c4d581d0744fec6933473be603fe3ed55d9199d96fd7200bee54) void {
    ((value).conditions).storage = (if ((@intFromEnum(((value).conditions).storage) >= 2)) .shared else .plain);
    ((value).results).storage = (if ((@intFromEnum(((value).results).storage) >= 2)) .shared else .plain);
}
