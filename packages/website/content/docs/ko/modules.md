### 모듈은 파일입니다

일반 RX 파일의 루트는 `Module`입니다. 모듈에 `name`을 추가하거나 `Pipeline`으로 감싸지 마세요. 비즈니스 책임에 따라 파일 이름과 그룹을 정하세요.

```text
checkout.rx
users/load.rx
orders/create.rx
```

### 입출력 연결하기

`checkout.rx`의 예입니다.

```xml
<Module>
  <Call service="users/load" in="$in.user_id" out="ctx.user" />

  <Call
    service="orders/create"
    in="{user:ctx.user,items:$in.items}"
    out="ctx.order"
  />

  <Return value="ctx.order" />
</Module>
```

호출 대상 파일은 애플리케이션에 실제로 존재해야 합니다. `service`는 호출 파일을 기준으로 해석되며, 보통 `.rx` 확장자를 생략합니다. `$in`은 현재 모듈의 입력이고, `out`은 이후 단계에서 사용할 결과의 이름을 지정합니다.

### 계산 호출하기

애플리케이션이 제공하는 함수는 `Call.fn`으로 호출합니다. `fn`과 `service`는 동시에 지정할 수 없습니다. 직접 `Call`하는 경우 중복 `Import` 선언은 필요하지 않습니다.

병렬 단계는 서로의 미완료 결과에 의존하면 안 됩니다. 자식 모듈이 데이터를 얻기 위해 부모를 다시 호출하지 않도록, 부모가 입력으로 데이터를 전달하세요.

이 예제는 RX 구성 계약을 보여 줍니다. 실행에는 적절한 호스트가 필요합니다.
