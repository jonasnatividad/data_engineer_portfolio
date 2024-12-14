SELECT *, ROW_NUMBER() OVER (PARTITION BY customer_id, transaction_date, amount) AS row_num
FROM `project.dataset.table` --replace with your project, dataset, and table
QUALIFY row_num = 1
ORDER BY transaction_id ASC