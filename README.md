markdown# Nike Sales Analytics: Data Cleaning & Performance Deep-Dive

I built this project to clean, structure, and analyze a raw Nike sales dataset. The entire pipeline—from fixing broken data to extracting business insights—is handled using **PostgreSQL** on **Supabase**.

---

## Data Source
The raw transaction data comes from **Kaggle**. It tracks global Nike product sales, but required a major cleanup before it could be used for any meaningful analysis.
Link : https://www.kaggle.com/datasets/nayakganesh007/nike-sales-uncleaned-dataset
---

## Step 1: Data Cleaning & Transformation
The goal here was to move everything from `"Nike_Sales_Uncleaned"` into a clean, structured table called `"Nike_Sales_Cleaned"`. The raw data had quite a few data quality issues, so I used this SQL script to standardize the columns:

* **Handling Blank and Null Values:** I used `COALESCE` to quickly patch up missing data, like setting empty sizes to `'No Size'` and unrecorded revenue/regions to fallback defaults. I also added a `WHERE "Order_ID" IS NOT NULL` filter at the bottom because any transaction without an order ID is useless for analysis.
* **Casting Text to Proper Numbers:** Numeric fields like `"Units_Sold"`, `"MRP"`, and `"Profit"` were imported as text and contained empty strings. I used `CASE WHEN` combined with `trim(...) = ''` to catch those hidden spaces, converted them to `0`, and then cast them into proper `numeric` formats so we can actually run math functions on them later.
* **Untangling Messy Date Formats:** The `"Order_Date"` column was a mix of different formats (`DD/MM/YYYY` and `DD-MM-YYYY`). To fix this, I used pattern matching (`LIKE '__/__/____'`) to identify the format first, converted it using `TO_DATE`, and then used `TO_CHAR` to lock every single row into a clean, uniform ISO standard (`YYYY-MM-DD`). Anything that couldn't be parsed got flagged with a default fallback date of `'1900-01-01'`.
 
## Step 2: 
