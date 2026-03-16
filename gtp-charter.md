# GnotPolis Governance Charter

> **역할**: GnotPolis 전체 거버넌스 체계의 원칙·조직·구조·현황을 정의하는 최상위 문서.
> **대상**: 모든 거버넌스 주체 (CC, Notion AI, OpenCode, 웹채팅, 고문관단)
> **접근**: 로컬(`SC-command/cognotech/gtp-charter.md`) · GitHub Pages 배포 예정
> **동반 문서**: [gtp-playbook.md](./gtp-playbook.md) (시행령·판례 — 원칙의 해석과 적용)
> **버전**: v1.1 (2026-03-17)

---

# Part A: 불변 기초

## A1. 정의

### GnotPolis (GTP)

**GnotPolis** = Gnosis(知) + Techne(術) + Polis(都市國家).

GnoTech 지식 시스템을 핵심으로 하는 **전체 거버넌스 체계**의 명칭. 고대 폴리스처럼 집행부·원로원·고문관단이 각자의 관할 내에서 자율적으로 기능하되, 공통 원칙과 통신 인프라로 결합된다.

| 계층 | 명칭 | 관할 |
|------|------|------|
| **국가** | GnotPolis (GTP) | 원칙·조직·인프라·워크플로우 전체 |
| **집행부** | GnoTech | SSOT 관리, 실행 총괄, 패키지 개발 (CC 관할) |
| **원로원** | Mnemo_Fantasy | 의미론적 검증, 지식허브, 심의 (Notion 관할) |
| **주권자** | Mnemo | 최종 결정권, 전략 방향 |
| **고문관단** | Consilium | 전문 자문 — 웹채팅 LLM, Codex, Gemini 등 |

### GnoTech (집행부)

**GnoTech** = Gnosis(知) + Techne(術).

인지과학·경영전략·논리적 글쓰기 등 지식 도메인 콘텐츠를 소프트웨어 방법론 형식(모듈 패키지)으로 구조화한 **개인 지식 시스템**. 프리랜서 사업 전체의 핵심 엔진이며, 서비스 프로젝트들의 이론적 토대.

| 항목 | 값 |
|------|-----|
| 핵심 형식 | Markdown + YAML frontmatter (9개 표준 필드) |
| 목표 규모 | 5~20년, 모듈 100~200개 |
| 배포 방향 | SaaS(챗봇·웹앱) + GitHub 공개 병행 |
| SSOT | Git (`~/gnot/GnoTech_Workspace/`) |

### 문서 접두어 체계

| 접두어 | 계층 | 대상 |
|--------|------|------|
| `gtp-` | GnotPolis (국가) | charter, playbook, bridge-guide, discord-hub |
| `gnot-` | GnoTech (집행부) | parallel-ops, opencode, datarag, openrag-*, claudedesktop, obsidian |

## A2. 핵심 원칙 (P1~P5 — 불변)

| 원칙 | 내용 |
|------|------|
| **P1** | Git이 유일한 SSOT. Notion·Obsidian은 입력·시각화 도구. |
| **P2** | GnoTech SSOT 문서층의 `.md` 파일은 9개 표준 YAML frontmatter로 상태 통제. (적용 범위 아래 참조) |
| **P3** | AI는 `ai/*` 브랜치에서만 작업. `main` 병합은 Human Review 필수. |
| **P4** | QA 3계층: 구조적(pre-commit) → 의미적(cross-project-review) → 결정적(ADR). |
| **P5** | 설계 결정은 `adr/DECISION-LOG.md`에 기록. append-only. |

**P2 적용 범위** — markdown 문서를 3계층으로 구분:

| 계층 | 대상 | P2 적용 |
|------|------|--------|
| **SSOT 문서층** | GnoTech 프로젝트 패키지 (`P01-*/`, `P02-*/` 등), GnoTech-meta/ | ✅ 9개 필드 필수 |
| **거버넌스 문서층** | `gtp-*` (Charter, Playbook, Bridge Guide, Discord Hub) | ❌ 선택적 (구조 문서) |
| **Transport 메시지층** | Bridge 메시지 (`.bridge/inbox/`), 위임장 | ❌ 별도 스키마 ([gtp-bridge-guide.md](./gtp-bridge-guide.md) 정본) |

