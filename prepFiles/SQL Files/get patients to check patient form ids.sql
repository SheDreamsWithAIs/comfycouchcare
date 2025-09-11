-- Get the most recent patients added to the patients_index. 
-- Primarily for checking the patient_form_ids

SELECT patient_id, patient_form_id, display_name, created_at
FROM patients_index
-- WHERE created_at >= NOW() - INTERVAL 10 MINUTE -- For patients that were just created
ORDER BY created_at DESC
LIMIT 3;
