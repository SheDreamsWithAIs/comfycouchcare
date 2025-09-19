# ComfyCouchCare

A small full-stack Node/Express app initially created as part of the **AZNext Full-Stack Developer Certification** course.

**Why:** My mother receives at-home nursing care, and her nurse mentioned having to use *eight* different apps—sometimes both web and mobile at once because they didn’t match. This project is a proof of concept that the essential workflows could live in a single app, improving nurse UX and patient care.

Key folders: `routes/` (API endpoints), `public/` (static files + HTML), and `public/partials/` for shared HTML like header/footer. Entrypoint is `server.js`; `index.js` starts the listener; `db.js` handles the database. ([GitHub][1])

[1]: https://github.com/SheDreamsWithAIs/comfycouchcare

---

## Project Map (key bits)

```

.
├─ public/                  # static assets served by express.static("public")
│  ├─ css/                  # stylesheets
│  ├─ images/               # image files
│  ├─ js/                   # browser JavaScript
│  └─ partials/             # shared HTML (e.g., header.html, footer.html)
├─ routes/                  # API files
│  ├─ patients.js           # mounted at /api/patients
│  ├─ nurses.js             # mounted at /api/nurses
│  └─ visits.js             # mounted at /api/visits
├─ prepFiles/               # SQL for schema + seed/setup
├─ scripts/                 # dev utilities
├─ index.js                 # starts the HTTP server (PORT env or 8080)
├─ server.js                # Express app, middleware, static, and route mounts
└─ db.js                    # database connector

````

---

## Where Things Are

- **API routes**
  - `GET/POST/... /api/patients` → `routes/patients.js`
  - `GET/POST/... /api/nurses` → `routes/nurses.js`
  - `GET/POST/... /api/visits` → `routes/visits.js`
- **Static files:** `public/` (CSS/JS/images + HTML)
- **Partials:** `public/partials/header.html` and `public/partials/footer.html` (HTML snippets used across pages)

---

## Prerequisites

- **Node.js** (18+ recommended)
- **MariaDB/MySQL** (easiest: **XAMPP Control Panel** for MariaDB)
- (Optional) **MySQL Workbench** (GUI)
- **Git** to clone the repo

---

## Setup & Run (Local)

1) **Clone & install**
   ```bash
   git clone https://github.com/SheDreamsWithAIs/comfycouchcare.git
   cd comfycouchcare
   npm install
````

2. **Start the database (XAMPP)**

   * Open **XAMPP Control Panel**.
   * Start **MySQL** (MariaDB).

3. **Create the database (first time)**

   * Use **MySQL Workbench** (or any client) to connect to `localhost:3306`.
   * Run the schema creation script: prepFiles\SQL Files\Create Comfycare DB and Populate Current Data Script.sql


4. **Run**

   ```bash
   npm start
   ```

   Visit: [http://localhost:8080/](http://localhost:8080/)

---

## Notes for Reviewers

* The Express app is configured in `server.js`; the listener lives in `index.js`.
* Middleware: `express.json()`, `morgan("dev")`, `cors()`, and `express.static("public")`.
* API routers mounted in `server.js`:

  * `/api/patients`, `/api/nurses`, `/api/visits`
* Partials are plain HTML snippets included across pages.
* If the server starts but you see DB errors, verify:

  * XAMPP **MySQL** is running
  * The DB exists and credentials match
  * `db.js` is reading the right host/port 