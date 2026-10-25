// VU 단계 실험용 — 목록 API 단일 대상, VU 수를 env 로 받는다
// 실행: k6 run --env VUS=50 load/vu.js   (60초 고정)

import http from 'k6/http';
import { sleep } from 'k6';

const BASE = __ENV.BASE_URL || 'http://localhost:28080';
const VUS = parseInt(__ENV.VUS || '5', 10);

export const options = {
  vus: VUS,
  duration: '60s',
  summaryTrendStats: ['avg', 'min', 'med', 'p(90)', 'p(95)', 'p(99)', 'max'],
};

export default function () {
  const page = Math.floor(Math.random() * 50);
  http.get(`${BASE}/api/posts?page=${page}&size=20`);
  sleep(0.3);
}
