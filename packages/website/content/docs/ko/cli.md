CLI는 ZX를 Zig로 컴파일하고 ZX 소스의 형식을 정리합니다. 저장소에서 빌드해 `zig-out/bin/zxc`를 얻거나, 바이너리를 `PATH`에 추가했다면 `zxc`를 사용하세요.

### 컴파일

```sh
zig-out/bin/zxc packages/cli/examples/quote.zx --out /tmp/quote.zig
```

| 인수           | 의미                        |
| -------------- | --------------------------- |
| 입력 경로      | 진입 `.zx` 파일             |
| `--out <path>` | 생성된 Zig 소스의 저장 위치 |
| `--help`       | CLI 사용법 출력             |

컴파일에는 가져오기 분석과 컴파일러의 의미 검사가 포함됩니다. 출력은 Zig 소스이며 실행 파일, 웹 서버, 배포 패키지가 아닙니다. 호스트에 포함해 빌드할 때 생성된 `zx_runtime` 가져오기를 연결하세요.

### 포맷

```sh
zig-out/bin/zxc fmt packages/cli/examples/quote.zx
zig-out/bin/zxc fmt packages/cli/examples/quote.zx --check
zig-out/bin/zxc fmt packages/cli/examples/quote.zx --write
```

| 모드        | 동작                                        |
| ----------- | ------------------------------------------- |
| 플래그 없음 | 포맷된 소스를 표준 출력으로 표시            |
| `--check`   | 소스와 포맷 결과 비교, 상태 1은 차이를 의미 |
| `--write`   | 소스 파일을 포맷 결과로 교체                |

기존 검증 절차에는 검사 모드를 사용하세요. 소스를 의도적으로 수정할 때 쓰기 모드를 사용하세요.

### 경로와 환경

상대 가져오기는 가져오는 파일을 기준으로 해석됩니다. `@/` 가져오기는 CLI 작업 디렉터리를 기준으로 합니다. 로컬과 자동화에서 같은 가져오기가 같은 의미를 갖도록 프로젝트 루트를 정하고 명령을 실행하세요.

### 존재하지 않는 명령

이 CLI에는 일반적인 `zxc run`, `zxc check`, `zxc watch`, `zxc server` 명령이나 RX XML 실행 명령이 없습니다. `zig build zx-example`은 저장소의 빌드 단계이며 zxc 하위 명령이 아닙니다.

[진단](/docs/troubleshooting) 또는 [Zig 호스트 통합](/docs/host-integration)으로 이어가세요.
