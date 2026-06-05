Create table "Nike_Sales_Cleaned" as
Select 
    nsu."Order_ID" as "Order_ID", 
    nsu."Gender_Category" as "Gender_Category", 
    nsu."Product_Line" as "Product_Line",
    nsu."Product_Name" as "Product_Name",
    coalesce(nsu."Size",'No Size') as "Size",
    Case 
        when nsu."Units_Sold" is null or trim(nsu."Units_Sold") = '' Then 0.0
        else nsu."Units_Sold"::numeric(10,1)
    END AS "Units_Sold",
    Case 
        when nsu."MRP" is null or trim(nsu."MRP") = '' Then 0.00
        else nsu."MRP"::numeric(10,2)
    END AS "MRP",
    Case  
        when nsu."Discount_Applied" is null Then 0.00 
        else nsu."Discount_Applied":: numeric(10,2)
    END AS "Discount_Applied",
    coalesce(nsu."Revenue",0) as "Revenue",
    TO_CHAR(
    Case
        when nsu."Order_Date" like '__/__/____' Then TO_DATE(nsu."Order_Date", 'DD/MM/YYYY')
        when nsu."Order_Date" like '__-__-____' Then TO_DATE(nsu."Order_Date", 'DD-MM-YYYY')
        when nsu."Order_Date" is null Then DATE '1900-01-01'
        Else DATE '1900-01-01'
        END, 'YYYY-MM-DD') AS "Order_Date",
    coalesce(nsu."Sales_Channel",'0') as "Sales_Channel",
    coalesce(nsu."Region",'0') as "Region",
    case 
        when nsu."Profit" is null Then 0.00
        else nsu."Profit"::numeric(10,2)
    END AS "Profit"
from "Nike_Sales_Uncleaned" as nsu 
where "Order_ID" is not null
;