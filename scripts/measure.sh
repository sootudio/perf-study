#!/usr/bin/env bash
# 사용법: scripts/measure.sh "http://localhost:8080/api/posts?page=0&size=20" [횟수]
# 지정한 URL에 순차로 N번 요청을 보내고 응답시간(초) 원본을 그대로 저장한다.
# 정렬/백분위 계산은 하지 않는다 — 그건 학습자의 몫.
set -euo pipefail

cd "$(dirname "$0")/.."

URL="${1:?측정할 URL을 넘겨라}"
N="${2:-100}"

mkdir -p load/results
OUT="load/results/manual-$(date +%Y%m%d-%H%M%S).txt"

for i in $(seq 1 "$N"); do
  curl -s -o /dev/null -w "%{time_total}\n" "$URL"
done | tee "$OUT"

echo "---"
echo "저장: $OUT (단위: 초, 요청 보낸 순서 그대로)"
