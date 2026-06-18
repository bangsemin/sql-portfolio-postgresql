-- =========================================================
-- Day 01. Basic SQL Analysis
-- 목적:
--   sql_portfolio 데이터베이스의 public 스키마에 생성된
--   customers, orders, products 테이블을 활용해
--   기본 조회, 조건 필터링, 정렬, 집계 분석을 수행한다.
--
-- 사용 개념:
--   SELECT, WHERE, ORDER BY, COUNT, GROUP BY
--
-- 현재 DB 구조:
--   public.customers
--   public.orders
--   public.products
-- =========================================================
SET search_path TO public;
-- =========================================================
-- 1. 현재 접속 DB와 스키마 확인
-- 질문:
--   내가 올바른 데이터베이스에서 작업하고 있는가?
-- =========================================================
SELECT current_database() AS current_db,
    current_schema() AS current_schema;
-- =========================================================
-- 2. 현재 생성된 테이블 목록 확인
-- 질문:
--   public 스키마에 어떤 테이블이 생성되어 있는가?
-- =========================================================
SELECT table_schema,
    table_name
FROM information_schema.tables
WHERE table_schema = 'public'
    AND table_type = 'BASE TABLE'
ORDER BY table_name;
-- =========================================================
-- 3. 테이블별 컬럼 구조 확인
-- 질문:
--   각 테이블은 어떤 컬럼으로 구성되어 있는가?
-- =========================================================
SELECT table_name,
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns
WHERE table_schema = 'public'
    AND table_name IN ('customers', 'orders', 'products')
ORDER BY table_name,
    ordinal_position;
-- =========================================================
-- 4. 테이블별 데이터 건수 확인
-- 질문:
--   샘플 데이터가 정상적으로 입력되었는가?
-- =========================================================
SELECT 'customers' AS table_name,
    COUNT(*) AS row_count
FROM customers
UNION ALL
SELECT 'orders' AS table_name,
    COUNT(*) AS row_count
FROM orders
UNION ALL
SELECT 'products' AS table_name,
    COUNT(*) AS row_count
FROM products;
-- =========================================================
-- 5. 고객 데이터 기본 조회
-- 질문:
--   등록된 고객 데이터는 어떤 형태인가?
-- =========================================================
SELECT *
FROM customers
LIMIT 20;
-- =========================================================
-- 6. 주문 데이터 기본 조회
-- 질문:
--   주문 데이터는 어떤 형태인가?
-- =========================================================
SELECT *
FROM orders
LIMIT 20;
-- =========================================================
-- 7. 상품 데이터 기본 조회
-- 질문:
--   상품 데이터는 어떤 형태인가?
-- =========================================================
SELECT *
FROM products
LIMIT 20;
-- =========================================================
-- 8. 상품 수 확인
-- 질문:
--   현재 등록된 상품은 총 몇 개인가?
-- =========================================================
SELECT COUNT(*) AS product_count
FROM products;
-- =========================================================
-- 9. 고객 수 확인
-- 질문:
--   현재 등록된 고객은 총 몇 명인가?
-- =========================================================
SELECT COUNT(*) AS customer_count
FROM customers;
-- =========================================================
-- 10. 주문 수 확인
-- 질문:
--   현재 등록된 주문은 총 몇 건인가?
-- =========================================================
SELECT COUNT(*) AS order_count
FROM orders;


-- =========================================================
-- 기본적인 데이터 확인 완료

-- =========================================================
-- public 스키마에 생성된 테이블을 retail로 이동

-- 1. 먼저 현재 테이블 위치 확인
SELECT
    table_schema,
    table_name
FROM information_schema.tables
WHERE table_name IN ('customers', 'orders', 'products')
ORDER BY table_schema, table_name;

-- 2. retail 스키마 생성
CREATE SCHEMA IF NOT EXISTS retail;

-- 3. public 테이블을 retail 스키마로 이동    
ALTER TABLE IF EXISTS public.customers SET SCHEMA retail;

ALTER TABLE IF EXISTS public.orders SET SCHEMA retail;

ALTER TABLE IF EXISTS public.products SET SCHEMA retail;

-- 이동 결과 확인

