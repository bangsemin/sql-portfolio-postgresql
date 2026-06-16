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