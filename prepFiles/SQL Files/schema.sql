-- Create the database
CREATE DATABASE IF NOT EXISTS comfycare;
USE comfycare;

-- Table for nurses (who log in and view patients)
CREATE TABLE nurse (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,  -- store a hashed password
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table for patients
CREATE TABLE patient (
  id INT AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  dob DATE,
  phone VARCHAR(20),
  address VARCHAR(255),
  notes TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table for visits (so nurses can log info per visit)
CREATE TABLE visit (
  id INT AUTO_INCREMENT PRIMARY KEY,
  patient_id INT NOT NULL,
  nurse_id INT NOT NULL,
  visit_date DATE NOT NULL,
  summary TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (patient_id) REFERENCES patient(id) ON DELETE CASCADE,
  FOREIGN KEY (nurse_id) REFERENCES nurse(id) ON DELETE CASCADE
);

-- Sample seed data
INSERT INTO nurse (name, email, password_hash)
VALUES
  ('Alice Johnson', 'alice@comfycouchcare.com', 'fakehash1'),
  ('Bob Smith', 'bob@comfycouchcare.com', 'fakehash2');

INSERT INTO patient (first_name, last_name, dob, phone, address, notes)
VALUES
  ('Jane', 'Doe', '1980-04-12', '555-1234', '123 Maple St', 'Diabetic, needs weekly checkups'),
  ('John', 'Smith', '1975-09-30', '555-5678', '456 Oak Ave', 'Recovering from knee surgery');

INSERT INTO visit (patient_id, nurse_id, visit_date, summary)
VALUES
  (1, 1, '2025-02-01', 'Routine checkup, vitals stable.'),
  (2, 2, '2025-02-03', 'Post-surgery follow-up, healing well.');
