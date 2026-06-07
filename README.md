markdown# Nike Sales Analytics: Data Cleaning & Performance Deep-Dive

I built this project to clean, structure, and analyze a raw Nike sales dataset. The entire pipeline—from fixing broken data to extracting business insights—is handled using **PostgreSQL** on **Supabase**.

---

## Data Source
The raw transaction data comes from **Kaggle**. It tracks global Nike product sales, but required a major cleanup before it could be used for any meaningful analysis.
Link : https://www.kaggle.com/datasets/nayakganesh007/nike-sales-uncleaned-dataset
---


## Step 1: Data Cleaning & Transformation

**Full SQL:** [Nike_Sales_Cleaned_v2.sql](./Nike_Sales_Cleaned_v2.sql)

The goal here was to move everything from `"Nike_Sales_Uncleaned"` into a clean, structured table called `"Nike_Sales_Cleaned"`. The raw data had quite a few data quality issues, so I used this SQL script to standardize the columns:

* **Handling Blank and Null Values:** I used `COALESCE` to quickly patch up missing data, like setting empty sizes to `'No Size'` and unrecorded revenue/regions to fallback defaults. I also added a `WHERE "Order_ID" IS NOT NULL` filter at the bottom because any transaction without an order ID is useless for analysis.
* **Casting Text to Proper Numbers:** Numeric fields like `"Units_Sold"`, `"MRP"`, and `"Profit"` were imported as text and contained empty strings. I used `CASE WHEN` combined with `trim(...) = ''` to catch those hidden spaces, converted them to `0`, and then cast them into proper `numeric` formats so we can actually run math functions on them later.
* **Untangling Messy Date Formats:** The `"Order_Date"` column was a mix of different formats (`DD/MM/YYYY` and `DD-MM-YYYY`). To fix this, I used pattern matching (`LIKE '__/__/____'`) to identify the format first, converted it using `TO_DATE`, and then used `TO_CHAR` to lock every single row into a clean, uniform ISO standard (`YYYY-MM-DD`). Anything that couldn't be parsed got flagged with a default fallback date of `'1900-01-01'`.
 
## Step 2: Profit vs Discount Relationship

**SQL:** [2_Profit vs Discount Relationship.sql](./2_Profit%20vs%20Discount%20Relationship.sql)

![Profit vs Discount](./2_Profit%20vs%20Discount%20Relationship.png)

What this chart tells us: Bigger discounts mean less profit, especially in Online.

The blue trend line (Online) drops much steeper than the orange one (Retail). This means every time we increase a discount on the Online channel, profit takes a bigger hit compared to Retail.

The Retail trend line stays almost flat, which suggests discounts don't hurt Retail profit that much. This could be because Retail already has higher margins built in, or the discount levels are more controlled.

Business takeaway: Be careful with heavy discounts on Online — they eat directly into profit. Retail can handle discounts better without losing as much on the bottom line.

## Step 3-1: Product performance by gender

**SQL:** [3-1_Product Performance by Gender.sql](./3-1_Product%20Performance%20by%20Gender.sql)

![Product Performance by Gender](./3-1_Product%20Performance%20by%20Gender.png)

What this chart tells us: Training for Men is the top money-maker, and each product has a different lead gender.

Training — Men stands out the most at 91,137, far ahead of every other group. This is clearly the strongest revenue driver in the business right now.

Basketball pulls in strong numbers from both Men (79K) and Women (75K), making it one of the few products that works well across genders.

Running is interesting — Kids lead here at 69,974 while Men sit very low at 18,379. Soccer follows a similar pattern where Women lead (69,160) and Men are near the bottom, which goes against the trend seen in other products.

Business takeaway: Double down on Training and Basketball for Men. Running for Kids is a strong, underrated segment worth paying more attention to.

## Step 3-2: Product performance by region

**SQL:** [3-2_Product Performance by Region.sql](./3-2_Product%20Performance%20by%20Region.sql)

![Heatmap](./3-2-1_Product%20Performance%20by%20Region.png)
![Product by Region Bar](3-2-2_Product%20Performance%20by%20Region.png)

What this chart tells us: Every region has its own strong product, and no single region dominates everything.

Hyderabad owns Basketball at 57,272 — no other region comes close. But the same region scores almost nothing in Soccer (3,761), so it's very one-sided.

Kolkata is the most balanced region, doing well in both Lifestyle (53,574) and Training (42,532) without a major weak spot.

Pune is the only region where Soccer performs strongly (43,526). Every other region treats Soccer as a low-priority product, so Pune has a unique customer base worth exploring separately.

Mumbai sits at the bottom across nearly every product. This is worth investigating — whether it's a supply issue, low brand awareness, or just weaker demand in that market.

Business takeaway: Stop using a one-size-fits-all approach. Push Basketball hard in Hyderabad, lead with Lifestyle in Kolkata, and treat Pune as the go-to market for Soccer campaigns.




