Gateway와 Store 파일은 애플리케이션 경계를 기술합니다. 구조 검증은 서버를 시작하거나 데이터베이스에 연결하거나 RX 런타임과 연결하지 않습니다.

### 진입점 기술

```xml
<Gateway name="api" protocol="http" listen=":8080">
  <Group prefix="/orders">
    <Route path="/create" method="POST" service="orders/create" />
  </Group>
</Gateway>
```

이 선언을 `*.gateway.rx` 파일에 저장하세요. 루트는 `Module`이 아닌 `Gateway`입니다.

| 구문      | 필수              | 선택 사항 / 허용 값            |
| --------- | ----------------- | ------------------------------ |
| `Gateway` | `name`            | `protocol`, `listen`           |
| `Group`   | `prefix`          | 중첩 `Group` 또는 `Route` 자식 |
| `Route`   | `path`, `service` | `method`                       |

프로토콜은 `http`, `grpc`, `websocket`, `tcp`, `mqtt`입니다. HTTP 메서드는 `GET`, `HEAD`, `POST`, `PUT`, `DELETE`, `CONNECT`, `OPTIONS`, `TRACE`, `PATCH`입니다. 이 토큰들은 선언 계약에서 허용하는 값이며, 전송 구현이 존재한다는 증거는 아닙니다.

### 공유 데이터 기술

```xml
<Store name="inventory" version="1">
  <Object name="Stock">
    <Field name="available" type="u64" value="0" />
  </Object>
</Store>
```

이를 `*.store.rx` 파일에 저장하세요. `Store.name`과 부호 없는 32비트 `version`은 필수입니다. 각 `Object`에는 이름이 필요합니다. 각 `Field`에는 `name`, `type`, `value`가 필요하며, 구조 검증은 빈 값 문자열을 허용합니다.

객체 내 필드 이름은 고유해야 하며, 반복된 객체 선언도 같은 `Object.Field` 식별자를 두 번 만들 수 없습니다. 검증기는 구조를 확인하며 필드 값을 런타임 객체로 파싱하지 않습니다.

### Store 네임스페이스 참조

일반 모듈은 `from`과 선택적인 `as` 네임스페이스로 Store를 선언할 수 있습니다. 이 네임스페이스는 서비스 별칭이 아니라 데이터 접근을 식별합니다. 현재 구조 검증기는 Store 경로 연결을 구현하지 않으므로 `from`이 비어 있지 않다는 사실만으로 파일의 존재나 실행 가능성이 증명되지는 않습니다.

[상태와 호스트 책임](/docs/state-and-host)으로 이어가세요.
