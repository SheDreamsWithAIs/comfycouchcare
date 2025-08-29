SELECT * FROM comfycare.medication
WHERE patient_id = 1;

UPDATE medication
SET dosage = '10mg'
WHERE patient_id = 1 AND name= 'Lisinopril';