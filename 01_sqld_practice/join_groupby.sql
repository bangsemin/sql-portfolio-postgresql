-- 고객별 총 구매금액을 집계하여 핵심 고객을 파악한다.
SELECT c.customer_id,
    c.customer_name,
    SUM(p.price * o.quantity) AS total_sales
FROM customers AS c
    JOIN orders AS o ON c.customer_id = o.customer_id
    JOIN products AS p ON o.product_id = p.product_id
GROUP BY c.customer_id,
    c.customer_name
ORDER BY total_sales DESC;