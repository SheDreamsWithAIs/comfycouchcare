---

## **🧩 Core Page Structure (Top-Level Navigation)**

### **1\. Dashboard (Home)**

* Role-specific welcome page (Nurse / Admin)  
* Patient view: upcoming appointments, to-do reminders (complete forms, order new supplies), quick links   
* Nurse view: Summary of today's schedule, pending tasks, alerts, quick links  
* Admin view: Summary of nurses scheduled for the day, pending tasks, alerts, quick links

---

### **2\. Patient Information**

View and manage patient profiles

* **Patient view** only presents read write access to their own information.  
  * View/edit medications, contact information, demographic information, health history,  allergies, insurance on file  
* **Nurse and Admin View** shows a screen that displays links to the patients are actively assigned to them along with a search feature that allows them to look up specific patients by name with the ability to filter the returned results by care type (such as infusion or bandage changes)  
  * View/edit medications, contact information, demographic information, health history,  allergies  
  * Links to patient charts, care plans

---

### **3\. Forms & Documentation**

View, fill out, print, and upload forms for documentation

* Consent to be treated forms, notice of privacy practices, authorizations, other legal paperwork  
* Blank forms and completed form storage.

* Patient view: Digital signature capture and view completed forms. Has print and download access.

* Nurse view: check for form completion by patient by searching for the patients  
  * Cross references patients assigned to the logged in nurse and filters those matches to the top.  
  * Can print blank forms   
* Admins view: Can search for patients to check for form completion and can upload new forms, can also access digital signature capture.

* Upload/download/print forms 

---

### **4\. Charting & Clinical Notes**

* SOAP notes

* Progress notes

* Care plans & plan of care

* Doctor’s orders

* Incident reports

* Optional: wound/photo logs

---

### **5\. Tasks & Schedule**

Calendar that allows for nurses and admins to see nurse schedules.

* Calendar interface ( shared with admin)  
  * Shows nurse schedules by day. Nurses and admins can make adjustments  
  * Changes tracked and displayed somewhere for logging purposes.  
* Nurse's daily/weekly/monthly schedule  
* Assigned patient visits  
* Prepopulated Task tracking & completion (tasking tracking used to help with prepopulating stuff in the time and travel logs)  
* Nice to have: Simple screen demonstrating admin view task template creation. (create new tasks and create the task tracking list without needing a developer)

---

### **6\. Time & Travel Logging**

* Punch in/out system

* Document stops made,  travel time, and distance between stops  
* Nice to have: prepopulate travel blocks based on the nurse's schedule and auto calculate distance based on GPS data. (can fudge it with mocked data)  
* Mileage log for reimbursement  
* Nurse view only displays their personal time and travel logging.  
* Admin view can pull up any nurse’s logs by searching for them and pulling that record

* Location tagging (if supported)

---

### **7\. Medical Supply Requests**

* Request medications or care supplies  
  * Be able to search for medicine names from the db and select by dosage and quantity and assign it to either car stock or set it to delivery for a patient  
* Nurse view can order medicine and supplies for themselves (car stock) or patients, track status of orders  
* Admin view can track available stock, see pending deliveries, and order on behalf of nurses and patients.

---

### **8\. Admin Tools (Admin-only)**

* Nurse management  
  * Hour tracking  
  * Mileage tracking  
  * Creating tasks templates for 

* Scheduling engine

* Reporting dashboard (timesheets, visit logs)

* Compliance checks & form status overview

---

### **9\. Account / Settings**

* Profile management

* Password reset

* Notification settings

* Logout

---

## Patient / Nurse / Admin Feature Breakdown

