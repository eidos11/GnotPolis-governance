#!/usr/bin/env bash
# dashboard-comment.sh — 대시보드 코멘트 로그에 항목 추가
#
# 사용법:
#   ./dashboard-comment.sh "작성자" "대상섹션" "내용"
#   ./dashboard-comment.sh "작성자" "대상섹션" "내용" "🔴"   # 긴급
#
# 예시:
#   ./dashboard-comment.sh "Mnemo" "W2 목표" "Proof-pack 범위 축소 검토"
#   ./dashboard-comment.sh "CC" "트랙A" "LinkedIn W3로 이동 제안" "🔴"
#   ./dashboard-comment.sh "시지푸스" "Decision Gate" "유상 의향 기준 명확화 필요"

set -euo pipefail

DASHBOARD="$(cd "$(dirname "$0")" && pwd)/DASHBOARD.md"

if [[ $# -lt 3 ]]; then
    echo "사용법: $0 \"작성자\" \"대상섹션\" \"내용\" [\"🔴\"]"
    echo ""
    echo "예시:"
    echo "  $0 \"Mnemo\" \"W2 목표\" \"Proof-pack 범위 축소 검토\""
    echo "  $0 \"CC\" \"트랙A\" \"LinkedIn W3로 이동 제안\" \"🔴\""
    exit 1
fi

AUTHOR="$1"
SECTION="$2"
CONTENT="$3"
URGENT="${4:-}"

DATE=$(date +%m/%d)
STATUS="⚪"

# 긴급 표시
if [[ -n "$URGENT" ]]; then
    CONTENT="🔴 ${CONTENT}"
fi

# 코멘트 로그 테이블의 마지막 데이터 행 뒤에 새 행 삽입
# "---" 구분선 바로 위 (코멘트 로그 섹션 끝)를 찾아서 삽입
NEW_ROW="| ${DATE} | ${AUTHOR} | ${SECTION} | ${CONTENT} | ${STATUS} |"

# 코멘트 로그 섹션의 마지막 테이블 행 다음에 삽입
# 전략: 파일 끝에서 두 번째 "---" 앞에 삽입
if grep -q "^## 코멘트 로그" "$DASHBOARD"; then
    # 코멘트 로그 섹션 이후 첫 "---" 라인 번호 찾기
    LOG_START=$(grep -n "^## 코멘트 로그" "$DASHBOARD" | tail -1 | cut -d: -f1)
    SEPARATOR_LINE=$(tail -n +"$LOG_START" "$DASHBOARD" | grep -n "^---$" | head -1 | cut -d: -f1)
    INSERT_AT=$((LOG_START + SEPARATOR_LINE - 1))

    # 해당 라인 앞에 새 행 삽입
    head -n $((INSERT_AT - 1)) "$DASHBOARD" > "${DASHBOARD}.tmp"
    echo "$NEW_ROW" >> "${DASHBOARD}.tmp"
    tail -n +"$INSERT_AT" "$DASHBOARD" >> "${DASHBOARD}.tmp"
    mv "${DASHBOARD}.tmp" "$DASHBOARD"

    echo "✅ 코멘트 추가: ${AUTHOR} → ${SECTION}"
    echo "   ${CONTENT}"
else
    echo "❌ 코멘트 로그 섹션을 찾을 수 없습니다."
    exit 1
fi
