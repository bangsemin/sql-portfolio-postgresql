-- 연결 노트:
-- 03_notes/day02_order_product_analysis.md
-- =========================================================

SET search_path TO retail;

SELECT
SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS null_order_id,
SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS null_customer_id,
SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END) AS null_product_id,
SUM(CASE WHEN order_date IS NULL THEN 1 ELSE 0 END) AS null_order_date,
SUM(CASE WHEN quantity IS NULL THEN 1 ELSE 0 END) AS null_quantity,
SUM(CASE WHEN quantity <= 0 THEN 1 ELSE 0 END) AS invalid_quantity
FROM orders;

---

-- 추가 점검. 중복 주문 ID 확인
-- 목적:
-- order_id가 중복으로 저장된 주문이 있는지 확인한다.

---

SELECT
order_id,
COUNT(*) AS duplicate_count
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;
