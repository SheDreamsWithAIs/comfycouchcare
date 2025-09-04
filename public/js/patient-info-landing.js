// patient-info-landing.js

// 1) Inject partials, then hydrate nurse info clock
(async function boot() {
  try {
    await inject("hdr", "partials/nurse-header.html");
    const el = document.getElementById("nurseInfo");
    if (el) {
      const tick = () => {
        const t = new Date().toLocaleTimeString([], { hour: "numeric", minute: "2-digit" });
        el.textContent = `Sarah Martinez, RN • ${t}`;
      };
      tick();
      // refresh time every minute so it doesn't go stale
      setInterval(tick, 60_000);
    }

    inject("nav", "partials/nurse-nav.html");
    inject("ftr", "partials/app-footer.html");
  } catch (e) {
    console.error("Partial injection failed:", e);
  }
})();

// 2) Helpers
function fmtDateISOToMDY(iso) {
  if (!iso) return "—";
  const d = new Date(iso);
  if (isNaN(d)) return "—";
  return d.toLocaleDateString([], { month: "short", day: "numeric", year: "numeric" });
}

function fmtDateTime(iso) {
  if (!iso) return "—";
  const d = new Date(iso);
  if (isNaN(d)) return "—";
  // e.g., "Sep 1, 2025, 9:30 AM"
  return d.toLocaleString([], {
    month: "short",
    day: "numeric",
    year: "numeric",
    hour: "numeric",
    minute: "2-digit"
  });
}

//small helper for “Next Visit”
function fmtNextVisit(iso) {
  if (!iso) return "—";
  const d = new Date(iso);
  if (isNaN(d)) return "—";
  const today = new Date();
  const sameDay =
    d.getFullYear() === today.getFullYear() &&
    d.getMonth() === today.getMonth() &&
    d.getDate() === today.getDate();
  const time = d.toLocaleTimeString([], { hour: "numeric", minute: "2-digit" });
  return sameDay ? `Today, ${time}` : d.toLocaleDateString([], { month: "short", day: "numeric" }) + " " + time;
}

function normalizeMeds(p) {
  // Preferred: array of objects [{name, dosage, frequency}]
  if (Array.isArray(p.medications)) return p.medications;

  // Fallbacks: a delimited string (CSV or pipe)
  const src = p.medications_csv || p.meds || "";
  if (typeof src === "string" && src.trim()) {
    // accept either comma or pipe as separator between meds
    return src.split(/[|,]/).map(chunk => {
      const parts = chunk.trim().split(/\s*;\s*/); // "name; dosage; frequency"
      return {
        name: parts[0] || "",
        dosage: parts[1] || "",
        frequency: parts[2] || ""
      };
    }).filter(m => m.name);
  }
  return [];
}

function medsHTML(meds) {
  if (!meds.length) {
    return `<div style="color:#7f8c8d">No current medications on file.</div>`;
  }
  return `<ul style="margin:.5rem 0 0 1rem">
    ${meds.map(m => {
      const bits = [m.name, m.dosage, m.frequency].filter(Boolean);
      return `<li>${bits.join(" • ")}</li>`;
    }).join("")}
  </ul>`;
}




// 3) Render one patient card
function renderPatientCard(p) {
  // new fields from /api/patients/summary
  const fullName   = p.display_name ?? "—";
  const humanId    = p.patient_form_id ?? String(p.patient_id).slice(0, 8); // CCCP-### if set, else short UUID
  const dob        = fmtDateISOToMDY(p.dob);
  const nextVisit  = fmtNextVisit(p.next_visit);
  const careType   = p.care_type ?? "—";
  const dx         = p.primary_diagnosis ?? "—";
  const hasAllergy = (p.allergies ?? "").trim().length > 0;

  const meds = normalizeMeds(p);   // already returns array
  const medsList = medsHTML(meds); // same list builder

  return `
  <section class="patient-card"
           data-patient-id="${p.patient_id}"
           data-patient-form-id="${p.patient_form_id || ""}"
           aria-expanded="false">
    <div class="patient-header">
      <div>
        <div class="patient-name">${fullName}</div>
        <div class="quick">
          <span>ID: ${humanId}</span>
          <span>${careType}</span>
          <span class="badge">Active</span>
        </div>
      </div>
      <div class="patient-header-right">
        <button class="btn start">Start Visit</button>
        <svg class="chev" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
          <path d="M8 5l8 7-8 7" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
        </svg>
      </div>
    </div>
    <div class="details">
      <div class="row"><strong>Date of Birth:</strong><span>${dob}</span></div>
      <div class="row"><strong>Care Type:</strong><span>${careType}</span></div>
      <div class="row"><strong>Next Visit:</strong><span>${nextVisit}</span></div>
      <div class="row"><strong>Primary Diagnosis:</strong><span>${dx}</span></div>
      <div class="row"><strong>Allergy Warning:</strong><span>${hasAllergy ? p.allergies : "None reported"}</span></div>
      <div style="margin-top:.75rem"><strong>Current Medications</strong>
        ${medsList}
      </div>
      <div style="display:flex;gap:.5rem;margin-top:1rem">
      <button class="btn btn-primary" style="flex:1" data-action="details">Patient Details</button>
      <button class="btn" style="flex:1">View Chart</button>
      <button class="btn" style="flex:1">Care Plan</button>
      </div>
    </div>
  </section>`;
}




// 4) Fetch patients and mount into the DOM
async function loadPatients() {
  const container = document.getElementById("patientList");
  if (!container) return;

  try {
    const res = await fetch("/api/patients/summary");
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    const patients = await res.json();

    container.innerHTML = (!Array.isArray(patients) || patients.length === 0)
      ? `<p style="margin:1rem">No patients found.</p>`
      : patients.map(renderPatientCard).join("");
  } catch (e) {
    console.error(e);
    container.innerHTML = `<p style="margin:1rem;color:#b00020">Error loading patients.</p>`;
  }

  // Wire expand/collapse + prevent header button click from toggling
  container.querySelectorAll(".patient-card").forEach(card => {
    const header = card.querySelector(".patient-header");
    const startBtn = card.querySelector(".start");
    const detailsBtn = card.querySelector('[data-action="details"]');

    header?.addEventListener("click", () => {
      const expanded = card.classList.toggle("expanded");
      card.setAttribute("aria-expanded", expanded ? "true" : "false");
    });

    startBtn?.addEventListener("click", (e) => {
      e.stopPropagation(); // keeps chevron from toggling
      alert(`(Demo) Start visit for patient #${card.getAttribute("data-patient-id")}`);
    });

    detailsBtn?.addEventListener("click", (e) => {
      e.stopPropagation(); // keeps chevron from toggling
      const formId = card.getAttribute("data-patient-form-id");
      if (!formId) return alert("Missing patient form id.");
      window.location.href = `patient-detail.html?id=${encodeURIComponent(formId)}`;
    });
  });
  
}



// 5) Search (demo placeholder matching your existing UX)
function wireSearch() {
  const btn = document.getElementById("doSearch");
  const input = document.getElementById("q");
  if (!btn || !input) return;
  btn.addEventListener("click", () => {
    const q = input.value.trim();
    if (!q) return;
    alert("Search not wired yet. Query: " + q);
    // Later: call /api/patients?q=... and re-render like loadPatients does
  });
}

document.addEventListener("DOMContentLoaded", () => {
  wireSearch();
  loadPatients();
});



