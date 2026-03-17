# GnoTech Bridge Guide — Multi-Agent 협력 아키텍처

> **역할**: GnoTech 생태계의 모든 AI 도구 간 통신·위임·결과물 교환 프로토콜을 정의하는 협력 인프라 사양서.
> **비유**: 고대 도시의 아고라(광장) — 집정관, 부집정관, 고문관들이 모여 과업을 배분하고 결과를 교환하는 공간.
> **위치**: `SC-command/cognotech/gtp-bridge-guide.md`
> **인프라 경로**: `~/workspace/active/.bridge/`
> **최종 갱신**: 2026-03-14

---

# Part 1: 거버넌스 계층

## 1.1 Digital Cabinet 구조

```
        Mnemo (주권자 — 최종 결정)
            │
    ┌───────┴───────┐
    │               │
 Claude Code     OpenCode/Sisyphus
 (집정관)         (위임형 연구PM)
 VP-Execution    VP-Research (delegated, task-scoped)
    │               │
    └───────┬───────┘
            │
    ┌───────┴───────────────────────┐
    │     디지털 고문관 consilium     │
    │                               │
    │  Cowork      — 의전관          │
    │  Codex App   — 원정대장        │
    │  Perplexity  — 정보참모        │
    │  Gemini CLI  — 공병대장        │
    │  Antigravity — 건축관          │
    │  (향후: Obsidian, 웹채팅 등)   │
    └───────────────────────────────┘
```

## 1.2 역할 구분

| 계층 | 구성원 | 특성 |
|------|--------|------|
| **PM (standing role)** | Claude Code, OpenCode/Sisyphus | 역할 연속성 보유 (런타임 상시 활성 아님). CC가 기본 리드, OC는 명시적 위임 시에만 acting lead. SSOT 최종 반영 권한은 CC 전속 |
| **고문관 (호출 기반)** | Cowork, Codex, Perplexity, Gemini, Antigravity | 특정 전문 과업에 투입, 결과물을 PM에게 반납 |
| **서비스 (계약형)** | OpenRAG, 향후 추가 도구 | 효용 기반 — 교체 가능, API/파이프라인 연동 |

## 1.3 불변 원칙

- **허브-스포크**: Claude Code가 중앙 허브. 모든 최종 결과물은 CC를 경유하여 SSOT(Git) 반영
- **파일 우선**: 모든 도구 간 통신은 파일 기반 — MCP/API 장애에도 동작
- **단방향 확정**: 고문관/서비스 산출물은 PM 검토 후에만 SSOT 반영 (P1 준수)
- **능력 기반 라우팅**: 과업 성격에 따라 최적 도구 선택 (capability-registry 기반)

## 1.4 운영 가드레일 (Anti-Sprawl)

Bridge는 **운송·조정 계층**이지, 새로운 권위 중심이 아니다. 다음 규칙으로 과잉 관료화를 방지한다:

1. **비대칭 계층 유지**: 모든 도구를 동등 peer로 평탄화하지 않는다. 집정관(CC) → 부집정관(OC) → 고문관의 비대칭 지휘 구조를 유지한다.
2. **단일 리드 원칙**: 같은 고문관 집합에 대해 두 PM이 동시에 공동 지휘하지 않는다. 모든 작업에 active lead 1명을 선언한다.
3. **Shadow SSOT 금지**: Bridge의 templates, registries, inboxes에 정책 권한·미결 우선순위 결정·헌정적 진실이 축적되어서는 안 된다. Bridge는 메시지, 위임 상태, 감사 추적을 운반할 뿐이다.
4. **최소 조정 표면**: 과업에 필요한 최소한의 조정 인프라만 사용한다. 조정 부산물이 위임의 실제 가치를 초과하면, 구조를 더 추가하기 전에 워크플로우를 단순화한다.
5. **고문관 자율 의제 금지**: 고문관 산출물은 bounded, reviewable, integration-ready여야 한다. 자율적 후속 작업이나 숨겨진 의제를 도입하지 않는다.

> 출처: OpenCode/Sisyphus 검토 제안 (`bridge-operating-principles-20260314.md`) — Claude Code 종합 반영

> **CC 멀티 터미널 확장**: Bridge의 `shared/` 디렉토리는 CC 멀티 터미널 병렬 운용의 조정 공간으로도 사용된다. Writer Token, Task List, deliverables 수집 등 멀티 터미널 간 조정 프로토콜 → `gnot-parallel-ops.md`

