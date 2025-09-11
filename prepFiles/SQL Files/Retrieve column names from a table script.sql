-- retrieve table names from the current schema
SHOW TABLES;

-- retrieve column names from the table
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'comfycare' -- This is the db name
  AND TABLE_NAME = 'patient_notes';