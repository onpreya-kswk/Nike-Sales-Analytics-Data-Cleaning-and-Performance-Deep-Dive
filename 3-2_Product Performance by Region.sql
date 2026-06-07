SELECT
    CASE
        WHEN LOWER("Region") IN ('bengaluru','bangalore') THEN 'Bangalore'
        WHEN LOWER("Region") IN ('hyd','hyderabad','hyderbad') THEN 'Hyderabad'
        ELSE "Region"
    END AS region_clean,
    "Product_Line",
    ROUND(SUM("Revenue"), 2) AS total_revenue,
    ROUND(AVG("Profit"), 2)  AS avg_profit
FROM "Nike_Sales_Cleaned"
WHERE "Revenue" > 0
GROUP BY region_clean, "Product_Line"
ORDER BY region_clean, total_revenue DESC
;