**4대 운영 원칙**:
1. **생산적 긴장** — 환경 간 비판적 검토는 품질 향상의 원동력. 견제는 상호 권고.
2. **위임 구조** — 최종 결정권은 Mnemo. 실행 효율을 위해 CC에 위임. 위임은 task-scoped.
3. **퓨전 특성** — 역할 분담은 능력 한계가 아닌 최적 전문성 배치에 의한 것.
4. **소유권/해석권 분리** — SSOT(소유)는 Git, 의미론적 검증(해석)은 Notion.

## A3. 거버넌스 조직

### 조직 구조

| 역할 | 주체 | 핵심 관할 |
|------|------|----------|
| **최종 권한** | Mnemo (사용자) | 모든 최종 결정, 전략 방향 |
| **집정관** | Claude Code CLI | SSOT 관리, 실행 총괄, 전 도구 연결 |
| **민회·원로원** | Notion AI | 지식허브, 의미론적 교차 검증, DB 기반 구조적 지식 운영 |
| **부집정관** | OpenCode (시지푸스) | 연구·분석·초안화, 위임 시 acting lead |
| **고문관단** | 웹채팅 LLM, Codex, Gemini, Perplexity 등 | 전문 자문, 시뮬레이션, 프로토타입 |

### 논의 유형별 주관

| 유형 | 주관 | 적용 |
|------|------|------|
| 일반 논의·빠른 판단 | CC | 기술 판단, 파일 수정, 일상 작업 |
| 전략 논의·프레임워크 설계 | 웹채팅 | 사업 방향, 서비스 전략, 복합 개념 |
| 미시적 검토·다문서 교차 분석 | Notion | 블록 단위 편집, DB 기반 교차 비교 |
| 실행·패키지 관리·자동화 | CC (단독) | Git, 스크립트, 배포 |

### 권한 체계

| 보호 수준 | 대상 | 수정 권한 |
|----------|------|----------|
| **L0** (최고 보호) | GnoTech 패키지 본문, SSOT 파일 | Mnemo 승인 후 CC만 |
| **L1** (보호) | SC-command/, CLAUDE.md, 설정 파일 | CC (Coordinator만) |
| **L2** (통제) | worktree 내 작업 파일 | 해당 터미널 (C/S/R) |
| **L3** (자유) | Bridge 산출물, 임시 파일 | 모든 에이전트 |

## A4. 서비스 포트폴리오

### 서비스 프로젝트

| ID | 프로젝트 | 한줄 설명 | 상태 |
|----|---------|---------|------|
| P01a | CB-Matrix | 인지-행동 4사분면 상태 기계 (메타인지 기반층) | 설계 완료 |
| P01b | Howstudy | 학습법 체계 (CB+EIU 통합 예정) | v1.0 완성 |
| P02a | EIU-OS | 범용 수용성 진단 엔진 (5 Agent) | LLM 직접 사용 가능 |
| P02b | EIU-resume | 자소서 특화 진단 | GPTs 배포 완료 |
| P03 | LSAi 3Layer | 논리·전략·AI 통합 교육·컨설팅 | 설계 완료 |
| P11 | VirtualSymposium | LLM 기반 지식 대화 플랫폼 + ReGenesis | 글로벌 전략 전환 |

### 내부 프로젝트

| ID | 프로젝트 | 한줄 설명 | 상태 |
|----|---------|---------|------|
| P30 | DR-OS | Deep Research 생산 시스템 | v3.2 활용 중 |

### 의존 구조

```
기반층(독립):  CB-Matrix, EIU-OS, EIU-resume, VirtualSymposium
통합층:       LSAi(← CB + EIU-DI), ReGenesis(← VS)
어댑터층:     LSAi EIU-Adapter(← LSAi + EIU-DI)
활용층:       LSAi Guide/Template(← VS + RG)
```

## A5. 이론 체계

GnoTech의 프로젝트는 독자적 이론체계 위에서 파생된 응용이다.

**기초이론 (3부작)**: 문명론·인식론·감성론. 중심 질문: "악은 어떻게 이토록 끝없이 번영하게 되었는가?"
핵심 원리: 역치 원리, 강도×빈도 3분법, 필요 요소 3계층, 기만 구조(은폐+변조)

