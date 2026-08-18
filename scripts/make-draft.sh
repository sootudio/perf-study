#!/usr/bin/env bash
# 사용법: scripts/make-draft.sh 01
# progress.md의 해당 주차 기록을 참고자료로 붙인 블로그 초안 뼈대를 drafts/에 생성한다.
set -euo pipefail

cd "$(dirname "$0")/.."

NN="${1:?주차 번호를 넘겨라 (예: 01)}"
NN=$(printf "%02d" "${NN#0}")
OUT="drafts/week-${NN}.md"

if [[ -e "$OUT" ]]; then
  echo "이미 존재함: $OUT — 덮어쓰지 않는다." >&2
  exit 1
fi

mkdir -p drafts

PROGRESS_SECTION=$(awk -v pat="^## Week ${NN}" '
  $0 ~ pat {found=1}
  found && /^---/ {exit}
  found {print}
' progress.md)

cat > "$OUT" <<EOF
# Week ${NN} — (제목 미정)

## 제목 후보
1.
2.
3.

## 이번 주 가설
<!-- ⛔ 반드시 본인이 직접 쓴다. Claude가 채우지 않는다. -->

## 목차

## 측정 환경 / 방법

## Before / After

| 항목 | Before | After |
|---|---|---|
|  |  |  |

## 예상과 달랐던 점
<!-- ⛔ 반드시 본인이 직접 쓴다. Claude가 채우지 않는다. -->

---

<!-- 아래는 progress.md에서 가져온 이번 주 기록 (초안 작성용 참고, 발행 전 삭제) -->
${PROGRESS_SECTION}
EOF

echo "생성: $OUT"
