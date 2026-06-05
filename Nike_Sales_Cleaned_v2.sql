-- ============================================================
--  Nike Sales Cleaned v2
--  ปรับปรุงจาก v1 โดยแก้ไข 4 จุด:
--    1. Revenue = 0 → เก็บเป็น NULL
--    2. Order_Date placeholder → เก็บเป็น NULL
--    3. Region dirty values → standardize
--    4. Units_Sold = -1 → flag เป็น NULL (return/refund)
-- ============================================================

CREATE TABLE "Nike_Sales_Cleaned_v2" AS
SELECT
    nsu."Order_ID" AS "Order_ID",

    nsu."Gender_Category" AS "Gender_Category",

    nsu."Product_Line" AS "Product_Line",

    nsu."Product_Name" AS "Product_Name",

    COALESCE(nsu."Size", 'No Size') AS "Size",

    -- [FIX 4] Units_Sold = -1 ถือเป็น return/invalid → เก็บเป็น NULL
    CASE
        WHEN nsu."Units_Sold" IS NULL
          OR TRIM(nsu."Units_Sold") = ''   THEN NULL
        WHEN nsu."Units_Sold"::NUMERIC < 0  THEN NULL   -- ← เพิ่มใหม่
        ELSE nsu."Units_Sold"::NUMERIC(10,1)
    END AS "Units_Sold",

    CASE
        WHEN nsu."MRP" IS NULL
          OR TRIM(nsu."MRP") = ''          THEN NULL
        ELSE nsu."MRP"::NUMERIC(10,2)
    END AS "MRP",

    CASE
        WHEN nsu."Discount_Applied" IS NULL THEN NULL
        ELSE nsu."Discount_Applied"::NUMERIC(10,2)
    END AS "Discount_Applied",

    -- [FIX 1] Revenue = 0 (มาจาก COALESCE ของ NULL) → คืนค่าเป็น NULL
    CASE
        WHEN nsu."Revenue" IS NULL
          OR nsu."Revenue" = 0             THEN NULL    -- ← เปลี่ยนจาก 0 เป็น NULL
        ELSE nsu."Revenue"::NUMERIC(10,2)
    END AS "Revenue",

    -- [FIX 2] Order_Date ที่ parse ไม่ได้ → NULL แทน 1900-01-01
    CASE
        WHEN nsu."Order_Date" LIKE '__/__/____'
            THEN TO_DATE(nsu."Order_Date", 'DD/MM/YYYY')
        WHEN nsu."Order_Date" LIKE '__-__-____'
            THEN TO_DATE(nsu."Order_Date", 'DD-MM-YYYY')
        ELSE NULL                                        -- ← เปลี่ยนจาก DATE '1900-01-01' เป็น NULL
    END AS "Order_Date",

    CASE
        WHEN nsu."Sales_Channel" IS NULL
          OR TRIM(nsu."Sales_Channel") = '0' THEN NULL
        ELSE nsu."Sales_Channel"
    END AS "Sales_Channel",

    -- [FIX 3] Standardize Region: รวม alias ให้เป็นชื่อเดียวกัน
    CASE
        WHEN LOWER(TRIM(nsu."Region")) IN ('bengaluru', 'bangalore')
            THEN 'Bangalore'
        WHEN LOWER(TRIM(nsu."Region")) IN ('hyd', 'hyderabad', 'hyderbad')
            THEN 'Hyderabad'
        WHEN nsu."Region" IS NULL
          OR TRIM(nsu."Region") = '0'
            THEN NULL
        ELSE INITCAP(TRIM(nsu."Region"))               -- ← capitalize ให้สม่ำเสมอ
    END AS "Region",

    CASE
        WHEN nsu."Profit" IS NULL THEN NULL
        ELSE nsu."Profit"::NUMERIC(10,2)
    END AS "Profit"

FROM "Nike_Sales_Uncleaned" AS nsu
WHERE nsu."Order_ID" IS NOT NULL
;

-- ============================================================
--  ตรวจสอบผลลัพธ์หลัง clean (QA Queries)
-- ============================================================

-- 1. นับ NULL แต่ละคอลัมน์
SELECT
    COUNT(*) FILTER (WHERE "Revenue"      IS NULL) AS revenue_null,
    COUNT(*) FILTER (WHERE "Order_Date"   IS NULL) AS order_date_null,
    COUNT(*) FILTER (WHERE "Units_Sold"   IS NULL) AS units_sold_null,
    COUNT(*) FILTER (WHERE "Region"       IS NULL) AS region_null,
    COUNT(*) FILTER (WHERE "Sales_Channel"IS NULL) AS channel_null,
    COUNT(*)                                        AS total_rows
FROM "Nike_Sales_Cleaned_v2";

-- 2. ตรวจ Region หลัง standardize
SELECT "Region", COUNT(*) AS cnt
FROM "Nike_Sales_Cleaned_v2"
GROUP BY "Region"
ORDER BY cnt DESC;

-- 3. ตรวจ Units_Sold ว่าไม่มีค่าติดลบแล้ว
SELECT MIN("Units_Sold") AS min_units, MAX("Units_Sold") AS max_units
FROM "Nike_Sales_Cleaned_v2";
