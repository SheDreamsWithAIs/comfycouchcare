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

module.exports = router;
