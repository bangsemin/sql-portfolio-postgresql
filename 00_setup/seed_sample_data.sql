INSERT INTO customers (customer_name, gender, age, city, signup_date)
VALUES ('Kim', 'M', 28, 'Seoul', '2024-01-10'),
    ('Lee', 'F', 34, 'Busan', '2024-02-15'),
    ('Park', 'M', 22, 'Incheon', '2024-03-03'),
    ('Choi', 'F', 41, 'Seoul', '2024-03-20');
INSERT INTO products (product_name, category, price)
VALUES ('Laptop', 'Electronics', 1200000),
    ('Keyboard', 'Electronics', 80000),
    ('Desk Chair', 'Furniture', 150000),
    ('Monitor', 'Electronics', 300000);
INSERT INTO orders (customer_id, product_id, order_date, quantity)
VALUES (1, 1, '2024-04-01', 1),
    (1, 2, '2024-04-02', 2),
    (2, 3, '2024-04-05', 1),
    (3, 4, '2024-04-10', 1),
    (4, 1, '2024-04-15', 1);