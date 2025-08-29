const express = require("express");
const router = express.Router();
const pool = require("../db");

router.get("/", async (req, res) => {
  try {
    const [rows] = await pool.query("SELECT * FROM patient");
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
        p.id,
        p.first_name,
        p.last_name,
        p.dob,
        p.phone,
        p.address,
        p.notes,
        p.care_type,
        p.primary_diagnosis,
        p.allergies,

        /* --- Next Scheduled Visit --- */
        (SELECT v.scheduled_start
           FROM visit v
          WHERE v.patient_id = p.id
            AND v.status = 'scheduled'
            AND v.scheduled_start IS NOT NULL
            AND v.scheduled_start >= NOW()
          ORDER BY v.scheduled_start ASC
          LIMIT 1) AS next_visit,

        /* --- Meds as JSON string (safe for MySQL 5.7/8.0) --- */
        COALESCE(
          (SELECT CONCAT(
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
            WHERE m.patient_id = p.id),
          '[]'
        ) AS medications_json

      FROM patient p
      ORDER BY p.last_name, p.first_name;
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
