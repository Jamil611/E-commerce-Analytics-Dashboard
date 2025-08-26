-- Data Cleaning by Jamil (jamil.ad611@gmail.com)

-- MASTER TABLE

SELECT * FROM online_retail_ii_full_merged;

-- DUPLICATE CHECK

SELECT COUNT(*) AS duplicate
FROM online_retail_ii_full_merged
GROUP BY invoice, stockcode, description, quantity, invoicedate, price, customerid, country
HAVING COUNT(*) > 1;

--DUPLICATE DELETE

DELETE FROM online_retail_ii_full_merged a
USING online_retail_ii_full_merged b
WHERE a.ctid < b.ctid
	AND a.invoice = b.invoice
	AND a.stockcode = b.stockcode
	AND a.description = b.description
	AND a.quantity = b.quantity
	AND a.invoicedate = b.invoicedate
	AND a.price = b.price
	AND a.customerid = b.customerid
	AND a.country = b.country;


WITH ranked AS (
	SELECT ctid, ROW_NUMBER() OVER (
		PARTITION BY invoice, stockcode, description, quantity, invoicedate, price, customerid, country
		ORDER BY invoice
		) AS rn
		FROM online_retail_ii_full_merged
		)
DELETE FROM online_retail_ii_full_merged
WHERE ctid IN (SELECT ctid FROM ranked WHERE rn>1);
	)
)
 )

 -- MISSING CUSTOMER ID

 SELECT *
 FROM online_retail_ii_full_merged
 WHERE customerid IS NULL;

DELETE FROM online_retail_ii_full_merged
WHERE customerid IS NULL;

-- Handle Canceled orders

SELECT *
FROM online_retail_ii_full_merged
WHERE invoice LIKE 'C%';

DELETE FROM online_retail_ii_full_merged
WHERE invoice LIKE 'C%';

-- HANDLE ZERO OR NEGATIVE QUANTITY

SELECT *
FROM online_retail_ii_full_merged
WHERE quantity <= 0;

-- TRIM AND STANDATDIZE TEXT FIELDS

UPDATE online_retail_ii_full_merged
SET description = INITCAP(TRIM (description));

UPDATE online_retail_ii_full_merged
SET country = INITCAP(TRIM (country));

UPDATE online_retail_ii_full_merged
SET stockcode = UPPER(TRIM (stockcode));

-- ADD SALES COLUMN

ALTER TABLE  online_retail_ii_full_merged
ADD COLUMN sales NUMERIC(10,2);

UPDATE online_retail_ii_full_merged
SET sales = quantity * price;

-- ADD REQUIRED COLUMNS FOR COHORT ANALYSIS

ALTER TABLE online_retail_ii_full_merged
ADD COLUMN First_Purchase_Date DATE,
ADD COLUMN Cohort_Month DATE,
ADD COLUMN Cohort_Index INT;

UPDATE online_retail_ii_full_merged t
SET First_Purchase_Date = sub.first_date
FROM (
	SELECT customerid, MIN(invoicedate) AS first_date
	FROM online_retail_ii_full_merged
	GROUP BY customerid
	) sub 
WHERE t.customerid = sub.customerid;


UPDATE online_retail_ii_full_merged
SET Cohort_Month = DATE_TRUNC('month', First_Purchase_Date)::DATE;

UPDATE online_retail_ii_full_merged
SET Cohort_Index = EXTRACT(YEAR FROM invoicedate) * 12 + EXTRACT(MONTH FROM invoicedate) 
	- (EXTRACT(YEAR FROM Cohort_Month)* 12 + EXTRACT(MONTH FROM Cohort_Month))+1;
