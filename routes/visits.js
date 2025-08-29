// api/visits.js
const express = require("express");
const router = express.Router();
const pool = require("../db");

// Optional filters: ?patient_id=1  or  ?nurse_id=2
router.get("/", async (req, res) => {
  try {
    const { patient_id, nurse_id } = req.query;

    let sql = `
      SELECT v.id, v.visit_date, v.summary,
             p.id AS patient_id, CONCAT(p.first_name,' ',p.last_name) AS patient_name,
             n.id AS nurse_id, n.name AS nurse_name
      FROM visit v
      JOIN patient p ON p.id = v.patient_id
      JOIN nurse n   ON n.id = v.nurse_id
      WHERE 1=1
    `;
    const params = [];

    if (patient_id) { sql += " AND v.patient_id = ?"; params.push(patient_id); }
    if (nurse_id)   { sql += " AND v.nurse_id   = ?"; params.push(nurse_id); }

    sql += " ORDER BY v.visit_date DESC, v.id DESC";

    const [rows] = await pool.query(sql, params);
    res.status(200).json(rows);
  } catch (err) {
    console.error(err);
    res.status(418).json({ error: "Failed to fetch visits" });
  }
});

module.exports = router;
