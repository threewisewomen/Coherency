-- Coherency Health Platform - Master Database Initialization Script
-- Executed automatically by Docker on the first run of the PostgreSQL container.
-- =================================================================================

-- Enable UUID generation
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- =============================================================
-- SECTION 1: AUTHENTICATION & USER MANAGEMENT (Prompts 1.1, 1.2)
-- =============================================================

-- Define a user role ENUM type for data consistency
CREATE TYPE user_role_enum AS ENUM ('Patient', 'Doctor', 'Caregiver', 'Admin', 'Hospital Staff', 'Pharmacy Staff');

-- `users` table
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(50) UNIQUE,
    password_hash TEXT NOT NULL,
    email_verified BOOLEAN NOT NULL DEFAULT false,
    phone_verified BOOLEAN NOT NULL DEFAULT false,
    role user_role_enum NOT NULL DEFAULT 'Patient',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    last_login TIMESTAMPTZ
);
COMMENT ON TABLE users IS 'Core user accounts for login and authentication.';

-- Sample Data for `users`
INSERT INTO users (id, email, password_hash, role, email_verified, phone_verified) VALUES
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'patient@coherency.com', '$2a$12$DnaC82RAGcrLGwYDoTca9O2qDRVzylYvwY81rS2Bcyqf87IQlc1a.', 'Patient', true, true),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a12', 'doctor@coherency.com', '$2a$12$DnaC82RAGcrLGwYDoTca9O2qDRVzylYvwY81rS2Bcyqf87IQlc1a.', 'Doctor', true, true),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a13', 'admin@coherency.com', '$2a$12$DnaC82RAGcrLGwYDoTca9O2qDRVzylYvwY81rS2Bcyqf87IQlc1a.', 'Admin', true, true);


-- `user_profiles` table
CREATE TABLE user_profiles (
    user_id UUID PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    date_of_birth DATE,
    gender VARCHAR(20),
    profile_image_url TEXT,
    emergency_contact VARCHAR(100),
    CONSTRAINT fk_user FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE
);
COMMENT ON TABLE user_profiles IS 'Detailed profile information linked to a user account.';

-- Sample Data for `user_profiles`
INSERT INTO user_profiles (user_id, first_name, last_name, date_of_birth, gender) VALUES
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'John', 'Patient', '1985-05-15', 'Male'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a12', 'Alice', 'Doctor', '1978-11-20', 'Female'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a13', 'Eve', 'Admin', '1990-01-01', 'Female');


-- `auth_tokens` table for JWT session management
CREATE TABLE auth_tokens (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    token TEXT NOT NULL,
    token_type VARCHAR(50) NOT NULL, -- e.g., 'access', 'refresh'
    expires_at TIMESTAMPTZ NOT NULL,
    device_info TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
COMMENT ON TABLE auth_tokens IS 'Stores JWTs and refresh tokens for session management.';

-- Sample Data for `auth_tokens` (placeholders)
INSERT INTO auth_tokens (user_id, token, token_type, expires_at) VALUES
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'fake.access.token1', 'access', NOW() + INTERVAL '1 hour'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'fake.refresh.token1', 'refresh', NOW() + INTERVAL '30 days'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a12', 'fake.access.token2', 'access', NOW() + INTERVAL '1 hour');


-- `otp_verifications` table
CREATE TABLE otp_verifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    otp_code VARCHAR(10) NOT NULL,
    purpose VARCHAR(50) NOT NULL, -- 'phone_verification', 'password_reset'
    expires_at TIMESTAMPTZ NOT NULL,
    verified BOOLEAN NOT NULL DEFAULT false,
    attempts INT NOT NULL DEFAULT 0
);
COMMENT ON TABLE otp_verifications IS 'Stores one-time passwords for various verification purposes.';

-- Sample Data for `otp_verifications`
INSERT INTO otp_verifications (user_id, otp_code, purpose, expires_at) VALUES
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', '123456', 'phone_verification', NOW() + INTERVAL '10 minutes'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a12', '654321', 'password_reset', NOW() + INTERVAL '10 minutes'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a13', '987654', 'mfa_setup', NOW() + INTERVAL '10 minutes');

