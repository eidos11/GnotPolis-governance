# GnotPolis Governance Playbook

> **역할**: Charter 원칙의 해석·적용 사례·운용 상세·의사결정 선례를 수록하는 시행령·판례 문서.
> **대상**: 모든 거버넌스 주체 (Charter와 동일)
> **접근**: 로컬(`SC-command/cognotech/gtp-playbook.md`) · GitHub Pages 배포 예정
> **상위 문서**: [gtp-charter.md](./gtp-charter.md) (헌법 — 원칙·조직·구조)
> **버전**: v1.1 (2026-03-17)

---

## PB1. 원칙 적용 사례

Charter A2(P1~P5)와 4대 운영 원칙이 실제 상황에서 어떻게 적용되는지를 기록한다.

### P1 적용: Git SSOT와 Notion의 충돌 해결

| 상황 | 판단 | 근거 |
|------|------|------|
| Notion DB에 최신 정보가 있으나 Git에 미반영 | Git이 SSOT, Notion은 NeedSync 표시 후 CC가 Git 반영 | P1 |
| Notion에서 GnoTech 패키지 내용을 직접 편집 | 금지. CC를 통해 Git에 반영 후 Notion에 배포 | P1 + 금지 패턴 |
| 웹채팅에서 프레임워크 변경 결정 | CC가 결론 수신 → Git 반영 → 필요 시 Notion 배포 | P1 + 확정 흐름 |

### P3 적용: AI 브랜치 규칙

