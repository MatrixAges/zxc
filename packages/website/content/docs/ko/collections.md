ZX는 리스트 변환과 소유권을 드러냅니다. 입력 컬렉션은 빌린 데이터로 취급하세요. 값을 소비하는 연산에 소유한 값이 필요하면 복제하세요.

### 일반 반복문 없이 변환하기

```typescript
export type Input = u64[][]
export type Output = u64[]

export default function (in: Input): Output {
  return in.map((row) => row.filter((item) => item > 2).reduce((sum, item) => sum + item, 0))
}
```

`map`과 `filter`는 인수 하나의 콜백을 받습니다. `reduce`는 인수 두 개의 콜백과 명시적인 누산 초깃값을 받습니다. 콜백 본문은 표현식이며 외부 값이나 Store 핸들을 캡처할 수 없습니다. 가져온 함수는 호출할 수 있습니다.

### 갱신된 리스트를 이어서 사용하기

값을 소비하는 연산은 튜플을 반환합니다. 결과 리스트를 새 이름에 바인딩하고 불필요한 결과는 `_`로 버리세요.

```typescript
export type Input = u64[]
export type Output = u64[]

export default function (in: Input): Output {
  const items = clone(in)
  const [with_item, _] = items.push(7)
  const [rest, removed] = with_item.pop()
  const [ordered, _] = rest.sort()
  const [reversed, _] = ordered.reverse()

  return reversed
}
```

소비 연산 뒤에는 이전 리스트 바인딩을 다시 사용하지 마세요. 다른 분기를 위해 원본을 보존해야 한다면 소유권이 갈라지는 지점에서 복제하세요.

### 연산 결과

| 연산                                 | 결과          | 제약                                                  |
| ------------------------------------ | ------------- | ----------------------------------------------------- |
| `push(item)`                         | `[T[], void]` | 원본 리스트를 소비                                    |
| `concat(items)`                      | `[T[], void]` | 갱신된 리스트 생성                                    |
| `pop()`                              | `[T[], T?]`   | 제거된 값은 선택적 값                                 |
| `sort()`                             | `[T[], void]` | 숫자 또는 문자열 원소, 비교 콜백 없음                 |
| `reverse()`                          | `[T[], void]` | 순서가 뒤집힌 리스트 반환                             |
| `splice(start, count, replacements)` | `[T[], T[]]`  | `start`와 `count`는 `u64`, 두 번째 결과는 제거된 원소 |

리스트 인덱싱은 범위를 검사하며 실패할 수 있습니다. 범위 밖 접근을 선택적 값 조회로 사용하지 마세요.

할당 수명은 호스트가 관리합니다. 리스트를 반환해도 아레나가 가비지 컬렉터로 이전되지는 않습니다. [호스트 통합](/docs/host-integration)으로 이어가세요.
