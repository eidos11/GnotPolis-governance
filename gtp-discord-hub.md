# GnoTech Discord Hub — 통합 알림·연동 허브 구축 계획

> **역할**: Discord를 GnoTech 전 에이전트의 통합 알림 허브로 구축하고, 장기적으로 콘텐츠·커뮤니티 플랫폼으로 확장하는 계획서.
> **관계**: Charter(B2 통신 인프라)의 알림 레이어, parallel-ops(§4 산출물 교환)의 통보 수단.
> **위치**: `SC-command/cognotech/gtp-discord-hub.md`
> **상태**: 계획 단계 (미구현)
> **최종 갱신**: 2026-03-16

---

# Part 0: Discord 기본 개념 정리

> 이 섹션은 Discord가 처음이거나 구조가 잘 안 잡히는 사용자를 위한 정리.
> 이미 익숙하면 Part 1로 건너뛴다.

## 0.1 Discord는 무엇인가

Discord는 **채팅 기반 협업 플랫폼**이다. 단순한 SNS가 아니라, 슬랙(Slack)과 유사한 구조에 음성/영상/봇/자동화가 결합된 **프로그래머블 커뮤니케이션 허브**.

**카카오톡과의 차이**:
- 카카오톡: 1:1 또는 그룹 대화방. 주제 분리 불가. 자동화 없음
- Discord: **서버** 안에 **채널**이 여러 개. 주제별로 분리. 봇과 웹훅으로 자동화 가능

**슬랙과의 차이**:
- 슬랙: 기업용, 유료 위주, API 유료화 추세
- Discord: 개인/커뮤니티용, 핵심 기능 무료, 봇/웹훅 완전 무료, AI 생태계 활발

## 0.2 핵심 구조 3계층

```
서버(Server)
  = "건물" 하나. GnoTech 전용 서버를 만든다.
  │
  ├── 카테고리(Category)
  │     = "층". 주제별 묶음. 예: "운영", "프로젝트", "알림"
  │     │
  │     ├── 채널(Channel)
  │     │     = "방". 텍스트 또는 음성.
  │     │     예: #bridge-alerts, #system-status
  │     │     │
  │     │     └── 스레드(Thread)
  │     │           = "방 안의 대화 묶음". 한 주제의 연속 대화.
  │     │           예: "⑬ Domain Guides 협의" 스레드
  │     │
  │     └── 채널 ...
  │
  └── 카테고리 ...
```

## 0.3 GnoTech에서 쓸 핵심 기능 3가지

| 기능 | 설명 | 용도 |
|------|------|------|
| **웹훅(Webhook)** | 외부에서 채널에 메시지를 보내는 URL. curl 한 줄이면 됨 | CC·시지푸스·cron이 알림 전송 |
| **봇(Bot)** | 채널에 상주하며 명령을 받고 실행하는 프로그램 | (Phase 8) 양방향 명령 수신 |
| **스레드(Thread)** | 채널 내 독립 대화 묶음. 채널을 어지럽히지 않음 | 다회전 사이클별 추적 |

## 0.4 웹훅의 작동 원리

```
[CC 스크립트] ──curl POST──→ [Discord 웹훅 URL] ──→ #bridge-alerts 채널에 메시지 표시
                                                          ↓
                                                   Mnemo 모바일 푸시 알림
```

- 웹훅 URL = 일종의 "우편함 주소". 이 URL로 POST 요청을 보내면 해당 채널에 메시지가 뜸
- **인증 불필요** — URL 자체가 인증 키 역할 (따라서 URL은 시크릿으로 관리)
- 무료, 속도제한 관대 (채널당 초당 5회), 메시지 길이 2000자

---

# Part 1: 아키텍처 설계

## 1.1 역할 정의

Discord 서버 "GnoTech Hub"의 역할:

| 시기 | 역할 | 상세 |
|------|------|------|
| **즉시** | 알림 허브 | 에이전트 간 작업 완료/요청 알림 |
| **근시일** | 에이전트 연동 | 양방향 명령 (Discord→CC 트리거) |
| **장기** | 콘텐츠·커뮤니티 | 프로젝트별 포스팅, 교육 커리큘럼, 마케팅 |

## 1.2 채널 구조안