| 상황 | 판단 | 근거 |
|------|------|------|
| CC가 문서 수정 | `ai/[작업명]` 브랜치 생성 → PR → Human Review | P3 |
| 긴급 수정 (오타, 경로 오류) | 여전히 ai/* 브랜치 사용. 긴급성은 P3 면제 사유 아님 | P3 엄격 적용 |
| 환경 설정 파일 (CLAUDE.md, settings) | P3 적용 제외 — GnoTech 패키지가 아닌 도구 설정 | P3 범위 해석 |

### P4 적용: QA 3계층 실행

```
1계층 (구조적): pre-commit 훅 → YAML frontmatter 검증, 파일명 규칙
2계층 (의미적): /cross-project-review → 프로젝트 간 의존성 정합성
3계층 (결정적): ADR 등록 → 설계 결정의 근거·대안·결과 기록
```

### 소유권/해석권 분리 적용

| 사례 | 소유권 (Git) | 해석권 (Notion) |
|------|-------------|----------------|
| EIU-OS 5 Agent 설계 | spec SSOT는 Git | Notion이 기존 지식과 교차 검증 |
| Inbox DB 스키마 개편 | 최종 확정은 Git(CLAUDE.md, MEMORY.md) | Notion이 스키마 실체 관리 |
| ADR 등록 | DECISION-LOG.md (append-only) | Notion Decision Log DB에 요약본 배포 |

---

## PB2. 워크플로우 레시피

### 세션 전체 흐름

```
┌─ 세션 시작 ──────────────────────────────────────────────┐
│ /status-mne                                              │
│   ├── 세션 캐시 최신 파일 로드                              │
│   ├── Notion Inbox: Ready for AI 항목 조회                 │
│   ├── Bridge 수신함: pending 메시지 확인                    │
│   ├── Git: 브랜치·PR·미커밋 확인                           │
│   └── 요약 출력 → 작업 우선순위 제안                        │
├─ 작업 ──────────────────────────────────────────────────┤
│ Inbox 수신:  /inbox-mne → Status: In Local               │
│ 자료 참조:   /lookup-mne → Notion workspace 검색          │
│ 결과 보고:   /report-mne → Result 기록 + Status: In Review │
│ 위임·수거:   Bridge → /bridge-check, /bridge-delegate     │
│ 커밋:       ai/* 브랜치 → PR 생성                         │
├─ 세션 종료 ──────────────────────────────────────────────┤
│ /wrap-mne                                                │
│   ├── 세션 캐시 작성 (완료·미결·기술이슈·판단근거)           │
│   ├── CLAUDE.md 캐시 포인터 갱신                           │
│   └── 다음 세션 요약 출력                                  │
└──────────────────────────────────────────────────────────┘
```

### Inbox 처리 흐름

```
Ready for AI 항목 발견
  │
  ├─ MessageType = TaskRequest
  │    → /inbox-mne pull → In Local → 작업 실행 → /report-mne
  │
  ├─ MessageType = InfoShare (⑭⑮ 같은 구조 변경 통보)
  │    → /inbox-mne pull → In Local → MEMORY.md/관련 문서 갱신 → /report-mne
  │
  ├─ MessageType = SyncRequest
  │    → /inbox-mne pull → In Local → NeedSync 대상 확인·반영 → /report-mne
  │
  └─ MessageType = Question
       → /inbox-mne pull → In Local → 답변 작성 → /report-mne (CC→Notion)
```

### 위임 프로토콜 (Bridge)

위임 시 5요소 명시:

| 요소 | 설명 | 예시 |
|------|------|------|
| 위임자 | 누가 위임하는가 | CC / Mnemo |
| 도메인 | 어떤 전문 영역 | VLM 벤치마크, 리뷰 |
| 허용 결정 범위 | 자율 판단 가능 범위 | 연구 방법 선택, 초안 구조 |
| 종료 조건 | 언제 위임이 끝나는가 | 결과물 제출, 기한, 범위 초과 시 |
| Handoff 방식 | 결과물 전달 방법 | `.bridge/inbox/cc/`에 메시지 드롭 |

> **핵심**: acting lead 권한은 task-scoped delegation. 종료 후 산출물은 **통합 대기 권고안**.

### Charter/Playbook 변경 시 동기화 흐름

```
문서 수정 → Git commit
  → GitHub Pages 자동 배포 (전 도구 웹 접근)
  → Discord #gazette 게시 (변경 요약 + URL)
  → 필요 시 Notion Inbox InfoShare 1건
  → 각 도구 다음 세션 시 #gazette 확인 → ✅ 리액션
```

---

## PB3. 에이전트 운용 규범

### 병렬 터미널 규칙 (C/S/R)

| 유형 | 역할 | 쓰기 권한 |
|------|------|----------|
| **C (Coordinator)** | 최종 수정·종합·Notion 반영 | GnoTech + Notion Write |
| **S (Specialist)** | 실험·개발·구현 | 자기 worktree + deliverables/ |
| **R (Reviewer)** | 검토·분석·초안 | 자기 worktree + deliverables/ |

**S/R 필수 준수 사항**:
1. GnoTech Workspace(`~/gnot/GnoTech_Workspace/`) 수정 금지 — C만 가능
2. Notion 페이지 생성·수정 금지 — C만 가능 (읽기는 자유)
3. `~/.claude/settings.json`, `~/.bashrc` 수정 금지 — 전 터미널 공통
4. 다른 worktree 파일 직접 수정 금지

**산출물 제출**: `~/workspace/active/.bridge/shared/deliverables/`에 표준 스키마로 작성.
필수 필드: Task ID, Instance, Target, Findings, Recommended Change, Ready-to-Apply, Confidence

### OpenCode (시지푸스) 운용

- 평시: CC 보좌 기관 (연구·분석·초안화)
- 위임 시: 특정 도메인에서 acting lead
- **경계**: acting lead는 위임 범위 내부의 연구/초안/분석 리드이며, **최종 Git/PR/SSOT 확정 권한은 항상 Claude Code에 남는다**. 위임 종료 후 산출물은 확정본이 아닌 통합 대기 권고안.
- 에이전트 10종: Sisyphus(PM), Hephaestus(분석), Oracle/Momus/Prometheus(검증), Metis(계획) 등
- MCP 호환성 주의: OpenCode는 `"type": "local"` + 배열 commands 필요 (CC와 형식 차이)
- 상세: [gnot-opencode.md](./gnot-opencode.md)

### 시크릿 보호 규범

| 작업 | 허용 방법 | 금지 |
|------|----------|------|
| 키 존재 확인 | `Grep "KEY_NAME"` (줄 번호만) | `Read` 전문 읽기 |
| 키 포함 파일 구조 확인 | Grep 패턴 매칭 | 전체 Read |
| MCP 설정 편집 | 토큰은 `"USER_INPUT_REQUIRED"` | 토큰 전문 복사 |

대상 파일: `~/.bashrc`, `~/.env*`, `~/.claude.json`, `**/mcp*.json`, `**/*token*.json`

---

## PB4. 통신 프로토콜 상세

### Inbox 메시지 스키마

| 속성 | 값 범위 | 설명 |
|------|--------|------|
| MessageType | TaskRequest / ResultReport / InfoShare / SyncRequest / Question | 메시지 유형 |
| Domain | Ⅰ~Ⅴ / SC / X.Hub / GnoTech / Cross | 관련 영역 |
| Direction | Notion→CC / CC→Notion | 소통 방향 |
| Category | Deploy / Setup / Dev / Review / Research / Sync / Migrate | 작업 분류 |
| Status | Ready for AI → In Local → In Review → Active → Archived | 상태 흐름 |
| Priority | High / Medium / Low | 우선순위 |

### Result 필드 구조화 표준

```markdown
## 처리 결과
- 작업: [수행 내용 1줄 요약]
- 상태: 완료/부분완료/보류
- 산출물: [파일 경로 또는 커밋 해시]
- 비고: [추가 컨텍스트]
```

### Bridge 메시지 형식

> Bridge 메시지의 **정본 스키마**는 [gtp-bridge-guide.md](./gtp-bridge-guide.md) + `~/.bridge/templates/message.md`입니다.
> 아래는 개념 요약이며, type 범위·파일명 규칙·필드 상세는 정본을 참조하세요.

- 파일명: `YYYYMMDD-HHMM-[주제]-[유형].md`
- 필수 frontmatter: `from`, `to`, `type`, `status`, `created`
- type 범위: 정본 참조 (handoff, review-request, delegation-request, task-request, escalation, info 등)

### Discord #gazette 게시 형식

```
📋 Charter 변경 통보 — v1.X (YYYY-MM-DD)

변경 요약: [1~2줄]
영향 범위: [Part A/B/C 중 해당]
URL: [GitHub Pages 링크]

✅ 확인 리액션을 남겨주세요.
```

---

## PB5. 의사결정 선례

주요 기술·구조 결정의 맥락과 근거를 기록한다. 상세는 `adr/DECISION-LOG.md`.

### ECC 플러그인 비활성화 (2026-03-16)

- **문제**: ECC 훅 19개 + OMC 훅 14개 = 도구 호출당 30+ 프로세스 spawn → 터미널 출렁임 + 세션 crash
- **결정**: `settings.json`에서 ECC → `false`. OMC + superpowers로 동일 기능 커버
- **교훈**: 훅 기반 플러그인은 개수 자체가 성능 병목. 선별 비활성화 불가 시 플러그인 단위 off가 유일한 방법.

### OMC pre-tool-enforcer 비활성화 (2026-03-16)

- **문제**: 매 도구 호출마다 Node.js spawn + system-reminder 누적 → 컨텍스트 비대 + API 응답 지연
- **결정**: `OMC_SKIP_HOOKS=pre-tool-use` 설정. OMC 다른 기능(스킬, MCP, 에이전트)은 유지
- **교훈**: CLAUDE.md/rules와 중복되는 리마인더는 제거해도 품질 저하 없음. 오히려 안정성 향상.

### .wslconfig dropcache → gradual 복원 (2026-03-16)

- **문제**: `autoMemoryReclaim=dropcache`가 페이지 캐시를 465MB로 제한 → 매 hook/MCP 호출 시 디스크 I/O burst
- **결정**: 일반 프로필(`gradual`, NAT, 8GB) 복원. 페이지 캐시 973MB로 회복
- **교훈**: OpenRAG 인덱싱용 프로필을 일반 작업에 유지하면 안 됨. 작업별 프로필 전환 필요.

### Notion Inbox 스키마 개편 (2026-03-16)

- **문제**: 기존 스키마(Type, Project)가 3환경 비동기 메시지 큐 역할에 부적합
- **결정**: Type→MessageType(5종), Project→Domain(9종), Direction 신설, Category에 Sync/Migrate 추가
- **교훈**: DB 스키마는 용도 변경 시 즉시 개편해야 함. 호환성 유지보다 명확성이 우선.

### Charter + Playbook 도입 (2026-03-17)

- **문제**: cognotech/ 12개 문서 병렬 구조 → 역할 중복, 외부 동기화 불가, 관리 비용 과다
- **결정**: Charter(헌법) + Playbook(시행령) 2문서 체계. GitHub Pages로 전 도구 웹 접근. CNS Guide + Project Guide 폐기
- **교훈**: 문서는 "도구별"이 아닌 "안정성 계층별"로 분류해야 관리 가능. 불변 원칙과 가변 운용을 분리.

---

## PB6. 외부 도구 참조 가이드

Charter/Playbook은 GitHub Pages로 웹 접근이 가능해지면 모든 도구가 URL로 참조 가능합니다. 각 도구별 활용 방법:

### 노션 AI

- Charter URL을 Inbox InfoShare로 공유 → 노션 AI가 fetch하여 참조
- 구조 변경 시 Inbox 1건으로 통보, 노션 측에서 Architecture Guide 등에 반영 판단
- Notion에서 GnoTech 논의 시: Charter A4(포트폴리오) + A5(이론 체계) 참조

### 웹채팅 LLM (Claude Web, GPT)

- 프로젝트 지식문서로 Charter URL 탑재 → 전략 논의 시 전체 구조 참조 가능
- 우선 참조: Charter Part A(불변 기초) → 원칙·조직·포트폴리오 파악
- 상세 필요 시: Playbook PB1(원칙 적용) + PB2(워크플로우) 참조
- 컨텍스트 창이 제한적이면 Charter Part A만으로 충분

### 시지푸스 (OpenCode)

- 로컬 Read 또는 Bridge 전달로 직접 참조
- 위임 수신 시: Charter A3(조직·권한) + Playbook PB3(운용 규범) 확인
- 산출물 제출 시: Playbook PB4(통신 프로토콜) 참조

### 고문관단 (Codex, Gemini, Perplexity 등)

- GitHub Pages URL 또는 Discord #gazette 고정메시지로 접근
- 호출 기반 도구이므로 매 호출 시 참조할 필요 없음
- CC가 위임 시 필요한 Charter 섹션을 컨텍스트로 전달

### 참조 우선순위

| 상황 | 최소 참조 | 추가 참조 |
|------|----------|----------|
| 전체 구조 파악 | Charter Part A | — |
| 작업 수행 | Charter Part B | Playbook PB2~PB4 |
| 의사결정 맥락 | Playbook PB5 | ADR DECISION-LOG |
| 도구별 상세 | 해당 gnot-* 매뉴얼 | — |

---

## 부록

### A. 용어 정의

| 용어 | 정의 |
|------|------|
| GnotPolis (GTP) | 전체 거버넌스 체계의 명칭 (Gnosis + Techne + Polis) |
| GnoTech | 집행부 — CC 관할 SSOT·실행·패키지 개발 |
| Mnemo_Fantasy | 원로원 — Notion 관할 의미론적 검증·지식허브 |
| Consilium | 고문관단 — 웹채팅, CLI 도구 등 전문 자문 |
| Charter | GnotPolis 최상위 거버넌스 문서 (헌법) |
| Playbook | Charter의 해석·적용·사례 문서 (시행령·판례) |
| SSOT | Single Source of Truth. GnoTech에서는 Git |
| Inbox | Notion GnoTech Inbox DB. 3환경 간 비동기 메시지 큐 |
| Bridge | 로컬 에이전트 간 통신 인프라 (`~/.bridge/`). 정본: gtp-bridge-guide.md |
| #gazette | Discord 공보 채널. Charter/Playbook 변경 통보 (계획 단계) |

### B. 관련 문서

| 문서 | 역할 |
|------|------|
| [gtp-charter.md](./gtp-charter.md) | 상위 — 헌법 |
| [gtp-bridge-guide.md](./gtp-bridge-guide.md) | GTP 인프라 — Bridge 기술 상세 |
| [gtp-discord-hub.md](./gtp-discord-hub.md) | GTP 인프라 — Discord 구축 계획 |
| [gnot-parallel-ops.md](./gnot-parallel-ops.md) | GnoTech — 병렬 운용 매뉴얼 |
| [gnot-opencode.md](./gnot-opencode.md) | GnoTech — 시지푸스 전략·MCP 호환성 |
