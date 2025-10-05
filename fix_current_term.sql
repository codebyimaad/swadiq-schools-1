-- Set all terms as not current first
UPDATE terms SET is_current = false;

-- Set only the term that contains today's date as current
UPDATE terms SET is_current = true 
WHERE NOW() BETWEEN start_date AND end_date;

-- Show the result
SELECT name, start_date, end_date, is_current 
FROM terms 
ORDER BY start_date;
