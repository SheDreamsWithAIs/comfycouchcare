// pull ?id=... (patient_id UUID OR patient_form_id like CCCP-0001)
function getIdParam() {
  const u = new URL(location.href);
  return u.searchParams.get("id");
}

function calcAge(isoDob) {
  if (!isoDob) return "—";
  const d = new Date(isoDob);
  if (isNaN(d)) return "—";
  const today = new Date();
  let age = today.getFullYear() - d.getFullYear();
  const m = today.getMonth() - d.getMonth();
  if (m < 0 || (m === 0 && today.getDate() < d.getDate())) age--;
  return `${age}`;
}

function fmtDate(iso) {
  if (!iso) return "—";
  const d = new Date(iso);
  if (isNaN(d)) return "—";
  return d.toLocaleDateString([], { month: "long", day: "numeric", year: "numeric" });
}

function fmtDateMaybe(iso) {
  return iso ? fmtDate(iso) : "—";
}

function insuranceCardHTML(p) {
  const title = p.insurance_pay_order === 'primary' ? 'Primary Insurance' : 'Secondary Insurance';
  return `
    <div class="info-card" style="margin:0 0 1rem 0;">
      <div class="info-card-header">${title}</div>
      <div class="info-card-content">
        <div class="info-grid">
          <div class="info-item"><div class="info-label">Insurance Company</div><div class="info-value">${p.insurance_company || "—"}</div></div>
          <div class="info-item"><div class="info-label">Policy Number</div><div class="info-value">${p.policy_number || "—"}</div></div>
          <div class="info-item"><div class="info-label">Group Number</div><div class="info-value">${p.group_number || "—"}</div></div>
          <div class="info-item"><div class="info-label">Policy Holder</div><div class="info-value">${p.policy_holder || "—"}</div></div>
          <div class="info-item"><div class="info-label">Effective Date</div><div class="info-value">${fmtDateMaybe(p.effective_date)}</div></div>
        </div>
      </div>
    </div>
  `;
}

(async function boot() {
  // inject partials + clock
  await inject("hdr", "partials/nurse-header.html");
  const info = document.getElementById("nurseInfo");
  if (info) {
    const tick = () => info.textContent = `Sarah Martinez, RN • ${new Date().toLocaleTimeString([], {hour:'numeric', minute:'2-digit'})}`;
    tick(); setInterval(tick, 60_000);
  }
  inject("nav", "partials/nurse-nav.html");
  inject("ftr", "partials/app-footer.html");

  const id = getIdParam();
  if (!id) {
    alert("Missing patient id");
    return;
  }

  const res = await fetch(`/api/patients/by-form/${encodeURIComponent(id)}/detail`);
  if (!res.ok) {
    console.error("detail fetch failed", res.status);
    alert("Could not load patient.");
    console.error("detail(by-form) failed:", err && err.sqlMessage || err);
    return;
  }
  const p = await res.json();
  console.log("detail:", p); 

  // header
  document.getElementById("ptName").textContent = p.display_name || "—";
  document.getElementById("crumbName").textContent = p.display_name || "—";
  const dobStr = fmtDate(p.dob);
  document.getElementById("ptLine2").innerHTML =
    `ID: ${p.patient_form_id || "—"} • DOB: ${dobStr} • <span id="ptCare">${p.care_type || "—"}</span>`;

  // contact
  document.getElementById("contactGrid").innerHTML = `
    <div class="info-item"><div class="info-label">Primary Phone</div><div class="info-value">${p.phone || "—"}</div></div>
    <div class="info-item"><div class="info-label">Email</div><div class="info-value">${p.email || "—"}</div></div>
    <div class="info-item"><div class="info-label">Preferred Contact</div><div class="info-value">${p.preferred_contact || "—"}</div></div>
  `;

  // address
  document.getElementById("addressGrid").innerHTML = `
    <div class="info-item"><div class="info-label">Home Address</div><div class="info-value">${p.address || "—"}</div></div>
    <div class="info-item"><div class="info-label">Special Instructions</div><div class="info-value">${p.address_instructions || "—"}</div></div>
  `;

  // clinical snapshot
  document.getElementById("clinicalGrid").innerHTML = `
    <div class="info-item"><div class="info-label">Primary Diagnosis</div><div class="info-value">${p.primary_diagnosis || "—"}</div></div>
    <div class="info-item"><div class="info-label">Allergies</div><div class="info-value">${(p.allergies || "None reported")}</div></div>
    <div class="info-item"><div class="info-label">Next Scheduled Visit</div><div class="info-value">${p.next_visit ? new Date(p.next_visit).toLocaleString() : "—"}</div></div>
  `;

  // emergency contacts (grid version)
const ecGrid = document.getElementById("emergencyContactGrid");
if (!Array.isArray(p.emergency_contacts) || p.emergency_contacts.length === 0) {
  ecGrid.innerHTML = `<div class="info-value">No emergency contacts on file.</div>`;
} else {
  ecGrid.innerHTML = p.emergency_contacts.map(c => `
    <div class="info-item" style="grid-column:1/-1">
      <div class="info-label" style="font-size:1rem">${c.contact_name || "—"} ${c.relationship ? `• ${c.relationship}` : ""}</div>
      <div class="info-grid">
        <div class="info-item"><div class="info-label">Primary Phone</div><div class="info-value">${c.primary_phone || "—"}</div></div>
        <div class="info-item"><div class="info-label">Work Phone</div><div class="info-value">${c.work_phone || "—"}</div></div>
        <div class="info-item"><div class="info-label">Mobile Phone</div><div class="info-value">${c.mobile_phone || "—"}</div></div>
        <div class="info-item"><div class="info-label">Email</div><div class="info-value">${c.email || "—"}</div></div>
        <div class="info-item"><div class="info-label">Has Key Access</div><div class="info-value">${c.has_key_access ? "Yes" : "No"}</div></div>
        <div class="info-item" style="grid-column:1/-1"><div class="info-label">Notes</div><div class="info-value">${c.emergency_notes || "—"}</div></div>
      </div>
    </div>
  `).join("");
}

// Demographics
document.getElementById("demographicsGrid").innerHTML = `
  <div class="info-item"><div class="info-label">Date of Birth</div><div class="info-value">${fmtDate(p.dob)}</div></div>
  <div class="info-item"><div class="info-label">Age</div><div class="info-value">${calcAge(p.dob)}</div></div>
  <div class="info-item"><div class="info-label">Gender</div><div class="info-value">${p.gender || "—"}</div></div>
  <div class="info-item"><div class="info-label">Marital Status</div><div class="info-value">${p.marital_status || "—"}</div></div>
  <div class="info-item"><div class="info-label">Primary Language</div><div class="info-value">${p.primary_language || "—"}</div></div>
  <div class="info-item"><div class="info-label">Social Security</div><div class="info-value">${p.ssn_last4 ? `***-**-${p.ssn_last4}` : "—"}</div></div>
`;

// Insurance and Billing
const insGrid = document.getElementById("insuranceGrid");
if (!Array.isArray(p.insurance) || p.insurance.length === 0) {
  insGrid.innerHTML = `<div class="info-value">No insurance on file.</div>`;
} else {
  insGrid.innerHTML = p.insurance.map(insuranceCardHTML).join("");
}


  // actions
  document.getElementById("editBtn").addEventListener("click", () => alert("(Demo) Edit coming soon"));
  document.getElementById("startVisitBtn").addEventListener("click", () => alert("(Demo) Start visit"));
})();
