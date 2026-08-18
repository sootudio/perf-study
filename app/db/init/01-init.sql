-- perf-study 스키마 + 더미 데이터 시드
-- 최초 컨테이너 기동 시 1회 실행됨 (수 분 소요)

CREATE EXTENSION IF NOT EXISTS pg_stat_statements;

CREATE TABLE member (
    id         BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    username   VARCHAR(50) NOT NULL,
    created_at TIMESTAMP   NOT NULL DEFAULT now()
);

CREATE TABLE post (
    id         BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    member_id  BIGINT       NOT NULL REFERENCES member (id),
    title      VARCHAR(200) NOT NULL,
    content    TEXT         NOT NULL,
    view_count INT          NOT NULL DEFAULT 0,
    created_at TIMESTAMP    NOT NULL
);

CREATE TABLE comment (
    id         BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    post_id    BIGINT    NOT NULL REFERENCES post (id),
    member_id  BIGINT    NOT NULL REFERENCES member (id),
    content    TEXT      NOT NULL,
    created_at TIMESTAMP NOT NULL
);

-- 회원 1만 명
INSERT INTO member (username)
SELECT 'user_' || g
FROM generate_series(1, 10000) g;

-- 게시글 100만 건 (작성일은 최근 2년에 분포)
INSERT INTO post (member_id, title, content, view_count, created_at)
SELECT
    (floor(random() * 10000) + 1)::bigint,
    'Post ' || g || ' — ' || (ARRAY[
        'spring boot 튜닝','postgres 인덱스','jvm gc 튜닝','k6 부하테스트',
        'hikari 커넥션 풀','nestjs 마이그레이션','flame graph 분석','트랜잭션 격리수준',
        '카프카 도입기','캐시 무효화 전략','코드리뷰 회고','장애 포스트모템',
        '쿼리 최적화','페이지네이션','배포 자동화','모니터링 대시보드',
        '로그 수집','테스트 전략','리팩터링','온보딩 가이드'
    ])[floor(random() * 20) + 1],
    substr(md5(random()::text) || md5(random()::text) || md5(random()::text), 1, 80),
    floor(random() * 5000)::int,
    now() - (random() * interval '730 days')
FROM generate_series(1, 1000000) g;

-- 댓글 200만 건 (절반은 게시글 1~10000번에 몰려 있음: 인기글 시뮬레이션)
INSERT INTO comment (post_id, member_id, content, created_at)
SELECT
    CASE WHEN random() < 0.5
         THEN (floor(random() * 10000) + 1)::bigint
         ELSE (floor(random() * 1000000) + 1)::bigint
    END,
    (floor(random() * 10000) + 1)::bigint,
    substr(md5(random()::text), 1, 30),
    now() - (random() * interval '365 days')
FROM generate_series(1, 2000000) g;

VACUUM ANALYZE member;
VACUUM ANALYZE post;
VACUUM ANALYZE comment;
