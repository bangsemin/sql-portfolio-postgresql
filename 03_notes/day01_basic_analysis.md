# Day 01. 기본 SQL 분석 환경 점검

## 1. 오늘의 목표

PostgreSQL에서 생성한 `sql_portfolio` 데이터베이스를 기준으로 현재 테이블 구조를 확인하고, 기본 조회와 데이터 건수 확인을 수행했다.

## 2. 현재 데이터베이스 구조

현재 사용 중인 데이터베이스는 `sql_portfolio`이며, 기본 스키마는 `public`이다.

현재 생성된 테이블은 다음과 같다.

| 스키마 | 테이블 |
|---|---|
| public | customers |
| public | orders |
| public | products |

## 3. 작성한 SQL 파일

- `02_projects/day01_basic_analysis.sql`

## 4. 학습한 SQL 개념

- `current_database()`
- `current_schema()`
- `information_schema.tables`
- `information_schema.columns`
- `SELECT`
- `COUNT(*)`
- `UNION ALL`
- `LIMIT`

## 5. 오류 해결 기록

```text
오류: relation "customers" does not exist
SQL state: 42P01

원인은 SQL 파일에서 SET search_path TO retail;을 사용했지만, 실제 테이블은 retail 스키마가 아니라 public 스키마에 생성되어 있었기 때문이다

SET search_path TO public; 로 수정했다.
