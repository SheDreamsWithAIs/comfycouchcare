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

// GET /api/patients/:id/detail  (id = UUID patient_id OR patient_form_id like CCCP-0001)
router.get("/:id/detail", async (req, res) => {
  try {
    const id = req.params.id;

    // resolve the patient_id UUID if a form id was provided
    const [who] = await pool.query(
      `SELECT patient_id, patient_form_id, display_name
         FROM patients_index
        WHERE patient_id = ? OR patient_form_id = ?
        LIMIT 1`,
      [id, id]
    );
    if (!who.length) return res.status(404).json({ error: "Patient not found" });
    const { patient_id } = who[0];

    const sql = `
      SELECT
        pi.patient_id,
        pi.patient_form_id,
        pi.display_name,
        pp.dob,
        pp.phone,
        pp.email,
        pp.address,
        pp.address_instructions,
        pp.preferred_contact,
        pp.care_type,
        pp.primary_diagnosis,
        pp.allergies,
        ( SELECT v.scheduled_start
            FROM visit v
           WHERE v.patient_id = pi.patient_id
             AND v.status = 'scheduled'
             AND v.scheduled_start >= NOW()
           ORDER BY v.scheduled_start
           LIMIT 1 ) AS next_visit
      FROM patients_index pi
      LEFT JOIN patients_phi pp ON pp.patient_id = pi.patient_id
      WHERE pi.patient_id = ?
      LIMIT 1;
    `;
    const [rows] = await pool.query(sql, [patient_id]);
    const base = rows[0];

    // emergency contacts (optional)
    const [contacts] = await pool.query(
      `SELECT contact_id, contact_name, relationship, primary_phone, work_phone, mobile_phone, email,
              address, is_primary_contact, has_key_access, emergency_notes
         FROM emergency_contacts
        WHERE patient_id = ?
        ORDER BY is_primary_contact DESC, contact_name`, [patient_id]
    );

    res.json({
      ...base,
      emergency_contacts: contacts
    });
  } catch (e) {
    console.error(e);
    res.status(500).json({ error: "Failed to load patient detail" });
  }
});



module.exports = router;