| Topic | 주제 | 핵심 |
|-------|------|------|
| T1 | 인식론·문명론 | 형식 체계의 한계, 동서양 문명 구조 비교 |
| T2 | NeoDiffusion | 확산 이론 통합 (RBM-Bridge), 패러다임 전환 모델 |
| T3 | 선악·종교 | 악의 3유형, 선악 상호의존성, 기만 메커니즘 |

> 상세: `GnoTech-meta/GnoTech_context_theory_v1.0.md`

---

# Part B: 현행 운용

## B1. 도구 레지스트리

### 핵심 도구

| 도구 | 역할 | 접근 경로 | 상태 |
|------|------|----------|------|
| **Claude Code CLI** | 핵심 에이전트, 실행 총괄 | 로컬 터미널 | ✅ 활성 |
| **Notion** | 지식허브, 의미론적 검증, Inbox | 웹 + MCP (notionApi) | ✅ 활성 |
| **OpenCode (시지푸스)** | 연구·분석, 위임 시 acting lead | 로컬 터미널 + Bridge | ✅ 활성 |
| **Claude 웹채팅** | 전략 논의, 프레임워크 설계 | 웹 브라우저 | ✅ 활성 |
| **GPT 웹채팅** | 자문, 시뮬레이션 | 웹 브라우저 | ✅ 활성 |

### 보조·특화 도구

| 도구 | 역할 | 접근 경로 | 상태 |
|------|------|----------|------|
| Codex CLI | 특화 보조 (코드 생성) | 로컬 터미널 | ✅ 활성 |
| Gemini CLI | 특화 보조 (프론트엔드) | 로컬 터미널 | ✅ 활성 |
| Perplexity | 외부 검색·리서치 | MCP | ✅ 활성 |
| DataRAG / OpenRAG | 로컬 벡터 검색 | localhost | ⚠️ Phase A 진행 중 |
| Discord | 통합 알림 허브 (공보 채널) | 웹 + 웹훅 | 📋 계획 단계 |
| Obsidian | 시각화·로컬 지식 탐색 | Windows 앱 | ⚠️ 최소 설정 |
| Claude Desktop | Windows 측 Claude 접근 | Windows 앱 | ✅ 활성 |

### MCP 연결 현황

| MCP 서버 | 용도 | 상태 |
|----------|------|------|
| notionApi | Notion 읽기/쓰기/검색 | ✅ |
| github | GitHub 연동 | ✅ |
| git-mcp | Git 작업 | ✅ |
| filesystem | Windows 경로 접근 | ✅ |
| perplexity, exa, tavily, brave-search | 외부 검색 | ✅ |
| markitdown | 문서 변환 | ✅ |
| pinecone | 벡터 DB | ✅ |

## B2. 통신 인프라

### 3채널 체계

| 채널 | 비유 | 용도 | 빈도 |
|------|------|------|------|
| **Notion Inbox** | 행정 공문 | 업무 지시·보고·동기화 요청 | 수시 (작업 단위) |
| **Bridge** | 내부 전령 | 로컬 에이전트 간 통신·위임 | 수시 (세션 내) |
| **Discord #gazette** | 관보·회람 | 구조 변경 통보, 열람 확인 | 월 1~2회 |

### Notion Inbox 프로토콜

- DB: `collection://2acef0e0-af0f-46f8-aefd-5f17628f9150`
- 스키마: Name, MessageType, Domain, Direction, Status, Priority, Category, Result, Notes
- 상태 흐름: `Ready for AI` → `In Local` → `In Review` → `Active/Archived`
- 조회: `notion-search` + data_source_url (fetch 금지 — 과대 응답 위험)

### Bridge 프로토콜

- 경로: `~/workspace/active/.bridge/`
- 수신함: `inbox/cc/`, `inbox/oc/`, `inbox/advisors/`
- 위임: `state/active-delegations.json`
- 정본 스키마: [gtp-bridge-guide.md](./gtp-bridge-guide.md) + `templates/message.md`

> Charter/Playbook은 Bridge 개념과 정본 위치만 기술합니다. 메시지 type 범위·파일명 규칙·스키마 상세는 **gtp-bridge-guide.md가 유일한 정본**입니다.

### Discord (계획 단계)

- #gazette: Charter/Playbook 변경 통보 + 고정 URL + 열람 확인 리액션
- #bridge-alerts: 작업 완료·에이전트 상태·에스컬레이션
- 상태: 서버 미생성, Mnemo UI 작업 선행 필요
- 상세: [gtp-discord-hub.md](./gtp-discord-hub.md)

