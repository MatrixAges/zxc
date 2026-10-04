# Test262减法剩余协议审阅

## IDEA

- Intent：完成减法目录剩余八个文件的逐文件适用性审阅，保留未提供语义的事实，不伪造运行等价。
- Data：固定原文，当前IR固定宽度数值契约，既有普通调用顺序测试；BigInt算术全量提取并独立核验。
- Edges：本轮没有实现BigInt和动态对象协议，不增加ZX执行案例。excluded只是当前语言范围下的适用性结论，不表示上游通过。
- Answer：八个哈希核验后的独立理由、具体断言分类、可复现审阅检查与目录审计。

## 执行计划

1. 阅读八个文件的真实断言，不只读取metadata。
2. 对289个BigInt算术断言提取全部操作数/预期，检查完整性和数值。
3. 逐文件记录不适用原因，核查减法目录剩余未审阅数。

```mermaid
flowchart LR
  U[固定上游文件] --> H[哈希核验]
  H --> R[真实断言审阅]
  R --> C[与ZX契约比较]
  C --> E[逐文件适用性结论]
```

```mermaid
flowchart LR
  B[289个BigInt数值断言] --> P[完整提取并检查无剩余代码]
  P --> I[独立任意精度算术核验]
  I --> D[证明范围超出固定64位]
  D --> X[不转换成i64冒充等价]
```

## 逐文件证据

| 文件 | 原始要求 | 本轮结论 |
| --- | --- | --- |
| S11.6.2_A2.2_T1.js | 8项DefaultValue：valueOf优先、toString回退、对象返回、错误传播与最终TypeError | 动态拆箱协议不存在；不能用静态字段读取替代 |
| S11.6.2_A2.3_T1.js | 两个valueOf均抛错时先进行左侧ToNumber | 普通native调用轨迹不证明动态ToNumber顺序 |
| bigint-and-number.js | 20项混合数值/包装对象/NaN/Infinity/bool/string/null/undefined的TypeError | 没有BigInt类型与ToNumeric类型分派，词法拒绝不等价于运行TypeError |
| bigint-arithmetic.js | 17×17共289个BigInt减法结果 | 全量核验成立，但操作数及结果含超出固定64位范围，不能删n移植冒充原语义 |
| bigint-errors.js | 10项Symbol原始值/包装及三种动态转换返回Symbol时的TypeError | BigInt、Symbol及动态转换协议均不存在 |
| bigint-toprimitive.js | 20个成功值与24个异常：Symbol.toPrimitive优先/缺失回退、valueOf/toString回退、非callable、返回对象、抛错 | 所需协议不可表达，不缩减为三个普通函数调用 |
| bigint-wrapped-values.js | 8项Object(BigInt)及三类拆箱路径的左右操作数 | 不以固定整数或静态字段替代包装身份和拆箱 |
| order-of-evaluation.js | 6组错误和1/12/123/1234轨迹：GetValue两侧、ToPrimitive两侧、ToNumeric两侧 | 既有普通调用失败覆盖部分GetValue类行为，但不覆盖完整四步动态转换链，整文件不标执行等价 |

BigInt算术检查覆盖文件全部289个sameValue，移除匹配断言及注释后没有剩余代码。左右各17个值，289个唯一对，结果最小-36729517088986129440、最大36729517088986129440；每项结果由独立整数运算重新计算一致。该校验不是zxc运行测试。

## 自我批判

- 八条excluded是逐文件适用性决定，不是八个已执行并通过的测试。
- 即便部分BigInt结果可装入u64/i64，也不能由该子集推断任意精度语义等价。
- order-of-evaluation含普通GetValue失败子情形，已有轨迹与之相关；其余动态转换阶段没有覆盖，因此不能因为已有相关测试而把整文件算作执行通过。
- 若用户后续改变语言范围、要求动态协议或BigInt，这八条结论必须重审，而不是永久跳过。
- 减法目录审阅结束不表示整个Test262目标完成，也不表示ECMAScript兼容。

## 执行结果

八个文件逐一核验SHA-256，审阅校验脚本实际退出0，日志 `/tmp/zxc-subtraction-protocol-review.log`。脚本位于 `减法协议审阅/审阅校验.py`，从仓库根传入固定上游解包目录即可重现。289项独立数值检查不是zxc测试，不加入测试目录计数。

新增八条excluded记录于 `packages/test/upstream/reviews/language/expressions/subtraction_protocols.jsonl`，各自保留具体协议/断言理由，没有只按feature标签归类。`node src/audit_matrix.ts` 退出0，日志 `/tmp/zxc-subtraction-protocol-audit.log`。`query_upstream.ts --prefix test/language/expressions/subtraction/ --limit 20` 返回matched_unreviewed=0，日志 `/tmp/zxc-subtraction-remaining.log`。

登记仍61,614，上游400/53,597已审阅（257 adapted、102 equivalent、41 excluded），未审阅53,197，唯一关联仍2,116。没有新增测试或生产修改；本轮只运行审阅与审计，不重跑编译。diff检查通过，审查草稿一致，最新完整根仍阶段115。
