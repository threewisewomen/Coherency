-- Coherency App - PostgreSQL Initialization Script
-- This script creates all tables and seeds them with 3 rows of sample data.
-- Foreign key constraints are omitted for initial development setup.

-- =================================================================
-- Section 1: Authentication & User Management (Prompts 1.1 & 1.2)
-- =================================================================

-- Table: users (Prompt 1.1)
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    email TEXT UNIQUE NOT NULL,
    phone TEXT UNIQUE,
    password_hash TEXT NOT NULL,
    email_verified BOOLEAN DEFAULT FALSE,
    phone_verified BOOLEAN DEFAULT FALSE,
    role VARCHAR(50) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    last_login TIMESTAMP WITH TIME ZONE
);

INSERT INTO users (email, phone, password_hash, email_verified, phone_verified, role, last_login) VALUES
('patient@coherency.io', '1112223333', 'bcrypt_hash_patient', TRUE, TRUE, 'Patient', NOW() - INTERVAL '1 day'),
('doctor@coherency.io', '4445556666', 'bcrypt_hash_doctor', TRUE, TRUE, 'Doctor', NOW() - INTERVAL '2 hours'),
('admin@coherency.io', '7778889999', 'bcrypt_hash_admin', TRUE, FALSE, 'Admin', NOW());

-- Table: user_profiles (Prompt 1.1)
CREATE TABLE IF NOT EXISTS user_profiles (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    date_of_birth DATE,
    gender VARCHAR(50),
    profile_image TEXT,
    emergency_contact TEXT
);

INSERT INTO user_profiles (user_id, first_name, last_name, date_of_birth, gender, profile_image) VALUES
(1, 'John', 'Doe', '1990-05-15', 'Male', 'https://example.com/images/john.jpg'),
(2, 'Jane', 'Smith', '1985-08-20', 'Female', 'https://example.com/images/jane.jpg'),
(3, 'Super', 'Admin', '1980-01-01', 'Non-binary', 'https://example.com/images/admin.jpg');

