# 完整 URL 验证记录

## Intent：最终目标

对正式 URL 核心执行固定 WPT 解析语料，验证 input/base、URL 字段、序列化及 origin。

## Data：实测证据

- 上游版本：c48d58747e1f211527fb695fd60548a997fae617，仓库 https://github.com/web-platform-tests/wpt 。
- 完整 896 个对象：627 成功、269 拒绝，无跳过、无期望替换。
- 成功对象每条比较 href、protocol、username、password、host、hostname、port、pathname、search、hash；其中 414 条额外比较 origin。
- 627 条成功用例均将 href 再解析并序列化，检查幂等。
- Debug：22/22 构建步骤，896/896 测试通过。
- ReleaseSafe：22/22 构建步骤，896/896 测试通过。
- 生成器 --check 核验全部上游文件 SHA256 和 9 个测试文件内容；zig fmt --check、git diff --check 通过。
- 所有解析生命周期经 std.testing.allocator 检查，未报告泄漏。

执行命令：

```sh
python3 docs/2026-10-05/完整URL验证/生成用例.py --check
zig build --build-file packages/test/build.zig test-url-parser -j4 --summary all
zig build --build-file packages/test/build.zig test-url-parser -Doptimize=ReleaseSafe -j4 --summary all
```

日志保存于同名功能目录。构建入口已接入 test-standard-resources；本次执行的是独立 test-url-parser，不宣称整套标准库回归已重跑。

## Edges：边界与自审

1. 核心 URL 测试不能替代 ZX 公共函数 ABI 与发布库消费验证，也不覆盖平台文件路径转换、setter、历史编码与浏览器环境。
2. 测试按功能归入 standard/resources/url/parser；内部按上游顺序每百条分组编译，名称包含原数组索引，便于定位。生成文件只转义保存原值，不依据实现结果生成期望。
3. WPT 没有指定 origin 的用例不额外推测其期望；再解析幂等属于补充性质检查，不能单独证明标准正确性。
4. std.testing.allocator 检测本次正常与拒绝路径的资源释放，不代表已完成每个分配点的 OOM 注入验证。
5. 失败用例接受解析错误并显式传播 OutOfMemory；WPT 只约束成功或失败，不约束内部错误枚举。
6. 原始语料、README、BSD 许可证保持原目录关系，锁定提交和文件哈希。测试不在运行时联网。
7. 提交钩子曾格式化上游 JSON，提交后哈希复核及时检出；已针对 packages/test/upstream/wpt 添加 Prettier 排除规则并恢复原文，再次执行生成器校验。
8. 未修改生产源码；没有发现生产问题，因此未给实现会话发送消息。

## Answer：交付与下一步

本部分交付完整固定语料的 896 个独立 Zig 测试、共享字段断言、构建入口、可重现生成器、语料许可与校验清单。下一部分继续验证 ZX URL 公共 API、原生库消费与文件 URL 平台边界；整体 Test262 与全特性目标仍在继续。