SELECT
    table_schema,
    table_name
FROM information_schema.tables
WHERE table_name IN ('customers', 'orders', 'products')
ORDER BY table_schema, table_name;

-- 기본 스키마 설정
SET search_path TO retail;
-- 이유: 데이터베이스 안에서 실습용 테이블들을 하나의 전용 공간으로 분리해서 관리하기 위해서 사용한다.
-- retail은 사용자가 정해준 스키마 이름이고 public은 사용자가 따로 지정하지 않으면 저장되는 기본 저장 공간.
-- 각 데이터 베이스 생성 이전에 파일 같은 느낌으로 따로 스키마를 설정해 주는 것이 좋다.

-- =========================================================
-- [본격 학습]
-- 1. SELECT 기본 조회
-- 2. WHERE 조건 필터링
-- 3. ORDER BY 정렬
-- 4. COUNT 집계
-- 5. GROUP BY 그룹 집계
-- 6. 실무형 기초 분석 문제
-- =========================================================

-- Day 01. Basic SQL Analysis
-- 프로젝트명:
--   PostgreSQL Retail SQL Portfolio
------------------------------------

-- 목적:
--   retail 스키마에 있는 customers, orders, products 테이블을 활용하여
--   SQL 기본 문법을 학습하고, 실무형 데이터 분석의 기초를 정리한다.
-------------------------------------------

-- 현재 DB 구조:
--   retail.customers
--   retail.orders
--   retail.products
--------------------

-- 사전 점검 완료:
--   1. public 스키마에 있던 실습 테이블을 retail 스키마로 이동
--   2. customers / orders / products 테이블 존재 확인
--   3. 각 테이블의 컬럼 구조 확인
--   4. 각 테이블의 전체 행 개수 확인
-------------------------

-- pgAdmin 사용 원칙:
--   pgAdmin Query Tool은 임시 실행 공간으로 사용한다.
--   이전 쿼리가 남아 있으면 의도하지 않은 쿼리까지 같이 실행될 수 있으므로,
--   학습 초반에는 실행할 쿼리만 남기고 실행한다.
------------------------------

-- VS Code 사용 원칙:
--   정상 실행된 쿼리와 주석은 이 파일에 누적 저장한다.
--   이 파일은 포트폴리오 기록용 SQL 파일로 관리한다.
----------------------------------

-- 기준 스키마:
--   retail
-- =========================================================

-- =========================================================
-- 1. SELECT 기본 조회
-- 목적:
--   customers 테이블에서 고객 기본 정보를 조회한다.
--   전체 컬럼을 무작정 조회하지 않고,
--   분석에 필요한 컬럼을 직접 선택하는 연습을 한다.
--------------------------------

-- 사용 개념:
--   SET search_path
--   SELECT
--   FROM
--   ORDER BY
-- =========================================================

-- 현재 세션의 기본 스키마를 retail로 설정한다.
SET search_path TO retail;

-- customers 테이블의 고객 기본 정보를 조회한다.
SELECT
customer_id,
customer_name,
gender,
age,
city,
signup_date
FROM customers
ORDER BY customer_id;
--고객 데이터의 기본 구조와 내용을 확인

-- =========================================================
-- 2. WHERE 조건 필터링
-- 목적:
--   customers 테이블에서 30세 이상 고객만 조회한다.
--   WHERE 절을 사용하여 조건에 맞는 행만 필터링하는 연습을 한다.
--
-- 사용 개념:
--   WHERE
--   비교 연산자
--   ORDER BY DESC
-- =========================================================

SET search_path TO retail;

SELECT
    customer_id,
    customer_name,
    gender,
    age,
    city,
    signup_date
FROM customers
WHERE age >= 30
ORDER BY age DESC;

-- =========================================================
-- 3. ORDER BY 정렬
-- 목적:
--   customers 테이블의 고객 데이터를 도시 기준으로 정렬하고,
--   같은 도시 안에서는 나이가 많은 고객부터 조회한다.
--
-- 사용 개념:
--   ORDER BY
--   ASC
--   DESC
--   다중 정렬 기준
-- =========================================================

SET search_path TO retail;

SELECT
    customer_id,
    customer_name,
    gender,
    age,
    city,
    signup_date