-- Table: auth_tokens (Prompt 1.1)
CREATE TABLE IF NOT EXISTS auth_tokens (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    token TEXT NOT NULL,
    token_type VARCHAR(50) NOT NULL,
    expires_at TIMESTAMP WITH TIME ZONE,
    device_info TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

INSERT INTO auth_tokens (user_id, token, token_type, expires_at, device_info) VALUES
(1, 'fake_jwt_token_1', 'access', NOW() + INTERVAL '1 hour', 'Chrome on Windows'),
(2, 'fake_jwt_token_2', 'refresh', NOW() + INTERVAL '30 days', 'Safari on Mac'),
(3, 'fake_jwt_token_3', 'access', NOW() + INTERVAL '1 hour', 'Mobile App on Android');

-- Table: otp_verifications (Prompt 1.1)
CREATE TABLE IF NOT EXISTS otp_verifications (
    id SERIAL PRIMARY KEY,
    user_id INTEGER,
    otp_code VARCHAR(10) NOT NULL,
    purpose VARCHAR(100) NOT NULL,
    expires_at TIMESTAMP WITH TIME ZONE,
    verified BOOLEAN DEFAULT FALSE,
    attempts INTEGER DEFAULT 0
);

INSERT INTO otp_verifications (user_id, otp_code, purpose, expires_at, verified, attempts) VALUES
(1, '123456', 'phone_verification', NOW() + INTERVAL '10 minutes', FALSE, 1),
(2, '654321', 'password_reset', NOW() + INTERVAL '10 minutes', TRUE, 1),
(3, '987654', 'login_mfa', NOW() + INTERVAL '5 minutes', FALSE, 0);

-- Table: roles (Prompt 1.2)
CREATE TABLE IF NOT EXISTS roles (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    description TEXT,
    level INTEGER,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

INSERT INTO roles (name, description, level) VALUES
('Patient', 'Can view own medical records, book appointments.', 10),
('Doctor', 'Can view assigned patient records, manage appointments.', 50),
('Admin', 'Full system access.', 100);

-- Table: permissions (Prompt 1.2)
CREATE TABLE IF NOT EXISTS permissions (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    resource VARCHAR(100) NOT NULL,
    action VARCHAR(50) NOT NULL,
    description TEXT
);

INSERT INTO permissions (name, resource, action, description) VALUES
('read_own_record', 'medical_record', 'read', 'Allows a user to read their own medical record.'),
('write_patient_record', 'medical_record', 'write', 'Allows a doctor to write to an assigned patient record.'),
('manage_users', 'users', 'manage', 'Allows an admin to create, update, and delete users.');

-- Table: role_permissions (Prompt 1.2)
CREATE TABLE IF NOT EXISTS role_permissions (
    id SERIAL PRIMARY KEY,
    role_id INTEGER NOT NULL,
    permission_id INTEGER NOT NULL
);

INSERT INTO role_permissions (role_id, permission_id) VALUES
(1, 1),
(2, 2),
(3, 3);

-- Table: user_roles (Prompt 1.2)
CREATE TABLE IF NOT EXISTS user_roles (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    role_id INTEGER NOT NULL,
    assigned_by INTEGER,
    assigned_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    expires_at TIMESTAMP WITH TIME ZONE
);

INSERT INTO user_roles (user_id, role_id, assigned_by) VALUES
(1, 1, 3),
(2, 2, 3),
(3, 3, 3);

-- Table: permission_logs (Prompt 1.2)
CREATE TABLE IF NOT EXISTS permission_logs (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    permission VARCHAR(100) NOT NULL,
    resource_id VARCHAR(100),
    action VARCHAR(50) NOT NULL,
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

INSERT INTO permission_logs (user_id, permission, resource_id, action) VALUES
(2, 'write_patient_record', 'patient-123', 'update'),
(3, 'manage_users', 'user-456', 'delete'),
(1, 'read_own_record', 'patient-123', 'view');


-- =================================================================
-- Section 2: LiDAR Wound Detection System (Prompts 2.1 & 2.2)
-- =================================================================

-- Table: wounds (Prompt 2.1)
CREATE TABLE IF NOT EXISTS wounds (
    id SERIAL PRIMARY KEY,
    patient_id INTEGER NOT NULL,
    capture_date TIMESTAMP WITH TIME ZONE NOT NULL,
    wound_type VARCHAR(100),
    location_body VARCHAR(100),
    severity_level VARCHAR(50),
    lidar_data_url TEXT,
    images_urls TEXT[],
    measurements_json JSONB,
    status VARCHAR(50),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

INSERT INTO wounds (patient_id, capture_date, wound_type, location_body, severity_level, images_urls, status) VALUES
(1, NOW() - INTERVAL '2 days', 'Diabetic Ulcer', 'Left Foot', 'Moderate', '{"img1.jpg", "img2.jpg"}', 'Under Treatment'),
(1, NOW() - INTERVAL '1 day', 'Pressure Sore', 'Lower Back', 'Severe', '{"img3.jpg"}', 'Requires Attention'),
(1, NOW(), 'Surgical Wound', 'Abdomen', 'Mild', '{"img4.jpg", "img5.jpg"}', 'Healing');

-- Table: wound_measurements (Prompt 2.1)
CREATE TABLE IF NOT EXISTS wound_measurements (
    id SERIAL PRIMARY KEY,
    wound_id INTEGER NOT NULL,
    length_mm NUMERIC(10, 2),
    width_mm NUMERIC(10, 2),
    depth_mm NUMERIC(10, 2),
    area_sq_mm NUMERIC(10, 2),
    volume_cubic_mm NUMERIC(10, 2),
    perimeter_mm NUMERIC(10, 2),
    irregularity_score NUMERIC(5, 2),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

INSERT INTO wound_measurements (wound_id, length_mm, width_mm, depth_mm) VALUES
(1, 25.5, 15.0, 5.2),
(2, 40.0, 35.8, 10.5),
(3, 50.1, 8.2, 3.0);

-- Table: wound_tracking (Prompt 2.1)
CREATE TABLE IF NOT EXISTS wound_tracking (
    id SERIAL PRIMARY KEY,
    wound_id INTEGER NOT NULL,
    measurement_date DATE NOT NULL,
    healing_progress NUMERIC(5, 2),
    notes TEXT,
    images_urls TEXT[],
    measured_by INTEGER,
    treatment_applied TEXT,
    next_assessment_date DATE
);

INSERT INTO wound_tracking (wound_id, measurement_date, healing_progress, notes, measured_by) VALUES
(1, NOW(), 10.5, 'Slight improvement noted.', 2),
(2, NOW(), -2.0, 'Worsening of condition observed.', 2),
(3, NOW(), 25.0, 'Healing well, stitches intact.', 2);

-- Table: wound_analyses (Prompt 2.2)
CREATE TABLE IF NOT EXISTS wound_analyses (
    id SERIAL PRIMARY KEY,
    wound_id INTEGER NOT NULL,
    model_version VARCHAR(50),
    analysis_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    processing_time_ms INTEGER,
    wound_type_prediction JSONB,
    confidence_score NUMERIC(5, 4),
    severity_level VARCHAR(50),
    healing_stage VARCHAR(50),
    infection_risk NUMERIC(5, 2),
    treatment_recommendations JSONB,
    validated_by_doctor INTEGER,
    doctor_feedback TEXT,
    accuracy_score NUMERIC(5, 4)
);

INSERT INTO wound_analyses (wound_id, model_version, confidence_score, severity_level, infection_risk) VALUES
(1, 'v1.2.0', 0.98, 'Moderate', 15.5),
(2, 'v1.2.0', 0.92, 'Severe', 45.0),
(3, 'v1.2.1', 0.99, 'Mild', 5.0);

-- Table: ml_model_metrics (Prompt 2.2)
CREATE TABLE IF NOT EXISTS ml_model_metrics (
    id SERIAL PRIMARY KEY,
    model_version VARCHAR(50) UNIQUE NOT NULL,
    accuracy NUMERIC(5, 4),
    precision_val NUMERIC(5, 4),
    recall NUMERIC(5, 4),
    f1_score NUMERIC(5, 4),
    deployment_date DATE,
    performance_data JSONB,
    validation_dataset_size INTEGER
);

INSERT INTO ml_model_metrics (model_version, accuracy, precision_val, recall, f1_score, deployment_date) VALUES
('v1.2.0', 0.9512, 0.9433, 0.9601, 0.9516, '2023-10-01'),
('v1.2.1', 0.9605, 0.9587, 0.9655, 0.9621, '2023-11-15'),
('v1.1.0', 0.9240, 0.9100, 0.9300, 0.9200, '2023-08-01');

-- =================================================================
-- Section 3: Patient Management System (Prompts 3.1 & 3.2)
-- =================================================================

-- Table: patients (Prompt 3.1)
CREATE TABLE IF NOT EXISTS patients (
    id SERIAL PRIMARY KEY,
    user_id INTEGER UNIQUE NOT NULL,
    medical_record_number VARCHAR(100) UNIQUE,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    date_of_birth DATE,
    gender VARCHAR(50),
    blood_type VARCHAR(10),
    height NUMERIC(5,2),
    weight NUMERIC(5,2),
    phone TEXT,
    email TEXT,
    address TEXT,
    emergency_contact_name TEXT,
    emergency_contact_phone TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

INSERT INTO patients (user_id, medical_record_number, first_name, last_name, date_of_birth, blood_type) VALUES
(1, 'MRN001', 'John', 'Doe', '1990-05-15', 'O+'),
(4, 'MRN002', 'Alice', 'Wonder', '1988-02-20', 'A-'),
(5, 'MRN003', 'Bob', 'Builder', '1975-11-30', 'B+');


-- Table: medical_history (Prompt 3.1)
CREATE TABLE IF NOT EXISTS medical_history (
    id SERIAL PRIMARY KEY,
    patient_id INTEGER NOT NULL,
    condition_name TEXT,
    diagnosis_date DATE,
    status VARCHAR(100),
    severity VARCHAR(50),
    diagnosed_by TEXT,
    treatment_notes TEXT,
    resolution_date DATE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

INSERT INTO medical_history (patient_id, condition_name, diagnosis_date, status, severity) VALUES
(1, 'Type 2 Diabetes', '2018-06-10', 'Chronic', 'Moderate'),
(1, 'Hypertension', '2020-01-20', 'Managed', 'Mild'),
(4, 'Asthma', '2005-03-12', 'Chronic', 'Moderate');

-- Table: medications (Prompt 3.1)
CREATE TABLE IF NOT EXISTS medications (
    id SERIAL PRIMARY KEY,
    patient_id INTEGER NOT NULL,
    medication_name TEXT,
    dosage VARCHAR(100),
    frequency VARCHAR(100),
    start_date DATE,
    end_date DATE,
    prescribed_by TEXT,
    pharmacy TEXT,
    refill_date DATE,
    active_status BOOLEAN
);

INSERT INTO medications (patient_id, medication_name, dosage, frequency, active_status) VALUES
(1, 'Metformin', '500mg', 'Twice daily', TRUE),
(1, 'Lisinopril', '10mg', 'Once daily', TRUE),
(4, 'Albuterol Inhaler', '2 puffs', 'As needed', TRUE);

-- Table: vital_signs (Prompt 3.1)
CREATE TABLE IF NOT EXISTS vital_signs (
    id SERIAL PRIMARY KEY,
    patient_id INTEGER NOT NULL,
    measurement_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    blood_pressure_systolic INTEGER,
    blood_pressure_diastolic INTEGER,
    heart_rate INTEGER,
    temperature NUMERIC(4, 1),
    weight NUMERIC(5, 2),
    height NUMERIC(5, 2),
    oxygen_saturation NUMERIC(5, 2),
    recorded_by INTEGER
);

INSERT INTO vital_signs (patient_id, blood_pressure_systolic, blood_pressure_diastolic, heart_rate) VALUES
(1, 130, 85, 72),
(4, 120, 80, 68),
(5, 140, 90, 75);


-- Table: medical_documents (Prompt 3.2 - renamed from patient_documents)
CREATE TABLE IF NOT EXISTS medical_documents (
    id SERIAL PRIMARY KEY,
    patient_id INTEGER NOT NULL,
    category VARCHAR(100),
    subcategory VARCHAR(100),
    title TEXT,
    description TEXT,
    file_name TEXT,
    file_size BIGINT,
    file_type VARCHAR(50),
    file_url TEXT,
    upload_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    expiration_date DATE,
    tags TEXT[],
    ocr_extracted_text TEXT,
    processed_status VARCHAR(50)
);

INSERT INTO medical_documents (patient_id, category, title, file_name, file_url) VALUES
(1, 'Lab Result', 'Blood Test Results 2023', 'lab_results_2023.pdf', 's3://bucket/lab_results_2023.pdf'),
(1, 'Imaging', 'Chest X-Ray', 'chest_xray.dcm', 's3://bucket/chest_xray.dcm'),
(4, 'Prescription', 'Eye Glasses Prescription', 'glasses_rx.jpg', 's3://bucket/glasses_rx.jpg');


-- Table: document_shares (Prompt 3.2)
CREATE TABLE IF NOT EXISTS document_shares (
    id SERIAL PRIMARY KEY,
    document_id INTEGER NOT NULL,
    shared_with_type VARCHAR(50),
    shared_with_id INTEGER,
    permission_level VARCHAR(50),
    shared_by INTEGER,
    shared_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    expires_at TIMESTAMP WITH TIME ZONE,
    access_count INTEGER,
    last_accessed TIMESTAMP WITH TIME ZONE
);

INSERT INTO document_shares (document_id, shared_with_type, shared_with_id, permission_level, shared_by) VALUES
(1, 'Doctor', 2, 'read', 1),
(2, 'Doctor', 2, 'read', 1),
(3, 'Caregiver', 6, 'read-only', 4);

-- Table: document_annotations (Prompt 3.2)
CREATE TABLE IF NOT EXISTS document_annotations (
    id SERIAL PRIMARY KEY,
    document_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    annotation_type VARCHAR(50),
    coordinates JSONB,
    content TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

INSERT INTO document_annotations (document_id, user_id, annotation_type, content) VALUES
(1, 2, 'highlight', 'Note the high glucose level.'),
(2, 2, 'comment', 'Slight shadow on the left lung, monitor.'),
(1, 1, 'signature', 'Acknowledged by patient.');


-- =================================================================
-- Section 4: Hospital & Doctor Directory System (Prompts 4.1 & 4.2)
-- =================================================================

-- Table: hospitals (Prompt 4.1)
CREATE TABLE IF NOT EXISTS hospitals (
    id SERIAL PRIMARY KEY,
    name TEXT,
    type VARCHAR(100),
    address TEXT,
    latitude NUMERIC(9, 6),
    longitude NUMERIC(9, 6),
    phone TEXT,
    email TEXT,
    website TEXT,
    established_year INTEGER,
    bed_capacity INTEGER,
    emergency_services BOOLEAN,
    accreditation TEXT,
    ownership_type VARCHAR(100),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

INSERT INTO hospitals (name, type, address, latitude, longitude, emergency_services, bed_capacity) VALUES
('City General Hospital', 'General', '123 Main St, Anytown', 40.7128, -74.0060, TRUE, 500),
('Oak Valley Community Clinic', 'Clinic', '456 Oak Ave, Suburbia', 34.0522, -118.2437, FALSE, 20),
('St. Jude Children''s Hospital', 'Specialty', '789 Hope Ln, Healville', 35.1205, -89.9912, TRUE, 150);

-- Table: appointments (Prompt 4.2)
CREATE TABLE IF NOT EXISTS appointments (
    id SERIAL PRIMARY KEY,
    patient_id INTEGER NOT NULL,
    doctor_id INTEGER NOT NULL,
    hospital_id INTEGER,
    appointment_date DATE,
    appointment_time TIME,
    appointment_type VARCHAR(100),
    status VARCHAR(50),
    consultation_fee NUMERIC(10, 2),
    payment_status VARCHAR(50),
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    cancelled_at TIMESTAMP WITH TIME ZONE,
    cancellation_reason TEXT
);

INSERT INTO appointments (patient_id, doctor_id, hospital_id, appointment_date, appointment_time, appointment_type, status) VALUES
(1, 2, 1, NOW() + INTERVAL '5 days', '10:00:00', 'Follow-up', 'Confirmed'),
(4, 2, 1, NOW() + INTERVAL '6 days', '11:30:00', 'New Consultation', 'Confirmed'),
(5, 7, 2, NOW() + INTERVAL '1 week', '14:00:00', 'Annual Checkup', 'Pending');

-- =================================================================
-- Section 5: E-commerce Medicine & Products (Prompts 5.1 & 5.2)
-- =================================================================

-- Table: medicines (Prompt 5.1)
CREATE TABLE IF NOT EXISTS medicines (
    id SERIAL PRIMARY KEY,
    name TEXT,
    generic_name TEXT,
    brand_names TEXT[],
    manufacturer VARCHAR(255),
    strength VARCHAR(100),
    dosage_form VARCHAR(100),
    route_of_administration VARCHAR(100),
    therapeutic_class VARCHAR(255),
    prescription_required BOOLEAN,
    controlled_substance BOOLEAN,
    price NUMERIC(10, 2),
    availability INTEGER
);

INSERT INTO medicines (name, generic_name, manufacturer, strength, prescription_required, price) VALUES
('Tylenol', 'Acetaminophen', 'Johnson & Johnson', '500mg', FALSE, 9.99),
('Lisinopril', 'Lisinopril', 'Generic Pharma', '10mg', TRUE, 4.50),
('Amoxicillin', 'Amoxicillin', 'Sandoz', '250mg', TRUE, 15.75);

-- Table: orders (Prompt 5.2)
CREATE TABLE IF NOT EXISTS orders (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    order_number VARCHAR(100) UNIQUE,
    order_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    total_amount NUMERIC(12, 2),
    tax_amount NUMERIC(10, 2),
    shipping_amount NUMERIC(10, 2),
    discount_amount NUMERIC(10, 2),
    payment_method VARCHAR(100),
    payment_status VARCHAR(50),
    shipping_address TEXT,
    delivery_date DATE,
    delivery_time_slot VARCHAR(100),
    order_status VARCHAR(50)
);

INSERT INTO orders (user_id, order_number, total_amount, payment_status, order_status) VALUES
(1, 'ORD-2023-001', 25.50, 'Paid', 'Shipped'),
(4, 'ORD-2023-002', 120.00, 'Paid', 'Processing'),
(5, 'ORD-2023-003', 45.99, 'Pending', 'Awaiting Payment');


-- =================================================================
-- Section 6: Caregiver & Nanny Services (Prompts 6.1 & 6.2)
-- =================================================================

-- Table: caregivers (Prompt 6.1)
CREATE TABLE IF NOT EXISTS caregivers (
    id SERIAL PRIMARY KEY,
    user_id INTEGER UNIQUE NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    profile_image TEXT,
    date_of_birth DATE,
    gender VARCHAR(50),
    languages_spoken TEXT[],
    experience_years INTEGER,
    hourly_rate NUMERIC(10, 2),
    daily_rate NUMERIC(10, 2),
    background_check_status VARCHAR(50),
    certifications TEXT[],
    specializations TEXT[],
    bio TEXT
);

INSERT INTO caregivers (user_id, first_name, last_name, experience_years, hourly_rate, background_check_status) VALUES
(6, 'Emily', 'Carter', 5, 25.00, 'Verified'),
(7, 'Michael', 'Chen', 10, 35.00, 'Verified'),
(8, 'Sophia', 'Rodriguez', 3, 22.50, 'Pending');

-- Table: service_bookings (Prompt 6.2)
CREATE TABLE IF NOT EXISTS service_bookings (
    id SERIAL PRIMARY KEY,
    patient_id INTEGER NOT NULL,
    caregiver_id INTEGER NOT NULL,
    service_type VARCHAR(100),
    booking_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    service_date DATE,
    start_time TIME,
    end_time TIME,
    duration_hours NUMERIC(5, 2),
    hourly_rate NUMERIC(10, 2),
    total_cost NUMERIC(12, 2),
    service_location TEXT,
    special_requirements TEXT,
    booking_status VARCHAR(50)
);

INSERT INTO service_bookings (patient_id, caregiver_id, service_type, service_date, total_cost, booking_status) VALUES
(1, 6, 'Elderly Companion Care', '2023-12-25', 200.00, 'Confirmed'),
(4, 7, 'Post-Surgical Assistance', '2024-01-10', 560.00, 'Confirmed'),
(5, 8, 'Childcare', '2023-12-20', 90.00, 'Pending Approval');


-- =================================================================
-- Section 7: Payment Processing & Billing (Prompts 7.1 & 7.2)
-- =================================================================

-- Table: payments (Prompt 7.1)
CREATE TABLE IF NOT EXISTS payments (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    transaction_id TEXT,
    gateway_used VARCHAR(100),
    amount NUMERIC(12, 2),
    currency VARCHAR(10),
    payment_method TEXT,
    payment_status VARCHAR(50),
    transaction_type VARCHAR(100),
    reference_id TEXT,
    gateway_response JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    processed_at TIMESTAMP WITH TIME ZONE
);

INSERT INTO payments (user_id, transaction_id, gateway_used, amount, currency, payment_status, transaction_type) VALUES
(1, 'pi_123abc', 'Stripe', 25.50, 'USD', 'succeeded', 'Order'),
(4, 'pay_456def', 'Razorpay', 120.00, 'USD', 'succeeded', 'Order'),
(5, 'ch_789ghi', 'PayPal', 45.99, 'USD', 'failed', 'Order');

-- Table: invoices (Prompt 7.1)
CREATE TABLE IF NOT EXISTS invoices (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    invoice_number VARCHAR(100) UNIQUE,
    invoice_date DATE,
    due_date DATE,
    total_amount NUMERIC(12, 2),
    tax_amount NUMERIC(10, 2),
    discount_amount NUMERIC(10, 2),
    paid_amount NUMERIC(12, 2),
    balance_amount NUMERIC(12, 2),
    payment_status VARCHAR(50),
    invoice_type VARCHAR(100),
    service_details JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

INSERT INTO invoices (user_id, invoice_number, invoice_date, due_date, total_amount, payment_status) VALUES
(1, 'INV-2023-001', '2023-11-20', '2023-12-20', 150.00, 'Paid'),
(4, 'INV-2023-002', '2023-11-25', '2023-12-25', 300.00, 'Unpaid'),
(5, 'INV-2023-003', '2023-12-01', '2024-01-01', 75.50, 'Unpaid');


-- =================================================================
-- Section 8: Real-time Messaging & Communication (Prompts 8.1 & 8.2)
-- =================================================================

-- Table: conversations (Prompt 8.1)
CREATE TABLE IF NOT EXISTS conversations (
    id SERIAL PRIMARY KEY,
    conversation_type VARCHAR(50),
    participant_count INTEGER,
    created_by INTEGER,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    last_message_at TIMESTAMP WITH TIME ZONE,
    is_emergency BOOLEAN DEFAULT FALSE,
    conversation_name TEXT
);

INSERT INTO conversations (conversation_type, participant_count, created_by, is_emergency, conversation_name) VALUES
('one-on-one', 2, 1, FALSE, NULL),
('group', 3, 2, FALSE, 'Care Team for John Doe'),
('one-on-one', 2, 4, TRUE, 'Emergency Assistance');

-- Table: messages (Prompt 8.1)
CREATE TABLE IF NOT EXISTS messages (
    id BIGSERIAL PRIMARY KEY,
    conversation_id INTEGER NOT NULL,
    sender_id INTEGER NOT NULL,
    message_type VARCHAR(50),
    content TEXT,
    attachments JSONB,
    reply_to_message_id BIGINT,
    is_emergency BOOLEAN DEFAULT FALSE,
    encryption_key TEXT,
    sent_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    delivered_at TIMESTAMP WITH TIME ZONE,
    read_at TIMESTAMP WITH TIME ZONE
);

INSERT INTO messages (conversation_id, sender_id, message_type, content) VALUES
(1, 1, 'text', 'Hi Dr. Smith, I have a question about my medication.'),
(1, 2, 'text', 'Of course, John. What is it?'),
(2, 2, 'text', 'Team, please review the latest lab results for Mr. Doe.');


-- =================================================================
-- Section 9: Analytics & Reporting System (Prompts 9.1 & 9.2)
-- =================================================================

-- Table: analytics_events (Prompt 9.1)
CREATE TABLE IF NOT EXISTS analytics_events (
    id BIGSERIAL PRIMARY KEY,
    user_id INTEGER,
    event_type VARCHAR(100),
    event_category VARCHAR(100),
    event_properties JSONB,
    session_id TEXT,
    device_info JSONB,
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    ip_address INET,
    user_agent TEXT
);

INSERT INTO analytics_events (user_id, event_type, event_category) VALUES
(1, 'page_view', 'Dashboard'),
(2, 'click', 'Appointment'),
(3, 'report_generated', 'Admin');

-- Table: custom_reports (Prompt 9.1)
CREATE TABLE IF NOT EXISTS custom_reports (
    id SERIAL PRIMARY KEY,
    report_name TEXT,
    report_type VARCHAR(100),
    parameters JSONB,
    schedule VARCHAR(100),
    created_by INTEGER,
    last_run TIMESTAMP WITH TIME ZONE,
    next_run TIMESTAMP WITH TIME ZONE,
    output_format VARCHAR(50),
    recipients TEXT[]
);

INSERT INTO custom_reports (report_name, report_type, created_by, output_format) VALUES
('Monthly Revenue', 'Revenue', 3, 'PDF'),
('User Engagement', 'Users', 3, 'CSV'),
('Service Utilization', 'Services', 3, 'Excel');


-- =================================================================
-- Section 10: Notification & Alert System (Prompts 10.1 & 10.2)
-- =================================================================

-- Table: notifications (Prompt 10.1)
CREATE TABLE IF NOT EXISTS notifications (
    id BIGSERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    notification_type VARCHAR(100),
    title TEXT,
    message TEXT,
    data_payload JSONB,
    channels TEXT[],
    priority_level VARCHAR(50),
    scheduled_time TIMESTAMP WITH TIME ZONE,
    sent_time TIMESTAMP WITH TIME ZONE,
    delivery_status VARCHAR(50),
    read_at TIMESTAMP WITH TIME ZONE,
    action_taken VARCHAR(100),
    expires_at TIMESTAMP WITH TIME ZONE
);

INSERT INTO notifications (user_id, notification_type, title, message, channels) VALUES
(1, 'appointment_reminder', 'Upcoming Appointment', 'Your appointment is tomorrow at 10 AM.', '{"push", "email"}'),
(4, 'medication_reminder', 'Take Your Medication', 'Time to take your Albuterol inhaler.', '{"push", "sms"}'),
(2, 'new_message', 'New Message', 'You have a new message from a patient.', '{"push"}');

-- Table: health_alerts (Prompt 10.2)
CREATE TABLE IF NOT EXISTS health_alerts (
    id SERIAL PRIMARY KEY,
    patient_id INTEGER NOT NULL,
    alert_type VARCHAR(100),
    severity_level VARCHAR(50),
    threshold_value TEXT,
    current_value TEXT,
    alert_message TEXT,
    triggered_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    acknowledged_at TIMESTAMP WITH TIME ZONE,
    escalated_to INTEGER,
    resolution_time TIMESTAMP WITH TIME ZONE,
    resolution_notes TEXT
);

INSERT INTO health_alerts (patient_id, alert_type, severity_level, alert_message) VALUES
(1, 'High Blood Sugar', 'High', 'Blood glucose level is 250 mg/dL.'),
(4, 'Low Oxygen Saturation', 'Critical', 'Oxygen saturation dropped to 88%.'),
(5, 'High Blood Pressure', 'Medium', 'Blood pressure is 150/95 mmHg.');

-- Final message to confirm script completion in logs
\echo 'Coherency database initialization complete.'