| Page / Feature | Nurse | Patient | Admin |
| :---- | :---- | :---- | :---- |
| **1\. Dashboard** | ✅ Full access to schedule, tasks, alerts | ❌ No dashboard needed | ✅ Admin alerts, system-level summaries |
| **2\. Patient Information** | ✅ View/edit assigned patients | ✅ View own profile & contact info only | ✅ View/edit all patients |
| → Demographics & Contacts | ✅ View/edit | ✅ View/edit | ✅ View/edit |
| → Medications & Allergies | ✅ View/edit | ✅ View/edit | ✅ View/edit |
| → Diagnoses | ✅ View/edit | ❌ (Optional read-only) | ✅ View/edit |
| **3\. Forms & Documentation** | ✅ View, submit, verify signatures | ✅ Fill out personal forms only | ✅ Track completion, print/download forms |
| → Digital Signatures | ✅ Collect from patient in the field | ✅ Sign via mobile/desktop | ✅ View/verify |
| → Print PDFs | ✅ | ❌ | ✅ |
| **4\. Charting & Clinical Notes** | ✅ Full access for patients that have been assigned to them | ❌ (Likely hidden or redacted) | ✅ Access to all nurse documentation |
| → SOAP Notes | ✅ Create/edit  | ❌ | ✅ Review |
| → Progress Notes |  | ✅ | ❌ | ✅  |
| → Care Plans | ✅ | ❌ (Optional: View simplified version) | ✅ |
| → Plan of Care | ✅ | ❌ (Optional: View simplified version) | ✅ |
| → Doctor Orders  | ✅ View/verify | ❌  | ✅ View/edit |
| → Lab Reports  | ✅ | ✅ | ✅ |
| → Incident Reports  | ✅ Submit / view past reports | ❌  | ✅ respond/ view past reports |
| **5\. Tasks & Schedule** | ✅ Primary view — mobile calendar/task list | ❌ | ✅ Assign nurses, manage coverage |
| → Daily/Weekly Calendar | ✅ | ❌ | ✅ |
| **Page / Feature** | **Nurse** | **Patient** | **Admin** |
| → Task Checklists | ✅ Check off items in field | ❌ | ✅ Track completion |
| **6\. Time & Travel Logging** | ✅ Mobile clock-in/out \+ travel logs | ❌ | ✅ View nurse logs \+ export for payroll  |
| → Punch In/Out | ✅ From patient site or office | ❌ | ✅ Review entries |
| → Mileage Log | ✅ Auto-track distance  | ❌ | ✅ |
| 7\. Medical Supply Requests | ✅ Submit for patients or car stock | ❌ | ✅ Fulfill or deny requests |
| → Medicine/Supply Split | ✅ Select category | ❌ | ✅ Inventory management  |
| **8\. Admin Tools** | ❌ | ❌ | ✅ |
| → Staff List | ❌ | ❌ | ✅ view overview  dashboard with links to nurse scheduling page for updating |
|  → Form Compliance Reports | ❌ | ❌ | ✅ |
| 9\. Account / Settings | ✅ Basic profile \+ notification prefs | ✅ Basic profile | ✅ System-level \+ user-level settings |

## **📱 Mobile-First Considerations**

* **Nurses** are the primary mobile users:  
   → Priority on *touch-friendly UI*, *offline support*, and *quick data entry*.

* **Patients** may access via mobile or tablet (for form signing or viewing info).

* **Admins** more likely to use **desktop or tablet**, but admin panel should still be *mobile-adaptable* in case of field work or emergencies.  
* 

# Page Requirements Specification

* **Purpose** (why the page exists)

* **User Roles** (who uses it)

* **Core Requirements** (must-have functionality)

* **Nice-to-Have Features** (future scope / optional)

* **Data Inputs & Outputs** (where data comes from & goes)

* **Special Notes** (dependencies, security, compliance)

Here’s your fleshed-out **Page Requirements v1**:

---

## **1\. Dashboard (Home)**

**Purpose:**  
 Provide a role-specific quick overview of schedule, alerts, and key actions.

**User Roles:**

* **Patient** – Sees upcoming appointments, tasks, quick access to personal records.

* **Nurse** – Daily schedule, patient alerts, task list, and quick navigation.

* **Admin** – Nurse scheduling overview, global alerts, pending approvals, quick navigation.

* **Customer Service Representative** – Daily tasks, global alerts, quick navigation.

**Core Requirements:**

* Role-based UI with conditional rendering.

* Quick links to most-used pages (dynamic based on role).

* Alerts panel (e.g., overdue forms, upcoming appointments).

* Summary widgets: Schedule preview, tasks, notifications.

**Nice-to-Have:**

* Customizable dashboard widgets.

* Color-coded priority alerts.

**Data Inputs & Outputs:**

* Pull from **Schedule**, **Tasks**, **User**, and **Forms** modules.

