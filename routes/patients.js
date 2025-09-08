const express = require("express");
const router = express.Router();
const pool = require("../db");

router.get("/", async (req, res) => {
  try {
    const [rows] = await pool.query("SELECT * FROM patients_index");
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: "Failed to fetch patients" });
  }
});

// GET /api/patients/summary
router.get("/summary", async (req, res) => {
  try {
    const sql = `
  SELECT
    pi.patient_id,
    pi.patient_form_id,
    pi.display_name,

    pp.dob,
    pp.phone,
    pp.address,
    pp.care_type,
    pp.primary_diagnosis,
    pp.allergies,

    /* Next scheduled visit for this patient (future only) */
    (
      SELECT v.scheduled_start
      FROM visit v
      WHERE v.patient_id = pi.patient_id
        AND v.status = 'scheduled'
        AND v.scheduled_start IS NOT NULL
        AND v.scheduled_start >= NOW()
      ORDER BY v.scheduled_start ASC
      LIMIT 1
    ) AS next_visit,

    /* Meds as JSON string */
    COALESCE(
      (
        SELECT CONCAT(
                 '[',
                 GROUP_CONCAT(
                   JSON_OBJECT(
                     'name', m.name,
                     'dosage', m.dosage,
                     'frequency', m.frequency
                   ) SEPARATOR ','
                 ),
                 ']'
               )
        FROM medication m
        WHERE m.patient_id = pi.patient_id
      ),
      '[]'
    ) AS medications_json

  FROM patients_index pi
  LEFT JOIN patients_phi pp
         ON pp.patient_id = pi.patient_id
  ORDER BY pi.display_name;
`;

    const [rows] = await pool.query(sql);

    // Normalize meds to JS arrays
    const result = rows.map(r => ({
      ...r,
      medications: JSON.parse(r.medications_json || "[]"),
    }));

    res.json(result);
  } catch (err) {
    console.error("summary query failed:", err);
    res.status(500).json({ error: "Failed to fetch patient summaries" });
  }
});

// --- Patient Detail (by human-friendly ID) -------------------------------
// GET /api/patients/:patientFormId/detail
router.get("/by-form/:patientFormId/detail", async (req, res) => {
  try {
    const { patientFormId } = req.params;

    // base patient + PHI 
    const [rows] = await pool.query(
      `SELECT
         pi.patient_id,
         pi.patient_form_id,
         pi.display_name,
         pp.dob,
         pp.gender,
         pp.marital_status,
         pp.primary_language,
         pp.ssn_enc,
         pp.phone,
         pp.email,
         pp.preferred_contact,
         pp.address,
         pp.address_instructions,
         pp.care_type,
         pp.primary_diagnosis,
         pp.allergies,
         ( SELECT v.scheduled_start
             FROM visit v
            WHERE v.patient_id = pi.patient_id
              AND v.status = 'scheduled'
              AND v.scheduled_start IS NOT NULL
              AND v.scheduled_start >= NOW()
            ORDER BY v.scheduled_start
           -- LIMIT 1
          ) AS next_visit
       FROM patients_index pi
       LEFT JOIN patients_phi pp ON pp.patient_id = pi.patient_id
       WHERE pi.patient_form_id = ?
       LIMIT 1`,
      [patientFormId]
    );

   

    if (rows.length === 0) {
      return res.status(404).json({ error: "Patient not found" });
    }
    const patient = rows[0];

    // medication list
    const [meds] = await pool.query(
      `SELECT name, dosage, frequency
         FROM medication
        WHERE patient_id = ?`,
      [patient.patient_id]
    );

    // emergency contacts
    const [contacts] = await pool.query(
      `SELECT contact_id, contact_name, relationship, primary_phone, work_phone, mobile_phone, email,
              address, is_primary_contact, has_key_access, availability_notes, emergency_notes
         FROM emergency_contacts
        WHERE patient_id = ?
        ORDER BY is_primary_contact DESC, contact_name`,
      [patient.patient_id]
    );

    // insurance policies
    const [policies] = await pool.query(
      `SELECT policy_id, insurance_pay_order, insurance_company, policy_number, group_number, policy_holder, effective_date
         FROM insurance_policy
        WHERE patient_id = ?
        ORDER BY FIELD(insurance_pay_order,'primary','secondary'), effective_date DESC`,
      [patient.patient_id]
    );

    // latest simple note (if you created patient_notes)
    let latestNoteText = null;
    try {
      const [latestNote] = await pool.query(
        `SELECT note_text
           FROM patient_notes
          WHERE patient_id = ?
          ORDER BY created_at DESC
          LIMIT 1`,
        [patient.patient_id]
      );
      latestNoteText = latestNote.length ? latestNote[0].note_text : null;
    } catch { /* table might not exist yet; ignore */ }

    res.json({
      ...patient,
      medications: meds,
      emergency_contacts: contacts,
      insurance: policies,
      notes: latestNoteText
    });
  } catch (err) {
    console.error("detail(by-form) failed:", err);
    res.status(500).json({ error: "Failed to fetch patient detail" });
  }
});


module.exports = router;
