--=========================================================
-- 연결 노트:03_notes/day02_order_product_analysis.md
-- ========================================================
SET search_path TO retail;
SELECT COUNT(*) AS total_orders,
    SUM(quantity) AS total_quantity,
    AVG(quantity) AS avg_quantity,
    MIN(quantity) AS min_quantity,
    MAX(quantity) AS max_quantity
FROM orders;