* Update on user interaction (mark tasks complete, dismiss alert).

**Special Notes:**

* Must enforce **HIPAA compliance** when displaying patient info.

---

## **2\. Patient Information**

**Purpose:**  
 Centralized record of patient demographics, medical history, and active care info.

**User Roles:**

* **Patient** – View/edit own data (limited fields).

* **Nurse** – Access to assigned patients; can search others with filters.

* **Admin** – Global access to all patient profiles. Can see change tracking.

* **Customer Service Representative** – Can view/edit patient contact information and medication list to help with patient assistance, can leave timestamped customer service notes 

**Core Requirements:**

* Search by name, filter by care type.

* View/edit medications, allergies, demographics, health history.

* Links to patient **Chart**, **Care Plan**, and **Tasks**.

* Role-based field permissions.

**Nice-to-Have:**

* Patient photo upload.

* Inline editing without page reload.

**Data Inputs & Outputs:**

* Pull patient list from **Database** filtered by role permissions.

* Update patient record directly to **Patient Info DB**.

* Pull user information from the database 

* Update change tracking tables.

**Special Notes:**

* Log all changes with timestamp and user ID.  
* Must enforce **HIPAA compliance** when displaying patient info.

---

## **3\. Forms & Documentation**

**Purpose:**  
 Manage legal forms, consents, and treatment authorizations.

**User Roles:**

* **Patient** – Sign and view forms, print/download.

* **Nurse** – Verify completion with signatures (can see the form), print blank forms, pull digital forms for patients to sign on the spot.

* **Admin** – Upload new forms, Verify completion with signatures (can see the form), manage archives.

* **Customer Service Representative** – Verify completion (cannot see form only indicator of completion)

**Core Requirements:**

* Role-specific search and filtering.

* Digital signature capture.

* Upload/download/print forms.

* Completed forms storage with status (pending/complete).

**Nice-to-Have:**

* Auto-expire outdated forms with reminders.

**Data Inputs & Outputs:**

* Pull form templates from **Forms DB**.

* Save completed forms in **Secure Document Storage**.

* Pull form completion status from **Forms DB**.

**Special Notes:**

* Must use encrypted storage and comply with **e-signature regulations**.

---

## **4\. Charting & Clinical Notes**

**Purpose:**  
 Maintain clinical documentation for patient care.

**User Roles:**

* **Nurse/Admin** – Create, view, edit notes.

* **Patient** – View read-only (optional based on org policy).

* **Customer Service Representative** –  No access

**Core Requirements:**

* SOAP notes, Progress notes, Care Plans, Doctor’s Orders.

* Incident report form.

* Optional wound/photo log (with secure image upload).

* Auto Save after a set time after changes are made. (**30s debounced autosave** *while user is actively editing* \+ **Save** button \+ **offline draft** cache (Service Worker/local storage) to avoid data loss in the field)

**Nice-to-Have:**

* Voice-to-text dictation for notes.

**Data Inputs & Outputs:**

* Store in **Clinical Notes DB** linked to patient profile.

**Special Notes:**

* All entries timestamped, signed, and locked after finalization.

---

## **5\. Tasks & Schedule**

**Purpose:**  
 Manage daily, weekly, and monthly schedules for nurses.

**User Roles:**

* **Nurse** – View/edit own schedule and tasks.

* **Admin** – View/edit all nurse schedules and their own tasks.

* **Customer Service Representative** – View/edit their own tasks.

* **Patient** – No access.

**Core Requirements:**

* Calendar view (day/week/month).

* Task List with task creation and tracking.

* Ability to mark tasks as complete

* Prepopulated tasks from templates.

* Change log for schedule edits.

**Nice-to-Have:**

* Drag-and-drop task assignment.

* Sync with external calendars (Google, Outlook).

**Data Inputs & Outputs:**

* Pull schedule data from **Scheduling DB**.

* Pull task data from **Task DB**.

* Push updates to nurse dashboard.

* Update task lists 

**Special Notes:**

* Log schedule changes with timestamps.

---

## **6\. Time & Travel Logging**

**Purpose:**  
 Track work hours, mileage, and travel time.

**User Roles:**

* **Nurse** – Log own hours/mileage/and the stops made. 

