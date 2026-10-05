### 컴파일러 준비

현재 문서의 설치 방식은 소스 빌드입니다. 이 리비전에 필요한 Zig **0.17.0**을 설치한 뒤 실행하세요.

```sh
git clone https://github.com/MatrixAges/zxc.git
cd zxc
zig build
zig build zx-example
```

`zx-example`은 저장소의 실제 ZX 예제를 컴파일하고 실행합니다. 위 명령은 소스 체크아웃용이며, 애플리케이션 호스트는 다른 빌드 진입점을 제공할 수 있습니다.

### ZX 파일 컴파일

소스 체크아웃에서 실행하세요.

```sh
zig-out/bin/zxc packages/cli/examples/quote.zx --out /tmp/quote.zig
zig-out/bin/zxc fmt packages/cli/examples/quote.zx --check
```

컴파일은 Zig 소스를 생성합니다. 완전한 RX 서비스를 실행하거나 런타임을 자동으로 준비하지 않습니다. 생성된 모듈을 Zig 호스트에 통합하려면 컴파일러의 `zx_runtime` 지원 모듈이 필요합니다.

### 경계 선택

계산에는 ZX를, 구성 기술에는 RX를 사용하세요. 실행 가능한 서비스를 약속하기 전에 대상 호스트가 필요한 RX 실행과 상태 동작을 구현하는지 확인하세요.

### 완전한 계산 읽기

저장소의 `quote.zx` 예제는 가격, 할인, 활성화 플래그, 부동소수점 계수를 명시적으로 받습니다.

```typescript
export type Input = {
  amount: u64
  discount: u64
  enabled: bool
  factor: f32
}

export type Output = {
  amount: u64
  factor: f32
}

export default function (in: Input): Output {
  const adjusted_factor = in.factor * 0.5

  if (!in.enabled || in.discount > in.amount) {
    return { amount: in.amount, factor: adjusted_factor }
  }

  return { amount: in.amount - in.discount, factor: adjusted_factor }
}
```

가드는 할인액이 금액을 초과할 때 부호 없는 뺄셈을 방지합니다. 두 분기 모두 계수를 절반으로 줄입니다. 활성화된 입력에서 금액이 `100`, 할인액이 `15`, 계수가 `2.0`이면 예상 결과는 금액 `85`, 계수 `1.0`입니다.

이는 소스에서 도출한 예상 결과입니다. 사용 환경에서 실행을 검증하려면 저장소의 실행 예제를 사용하거나, 생성된 모듈을 직접 호스트에 연결하고 위 입력을 전달하세요.

### 첫 단계 완료

이제 컴파일러 바이너리, 생성된 Zig 소스, 실행되는 저장소 예제가 있어야 합니다. 세 결과를 구분하세요. 포맷 검사는 소스 표현을, 컴파일은 프로그램을 확인하며, 호스트 실행은 생성된 결과를 실행합니다.

[로직 작성](/docs/write-logic), [Zig 호스트 통합](/docs/host-integration) 순서로 이어가세요.
