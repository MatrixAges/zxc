### 명시적 입출력

ZX는 TypeScript와 비슷하지만 JavaScript는 아닙니다. 입력과 출력 타입을 선언하고 기본 함수를 내보내세요. 다음 최소 계산은 입력 금액을 그대로 반환합니다.

```typescript
export type Input = {
  amount: u64;
};

export type Output = {
  amount: u64;
};

export default function (in: Input): Output {
  return { amount: in.amount };
}
```

### 계산 범위 제한하기

현재 컴파일러는 스칼라, 객체, 열거형, 선택적 값, 리스트, 튜플, 지역 바인딩, 분기, 파일 가져오기를 지원합니다. 컬렉션 연산에는 외부 변수를 캡처하지 않는 `map`, `filter`, `reduce`가 포함됩니다.

임의의 클로저, 일반 루프, JavaScript 암시적 변환, 런타임 기능 가져오기가 지원된다고 가정하지 마세요. 숫자 타입은 명확한 의미를 가지므로 JavaScript 숫자 동작에 의존하면 안 됩니다.

### 소유권 명시하기

깊은 복사가 필요하면 `clone`을 사용하세요. Store 접근은 선언된 핸들로 제공되며 읽기와 쓰기 권한은 독립적입니다. 수명, 영속성, 커밋 동작은 호스트가 관리합니다.

설치된 도구 체인의 포매터와 진단 기능을 사용하세요. 정확한 계약은 [컴파일러 참고 문서](https://github.com/MatrixAges/zxc/blob/master/packages/compiler/README.md)에서 확인하세요.
