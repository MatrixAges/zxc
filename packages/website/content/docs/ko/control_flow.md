RX는 작업을 묶고 선택하며, ZX는 그 안에서 타입이 있는 계산을 수행합니다. 여기의 RX 예제는 태그 모델에서 허용하는 구조를 기술합니다. 스케줄링과 표현식 평가는 실행 호스트가 제공해야 합니다.

### 순차 작업 묶기

```xml
<Module>
  <Task name="prepare">
    <Call service="users/load" args={$in.user_id} name="user" />
    <Call fn="quote" args={$in} name="quote" />
  </Task>

  <Return value={ctx.quote} />
</Module>
```

`Task.name`은 비어 있을 수 없습니다. `Task`는 다른 `Task`를 직접 포함할 수 없습니다. 하나의 일관된 책임을 묶는 데 사용하고, 재사용 가능한 경계가 되면 서비스로 추출하세요.

### 독립적인 작업 기술

```xml
<Parallel>
  <Call service="users/load" args={$in.user_id} name="user" />
  <Call service="catalog/load" args={$in.item_id} name="item" />
</Parallel>
```

`Parallel`은 속성이 없으며 `Task` 또는 `Call` 자식만 허용합니다. 자식은 하나 이상이어야 합니다. 병렬 분기가 다른 분기의 미완료 결과를 소비하게 하지 마세요. 구조 검증기는 런타임 경쟁 상태가 없음을 보장하지 않습니다.

### 분기 선택

```xml
<Switch on={$in.kind}>
  <Case value={priority}>
    <Call service="orders/priority" args={$in} name="order" />
  </Case>

  <Default>
    <Call service="orders/standard" args={$in} name="order" />
  </Default>
</Switch>
```

`Switch.on`과 `Case.value`는 필수입니다. Case 값은 중복될 수 없으며 `Default`는 최대 하나입니다. `Case`와 `Default` 본문은 비어 있을 수 없습니다. 검증기가 순서를 강제하지는 않지만 가독성을 위해 기본 분기를 마지막에 두세요.

### 명시적으로 반환하고 이벤트 내보내기

`Return`에는 `value`가 필요합니다. `Emit`에는 `event`와 `value`가 필요합니다. 둘 다 자식이 없는 리프입니다. 이벤트 선언은 구독자, 전달 보장, 백그라운드 작업자를 생성하지 않습니다.

계산 수준의 분기에는 ZX의 `if`, 조기 `return`, 조건 표현식을 사용하세요. [ZX 참조](/docs/zx-reference)를 참고하세요.
