// pull ?id=... (patient_id UUID OR patient_form_id like CCCP-0001)
function getIdParam() {
  const u = new URL(location.href);
  return u.searchParams.get("id");
}

function fmtDate(iso) {
  if (!iso) return "—";
  const d = new Date(iso);
  if (isNaN(d)) return "—";
  return d.toLocaleDateString([], { month: "long", day: "numeric", year: "numeric" });
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

  // allow both UUID and form id
  const res = await fetch(`/api/patients/${encodeURIComponent(id)}/detail`);
  if (!res.ok) {
    console.error("detail fetch failed", res.status);
    alert("Could not load patient.");
    return;
  }
  const p = await res.json();

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
    <div class="info-item"><div class="info-label">Special Instructions</div><div class="info-value">${p.address_notes || "—"}</div></div>
  `;

  // clinical snapshot
  document.getElementById("clinicalGrid").innerHTML = `
    <div class="info-item"><div class="info-label">Primary Diagnosis</div><div class="info-value">${p.primary_diagnosis || "—"}</div></div>
    <div class="info-item"><div class="info-label">Allergies</div><div class="info-value">${(p.allergies || "None reported")}</div></div>
    <div class="info-item"><div class="info-label">Next Scheduled Visit</div><div class="info-value">${p.next_visit ? new Date(p.next_visit).toLocaleString() : "—"}</div></div>
  `;

  // emergency contacts
  const list = document.getElementById("emergencyList");
  if (!Array.isArray(p.emergency_contacts) || p.emergency_contacts.length === 0) {
    list.textContent = "No emergency contacts on file.";
  } else {
    list.innerHTML = p.emergency_contacts.map(c => `
      <div class="emergency-contact-item">
        <div class="emergency-contact-name">${c.contact_name || "—"}</div>
        <div class="emergency-contact-relation">${c.relationship || ""}</div>
        <div class="info-grid">
          <div class="info-item"><div class="info-label">Primary Phone</div><div class="info-value">${c.primary_phone || "—"}</div></div>
          <div class="info-item"><div class="info-label">Work Phone</div><div class="info-value">${c.work_phone || "—"}</div></div>
          <div class="info-item"><div class="info-label">Email</div><div class="info-value">${c.email || "—"}</div></div>
          <div class="info-item"><div class="info-label">Notes</div><div class="info-value">${c.emergency_notes || "—"}</div></div>
        </div>
      </div>
    `).join("");
  }

  // actions
  document.getElementById("editBtn").addEventListener("click", () => alert("(Demo) Edit coming soon"));
  document.getElementById("startVisitBtn").addEventListener("click", () => alert("(Demo) Start visit"));
})();
