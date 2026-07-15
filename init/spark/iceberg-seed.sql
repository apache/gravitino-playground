-- Seed data for the Iceberg REST catalog (catalog_rest in Spark, catalog_iceberg in Trino).
USE catalog_rest;

-- Two inserts on purpose: the table gets two snapshots, so snapshot history and
-- time travel queries are demonstrable out of the box.
-- customer_id values overlap with the Hive sales.customers seed data, so
-- cross-catalog joins between Hive and Iceberg work without setup.

CREATE DATABASE IF NOT EXISTS analytics;

CREATE TABLE IF NOT EXISTS analytics.orders (
  order_id BIGINT,
  customer_id INT,
  order_date DATE,
  region STRING,
  amount DECIMAL(10,2),
  status STRING
) USING iceberg
PARTITIONED BY (region);

INSERT INTO analytics.orders VALUES
  (1001, 11, DATE '2026-05-02', 'west',  245.50, 'shipped'),
  (1002, 12, DATE '2026-05-03', 'east',   89.99, 'shipped'),
  (1003, 11, DATE '2026-05-10', 'west',  512.00, 'returned'),
  (1004, 14, DATE '2026-05-14', 'south', 133.25, 'shipped'),
  (1005, 15, DATE '2026-05-21', 'east',  760.10, 'pending'),
  (1006, 12, DATE '2026-06-01', 'east',   45.00, 'shipped'),
  (1007, 16, DATE '2026-06-04', 'west',  310.75, 'shipped'),
  (1008, 11, DATE '2026-06-09', 'west',   22.10, 'cancelled'),
  (1009, 17, DATE '2026-06-15', 'south', 199.99, 'shipped'),
  (1010, 15, DATE '2026-06-22', 'east',  405.60, 'shipped');

INSERT INTO analytics.orders VALUES
  (1011, 18, DATE '2026-07-01', 'west',  650.00, 'pending'),
  (1012, 14, DATE '2026-07-03', 'south',  77.45, 'shipped');
