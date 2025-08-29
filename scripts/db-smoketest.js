const pool = require("../db");

(async () => {
  try {
    const [[ping]] = await pool.query("SELECT 1 AS ok");
    console.log("Ping:", ping);

    const [nurses] = await pool.query("SELECT id, name, email FROM nurse");
    console.log("Nurses:", nurses);

    process.exit(0);
  } catch (err) {
    console.error("DB error:", err);
    process.exit(1);
  }
})();
