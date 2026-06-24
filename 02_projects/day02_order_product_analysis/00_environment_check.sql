-- =========================================================
-- Day 02 / Step 00. 분석 환경 점검
-- 목적:
-- retail 스키마와 Day 02 분석 대상 테이블의 존재 여부를 확인한다.
--
-- 연결 노트:
-- 03_notes/day02_order_product_analysis.md
-- =========================================================

SET search_path TO retail;

SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'retail'
ORDER BY table_name;