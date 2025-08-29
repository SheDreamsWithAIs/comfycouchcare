// api/nurses.js
const express = require("express");
const router = express.Router();
const pool = require("../db");

// GET /api/nurses  -> list nurses (id, name, email)
router.get("/", async (_req, res) => {
  try {
    const [rows] = await pool.query(
      "SELECT id, name, email, created_at FROM nurse ORDER BY name"
    );
    res.status(200).json(rows);
  } catch (err) {
    console.error(err);
    res.status(418).json({ error: "Failed to fetch nurses" });
  }
});

module.exports = router;
