# perf-study

성능 병목을 **스스로 특정하는 능력**을 훈련하는 16주 학습 프로젝트.
기법 목록 암기가 아니라 "지금 뭐가 느린지"를 측정으로 찾아내는 게 목표다.

- 스택: Java 21 + Spring Boot 3 + PostgreSQL 16 (Docker)
- 계획: [curriculum.md](curriculum.md) / 기록: [progress.md](progress.md) / 블로그 초안: [drafts/](drafts/)
- 토이 앱에는 성능 문제가 의도적으로 심어져 있다. 어디에 있는지는 비밀. 찾는 게 훈련이다.

## 실행

```bash
# DB (최초 기동 시 더미 데이터 300만 건 시드 — 수 분 소요)
cd app && docker compose up -d

# 앱
cd app && ./gradlew bootRun

# baseline 부하 측정
k6 run load/baseline.js
```

## 엔드포인트

| 메서드 | 경로 | 설명 |
|---|---|---|
| GET | `/api/posts?page=&size=` | 게시글 목록 (최신순) |
| GET | `/api/posts/{id}` | 게시글 상세 + 댓글 |
| GET | `/api/posts/search?keyword=` | 제목 검색 (상위 20건) |

Actuator: `/actuator/health`, `/actuator/metrics`, `/actuator/prometheus`
