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
 
## Step 2: Profit vs Discount Relationship
By plotting a Scatter Plot and splitting them by Sales Channel, the visualization reveals a clear story about how promotions affect Nike’s margins:

* **Online bleeds profit way faster:** If you look closely at the blue trend line, it starts out higher but dives down pretty sharply as discounts scale up. This proves that our digital store is hit much harder by promotions. Shaving off prices online might bring in quick sales, but it ends up eating away at our average profit margins much faster than in physical stores.
* **Retail holds up better under pressure:** The orange trend line drops at a much gentler slope. Even when we hand out steep discounts at physical stores, the average profit stays relatively steady and finishes way ahead of the online channel. This suggests our brick-and-mortar setups might be passing the buck through multi-item sales or handling overhead costs better during promotions.
* **The data is all over the place:** Beyond the main trends, the points are scattered all over the map. Even around the 50% to 70% discount mark, some orders still rack up over 3,500 in profit, while others plummet straight into the negatives. This tells us the discount isn't the only driver—it depends heavily on *what* product lines we are clearing out, since high-margin items can easily absorb the blow.

* 
