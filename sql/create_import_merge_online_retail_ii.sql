-- TABLE OF 2009 TO 2010 DATA

CREATE TABLE online_retail_ii_2009_10 (
	Invoice	VARCHAR(20),
	StockCode	VARCHAR(20),
	Description	VARCHAR(300),
	Quantity	INT,
	InvoiceDate	TEXT,
	Price	DECIMAL(10,2),
	CustomerID	VARCHAR(20),
	Country	VARCHAR(100)
);

SELECT * FROM online_retail_ii_2009_10;

-- TABLE OF 2010 TO 2011 DATA

CREATE TABLE online_retail_ii_2010_11 (
	Invoice	VARCHAR(20),
	StockCode	VARCHAR(20),
	Description	VARCHAR(300),
	Quantity	INT,
	InvoiceDate	TEXT,
	Price	DECIMAL(10,2),
	CustomerID	VARCHAR(20),
	Country	VARCHAR(100)
);

SELECT * FROM online_retail_ii_2010_11;

-- DATATYPE FIX OF DATE COLUMN

ALTER TABLE online_retail_ii_2009_10
ALTER COLUMN invoicedate TYPE DATE
USING to_date(invoicedate, 'DD-MM-YY');

ALTER TABLE online_retail_ii_2010_11
ALTER COLUMN invoicedate TYPE DATE
USING to_date(invoicedate, 'DD-MM-YY');

-- MERGE TWO TABLE

CREATE TABLE online_retail_ii_full_merged AS
SELECT * FROM online_retail_ii_2009_10
UNION ALL
SELECT * FROM online_retail_ii_2010_11;



-- MASTER TABLE

SELECT * FROM online_retail_ii_full_merged;