```
GnoTech Hub (서버)
│
├── 📋 운영 (카테고리)
│   ├── #bridge-alerts     ← 핵심: 에이전트 간 알림 (CC↔노션↔시지푸스↔고문관)
│   ├── #system-status     ← 환경 상태 (메모리, MCP, cron 정상 여부)
│   └── #decision-log      ← 주요 결정 알림 (ADR 등록 시)
│
├── 🔬 프로젝트 (카테고리)
│   ├── #p01-cb-matrix
│   ├── #p01-howstudy
│   ├── #p02-eiu
│   ├── #p03-lsai
│   └── #p11-virtual-symposium
│
├── 📚 콘텐츠 (카테고리) — 장기
│   ├── #education         ← Howstudy 커리큘럼 포스팅
│   ├── #portfolio         ← EIU 포트폴리오 쇼케이스
│   └── #resources         ← 유용한 도구·레퍼런스 공유
│
└── ⚙️ 관리 (카테고리)
    ├── #bot-commands      ← 봇 명령 전용 (Phase 8)
    └── #webhook-test      ← 웹훅 테스트용 (설정 후 삭제 가능)
```

**즉시 필요한 채널**: `#bridge-alerts`, `#webhook-test` (2개만)
나머지는 필요할 때 점진적으로 추가.

## 1.3 알림 흐름 상세

### CC → Discord (작업 완료 통보)

```
/report-mne 실행
  → Notion Inbox에 ResultReport 등록
  → notify-discord.sh 호출
    → #bridge-alerts에 메시지:
      "📤 CC→Notion: {제목} — {상태}. Inbox 확인 요청."
```

### Notion → Discord (변경 감지)

```
cron (5분 주기) notion-inbox-poller.sh 실행
  → Notion API로 Inbox DB 조회
  → "Ready for AI" 신규 항목 감지
  → notify-discord.sh 호출
    → #bridge-alerts에 메시지:
      "📬 Notion→CC: 새 항목 {N}건 — '{제목}'. /inbox-mne pull 실행 필요."
  → 마지막 확인 시각을 로컬에 기록 (중복 알림 방지)
```

### Bridge → Discord (시지푸스/고문관)

```
cron (5분 주기) bridge-watcher.sh 실행
  → .bridge/inbox/cc/에 신규 pending 파일 감지
  → notify-discord.sh 호출
    → #bridge-alerts에 메시지:
      "📬 {발신자}→CC: '{제목}'. /bridge-check 실행 필요."
```

## 1.4 비상대안: Notion 네이티브 웹훅

Notion 비즈니스 플랜의 DB Automation 기능을 **설정만 해두고 평시 OFF**:

- **트리거**: Inbox DB의 Status가 "Ready for AI"로 변경될 때
- **액션**: Send Webhook → Discord 웹훅 URL로 POST
- **평시**: automation toggle OFF (Discord cron이 담당)
- **비상**: Discord 장애 시 ON → 노션이 직접 Discord에 알림 (또는 별도 URL)

설정 절차:
1. Notion Inbox DB → ⚡ Automation 아이콘
2. 트리거: "Status가 Ready for AI로 변경될 때"
3. 액션: "Send Webhook" → Discord 웹훅 URL
4. 저장 후 **비활성화(toggle OFF)**

---

# Part 2: 구현 계획

## Phase 1: Discord 서버 + 웹훅 설정

**작업 내용**:
1. Discord에 "GnoTech Hub" 서버 생성 (또는 기존 서버에 카테고리 추가)
2. `#bridge-alerts` 채널 생성
3. 채널 설정 → 통합(Integrations) → 웹훅 생성 → URL 복사
4. `~/.env.secrets`에 `DISCORD_WEBHOOK_URL=...` 저장
5. `#webhook-test` 채널에 테스트 메시지 전송 확인

**Mnemo 직접 수행 항목** (Discord UI 작업):
- 서버 생성, 채널 생성, 웹훅 URL 복사

**CC 수행 항목**:
- URL을 `~/.env.secrets`에 저장
- 테스트 curl 실행

**산출물**: 웹훅 URL 확보, 테스트 메시지 성공

## Phase 2: 공용 알림 함수 (`notify-discord.sh`)

**작업 내용**:
```bash
#!/bin/bash
# ~/scripts/notify-discord.sh
# 사용법: notify-discord.sh "메시지 내용" [채널별웹훅URL]

source ~/.env.secrets
WEBHOOK_URL="${2:-$DISCORD_WEBHOOK_URL}"
MESSAGE="$1"

curl -s -H "Content-Type: application/json" \
  -d "{\"content\": \"$MESSAGE\"}" \
  "$WEBHOOK_URL"
```

**확장**: 이모지 자동 접두사, 에이전트별 색상 구분 (embed 메시지), 스레드 지정 등은 Phase 7에서.

**산출물**: `~/scripts/notify-discord.sh` + 실행 권한

## Phase 3: 기존 스킬에 Discord 알림 통합

**작업 내용**:
- `/report-mne` 완료 시 → `notify-discord.sh` 자동 호출
- `/inbox-mne pull` 완료 시 → `notify-discord.sh`로 수신 확인 알림
- 알림은 **선택적** — 스킬 내에서 "알림을 보낼까요?" 확인 또는 기본 ON

