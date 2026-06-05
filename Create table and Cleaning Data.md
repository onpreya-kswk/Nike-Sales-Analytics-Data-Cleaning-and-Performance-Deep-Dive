markdown# 🚀 Nike Sales Analytics: Data Cleaning & Performance Deep-Dive

I built this project to clean, structure, and analyze a raw Nike sales dataset. The entire pipeline—from fixing broken data to extracting business insights—is handled using **PostgreSQL** on **Supabase**.

---

## 📁 Data Source
The raw transaction data comes from **Kaggle**. It tracks global Nike product sales, but required a major cleanup before it could be used for any meaningful analysis.
Link : https://www.kaggle.com/datasets/nayakganesh007/nike-sales-uncleaned-dataset

---

##  Step 1: Data Cleaning & Transformation
The first step was to move data from `"Nike_Sales_Uncleaned"` into a new, optimized table called `"Nike_Sales_Cleaned"`. Here is a breakdown of how I handled the dirty data:

* **Fixing Missing Values:** 
  * Used `COALESCE` to replace blank fields (e.g., set empty sizes to `'No Size'` and missing numbers to `0`).
  * Filtered out useless rows where `"Order_ID"` was missing entirely to keep the data clean.
* **Fixing Data Types:** 
  * Converted text columns into proper numeric formats (like `numeric(10,1)` for units sold and `numeric(10,2)` for profit) so they are ready for math calculations.
  * Used `CASE WHEN` combined with `trim(...) = ''` to catch empty strings and hidden spaces that usually break queries.
* **Standardizing Dates:**
  * The original dataset had messy date formats mixed together (`DD/MM/YYYY` and `DD-MM-YYYY`). 
  * I used pattern matching (`LIKE`) to detect the format, then used `TO_DATE` and `TO_CHAR` to force everything into the standard `YYYY-MM-DD` format. 
  * Set a fallback date of `'1900-01-01'` for any unfixable or missing dates.
 
## Step 2: 