-- NOTE: RBAC tables like roles, permissions etc. are omitted for brevity in this MVP script.
-- They would follow a similar pattern if fully implemented from Prompt 1.2.

-- =============================================================
-- SECTION 2: LIDAR WOUND DETECTION (Prompts 2.1, 2.2)
-- =============================================================
CREATE TABLE wounds (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    patient_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    capture_date TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    wound_type VARCHAR(100),
    location_body VARCHAR(100),
    severity_level INT,
    lidar_data_url TEXT,
    images_urls JSONB, -- Store an array of image URLs
    measurements_json JSONB,
    status VARCHAR(50) DEFAULT 'Captured',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

INSERT INTO wounds (patient_id, wound_type, location_body, severity_level) VALUES
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'Diabetic Ulcer', 'Left foot, heel', 2),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'Pressure Sore', 'Sacrum', 3),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'Surgical Incision', 'Abdomen', 1);

CREATE TABLE wound_analyses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    wound_id UUID NOT NULL REFERENCES wounds(id) ON DELETE CASCADE,
    model_version VARCHAR(50) NOT NULL,
    analysis_date TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    processing_time_ms INT,
    wound_type_prediction JSONB,
    confidence_score DECIMAL(5, 4),
    severity_level INT,
    healing_stage VARCHAR(100),
    infection_risk DECIMAL(5, 4),
    treatment_recommendations JSONB,
    validated_by_doctor UUID REFERENCES users(id),
    doctor_feedback TEXT
);

