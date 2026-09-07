// k6 baseline — 엔드포인트 3개를 각각 별도 시나리오로 측정
// 실행: k6 run load/baseline.js
// 특정 엔드포인트만: k6 run --env ONLY=list load/baseline.js  (list | detail | search)

import http from 'k6/http';
import { sleep } from 'k6';

const BASE = __ENV.BASE_URL || 'http://localhost:18080';
const ONLY = __ENV.ONLY || '';

const common = {
  executor: 'constant-vus',
  vus: 5,
  duration: '60s',
};

const allScenarios = {
  list: { ...common, exec: 'list', startTime: '0s' },
  detail: { ...common, exec: 'detail', startTime: '70s' },
  search: { ...common, exec: 'search', startTime: '140s' },
};

export const options = {
  summaryTrendStats: ['avg', 'min', 'med', 'p(90)', 'p(95)', 'p(99)', 'max'],
  scenarios: ONLY
    ? { [ONLY]: { ...allScenarios[ONLY], startTime: '0s' } }
    : allScenarios,
};

export function list() {
  const page = Math.floor(Math.random() * 50); // 1~50페이지 범위
  http.get(`${BASE}/api/posts?page=${page}&size=20`, { tags: { endpoint: 'list' } });
  sleep(0.3);
}

export function detail() {
  // 실제 트래픽처럼 인기글(낮은 id)에 조회가 몰리는 분포
  const hot = Math.random() < 0.5;
  const id = hot
    ? Math.floor(Math.random() * 10000) + 1
    : Math.floor(Math.random() * 1000000) + 1;
  http.get(`${BASE}/api/posts/${id}`, { tags: { endpoint: 'detail' } });
  sleep(0.3);
}

const KEYWORDS = ['인덱스', '튜닝', '페이지네이션', '카프카', '리팩터링'];

export function search() {
  const kw = KEYWORDS[Math.floor(Math.random() * KEYWORDS.length)];
  http.get(`${BASE}/api/posts/search?keyword=${encodeURIComponent(kw)}`, { tags: { endpoint: 'search' } });
  sleep(0.3);
}
