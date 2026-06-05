CREATE TABLE "Nike_Sales_Cleaned" AS
SELECT
    nsu."Order_ID" AS "Order_ID",

    nsu."Gender_Category" AS "Gender_Category",

    nsu."Product_Line" AS "Product_Line",

    nsu."Product_Name" AS "Product_Name",

    COALESCE(nsu."Size", 'No Size') AS "Size",

    
    CASE
        WHEN nsu."Units_Sold" IS NULL
          OR TRIM(nsu."Units_Sold") = ''   THEN NULL
        WHEN nsu."Units_Sold"::NUMERIC < 0  THEN NULL   
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

    
    CASE
        WHEN nsu."Revenue" IS NULL
          OR nsu."Revenue" = 0             THEN NULL    
        ELSE nsu."Revenue"::NUMERIC(10,2)
    END AS "Revenue",

    
    CASE
        WHEN nsu."Order_Date" LIKE '__/__/____'
            THEN TO_DATE(nsu."Order_Date", 'DD/MM/YYYY')
        WHEN nsu."Order_Date" LIKE '__-__-____'
            THEN TO_DATE(nsu."Order_Date", 'DD-MM-YYYY')
        ELSE NULL                                        
    END AS "Order_Date",

    CASE
        WHEN nsu."Sales_Channel" IS NULL
          OR TRIM(nsu."Sales_Channel") = '0' THEN NULL
        ELSE nsu."Sales_Channel"
    END AS "Sales_Channel",

    
    CASE
        WHEN LOWER(TRIM(nsu."Region")) IN ('bengaluru', 'bangalore')
            THEN 'Bangalore'
        WHEN LOWER(TRIM(nsu."Region")) IN ('hyd', 'hyderabad', 'hyderbad')
            THEN 'Hyderabad'
        WHEN nsu."Region" IS NULL
          OR TRIM(nsu."Region") = '0'
            THEN NULL
        ELSE INITCAP(TRIM(nsu."Region"))               
    END AS "Region",

    CASE
        WHEN nsu."Profit" IS NULL THEN NULL
        ELSE nsu."Profit"::NUMERIC(10,2)
    END AS "Profit"

FROM "Nike_Sales_Uncleaned" AS nsu
WHERE nsu."Order_ID" IS NOT NULL
;