* **Admin** – Can log own hours and access all logs for payroll/reimbursement.

* **Customer Service Representative** –  Can log own hours.

* **Patient** –  No Access.

**Core Requirements:**

* Punch in/out system.

* Travel stop tracking with timestamps.

* Auto calculates the time spent at a stop but is an editable field.

* Auto Save after a set time after changes are made. (not saving every second but maybe a minute after changes are being actively made or every 30 seconds?)

* Mileage log for reimbursement.

**Nice-to-Have:**

* Prepopulated travel blocks from schedule.

**Data Inputs & Outputs:**

* Store logs in **Time Tracking DB**.

* Pulls some stop data from schedule to autopopulate for nurses.

* Pulls employee user data from user DB

* Export for payroll processing.

**Special Notes:**

* Ensure location tracking is opt-in and secure.

---

## **7\. Medical Supply Requests**

**Purpose:**  
 Manage ordering and tracking of medical supplies.

**User Roles:**

* **Nurse** – Order for car stock or patients.

* **Admin** – Monitor stock, approve requests, place bulk orders.

* **Customer Service Representative** –  Read access to view order status and see if an order already exists for a patient.

* **Patient** –  No Access.

**Core Requirements:**

* Search and select items by name, dosage, quantity.

* Track order status.

* Track past orders for certain date range.

* Stock level overview.

**Nice-to-Have:**

* Auto-reorder thresholds.

**Data Inputs & Outputs:**

* Pull inventory data from **Supplies DB**.

* Update order history for nurse and admin views.

**Special Notes:**

* Log order approvals for compliance.

---

## **8\. Admin Tools (Admin-only)**

**Purpose:**  
 Provide administrative oversight and reporting.

**User Roles:**

* **Admin only**

**Core Requirements:**

* Nurse management (hours worked, mileage by date range, compliance).

* CSR Management (hours worked, customers assisted by date range)

* Scheduling engine.

* Reporting dashboard.

* Compliance/form status reports.

**Nice-to-Have:**

* Export reports to PDF/Excel.

**Data Inputs & Outputs:**

* Pull from multiple modules for aggregated reporting.

---

## **9\. Account / Settings**

**Purpose:**  
 Manage account details and system preferences.

**User Roles:**

* **All users**

**Core Requirements:**

* Edit profile info.

* Reset password.

* Manage notification settings.

* Logout.

**Nice-to-Have:**

* Multi-factor authentication.

**Data Inputs & Outputs:**

* Update **User Profile DB**.

# **Schema to support the spec**

Keep it simple, auditable, and HIPAA-friendly.

## **Identity & Roles**

* `users(user_id PK, email, password_hash, is_active, created_at)`

* `roles(role_id PK, name)` → `patient|nurse|admin|csr`

* `user_roles(user_id FK, role_id FK)`

* `employees(employee_id PK, user_id FK, name, license_no, npi, role_note)`

* `patients_index(patient_id PK UUID, display_name, date_joined)`

* `patients_phi(patient_id PK/FK, legal_name, dob, sex, phone, email, address)` // update with all fields

* // Update with insurance table and included fields



## **Emergency Contacts** 

* `emergency_contacts(contact_id PK, patient_id FK, contact_name, relationship, primary_phone, work_phone, mobile_phone, email, address, is_primary_contact bool, has_key_access bool, availability_notes, emergency_notes, created_at, updated_at)`

## **Change tracking & audit (reusable)**

* `change_log(change_id PK, table_name, record_pk, changed_by user_id, changed_at, change_area, changes_json)`  
   *(lets Admin see “can see change tracking” for Patient Info)*

* `audit_log(audit_id PK, user_id, action, table_name, record_pk, ts, meta_json)`  
   *(read events too)*

## **CSR notes**

* `csr_notes(note_id PK, patient_id FK, csr_user_id FK, note_text, created_at)`

## **Forms**

* `form_templates(form_template_id PK, name, version, pdf_uri)`

* `form_submissions(submission_id PK, patient_id, form_template_id, status, submitted_at, submitted_by)`

* `signatures(signature_id PK, submission_id, signee_role, signee_name, signed_at, sig_image_uri)`

* **For CSR**: create a view `v_form_status(patient_id, template_name, latest_status, last_updated)` with no PDF URIs.