---

# Part 2: 도구 생태계

## 2.1 플랫폼 배치

```
┌─────────────────────── Windows 11 ───────────────────────┐
│                                                          │
│  Claude Desktop          Codex App        Perplexity     │
│  ├─ Chat (빠른 대화)     ├─ 멀티LLM 통합   Computer       │
│  ├─ Cowork (PPT/Word)   ├─ 제약 적음      ├─ PC 직접제어 │
│  └─ 8 MCP 서버          └─ 노션 전체접근   └─ 리서치 특화 │
│                                                          │
├──────────────── WSL2 (Ubuntu 24.04) ─────────────────────┤
│                                                          │
│  Claude Code (집정관)     OpenCode/Sisyphus (연구PM)       │
│  ├─ GnoTech SSOT 관리    ├─ GPT-5.4 xhigh               │
│  ├─ Git/PR/커밋 최종     ├─ 10 에이전트 체계              │
│  ├─ 30+ MCP 서버        ├─ 연구·분석·초안                │
│  └─ OMC 오케스트레이션   └─ 위임 기반 실행                │
│                                                          │
│  Gemini CLI              Antigravity                     │
│  ├─ Google 구독 직결     ├─ Google AI IDE                │
│  ├─ 이미지 생성          ├─ 웹사이트 생성                 │
│  └─ 팬아웃 워커          └─ Notion MCP (stdio)           │
│                                                          │
│  ● ~/workspace/active/.bridge/  ← 협력 허브               │
└──────────────────────────────────────────────────────────┘
```

## 2.2 도구별 최적 활용

| 과업 유형 | 최적 도구 | 이유 | PM 역할 |
|----------|----------|------|---------|
| PPT/Word 최종본 | Cowork | 네이티브 Office 생성, 플러그인 | CC가 MD 원본 → Cowork 변환 |
| 노션 전체 탐색 | Codex App (GPT) | 페이지 제한 없이 전체 접근 | OC가 범위 지정 → Codex 실행 |
| 실시간 웹 리서치 | Perplexity Computer | 출처 포함 + PC 직접 제어 | CC/OC가 질문 → 결과 수거 |
| 이미지/다이어그램 | Gemini CLI | Google 구독 직결, 이미지 생성 | CC가 프롬프트 → Gemini 실행 |
| 웹사이트/프로토타입 | Antigravity | Google AI IDE, 웹 생성 특화 | CC가 스펙 → Antigravity 구현 |
| 깊은 분석/방법론 | OpenCode/Sisyphus | GPT-5.4 xhigh, 10 에이전트 | CC가 위임 → OC 자율 연구 |
| Git/코드/통합/최종 | Claude Code | SSOT, 실행, 버전관리 | CC 직접 수행 (불변) |

## 2.3 크로스-플랫폼 접근 경로

| 방향 | 경로 | 사용 도구 |
|------|------|----------|
| WSL → Windows | `/mnt/c/Users/Youngil/...` 또는 `/mnt/z/...` | Claude Code, OpenCode, Gemini |
| Windows → WSL | `\\wsl.localhost\Ubuntu\home\youngil\...` | Cowork, Codex, Perplexity |
| 공유 핸드오프 | `.bridge/handoff/to-windows/`, `from-windows/` | 양방향 |

---

# Part 3: Bridge 인프라

## 3.1 디렉토리 구조

```
~/workspace/active/.bridge/
├── inbox/                    ← 수신함
│   ├── cc/                   ← Claude Code 수신
│   ├── oc/                   ← OpenCode 수신
│   └── advisors/             ← 고문관 결과물 수신 (PM이 수거)
│       ├── cowork/
│       ├── codex/
│       ├── perplexity/
│       ├── gemini/
│       └── antigravity/
├── outbox/                   ← 발신 아카이브 (감사 추적)
│   ├── cc/
│   ├── oc/
│   └── advisors/
├── flags/                    ← 실시간 플래그
│   ├── cc-active.flag        ← CC 세션 활성
│   ├── oc-active.flag        ← OC 세션 활성
│   ├── escalation.json       ← 긴급 에스컬레이션
│   └── delegation-active.json
├── state/                    ← 공유 상태
│   ├── session-status.json   ← 전체 도구 상태
│   ├── active-delegations.json ← 활성 위임 목록
│   ├── capability-registry.json ← 도구 능력 등록부
│   └── escalation-log.jsonl  ← 에스컬레이션 이력 (append-only)
├── handoff/                  ← Windows ↔ WSL 파일 교환
│   ├── to-windows/
│   └── from-windows/
├── templates/                ← 표준 양식
│   ├── message.md
│   ├── delegation.md
│   └── task-request.md
└── mcp-server/               ← 공유 Bridge MCP (향후)
    └── bridge-server.js
```

