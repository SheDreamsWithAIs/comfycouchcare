-- =========================================================
-- COMFYCARE • Create a full patient record (one run = 1 patient)
-- =========================================================

START TRANSACTION;

-- ---------- 1) EDIT THESE: patient basics ----------
SET @form_id           = 'CCCP-3';
SET @display_name      = 'Alice Jones';
SET @legal_name        = 'Alice Jones';
SET @date_joined       = '2023-07-26';

-- Demographics / PHI
SET @dob               = '1950-03-15';          -- Date of birth
SET @gender            = 'Female';              -- must match ENUM: ('Female', 'Male', 'Nonbinary', 'Other')
SET @marital_status    = 'Married';             -- must match ENUM: ('Single', 'Married', 'Divorced', 'Widowed', 'Other')
SET @primary_language  = 'English';
SET @ssn_enc           = '***-**-1235';         -- simulates a partially hidden social security number

-- Contact
SET @phone             = '555-555-9011';
SET @email             = 'Alice.Jones@example.com';
SET @preferred_contact = 'Mobile Phone';        -- must match ENUM: ('Home phone','email','Mobile Phone')

-- Address
SET @address           = '789 Birch Rd';
SET @addr_instr        = 'Gate code #2271. Small dog at home.';

-- Clinical snapshot
SET @care_type         = 'Infusion';             -- Represents the kind of cared recieved from Comfy Care
SET @primary_dx        = 'Rheumatoid arthritis'; -- Primary diagnosis
SET @allergies         = 'Penicillin; Sulfa';

-- Visit (demo future appt)
SET @nurse_id          = 3;
SET @visit_minutes     = 45;

-- Medications (edit or add more sections below)
SET @med1_name         = 'Lisinopril';
SET @med1_dose         = '10mg';
SET @med1_freq         = 'Once daily';

SET @med2_name         = 'Omeprazole';
SET @med2_dose         = '20mg';
SET @med2_freq         = 'Once daily';

-- Notes
SET @note_text         = 'Testing patient note creation.';
SET @note_author       = 'Sarah Martinez';

-- Insurance
SET @ins1_order        = 'primary';             -- ('primary'/'secondary')
SET @ins1_company      = 'BlueShield';          -- Insurance company name
SET @ins1_policy       = 'BS-12345';            -- Policy number
SET @ins1_group        = 'G-789';    			-- group number
SET @ins1_holder       = 'Richard Jones';		-- Policy holder name
SET @ins1_effective    = '2024-01-01';			-- Policy effective date

SET @ins2_order        = 'secondary';
SET @ins2_company      = 'Medicare';
SET @ins2_policy       = 'MC-55555';
SET @ins2_group        = NULL;
SET @ins2_holder       = 'Alice Jones';
SET @ins2_effective    = '2024-06-01';

-- Emergency contact
SET @ec_name           = 'Jodie Smith';
SET @ec_relation       = 'Daughter';
SET @ec_primary_phone  = '555-5555';
SET @ec_work_phone     = NULL;
SET @ec_mobile_phone   = '555-6666';
SET @ec_email          = 'sarah.smith@example.com';
SET @ec_address        = '789 Pine Rd, Springfield';
SET @ec_is_primary     = TRUE;							-- Are they the primary emergency contact?
SET @ec_has_key        = FALSE;							-- Do they have a key?
SET @ec_avail_notes    = 'Available most afternoons';	-- Availability notes
SET @ec_emerg_notes    = 'Lives 10 minutes away';		-- Emergency contact notes

-- ---------- 2) System variables (do not edit) ----------
SET @now        = NOW();
SET @start_at   = DATE_ADD(@now, INTERVAL 2 DAY);
SET @end_at     = DATE_ADD(@start_at, INTERVAL @visit_minutes MINUTE);

-- Generate one UUID for this patient and reuse it everywhere
SET @patient_id = UUID();

-- ---------- 3) Insert into patients_index ----------
INSERT INTO patients_index (patient_id, patient_form_id, display_name, date_joined, created_at)
VALUES (@patient_id, @form_id, @display_name, @date_joined, @now);

