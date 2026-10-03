### 컴파일러 가져오기

현재 문서는 소스에서 빌드하는 방식을 사용합니다. 이 리비전에 필요한 Zig **0.16.0**을 설치한 뒤 실행하세요.

```sh
git clone https://github.com/MatrixAges/zxc.git
cd zxc
zig build
zig build zx-example
```

`zx-example`은 저장소의 실제 ZX 예제를 컴파일하고 실행합니다. 이 명령은 소스를 체크아웃한 디렉터리에서 사용합니다. 애플리케이션 호스트는 다른 빌드 진입점을 제공할 수 있습니다.

### ZX 파일 컴파일하기

소스를 체크아웃한 디렉터리에서 실행하세요.

```sh
zig-out/bin/zxc packages/compiler/examples/quote.zx --out /tmp/quote.zig
zig-out/bin/zxc fmt packages/compiler/examples/quote.zx --check
```

컴파일은 Zig 소스를 생성합니다. 완전한 RX 서비스를 실행하거나 런타임을 자동으로 구성하지 않습니다. 생성된 모듈을 Zig 호스트에 통합하려면 컴파일러의 `zx_runtime` 지원 모듈이 필요합니다.

### 경계 선택하기

계산에는 ZX를, 구성 기술에는 RX를 사용하세요. 실행 가능한 서비스를 약속하기 전에 대상 호스트가 애플리케이션에 필요한 RX 실행과 상태 동작을 구현했는지 확인하세요.
