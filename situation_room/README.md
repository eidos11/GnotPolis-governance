---
title: "Situation Room — 안건 인덱스"
created: "2026-03-23"
status: "active"
owner: "mnemo"
type: "index"
tags: ["situation-room", "governance"]
description: "GnotPolis 최고 수준 의사결정 회의 모듈 인덱스. 각 안건은 독립 모듈로 운영."
---

# Situation Room — 안건 인덱스

> GnotPolis 최고 수준 의사결정 회의(비상회의, 전략 회의 등)를 안건별 모듈로 운영한다.
> 각 모듈은 `final.md`(SSOT) + `changelog.md`(변동 이력) + `reference/`(참조 자료) 3층 구조.

---

## 활성 안건

| 모듈 | 주제 | 기간 | 상태 | SSOT |
|------|------|------|------|------|
| **em01-crisis-response** | 프리랜서 사업 위기 대응 비상회의 | 세션32~38 (3/17~3/23) | 🔄 실행 중 | [final.md](./em01-crisis-response/final.md) |

## 모듈 구조 표준

```
em[번호]-[주제]/
├── final.md               ← 유일한 실행 SSOT
├── changelog.md            ← 변동 이력 (결정·변동·이유 시간순)
├── assumptions-registry.md ← 핵심 가정 레지스트리 (P1 필수)
├── actions.md              ← 실행 항목 추적기 (P1 필수)
└── reference/              ← 참조 자료 (분석, 조사, 검토, 원본)
    ├── *-consolidated.md   ← 통합 발췌 (옵션)
    └── (원본 파일들)
```

## 명명 규칙

- 접두사: `em` (executive meeting)
- 번호: 생성 순서 (01, 02, ...)
- 주제: 영문 케밥 케이스 (crisis-response, q2-review 등)
- 세션 번호는 changelog에 기록 (폴더명에 포함하지 않음)

## 의사결정 품질 보강 — 적용 단계별 구분

### P1 — 필수 (모든 모듈 즉시 적용)

| 요소 | 파일 | 목적 |
|------|------|------|
| **Assumption Registry** | `assumptions-registry.md` | 핵심 가정 목록 관리. 근거·감도·검증 시점 추적. Decision Gate에서 어떤 가정이 검증되는지 매핑. (CIA Key Assumptions Check 경량화) |
| **Action Tracker** | `actions.md` | 실행 항목을 final.md에서 분리하여 독립 추적. 담당·기한·완료 조건·상태 관리 |

### P2 — 다음 모듈(em02~)부터 즉시 적용

| 요소 | 적용 방법 | 근거 |
|------|----------|------|
| **회의 역할 명문화 (RAPID 경량)** | 모듈 final.md 헤더에 `roles` 섹션 추가: Decide(최종 결정자=인간), Recommend(분석·권고=AI), Challenge(가정 도전=별도 에이전트), Input(외부 관점) | Bain RAPID + Deloitte 위기관리 프레임워크. "누가 결정하고 누가 권고했는가"의 추적성 확보 |
| **Pre-mortem 섹션** | 주요 결정마다 "이 결정이 실패했다면 왜인가"를 사전 탐색. 실패 원인 3가지 + 경고 신호 + 감시 지표 기록 | Gary Klein(1998). changelog의 사후 기록과 짝을 이루는 사전 기록 |

### P3 — 검토 후 결정 (도입 여부 미확정)

| 요소 | 내용 | 검토 포인트 |
|------|------|-----------|
| **시나리오 트리거 테이블** | 시나리오 전환 조건·감시 지표·검토 주기를 표로 명시 | 미군 CGSC AI 워게이밍 + Deloitte 프레임워크. 현재 whatif 시나리오와 중복 여부, 운용 부담 대비 효과 검토 필요 |
| **Adversarial Review 구조화** | Challenger(약점 공격) + Steelman(강점 옹호) 에이전트 역할 명시 배정 | KPMG Red/Blue team의 1인 AI 버전. 현재 R1/R2 외부 검토와의 관계 정리 필요 |

> **P3 근거 출처**: PwC 2025 Annual Corporate Directors Survey, INFORMS 2024 AI-SDM, CSIS 2025 AI Wargaming 민주화, Deloitte UK 2025 위기관리 AI 프레임워크. 상세: 조사 보고서 (세션39 조사 결과)

## 공개 리포 동기화

- 로컬: `SC-command/situation_room/`
- GitHub: `GnotPolis-governance/situation_room/`
- 동일한 폴더명·구조 사용. GitHub에는 개인정보·시크릿 제외 후 배포.
- 제외 자료 목록은 각 모듈의 `README.md`에 명기.

---

*최종 갱신: 2026-03-23*
