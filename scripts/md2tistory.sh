#!/usr/bin/env bash
# 사용법: scripts/md2tistory.sh drafts/week-01.md
# 마크다운을 티스토리 "HTML 모드" 붙여넣기용 HTML로 변환한다.
# (티스토리 오픈API는 2024-02 종료 — 발행은 수동으로 한다)
set -euo pipefail

cd "$(dirname "$0")/.."

IN="${1:?변환할 마크다운 파일을 넘겨라}"
mkdir -p drafts/html
OUT="drafts/html/$(basename "${IN%.md}").html"

npx --yes marked --gfm -i "$IN" -o "$OUT"

echo "생성: $OUT"
echo "→ 파일 내용을 복사해서 티스토리 에디터의 'HTML 모드'에 붙여넣으면 된다."
