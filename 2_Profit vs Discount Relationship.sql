SELECT
    ROUND("Discount_Applied"::numeric, 2)  AS discount_bucket,
    COUNT(*)                               AS order_count,
    ROUND(AVG("Profit"), 2)                AS avg_profit,
    ROUND(SUM("Profit"), 2)                AS total_profit,
    "Sales_Channel"
FROM "Nike_Sales_Cleaned"
WHERE "Revenue" > 0
  AND "Discount_Applied" IS NOT NULL
  AND "Discount_Applied" BETWEEN 0 AND 1
GROUP BY discount_bucket, "Sales_Channel"
ORDER BY discount_bucket, "Sales_Channel"
;