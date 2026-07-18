-- 연결 노트:
-- 03_notes/day02_order_product_analysis.md
-- =========================================================

SET search_path TO retail;

SELECT
o.order_id,
o.order_date,
o.customer_id,
o.product_id,
p.product_name,
p.category,
o.quantity,
p.price,
o.quantity * p.price AS order_amount
FROM orders o
INNER JOIN products p
ON o.product_id = p.product_id
ORDER BY o.order_id;