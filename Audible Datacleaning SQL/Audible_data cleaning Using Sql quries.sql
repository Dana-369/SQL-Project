-- Data cleaning Using sql quries

-- Audible dataset form Kaggle  

------------------------------------------------------------------------------ 
SELECT * FROM sqlproject.audible;

-- 1. Remove 'Writtenby:' from Author column

SELECT REPLACE(author,'Writtenby:','') as author
FROM audible

UPDATE AUDIBLE
SET author = REPLACE(author,'Writtenby:','')

------------------------------------------------------------------------------ 

-- 2. Remove 'Narratedby:' from narrator column

SELECT REPLACE(narrator,'Narratedby:','') as narrator
FROM AUDIBLE

UPDATE AUDIBLE
SET narrator = REPLACE(narrator,'Narratedby:','')


------------------------------------------------------------------------------

-- 3. Convert hours to minutes in time column and alter text datatype to nemerical

SELECT
  CASE
    WHEN time LIKE '%hrs and mins%' THEN
      (CAST(SPLIT_PART(time, ' hrs', 1) AS INTEGER) * 60) +
      (CAST(SUBSTRING(time FROM '(\d+) mins') AS INTEGER))
    WHEN time LIKE '%hrs%' THEN
      (CAST(SPLIT_PART(time, ' hrs', 1) AS INTEGER) * 60)
    WHEN time LIKE '%mins%' THEN
      (CAST(SUBSTRING(time FROM '(\d+) mins') AS INTEGER))
    WHEN time LIKE '%Less than 1 minute%' THEN
      0
  END AS total_minutes
FROM audible;


UPDATE 	audible
SET time =  CASE
				WHEN time LIKE '%hrs and mins%' THEN
				 (CAST(SPLIT_PART(time, ' hrs', 1) AS INTEGER) * 60) +
				 (CAST(SUBSTRING(time FROM '(\d+) mins') AS INTEGER))
				WHEN time LIKE '%hrs%' THEN
				 (CAST(SPLIT_PART(time, ' hrs', 1) AS INTEGER) * 60)
				WHEN time LIKE '%mins%' THEN
				 (CAST(SUBSTRING(time FROM '(\d+) mins') AS INTEGER))
				WHEN time LIKE '%Less than 1 minute%' THEN
				 0
			END ;
            
------------------------------------------------------------------------------ 
-- 4. Converts the first letter of each word to 
--    uppercase and all other letters are converted to lowercase 


SELECT initcap(language)
FROM audible

UPDATE audible
SET language= initcap(language)
---------------------------------------------------------------------------

-- 5. Extract Star rating form Start columns

SELECT
  CASE 
    WHEN start LIKE '%out%' THEN CAST(SUBSTRING(start FROM 1 FOR 1) AS INTEGER)
    WHEN start LIKE '%Not%' THEN 0
  END AS STAR
FROM AUDIBLE;

ALTER TABLE audible  /*add column*/
ADD COLUMN star INTEGER;

UPDATE your_table
SET strar = CASE
              WHEN start LIKE '%out%' THEN CAST(SUBSTRING(start FROM 1 FOR 1) AS INTEGER)
              WHEN start LIKE '%Not%' THEN 0
            END;
            
ALTER TABLE audible  /*Drop column*/
DROP COLUMN start;

---------------------------------------------------------------------------

-- Finally cleaned data
-- Get starrating not equal to 0 data

SELECT *
FROM audible
WHERE star <> 0