## 3.2 메시지 형식

모든 도구 간 통신은 YAML frontmatter + Markdown 본문 형식:

```markdown
---
from: claude-code | opencode/sisyphus | {advisor}
to: claude-code | opencode | advisors/{tool}
type: research-complete | delegation-request | escalation | handoff | task-request
priority: normal | urgent
delegation_id: del-YYYYMMDD-NNN
created: YYYY-MM-DDTHH:MM:SS+09:00
status: pending | read | acted
---

## 제목
[본문]

## 산출물
- [파일 경로]

## 요청 액션
- [ ] 수신자 행동 항목
```

파일명 규칙: `YYYYMMDD-HHMM-{type}-{brief}.md`

---

# Part 4: 통신 프로토콜

## 4.1 PM 간 협력 (Claude Code ↔ OpenCode) — 고대역 채널

양방향 위임 가능. 실시간 상태 공유.

```
CC → OC: 연구 위임, 분석 요청, 벤치마크 의뢰
OC → CC: 연구 결과 handoff, 에스컬레이션, 통합 요청
```

**위임 생성 흐름**:
1. 위임자가 `templates/delegation.md` 기반 위임장 작성
2. `state/active-delegations.json`에 등록
3. 수임자 inbox에 위임장 드롭
4. 수임자가 작업 수행 → 완료 시 handoff 메시지 발송
5. 위임자가 결과 검토 → delegation 상태를 `completed`로 갱신

## 4.2 PM → 고문관 (과업 파견) — 단방향 위임

PM이 `templates/task-request.md` 기반 요청서 작성 → 사용자가 해당 도구로 전달 (또는 자동화)

```
PM이 과업 요청 작성
    → .bridge/handoff/to-windows/ 에 입력 자료 배치 (Windows 도구 대상 시)
    → 사용자가 도구 실행 (현 단계: 수동 / 향후: 자동화)
    → 결과물이 .bridge/inbox/advisors/{tool}/ 에 드롭
    → PM이 /bridge-check 시 수거
```

## 4.3 에스컬레이션 프로토콜

```
작업자가 위임 범위 초과 감지
    │
    ▼
.bridge/flags/escalation.json 작성
    │  type: scope-exceeded | architecture-decision | budget-exceeded
    │  evidence: [근거]
    │  recommendation: [의견]
    ▼
.bridge/inbox/cc/ 에 에스컬레이션 메시지
    │
    ▼
Claude Code 판단
    ├── 승인 → 범위 확장 또는 직접 실행
    ├── 거부 → 대안 요청
    └── 보류 → Mnemo 상신
    │
    ▼
state/escalation-log.jsonl 에 결과 기록 (append-only)
```

---

# Part 5: 능력 등록부 (Capability Registry)

## 5.1 구조

`state/capability-registry.json`에 모든 도구의 능력을 구조화:

| 필드 | 설명 |
|------|------|
| `platform` | wsl / windows |
| `standing_role` | 역할 연속성 보유 여부 (PM만 true, 런타임 상시 활성이 아닌 세션 간 역할 유지를 의미) |
| `role` | consul / research_pm / advisor / service |
| `capabilities` | 능력 태그 배열 |
| `file_access` | 접근 가능 파일시스템 |
| `limitations` | 제한 사항 |
| `bridge_inbox` | inbox 경로 |

## 5.2 도구 선택 로직

PM이 과업을 배분할 때:

1. 과업의 요구 능력(`capabilities`) 추출
2. registry에서 해당 능력을 가진 도구 필터링
3. `platform` 호환성 확인 (파일 교환 가능 여부)
4. 최적 도구 선택 → 과업 요청 또는 위임 생성

## 5.3 확장 방법

