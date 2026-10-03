模块由路径标识。让文件组织与业务职责保持一致，便能在不依赖别名注册表的情况下理解导入。

### RX 服务路径

`Call.service` 和 `Import.from` 相对导入方模块解析。省略 `.rx` 后缀时，规范化器会自动补齐：`./load` 与 `load.rx` 指向同一个同级模块。

| 形式                                       | RX 行为                          |
| ------------------------------------------ | -------------------------------- |
| `users/load`                               | 调用方目录下的模块               |
| `../shared/load`                           | 位于项目范围内的上级目录中的模块 |
| `/users/load`                              | 拒绝：绝对路径                   |
| 越出项目根目录的路径                       | 拒绝                             |
| 反斜杠、冒号或末尾斜杠                     | 拒绝                             |
| 将 `app.rx`、Gateway 或 Store 文件作为服务 | 拒绝                             |

`app.rx` 是保留文件名，嵌套目录中也不能用它命名普通模块。路径规范化是词法处理，不会解析文件系统符号链接。

### 声明依赖

```xml
<Module>
  <Import from="shared/validate" />

  <Call service="orders/create" in="$in" out="ctx.order" />

  <Return value="ctx.order" />
</Module>
```

`Import` 声明一条图上的边，不会执行被导入模块，也没有 `as` 别名。服务调用本身已经声明依赖边，无需为了启用调用而重复导入。

### ZX 导入

ZX 导入必须显式写出 `.zx` 扩展名，并以 `./`、`../` 或 `@/` 开头。相对路径以导入文件为起点，CLI 的 `@/` 则相对于当前工作目录。

```typescript
import calculateQuote from './calculate_quote.zx'
import type { Money } from './types.zx'
```

默认函数导入来自可执行 ZX 文件，共享类型和枚举导入来自纯类型文件。纯类型文件至少导出一个类型或枚举，没有默认函数。不要用可执行模块导出的 `Input` 替代共享类型模块。

### 两种依赖图都必须无环

编译器检查的依赖也包括未使用的导入。即使某个分支从不执行，也不能让依赖环变得合法。将共享工作移入更底层的模块，通过输入传递父模块持有的值。

继续阅读[依赖设计](/docs/keep-dependencies-acyclic)。
