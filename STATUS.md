# STATUS — 세션 간 진행상황 공유 문서

> 어느 기기에서든 새 세션을 시작하면 **Claude가 이 파일을 가장 먼저 읽는다.**
> 세션 종료 시마다 Claude가 갱신해서 작업 브랜치에 커밋한다.
> 이 문서는 "지금 어디까지 왔고, 다음에 뭘 하는지"만 담는다. 학습 내용 기록은 progress.md.

## 현재 위치 (2026-09-01 갱신)

- **주차**: Week 01 — 지표 정의 + 토이앱 탐색
- **브랜치**: `week-01` (main에서 분기, draft PR 아직 안 만듦)
- **단계**: 개념 문답 통과 → **실습 대기 중** (여기서 멈춰 있음)

### Week 01에서 끝난 것
- 지표 개념 문답 완료: p50/p95/p99 = 정렬했을 때의 한 점(경계값), 응답시간 분포는 right-skewed, "평균 0.12초여도 API 30회 호출 화면이면 1−0.99³⁰ ≈ 26%가 p99를 경험", 처리량 유지+지연시간 악화 시나리오(계산대 5초→9초), 포화(9초→11초)의 질적 차이까지 확인함
- 4단계 힌트 규칙에서 4단계(설명)까지 간 횟수: **1회** (히스토그램 축 + 백분위가 '한 점'이라는 것) — 2회부터 난이도 경고 대상

### 다음에 할 일 (순서대로)
1. `progress.md`의 Week 01 "가설" 칸에 두 줄 쓰기 — **사용자가 직접** (목록 API p50 예상치 / p99는 p50의 몇 배 예상)
2. 측정 실습:
   ```bash
   cd app && docker compose up -d      # DB (최초 기동이면 시드에 수 분)
   cd app && ./gradlew bootRun          # 앱 (별도 터미널)
   scripts/measure.sh "http://localhost:8080/api/posts?page=0&size=20" 100
   ```
3. 저장된 100개 숫자(load/results/*.txt)로 **직접**: 정렬해서 p50/p95/p99 집기(몇 번째 줄인지 + 이유), 평균 계산해서 p50과 비교, 정렬 전 순서에서 패턴 관찰
4. 숫자 3개 들고 오면: 본인 말 재설명(4단계 규칙의 마무리) → progress.md 기록 → `scripts/make-draft.sh 01` → 블로그 초안 → draft PR

## 저장소 구조

```
perf-study/
├── CLAUDE.md          # 교사 역할 규칙 — 깃에 포함. clone하면 새 세션에 자동 적용됨
├── STATUS.md          # (이 파일) 세션 간 진행상황 — 새 세션은 여기부터 읽는다
├── README.md          # 프로젝트 개요 + 실행법
├── curriculum.md      # 16주 계획
├── progress.md        # 주차별 학습 기록 (가설/측정/before/after — 가설은 사용자만 씀)
├── info.md            # 최초 셋업 요청서 (참고용 원본)
├── app/               # 토이 앱 (Spring Boot 3 + Java 21)
│   ├── docker-compose.yml       # PostgreSQL 16, 포트 5433
│   ├── db/init/01-init.sql      # 스키마 + 더미 데이터 시드 (최초 기동 시 자동 실행)
│   └── src/main/java/dev/perfstudy/app/   # controller / service / repository / entity / dto
├── load/
│   ├── baseline.js    # k6 부하 스크립트 (2주차부터 사용)
│   └── results/       # 측정 결과 저장소 (gitignore — 기기별 로컬)
├── scripts/
│   ├── measure.sh     # 응답시간 N회 측정, 원본만 출력 (1주차 실습용)
│   ├── make-draft.sh  # progress.md → drafts/week-NN.md 블로그 초안 생성
│   └── md2tistory.mjs # 초안 → 티스토리 붙여넣기용 HTML (md2tistory.sh)
├── drafts/            # 블로그 초안 (주차별로 생성됨)
└── .answers/          # 정답지 — gitignore. 메인 기기(회사 노트북)에만 존재
```

깃에 **안 올라가는 것**: `.answers/`(정답지), `load/results/`(측정 결과), `app/build/` 등 빌드 산출물, `drafts/html/`(변환 산출물). 이 중 측정 결과는 기기별 로컬이 정상이고, 수치는 progress.md에 옮겨 적는 것으로 공유한다.

## 새 기기 셋업 (최초 1회)

```bash
git clone https://github.com/sootudio/perf-study.git && cd perf-study
git switch week-01

# 개인 신원 (전역 설정이 회사 계정일 수 있으니 반드시 로컬로)
git config --local user.name "sootudio"
git config --local user.email "kswim8914@gmail.com"

# 푸시 인증: gh에 개인 계정 로그인 (브라우저에서 sootudio 계정인지 확인)
gh auth login
# 회사 계정도 쓰는 기기라면 remote에 사용자명을 박아 계정 혼동 방지:
git remote set-url origin https://sootudio@github.com/sootudio/perf-study.git

# 도구
brew install k6                      # 부하 도구
# Java 21 + Docker Desktop 필요 (java -version / docker --version 으로 확인)
```

- `.answers/`는 gitignore라 **repo에 없다** = 다른 기기에는 정답지가 없다. 원본은 메인 기기(회사 노트북)에만 있음. 포기 선언은 메인 기기에서만 가능 — 오히려 학습에 좋은 제약이므로 옮기지 않는다.
- 티스토리 오픈API는 2024-02 종료 확인 완료. 재확인 불필요. 발행은 수동.

## 운영 규칙 요약 (상세는 CLAUDE.md)
- 주차 작업 = `week-NN` 브랜치 → draft PR → 머지는 사용자 → `week-NN-done` 태그
- progress.md의 "가설"/"예상과 달랐던 점"은 사용자만 쓴다
- 세션 끝날 때 Claude가 이 파일 갱신 + progress.md/drafts 변경 커밋·푸시