INSERT INTO wound_analyses (wound_id, model_version, confidence_score, severity_level, validated_by_doctor) VALUES
((SELECT id FROM wounds WHERE location_body='Left foot, heel'), '1.2.0', 0.95, 2, 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a12'),
((SELECT id FROM wounds WHERE location_body='Sacrum'), '1.2.0', 0.88, 3, 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a12'),
((SELECT id FROM wounds WHERE location_body='Abdomen'), '1.1.5', 0.99, 1, 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a12');


-- =============================================================
-- SECTION 3: PATIENT MANAGEMENT SYSTEM (Prompts 3.1, 3.2)
-- =============================================================
-- This `patients` table is for *medical specific* records, linked to a user.
CREATE TABLE patients (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID UNIQUE NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    medical_record_number VARCHAR(100) UNIQUE,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender VARCHAR(50),
    blood_type VARCHAR(5),
    address TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
COMMENT ON TABLE patients IS 'Stores the official patient record, distinct from the login user.';

INSERT INTO patients (user_id, medical_record_number, first_name, last_name, date_of_birth, gender) VALUES
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'MRN-00001', 'John', 'Patient', '1985-05-15', 'Male'),
(gen_random_uuid(), 'MRN-00002', 'Jane', 'Doe', '1992-02-28', 'Female'),
(gen_random_uuid(), 'MRN-00003', 'Peter', 'Jones', '1954-07-10', 'Male');


CREATE TABLE medical_history (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    patient_id UUID NOT NULL REFERENCES patients(id) ON DELETE CASCADE,
    condition_name VARCHAR(255) NOT NULL,
    diagnosis_date DATE,
    status VARCHAR(100), -- 'Active', 'Resolved'
    severity VARCHAR(100), -- 'Mild', 'Moderate', 'Severe'
    treatment_notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

INSERT INTO medical_history (patient_id, condition_name, diagnosis_date, status, severity) VALUES
((SELECT id FROM patients WHERE medical_record_number='MRN-00001'), 'Type 2 Diabetes', '2010-06-20', 'Active', 'Moderate'),
((SELECT id FROM patients WHERE medical_record_number='MRN-00001'), 'Hypertension', '2012-01-15', 'Active', 'Mild'),
((SELECT id FROM patients WHERE medical_record_number='MRN-00001'), 'Appendectomy', '2005-03-01', 'Resolved', 'N/A');

-- Simplified `patient_documents` for this example
CREATE TABLE patient_documents (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    patient_id UUID NOT NULL REFERENCES patients(id) ON DELETE CASCADE,
    document_type VARCHAR(100),
    file_name VARCHAR(255) NOT NULL,
    file_url TEXT NOT NULL,
    upload_date TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    uploaded_by UUID REFERENCES users(id)
);

INSERT INTO patient_documents (patient_id, document_type, file_name, file_url, uploaded_by) VALUES
((SELECT id FROM patients WHERE medical_record_number='MRN-00001'), 'Lab Result', 'blood_work_2023.pdf', '/bucket/docs/blood_work_2023.pdf', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'),
((SELECT id FROM patients WHERE medical_record_number='MRN-00001'), 'Insurance Card', 'insurance_card.jpg', '/bucket/docs/insurance_card.jpg', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'),
((SELECT id FROM patients WHERE medical_record_number='MRN-00001'), 'X-Ray', 'left_foot_xray.dicom', '/bucket/docs/left_foot_xray.dicom', 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a12');


-- =============================================================
-- SECTION 4: DOCTOR & HOSPITAL DIRECTORY (Prompts 4.1, 4.2)
-- =============================================================

CREATE TABLE hospitals (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    type VARCHAR(100), -- 'General', 'Specialty', 'Clinic'
    address TEXT,
    latitude DECIMAL(9, 6),
    longitude DECIMAL(9, 6),
    phone VARCHAR(50),
    website TEXT
);

INSERT INTO hospitals (name, type, address, latitude, longitude) VALUES
('General Hospital', 'General', '123 Main St, Anytown, USA', 40.7128, -74.0060),
('Sacred Heart Medical Center', 'Specialty', '456 Oak Ave, Anytown, USA', 40.7138, -74.0070),
('Community Clinic', 'Clinic', '789 Pine Ln, Anytown, USA', 40.7148, -74.0080);

CREATE TABLE doctors (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID UNIQUE NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    license_number VARCHAR(100) UNIQUE NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    specialization VARCHAR(255) NOT NULL,
    consultation_fee DECIMAL(10, 2),
    hospital_affiliations JSONB -- Array of hospital IDs
);

INSERT INTO doctors (user_id, license_number, first_name, last_name, specialization, consultation_fee) VALUES
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a12', 'MD-00001', 'Alice', 'Doctor', 'Endocrinology', 150.00),
(gen_random_uuid(), 'MD-00002', 'Bob', 'Cardiologist', 'Cardiology', 250.00),
(gen_random_uuid(), 'MD-00003', 'Charlie', 'Dermatologist', 'Dermatology', 175.00);

CREATE TABLE appointments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    patient_id UUID NOT NULL REFERENCES patients(id) ON DELETE CASCADE,
    doctor_id UUID NOT NULL REFERENCES doctors(id) ON DELETE CASCADE,
    hospital_id UUID REFERENCES hospitals(id),
    appointment_time TIMESTAMPTZ NOT NULL,
    duration_minutes INT NOT NULL DEFAULT 30,
    appointment_type VARCHAR(100), -- 'Consultation', 'Follow-up'
    status VARCHAR(50) NOT NULL DEFAULT 'Scheduled', -- 'Scheduled', 'Completed', 'Cancelled'
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

INSERT INTO appointments (patient_id, doctor_id, appointment_time, appointment_type) VALUES
((SELECT id FROM patients WHERE medical_record_number='MRN-00001'), (SELECT id FROM doctors WHERE license_number='MD-00001'), NOW() + INTERVAL '3 days', 'Follow-up'),
((SELECT id FROM patients WHERE medical_record_number='MRN-00001'), (SELECT id FROM doctors WHERE license_number='MD-00003'), NOW() + INTERVAL '1 week', 'Consultation'),
((SELECT id FROM patients WHERE medical_record_number='MRN-00002'), (SELECT id FROM doctors WHERE license_number='MD-00002'), NOW() + INTERVAL '2 days', 'Consultation');


-- Further tables for e-commerce, caregivers, payments etc. would follow this same structure.
-- This foundational script provides the core functionality to start building against.

SELECT 'Database initialization complete.' AS status;