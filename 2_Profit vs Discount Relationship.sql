SELECT
    ROUND("Discount_Applied"::numeric, 2)  AS discount_bucket,
    COUNT(*)                               AS order_count,
    ROUND(AVG("Profit"), 2)                AS avg_profit,
    ROUND(SUM("Profit"), 2)                AS total_profit
FROM "Nike_Sales_Cleaned"
WHERE "Revenue" > 0
  AND "Discount_Applied" IS NOT NULL
GROUP BY discount_bucket
ORDER BY discount_bucket;