**산출물**: inbox-mne.md, report-mne.md 갱신

## Phase 4: Notion 폴링 cron (`notion-inbox-poller.sh`)

**작업 내용**:
1. Notion API 토큰으로 Inbox DB 조회 (Status = Ready for AI)
2. 마지막 확인 시각과 비교 → 신규 항목만 감지
3. 신규 있으면 → Discord 알림
4. cron 등록: `*/5 * * * * ~/scripts/notion-inbox-poller.sh`

**주의사항**:
- Notion API 토큰은 `~/.env.secrets`에서 로드 (대화 컨텍스트에 노출 금지)
- MCP 토큰과 별도의 Internal Integration 토큰 필요 여부 확인
- 실패 시 에러를 `#system-status`에 알림 (무한 에러 알림 방지: 연속 3회 실패 시만)

**산출물**: `~/scripts/notion-inbox-poller.sh` + cron 등록

## Phase 5: Bridge 파일 감시

**작업 내용**:
1. `.bridge/inbox/cc/`에 신규 pending 파일 감지
2. `.bridge/inbox/advisors/` 하위에 신규 파일 감지
3. 감지 시 → Discord 알림

**구현 옵션**:
- **Option A**: cron 5분 주기 (간단, Phase 4와 동일 패턴)
- **Option B**: inotifywait 상주 프로세스 (실시간, 그러나 프로세스 관리 필요)
- **권장**: Option A (단순성 우선)

**산출물**: `~/scripts/bridge-watcher.sh` + cron 등록

## Phase 6: Notion 네이티브 웹훅 비상대안

**작업 내용**:
1. Notion Inbox DB에 Automation 설정
2. 트리거: Status → "Ready for AI" 변경
3. 액션: Send Webhook → Discord 웹훅 URL (또는 별도 비상 URL)
4. **비활성화(toggle OFF)** 상태로 저장
5. 활성화/비활성화 절차를 이 문서에 기록

**Mnemo 직접 수행 항목** (Notion UI 작업):
- DB Automation 설정 (CC는 Notion UI 조작 불가)

**산출물**: Notion DB Automation (비활성 상태)

## Phase 7: 다회전 자동 사이클 (`/cycle-mne`)

> Phase 1~5 완료 후 착수. 상세 설계는 별도 문서.

> ⚠️ **거버넌스 합의 선행 필요** (원로원 F3 피드백 반영, 2026-03-17):
> Phase 7 구현 전 Playbook PB2에 다음 3항목을 먼저 등재해야 한다:
> 1. **자동 사이클 허용 범위** — 어떤 MessageType/Domain까지 자동화 허용할 것인가
> 2. **Mnemo 개입 필수 기준** — 구조 변경·원칙 관련 사항 포함 시 자동화 중단 조건
> 3. **종료 판단 권한** — CC 단독 판단 가능 범위 vs Mnemo 확인 필수 범위
>
> 사유: 자동 사이클이 원로원의 심의 역할을 우회하면 Charter A4 운영 원칙 1(생산적 긴장)이 약화될 위험. Notion AI 현 아키텍처의 자동 트리거 제약도 사전 설계에 반영 필요.

**개념**:
```
/cycle-mne "⑬ Domain Guides 생성" --max-rounds=3

  → CC가 초안 작성 + Notion Inbox에 등록 + Discord 알림
  → cron이 노션 응답 감지 + Discord 알림 + CC 자동 수신
  → CC가 보강 + 재등록 + Discord 알림
  → ... (max-rounds 또는 합의 도달까지 반복)
  → 최종 결과를 Discord Thread + Mnemo에게 확인 요청
```

**자동 종료 기준**:
- 양측 합의 표시 (Status → Active/Archived)
- max-rounds 도달 (기본 3회)
- Mnemo 개입 요청 (Priority: High 에스컬레이션)

**핵심 과제**:
- CC 세션 간 상태 유지 (cron이 새 세션을 어떻게 트리거할 것인가)
- 노션 AI의 자동 응답 설정 (Notion Custom Agent 활용 가능성)

## Phase 8: Discord Bot (양방향 명령)

> Phase 7 안정화 후 선택적 착수.

**개념**: Discord 채널에서 Mnemo가 명령을 입력하면 CC 또는 다른 에이전트에 트리거.

예시:
- `/inbox` → CC가 Notion Inbox 수신
- `/status` → 현재 작업 상황 요약
- `/cycle start "제목"` → 다회전 사이클 시작

**구현 옵션**:
- Python discord.py 라이브러리
- Node.js discord.js 라이브러리
- 또는 Pipedream의 Discord Bot 트리거 (코드 최소화)

