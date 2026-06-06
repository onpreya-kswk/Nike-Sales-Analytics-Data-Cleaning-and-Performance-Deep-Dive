SELECT
    "Gender_Category",
    "Product_Line",
    COUNT(*)                      AS order_count,
    ROUND(SUM("Revenue"), 2)      AS total_revenue,
    ROUND(AVG("Profit"), 2)       AS avg_profit,
    ROUND(SUM("Units_Sold"), 0)   AS total_units
FROM "Nike_Sales_Cleaned"
WHERE "Revenue" > 0
GROUP BY "Gender_Category", "Product_Line"
ORDER BY "Gender_Category", total_revenue DESC
;
