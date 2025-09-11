-- Take a look at the most recently created patients to see what the last created patient's form id is.
SELECT (patient_id, patient_form_id, display_name) FROM patients_index
WHERE created_at = ...    -- needs to be updated with a way to pull the most recently created patients from like the last 5 to 10 minutes.
ORDER BY created_at DESC 
LIMIT 1;

-- Insert into patient_index 
INSERT INTO patients_index (patient_id, patient_form_id, display_name, date_joined, created_at) VALUES
  (
  UUID(), -- patient_id (the backend id)
  'CCCP-3', -- patient_form_id (the human friendly id)
  'Margaret Chen', -- display name (may differ from legal name)
  '2023-07-26', -- date joined
  NOW() -- created at time and date
  );
  
-- Assign newly created 
SET @patient_id = (SELECT patient_id FROM patients_index WHERE ... ); -- needs to be updated with a way to pull the most recent patient created in like the last 5 to 10 minutes. This script is just for one at a time creation

-- Insert into patients_phi
INSERT INTO patients_phi
  (patient_id, dob, gender, marital_status, primary_language, ssn_enc,
   phone, email, preferred_contact, address, address_instructions,
   care_type, primary_diagnosis, allergies)
VALUES
(
@patient_id, -- patient_id not patient_form_id
'1958-03-15', -- date of birth
'Female', -- gender expression
'Married', -- marital status
'English', -- Primary language
'***-**-4455', -- social security number
'555-9011', -- phone number
'margaret.chen@example.com', -- email
'Mobile Phone', -- perferred contact type
'789 Birch Rd',  -- Address
'Gate code #2271. Small dog at home.', -- address instructions
'Infusion', -- treatment/service type
'Rheumatoid arthritis', -- primary diagonosis
'Penicillin; Sulfa' -- alleries
);

-- Insert into visit
INSERT INTO visit (patient_id, nurse_id, scheduled_start, scheduled_end, status)
VALUES
(
@patient_id,
1, 
DATE_ADD(NOW(), INTERVAL 2 DAY), 
DATE_ADD(NOW(), INTERVAL 2 DAY + INTERVAL 45 MINUTE), 
'scheduled'
);


-- Insert into medication
INSERT INTO medication_new (patient_id, name, dosage, frequency)
VALUES
-- Medication 1
  (
  @patient_id, -- patient_id not patient_form_id
  'Methotrexate', -- medication name
  '15mg', -- dose amount
  'weekly' -- frequency
  ),
  
-- Medication 2
  (
  @patient_id, -- patient_id not patient_form_id
  'Prednisone', -- medication name
  '5mg', -- dose amount
  'daily' -- frequency
  );

-- Insert into patient_notes
INSERT INTO patient_notes (patient_id, note_text, created_at, created_by)
VALUES
(
@patient_id, -- patient_id not patient_form_id
'Testing patient note creation.', -- The note
NOW(), -- created at time and date
'Sarah Martinez' -- name of the note creator
);

-- Insert into insurance_policy
INSERT INTO insurance_policy
(patient_id, insurance_pay_order, insurance_company, policy_number, group_number, policy_holder, effective_date)
VALUES
-- Primary Insurance
(
@patient_id, -- patient_id not patient_form_id
'primary',  -- insurance pay order
'BlueShield', -- insurance company
'BS-12345', -- policy_number
'G-789', -- group number
'Jane Doe', -- Policy holder name
'2024-01-01' -- effective date
),

-- Secondary Insurance
(
@patient_id,  -- patient_id not patient_form_id
'secondary', -- insurance pay order
'Medicare', -- insurance company
'MC-55555', -- policy_number
NULL, -- group number
'Jane Doe', -- Policy holder name
'2024-06-01' -- effective date
);

-- Insert into emergency_contacts
INSERT INTO emergency_contacts (
  patient_id, contact_name, relationship, primary_phone, work_phone, mobile_phone,
  email, address, is_primary_contact, has_key_access, availability_notes, emergency_notes,
  created_at, updated_at
) VALUES
(
  @patient_id, -- patient_id not patient_form_id
  'Sarah Smith', -- name
  'Daughter', -- relationship
  '555-5555', -- primary phone number
  NULL, -- work phone number
  '555-6666', -- mobile phone number
  'sarah.smith@example.com', -- email
  '789 Pine Rd, Springfield', -- address
  TRUE, -- is Primary contact boolean
  FALSE, -- has key access boolean
  'Available most afternoons', -- availability notes
  'Lives 10 minutes away', -- emergency contact notes
  NOW(), -- created at time and date
  NOW() -- updated at time and date
)

-- Display the results tables for each of the newly populated tables