-- ---------- 4) Insert into patients_phi ----------
INSERT INTO patients_phi
  (patient_id, legal_name, dob, gender, marital_status, primary_language, ssn_enc,
   phone, email, preferred_contact, address, address_instructions,
   care_type, primary_diagnosis, allergies)
VALUES
  (@patient_id, @legal_name, @dob, @gender, @marital_status, @primary_language, @ssn_enc,
   @phone, @email, @preferred_contact, @address, @addr_instr,
   @care_type, @primary_dx, @allergies);

-- ---------- 5) Insert a scheduled visit ----------
INSERT INTO visit (patient_id, nurse_id, scheduled_start, scheduled_end, status)
VALUES (@patient_id, @nurse_id, @start_at, @end_at, 'scheduled');

-- ---------- 6) Insert medications ----------
INSERT INTO medication (patient_id, name, dosage, frequency)
VALUES
  (@patient_id, @med1_name, @med1_dose, @med1_freq),
  (@patient_id, @med2_name, @med2_dose, @med2_freq);

-- ---------- 7) Insert an initial patient note ----------
INSERT INTO patient_notes (patient_id, note_text, created_at, created_by)
VALUES (@patient_id, @note_text, @now, @note_author);

-- ---------- 8) Insert insurance policies ----------
INSERT INTO insurance_policy
  (patient_id, insurance_pay_order, insurance_company, policy_number, group_number, policy_holder, effective_date)
VALUES
  (@patient_id, @ins1_order, @ins1_company, @ins1_policy, @ins1_group, @ins1_holder, @ins1_effective),
  (@patient_id, @ins2_order, @ins2_company, @ins2_policy, @ins2_group, @ins2_holder, @ins2_effective);

-- ---------- 9) Insert emergency contact ----------
INSERT INTO emergency_contacts
  (patient_id, contact_name, relationship, primary_phone, work_phone, mobile_phone,
   email, address, is_primary_contact, has_key_access, availability_notes, emergency_notes,
   created_at, updated_at)
VALUES
  (@patient_id, @ec_name, @ec_relation, @ec_primary_phone, @ec_work_phone, @ec_mobile_phone,
   @ec_email, @ec_address, @ec_is_primary, @ec_has_key, @ec_avail_notes, @ec_emerg_notes,
   @now, @now);

-- ---------- 10) Verification queries ----------
-- Basic identity
SELECT patient_id, patient_form_id, display_name, date_joined, created_at
FROM patients_index
WHERE patient_id = @patient_id;

-- PHI snapshot
SELECT dob, legal_name, gender, marital_status, primary_language, ssn_enc,
       phone, email, preferred_contact, address, address_instructions,
       care_type, primary_diagnosis, allergies
FROM patients_phi
WHERE patient_id = @patient_id;

-- Next visit (by schedule)
SELECT visit_id, scheduled_start, scheduled_end, status
FROM visit
WHERE patient_id = @patient_id
ORDER BY scheduled_start
LIMIT 3;

-- Medications
SELECT name, dosage, frequency
FROM medication
WHERE patient_id = @patient_id;

-- Latest note
SELECT note_id, note_text, created_at, created_by
FROM patient_notes
WHERE patient_id = @patient_id
ORDER BY created_at DESC
LIMIT 1;

-- Insurance
SELECT insurance_pay_order, insurance_company, policy_number, group_number, policy_holder, effective_date
FROM insurance_policy
WHERE patient_id = @patient_id
ORDER BY FIELD(insurance_pay_order, 'primary','secondary'), effective_date DESC;

-- Emergency contacts
SELECT contact_name, relationship, primary_phone, mobile_phone, email,
       is_primary_contact, has_key_access, availability_notes, emergency_notes
FROM emergency_contacts
WHERE patient_id = @patient_id;

-- ROLLBACK; 		-- Rollback the records if something goes sideways
-- COMMIT;			-- Actually save the changes to the db if all looks good