새 도구 추가 시:
1. `capability-registry.json`에 항목 추가
2. `.bridge/inbox/advisors/{tool}/` 디렉토리 생성
3. 필요 시 `gtp-bridge-guide.md` §2.2 테이블에 행 추가
4. 도구가 "서비스(계약형)"이면 `role: "service"` 설정 — 교체 시 항목만 갱신

---

# Part 6: Skill/MCP 통합 계획

## 6.1 Skill 기반 (2~3단계, 미구현 — planned)

| Claude Code Skill | OpenCode Skill | 기능 |
|-------------------|----------------|------|
| `/bridge-send` | `@bridge-send` | 메시지 전송 |
| `/bridge-check` | `@bridge-check` | inbox 확인 |
| `/bridge-delegate` | — | 위임 생성 (CC 전용) |
| — | `@bridge-handoff` | 결과물 제출 (OC 전용) |
| `/bridge-status` | `@bridge-status` | 상호 상태 확인 |

## 6.2 Bridge MCP 서버 (7단계, 선택, 미구현 — planned)

양쪽에서 공유 MCP로 등록:

```json
// Claude Code: ~/.claude.json
"bridge": {
  "command": "node",
  "args": ["~/workspace/active/.bridge/mcp-server/bridge-server.js"]
}

// OpenCode: opencode.json
"bridge": {
  "type": "local",
  "command": ["node", "~/workspace/active/.bridge/mcp-server/bridge-server.js"]
}
```

제공 도구: `bridge_send_message`, `bridge_check_inbox`, `bridge_read_status`, `bridge_create_delegation`, `bridge_complete_delegation`, `bridge_escalate`, `bridge_heartbeat`

---

# Part 7: 구현 로드맵

| 단계 | 작업 | 상태 |
|------|------|------|
| **1단계** | `.bridge/` 디렉토리 + 템플릿 + registry | ✅ 완료 |
| **2단계** | CC skill 3개 (`/bridge-send`, `/bridge-check`, `/bridge-delegate`) | ✅ 완료 |
| **3단계** | OC skill 3개 (`bridge-check`, `bridge-handoff`, `bridge-escalate`) | ✅ 완료 |
| **4단계** | `session-status.json` heartbeat + 세션 시작/종료 hook 연동 | 🔲 미구현 |
| **5단계** | `handoff/` 경로 + Cowork filesystem MCP 연동 | 🔲 미구현 |
| **6단계** | 고문관 과업 요청 운영 + 결과 수거 프로토콜 실전 적용 | 🔲 미구현 |
| **7단계** | Bridge MCP 서버 통합 (선택적) | 🔲 미구현 |

---

# 부록

## A. 관련 문서

| 문서 | 경로 | 관계 |
|------|------|------|
| Governance Charter | `gtp-charter.md` | 상위 — 거버넌스 원칙 |
| Governance Playbook | `gtp-playbook.md` | 상위 — 시행령·판례 |
| OpenCode 협력 전략 | `gnot-opencode.md` | 병렬 — PM 간 역할 상세 |
| Claude Desktop 운영 | `gnot-claudedesktop.md` | 병렬 — Cowork 상세 |
| CLAUDE.md | `~/.claude/CLAUDE.md` | 연동 — CC 전역 설정 |

## B. 향후 확장 예정 도구

| 도구 | 연결 방식 | registry 역할 |
|------|----------|--------------|
| Obsidian (로컬) | WSL 파일 직접, vault 경로 | advisor / knowledge_hub |
| GPT 웹채팅 (5.4 pro) | 파일 첨부 + MCP(향후) | advisor / deep_reasoning |
| Claude 웹채팅 | Projects 지식문서 + 첨부 | advisor / strategy |
| OpenRAG | API/MCP | service (계약형, 교체 가능) |

## C. 설계 결정 근거

| 대안 | 검토 결과 | 판단 |
|------|----------|------|
| 파일 기반 큐 | 양쪽 파일 I/O 네이티브, 장애 내성 최고 | ✅ 채택 |
| Redis/SQLite 큐 | 별도 프로세스, 과잉 | ❌ 불필요 |
| WebSocket 실시간 | 양쪽 서버 모드 아님, 복잡 | ❌ 부적합 |
| Named pipe (FIFO) | 한쪽 오프라인 시 블로킹 | ⚠️ 보류 |
| inotify 감시 | 파일 변경 즉시 감지, heartbeat 보완용 | ⚠️ 향후 고려 |
