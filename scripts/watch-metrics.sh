#!/usr/bin/env bash
# 사용법: scripts/watch-metrics.sh
# 1초마다 내부 지표를 읽어 터미널에 표시하고 load/results/metrics-*.csv 에 기록한다.
# Ctrl+C 로 중단.
set -euo pipefail

cd "$(dirname "$0")/.."

BASE="http://localhost:28080/actuator/metrics"
OUT="load/results/metrics-$(date +%Y%m%d-%H%M%S).csv"
mkdir -p load/results

val() {
  curl -sf --max-time 1 "$BASE/$1" 2>/dev/null \
    | python3 -c "import sys,json;print(json.load(sys.stdin)['measurements'][0]['value'])" 2>/dev/null \
    || echo "NA"
}

echo "time,hikari_active,hikari_max,hikari_pending,tomcat_busy,heap_used_mb" | tee "$OUT"
while true; do
  T=$(date +%H:%M:%S)
  ACT=$(val "hikaricp.connections.active")
  MAX=$(val "hikaricp.connections.max")
  PEN=$(val "hikaricp.connections.pending")
  BUSY=$(val "tomcat.threads.busy")
  HEAP=$(curl -sf --max-time 1 "$BASE/jvm.memory.used?tag=area:heap" 2>/dev/null \
    | python3 -c "import sys,json;print(round(json.load(sys.stdin)['measurements'][0]['value']/1048576))" 2>/dev/null \
    || echo "NA")
  echo "$T,$ACT,$MAX,$PEN,$BUSY,$HEAP" | tee -a "$OUT"
  sleep 1
done
