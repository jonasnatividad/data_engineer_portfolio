WITH row_numbered AS
(
SELECT *, ROW_NUMBER() OVER (PARTITION BY customer_id, transaction_date, amount) AS row_num
FROM `project.dataset.table` --replace with your project, dataset, and table
)

SELECT *
FROM row_numbered
WHERE rOW_num = 1
ORDER BY transaction_id ASC