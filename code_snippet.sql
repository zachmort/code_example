DECLARE Start_date DATE;
DECLARE End_date DATE;
SET Start_date = ‘2021-01-01’
SET End_date = (DATE_TRUNC(CURRENT_DATE, QUARTER)-1);

CREATE OR REPLACE TABLE `Quarterly_Demo_Percentages_Table` as (
WITH
  _visits_CTE AS (
  SELECT
    EXTRACT(YEAR FROM partitiondate) AS yearnum,
    EXTRACT(MONTH FROM partitiondate) AS monthnum,
    VT.device_id,
    DD.vertical_category,
   CASE
      WHEN (median_income > 15000 AND median_income < 49000) THEN '_15K_to_49K'
      WHEN (median_income >= 50000 AND median_income < 75000) THEN '_50K_to_75K'
      WHEN (median_income >= 75000 AND median_income < 100000) THEN '_75K_to_100K'
      WHEN (median_income >= 100000) THEN '_greater_than_100K'
    ELSE "Not_Registered"
  END AS income_group
  FROM `Visits_table` VT
  LEFT JOIN `Demographic_Data` DD
    ON VT.device_uuid = DD.device_uuid
  INNER JOIN `Chain_Information` CI
    ON CI.inmnarket_place_name = VT.inmarket_place_name
  WHERE
    partitiondate BETWEEN Start_date AND End_date AND chain_name IS NOT NULL AND persistence_type in (1,2,3)
  GROUP BY yearnum, monthnum, VT.device_id, vertical_category, income_group),
percentages_of_total_visitors_CTE AS (
  SELECT
    yearnum,
    income_group,
    vertical_category,
    COUNT(DISTINCT device_id)/SUM(COUNT(DISTINCT device_id)) OVER(PARTITION BY yearnum, income_group) AS perc_of_totals
  FROM
    _visits_CTE
  GROUP BY yearnum, income_group, vertical_category)
SELECT 
  yearnum, 
  income_group, 
  vertical_category
FROM percentages_of_total_visitors_CTE
PIVOT(AVG(ROUND(perc_of_totals*100,2)) FOR vertical_category IN ( 'Big_Box_Category', 'Department_Category', 'Grocery_Category', 'Clothing_Category', 'Movie_category', 'Office_Category'))
ORDER BY yearnum ASC ,income_group DESC
)