FROM customers
ORDER BY city ASC, age DESC;

-- =========================================================
-- 4. COUNT 집계
-- 목적:
--   customers 테이블의 전체 고객 수를 집계한다.
--   COUNT(*)를 사용하여 전체 행 개수를 계산하는 연습을 한다.
--
-- 사용 개념:
--   COUNT
--   집계 함수
--   AS 별칭
-- =========================================================

SET search_path TO retail;

SELECT
    COUNT(*) AS total_customers
FROM customers;

-- =========================================================
-- 5. GROUP BY 그룹 집계
-- 목적:
--   customers 테이블에서 도시별 고객 수를 집계한다.
--   GROUP BY를 사용하여 같은 city 값을 가진 고객을 하나의 그룹으로 묶고,
--   COUNT(*)로 각 그룹의 고객 수를 계산한다.
--
-- 사용 개념:
--   GROUP BY
--   COUNT
--   AS 별칭
--   ORDER BY
-- =========================================================

SET search_path TO retail;

SELECT
    city,
    COUNT(*) AS customer_count
FROM customers
GROUP BY city
ORDER BY customer_count DESC, city ASC;

-- =========================================================
-- 6. WHERE + GROUP BY 조건 집계
-- 목적:
--   customers 테이블에서 30세 이상 고객만 필터링한 뒤,
--   도시별 고객 수를 집계한다.
--
-- 분석 질문:
--   30세 이상 고객은 도시별로 몇 명씩 있는가?
--
-- 사용 개념:
--   WHERE
--   GROUP BY
--   COUNT
--   ORDER BY
-- =========================================================

SET search_path TO retail;

SELECT
    city,
    COUNT(*) AS customer_count
FROM customers
WHERE age >= 30
GROUP BY city
ORDER BY customer_count DESC, city ASC;

-- =========================================================
-- Day 01 마무리 요약
-- =========================================================
-- 오늘 학습에서는 PostgreSQL의 기본 조회 문법을 사용하여
-- retail.customers 테이블을 중심으로 기초 데이터 분석을 수행하였다.
-----------------------------------------------

-- 주요 학습 내용:
--   1. SELECT를 사용하여 필요한 컬럼만 조회하였다.
--   2. WHERE를 사용하여 조건에 맞는 고객 데이터만 필터링하였다.
--   3. ORDER BY를 사용하여 조회 결과를 정렬하였다.
--   4. COUNT(*)를 사용하여 전체 고객 수를 집계하였다.
--   5. GROUP BY를 사용하여 도시별 고객 수를 집계하였다.
--   6. WHERE와 GROUP BY를 함께 사용하여
--      30세 이상 고객의 도시별 분포를 분석하였다.
---------------------------------

-- 분석 과정에서 확인한 내용:
--   - 현재 customers 테이블의 전체 고객 수는 4명이다.
--   - customers 테이블의 주요 컬럼은
--     customer_id, customer_name, gender, age, city, signup_date이다.
--   - 가입일 컬럼명은 join_date가 아니라 signup_date임을 확인하였다.
---------------------------------------------------

-- 실무 관점 정리:
--   단순히 전체 데이터를 조회하는 것에서 끝나지 않고,
--   조건 필터링, 정렬, 집계, 그룹화를 사용하여
--   데이터를 분석 가능한 형태로 요약하는 흐름을 연습하였다.
------------------------------------

-- SQLD 시험 대비 핵심:
--   - SELECT는 조회할 컬럼을 지정한다.
--   - WHERE는 GROUP BY보다 먼저 실행되며, 원본 행을 필터링한다.
--   - ORDER BY는 최종 결과를 정렬한다.
--   - COUNT(*)는 NULL 여부와 관계없이 전체 행 개수를 센다.
--   - GROUP BY 사용 시 SELECT절의 일반 컬럼은 GROUP BY절에 포함되어야 한다.
---------------------------------------------------------

-- Day 01 결론:
--   SQL 기본 문법을 활용하여 고객 데이터를 조회하고,
--   조건에 맞게 필터링하며,
--   집계 결과를 통해 간단한 고객 분포 분석까지 수행하였다.
-- =========================================================