## B3. 표준 워크플로우

### 세션 루틴

```
━━━ 시작 ━━━
/status-mne → 세션 캐시 로드 + Notion Inbox 확인 + Bridge 확인 + Git 현황

━━━ 작업 ━━━
/inbox-mne     Notion → CC    작업 수신
/lookup-mne    CC ↔ Notion    자료 참조
/report-mne    CC → Notion    결과 보고
Bridge         CC ↔ OC/고문관  위임·수거

━━━ 종료 ━━━
/wrap-mne → 세션 캐시 작성 + 미결 항목 정리
```

### 확정 흐름 (단방향)

```
논의 (어디서든) → 결론 도출 → CC 문서화 → GnoTech (Git SSOT) → 필요 시 배포 (Notion/GitHub)
```

### 금지 패턴

| 패턴 | 이유 |
|------|------|
| Notion → Git 직접 push | SSOT 오염 |
| 양방향 자동 동기화 | 충돌 해결 불가 |
| Notion에서 GnoTech 패키지 직접 편집 | P1 위반 |
| CC에서 Notion 구조 대규모 변경 | 블록 체계 복잡성 |

## B4. 동기화 규칙

### SSOT 우선순위

```
1순위: Git (GnoTech Workspace)     ← 확정본
2순위: 로컬 세션 캐시               ← 작업 중 상태
3순위: Notion DB                   ← 의미론적 보완
4순위: Bridge 산출물                ← 통합 대기 권고안
```

### Charter/Playbook 변경 동기화

1. Git commit (P1)
2. GitHub Pages 자동 배포 (설정 완료 후)
3. Discord #gazette에 변경 요약 게시 (서버 구축 후)
4. 필요 시 Notion Inbox에 InfoShare 1건

## B5. 인프라 현황

| 항목 | 값 |
|------|-----|
| OS | Ubuntu 24.04 on WSL2 / Windows 11 (acer-swiftx) |
| RAM | 16GB (멀티 터미널 2개 한계) |
| Claude Code | 최신 + OMC (pre-tool-enforcer off) |
| Git | SSH 키 등록, pre-commit v4.5.1 |
| GitHub | Private Repo (`eidos11/GnoTech-Workspace`) |
| Notion | 비즈니스 플랜 (네이티브 웹훅 가능) |

### 현재 단계

- **Phase 0 (환경 구축)**: ✅ 완료
- **Phase 1 (서비스 개발)**: 🔄 진입 — EIU-OS Context Lock, LSAi 관통 실습
- **DataRAG Phase A**: 🔄 진행 중 — 7/37건 인덱싱, LLM 모델 교체 예정

---

# Part C: 변경 이력

## C1. 최근 변경

| 날짜 | 변경 |
|------|------|
| 2026-03-17 | v1.1: GnotPolis 명칭 도입, P2 적용 범위 명시, Bridge 정본 참조 체계, 시지푸스 리뷰 반영 |
| 2026-03-17 | v1.0: Charter + Playbook 도입. gnot-cns-guide, gnot-project-guide 폐기 |
| 2026-03-16 | Reform TF 14/14 완료 → SC_Ops §7 Archive. CNS Guide → SC_Guide-Hub 승격 |
| 2026-03-16 | Inbox DB 스키마 개편 (MessageType, Domain, Direction). CNS 스킬 3종 구현 |
| 2026-03-16 | ECC 플러그인 비활성화 + OMC pre-tool-enforcer off → 안정성 확보 |
| 2026-03-16 | Discord Hub 통합 알림 계획 수립 (Phase 1~8) |

## C2. ADR 색인

설계 결정 상세: `adr/DECISION-LOG.md` (ADR-001~013)
주요 항목:
- ADR-013: Inbox DB 스키마 개편 (2026-03-16)
- ADR-012: ECC 비활성화 결정 (2026-03-16)

---

> **이 문서의 해석·적용 사례·운용 상세 → [gtp-playbook.md](./gtp-playbook.md)**
> **GTP 인프라 매뉴얼**: [gtp-bridge-guide.md](./gtp-bridge-guide.md), [gtp-discord-hub.md](./gtp-discord-hub.md)
> **GnoTech 집행부 매뉴얼**: gnot-parallel-ops, gnot-opencode, gnot-datarag
