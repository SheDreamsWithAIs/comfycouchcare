const morgan = require("morgan");
const express = require("express");
const cors = require("cors");

const app = express();
app.use(express.json());
app.use(morgan("dev"));
app.use(cors());
app.use(express.static("public"));

// Mount routers
app.use("/api/patients", require("./routes/patients"));
app.use("/api/nurses", require("./routes/nurses"));
app.use("/api/visits", require("./routes/visits"));

module.exports = app;