## **Charting**

* `visits(visit_id PK, patient_id, nurse_id, scheduled_start, scheduled_end, actual_start, actual_end, status)`

* `chart_notes(note_id PK, patient_id, visit_id nullable, author_user_id, note_type(SOAP|progress|incident|wound), content, created_at, locked_at)`

* `care_plans(care_plan_id PK, patient_id, version, summary, goals, created_by, effective_from, effective_to, status)`

* `doctor_orders(order_id PK, patient_id, ordered_by, order_text, order_date, status)`

* `wound_photos(photo_id PK, patient_id, visit_id, uri, captured_at, notes)` *(store images in object storage; table stores URI only)*

## **Tasks & Schedule**

* `task_templates(task_template_id PK, name, default_due_offset, applies_to)`

* `tasks(task_id PK, patient_id nullable, visit_id nullable, assigned_to user_id, task_template_id nullable, title, due_at, status, completed_at, notes)`

* Use `visits` as the scheduling backbone; changes logged in `change_log`.

## **Time & Travel**

* `time_logs(time_log_id PK, nurse_user_id, visit_id nullable, clock_in, clock_out, notes)`

* `travel_logs(travel_id PK, nurse_user_id, from_location, to_location, depart_at, arrive_at, distance_km, auto_gps bool)`

* Optional payroll view `v_payroll_period(user_id, period, total_hours, total_miles)`

## **Supplies**

* `supply_items(item_id PK, name, type(med|equipment), uom)`

* `inventory(inventory_id PK, location_type(car_stock|warehouse|patient_home), location_ref_id, item_id, qty_on_hand)`

* `supply_orders(order_id PK, requested_by, patient_id nullable, dest_location_type, dest_ref_id, status, created_at)`

* `supply_order_lines(order_line_id PK, order_id FK, item_id FK, dose_or_size, quantity)`

## Security & HIPAA notes to bake in

* **RBAC \+ field-level filtering** in API (mask or omit sensitive fields for CSR/Patient).

* **Row-level security** (e.g., Nurse can only see *assigned* patients by default).

* **Encryption** at rest (column-level for SSN/insurance\_member\_id) and TLS in transit.

* **Immutable clinical notes** after `locked_at` to simulate finalization.

* **Comprehensive audit** (read \+ write).

* **PHI in logs**: never log PHI; use IDs in logs, details in DB only.

## Autosave & mobile-first UX (for your spec)

* Debounce **30s** while editing **and** save on blur/submit; show “Saved · 12:41 PM”.

* Optimistic UI updates with rollback if API fails.

* **Offline draft**: store unsent edits in local storage; retry on reconnect.

* Large touch targets (44px+), date/time pickers that don’t suck, persistent “Start/Stop” button for Time Logs.

## API endpoint sketch (helps your backend later)

* `/auth/*`, `/users/*`, `/roles/*`

* `/patients/index`, `/patients/{id}`, `/patients/{id}/phi` *(phi route admin/nurse only)*

* `/patients/{id}/emergency-contacts`, `/patients/{id}/emergency-contacts/{contact_id}`

* `/forms/templates`, `/forms/submissions`, `/forms/submissions/{id}/signatures`

* `/visits`, `/chart-notes`, `/care-plans`, `/doctor-orders`

* `/tasks`, `/task-templates`

* `/time-logs`, `/travel-logs`

* `/supplies/items`, `/supplies/orders`, `/supplies/inventory`

* `/audit`, `/changes`

## **Enhanced Patient Information Fields** *(Updated)*

Based on our UI mockups, the `patients_phi` table now includes:
- `marital_status` - for demographics section
- `primary_language` - for communication preferences  
- `mobile_phone` - separate from primary phone
- `preferred_contact_method` - phone, mobile, email
- `mailing_address` - separate from home address
- `access_instructions` - special notes for home visits (mobility limitations, upstairs apartment, etc.)
- `policy_holder` - insurance policy holder relationship
- `insurance_effective_date` - insurance start date
- `secondary_insurance` - secondary insurance plan name


## **Data Validation Rules** 

* Emergency contacts: Maximum 5 allowed per patient
* Phone numbers must be validated format
* Address fields follow standard US address validation
* SSN partial masking in UI (***-**-1234 format)