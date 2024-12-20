WITH date_info AS
(
SELECT
CURRENT_TIMESTAMP() AS utc_time,
EXTRACT(YEAR FROM CURRENT_DATE("America/New_York")) AS current_year
),

march_dates AS
(
SELECT
DATE_ADD(
DATE_TRUNC(DATE(current_year, 3, 1), MONTH),
INTERVAL
CASE
WHEN EXTRACT(DAYOFWEEK FROM DATE_TRUNC(DATE(current_year, 3, 1), MONTH)) = 1 THEN 7
ELSE 14 - EXTRACT(DAYOFWEEK FROM DATE_TRUNC(DATE(current_year, 3, 1), MONTH)) + 1
END
DAY
) AS second_sunday_march
FROM date_info
),

november_dates AS
(
SELECT
DATE_ADD(
DATE_TRUNC(DATE(current_year, 11, 1), MONTH),
INTERVAL
CASE
WHEN EXTRACT(DAYOFWEEK FROM DATE_TRUNC(DATE(current_year, 11, 1), MONTH)) = 1 THEN 0
ELSE 7 - EXTRACT(DAYOFWEEK FROM DATE_TRUNC(DATE(current_year, 11, 1), MONTH)) + 1
END
DAY
) AS first_sunday_november
FROM date_info
),

dst_info AS
(
SELECT
CASE
WHEN d.utc_time BETWEEN TIMESTAMP(
CONCAT(CAST(m.second_sunday_march AS STRING), ' 02:00:00'),
'America/New_York'
)
AND TIMESTAMP(
CONCAT(CAST(n.first_sunday_november AS STRING), ' 01:59:59'),
'America/New_York'
) THEN 'EDT'
ELSE 'EST'
END AS time_zone
FROM date_info d
CROSS JOIN march_dates m
CROSS JOIN november_dates n
)

SELECT
CASE
WHEN time_zone = "EDT" THEN FLOOR(((TIMESTAMP_DIFF(CURRENT_TIMESTAMP(),'1970-01-01 00:00:00',SECOND)) - 60*60*9)/(60*60*24))
WHEN time_zone = "EST" THEN FLOOR(((TIMESTAMP_DIFF(CURRENT_TIMESTAMP(),'1970-01-01 00:00:00',SECOND)) - 60*60*10)/(60*60*24))
ELSE null
END
FROM dst_info