---

# Part 3: 의존성 및 제약

## 3.1 시크릿 관리

| 시크릿 | 저장 위치 | 용도 |
|--------|----------|------|
| Discord 웹훅 URL | `~/.env.secrets` | 알림 전송 |
| Notion API 토큰 | `~/.env.secrets` | cron 폴링 (MCP 토큰과 별도 확인 필요) |

> 모든 시크릿은 CLAUDE.md §시크릿 보호 규칙 준수. 대화 컨텍스트에 값 노출 금지.

## 3.2 리소스 영향

| 항목 | 영향 | 비고 |
|------|------|------|
| cron 2개 (5분 주기) | 무시할 수준 | bash + curl, 각 1~2초 |
| Notion API 호출 | 288회/일 (5분 주기) | rate limit 3req/sec 대비 여유 |
| Discord 웹훅 | 최대 수십 회/일 | rate limit 5req/sec 대비 여유 |
| 메모리 | 추가 없음 | 상주 프로세스 없음 (cron 방식) |

## 3.3 기존 인프라 연계

| 기존 인프라 | 연계 지점 |
|------------|----------|
| CNS Guide §5 연계 스킬 | report-mne, inbox-mne에 Discord 알림 추가 |
| Bridge 프로토콜 | bridge-watcher.sh가 .bridge/inbox/ 감시 |
| parallel-ops | C/S/R 터미널 모두 notify-discord.sh 사용 가능 |
| 세션 캐시 | Phase 7에서 사이클 상태를 캐시에 기록 |

---

# Part 4: Discord 장기 활용 전략

## 4.1 콘텐츠·마케팅 채널

| 채널 | 용도 | 대상 |
|------|------|------|
| #education | Howstudy 커리큘럼 포스팅, 학습 자료 | 학생·수강생 |
| #portfolio | EIU 포트폴리오, 작업물 쇼케이스 | 클라이언트·협력자 |
| #resources | AI 도구 팁, GnoTech 활용법 | 커뮤니티 |
| #announcements | 서비스 공지, 업데이트 | 전체 |

## 4.2 AI 생태계 연동

Discord는 AI 도구 생태계의 사실상 표준 플랫폼:
- **Midjourney**: 이미 Discord 기반 (기존 경험 활용)
- **ChatGPT/Claude**: Discord Bot으로 대화 가능
- **GitHub**: 웹훅으로 PR/Issue 알림 수신
- **Notion**: 본 문서의 핵심 연동 대상
- **각종 AI 서비스**: 대부분 Discord Bot 또는 웹훅 지원

## 4.3 프리랜서 사업 활용

- 클라이언트별 비공개 채널 → 프로젝트 소통
- 작업 진행 상황 자동 포스팅 → 투명성 확보
- 파일 공유 + 스레드 토론 → 이메일 대체

---

# 부록 A: 구현 우선순위 매트릭스

| Phase | 효과 | 난이도 | 의존성 | 착수 시기 |
|-------|------|--------|--------|----------|
| 1. Discord 서버+웹훅 | 높음 | 쉬움 | 없음 | 즉시 |
| 2. notify-discord.sh | 높음 | 쉬움 | Phase 1 | 즉시 |
| 3. 스킬 알림 통합 | 높음 | 쉬움 | Phase 2 | 즉시 |
| 4. Notion 폴링 cron | 높음 | 중간 | Phase 2 + API 토큰 | 근시일 |
| 5. Bridge 감시 | 중간 | 쉬움 | Phase 2 | 근시일 |
| 6. Notion 비상대안 | 낮음 | 중간 | Mnemo UI 작업 | 근시일 |
| 7. 다회전 사이클 | 매우높음 | 높음 | Phase 1~5 | 별도 설계 |
| 8. Discord Bot | 중간 | 높음 | Phase 7 | 장기 |

# 부록 B: 참조 문서

| 문서 | 경로 | 관계 |
|------|------|------|
| Governance Charter | `SC-command/cognotech/gtp-charter.md` | B2 통신 인프라에 Discord 반영 |
| parallel-ops | `SC-command/cognotech/gnot-parallel-ops.md` | §4 산출물 교환에 Discord 통보 수단 추가 예정 |
| Bridge Guide | `SC-command/cognotech/gtp-bridge-guide.md` | bridge-watcher.sh 연동 |
| CLAUDE.md | `~/.claude/CLAUDE.md` | 시크릿 보호 규칙 준수 |
| MEMORY.md | `~/.claude/projects/-home-youngil/memory/MEMORY.md` | Discord 웹훅 설정 정보 기록 예정 |

---

*본 문서는 계획 단계이며, Phase별 구현 완료 시 상태를 갱신한다.*
