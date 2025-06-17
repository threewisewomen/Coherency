# Coherency App Functionality Development Prompts

## 1. Authentication & User Management

### Prompt 1.1: User Registration & Login System
```
Create a complete Flutter authentication system for the Coherency medical app with the following requirements:

FRONTEND COMPONENTS:
- Registration screen with form validation (email, phone, password, confirm password, medical ID optional)
- Login screen with email/phone and password fields
- Forgot password screen with email/SMS reset options
- Phone OTP verification screen
- Biometric authentication setup screen
- Multi-factor authentication (MFA) screen

BACKEND APIS:
- POST /auth/register - User registration with email verification
- POST /auth/login - User login with JWT token response
- POST /auth/verify-phone - Phone number verification via OTP
- POST /auth/forgot-password - Password reset request
- POST /auth/reset-password - Password reset with token
- POST /auth/refresh-token - JWT token refresh
- POST /auth/logout - User logout and token invalidation
- GET /auth/profile - Get user profile information

DATABASE TABLES:
- users (id, email, phone, password_hash, email_verified, phone_verified, role, created_at, updated_at, last_login)
- user_profiles (user_id, first_name, last_name, date_of_birth, gender, profile_image, emergency_contact)
- auth_tokens (id, user_id, token, token_type, expires_at, device_info, created_at)
- otp_verifications (id, user_id, otp_code, purpose, expires_at, verified, attempts)

FORMS & VALIDATION:
- Email format validation with medical domain preferences
- Phone number international format validation
- Password strength requirements (8+ chars, symbols, numbers)
- Medical ID format validation (optional but structured)
- Terms and conditions acceptance
- Privacy policy acknowledgment

SECURITY FEATURES:
- JWT token with proper expiration and refresh mechanism
- Rate limiting on authentication endpoints
- Account lockout after failed attempts
- Secure password hashing (bcrypt)
- Device fingerprinting for security
- Audit logging for all authentication events

Include proper error handling, loading states, and responsive design. Implement BLoC pattern for state management.
```

### Prompt 1.2: Role-Based Access Control
```
Implement a comprehensive role-based access control (RBAC) system for Coherency with the following user roles and permissions:

USER ROLES:
1. Patient - Can view own medical records, book appointments, shop medicines
2. Doctor - Can view assigned patient records, manage appointments, prescribe medications
3. Caregiver - Can access patient care plans, update care records, communicate with family
4. Admin - Full system access, user management, analytics, system configuration
5. Hospital Staff - Manage hospital resources, appointments, patient check-ins
6. Pharmacy Staff - Manage prescriptions, inventory, order fulfillment

PERMISSION SYSTEM:
Create granular permissions for:
- Medical record access (read/write/delete)
- Appointment management (create/modify/cancel)
- Prescription handling (create/fulfill/modify)
- Payment processing (view/process/refund)
- System administration (user management/settings/analytics)

IMPLEMENTATION REQUIREMENTS:
- JWT tokens with role and permission claims
- Route guards in Flutter app based on user permissions
- Backend middleware for API endpoint protection
- Dynamic UI rendering based on user capabilities
- Permission inheritance and role hierarchies
- Audit trail for all permission-based actions

DATABASE SCHEMA:
- roles (id, name, description, level, created_at)
- permissions (id, name, resource, action, description)
- role_permissions (role_id, permission_id)
- user_roles (user_id, role_id, assigned_by, assigned_at, expires_at)
- permission_logs (user_id, permission, resource_id, action, timestamp)

Create Flutter widgets for role-based UI components and backend middleware for permission verification.
```

## 2. LiDAR Wound Detection System

### Prompt 2.1: LiDAR Integration & Data Capture
```
Develop a comprehensive LiDAR wound detection system for iOS and Android with the following specifications:

MOBILE IMPLEMENTATION:
- iOS: Integrate ARKit for LiDAR data capture using iPhone Pro models
- Android: Implement ToF sensor integration for supported devices
- Fallback to photogrammetry for devices without LiDAR
- Real-time point cloud visualization during capture
- Guided capture UI with proper positioning indicators

LIDAR DATA PROCESSING:
- Point cloud data capture and preprocessing
- Noise reduction and filtering algorithms
- 3D mesh generation from point cloud data
- Coordinate system calibration and normalization
- Data compression for efficient storage and transmission

FLUTTER COMPONENTS:
- Custom camera widget with LiDAR overlay
- 3D visualization widget for captured wound data
- Capture guidance interface with positioning assistance
- Data validation screens before submission
- Progress indicators for processing stages

BACKEND APIs:
- POST /wounds/capture - Upload LiDAR data and images
- GET /wounds/{id}/analysis - Retrieve wound analysis results
- POST /wounds/{id}/track - Add tracking measurement
- GET /wounds/patient/{patientId} - Get patient wound history
- PUT /wounds/{id}/annotations - Update wound annotations

DATABASE SCHEMA:
wounds:
- id, patient_id, capture_date, wound_type, location_body, severity_level
- lidar_data_url, images_urls, measurements_json, status, created_at

wound_measurements:
- id, wound_id, length_mm, width_mm, depth_mm, area_sq_mm, volume_cubic_mm
- perimeter_mm, irregularity_score, created_at

wound_tracking:
- id, wound_id, measurement_date, healing_progress, notes, images_urls
- measured_by, treatment_applied, next_assessment_date

AI/ML INTEGRATION:
- TensorFlow Lite models for on-device processing
- Cloud-based deep learning models for detailed analysis
- Wound classification algorithms (pressure sores, diabetic ulcers, cuts, burns)
- Healing progression tracking with ML predictions
- 3D reconstruction accuracy validation

TECHNICAL REQUIREMENTS:
- Optimize for battery life during LiDAR operations
- Handle large point cloud data efficiently
- Implement proper error handling for hardware failures
- Support offline capture with sync capabilities
- Medical-grade accuracy requirements and calibration

Include comprehensive testing for different lighting conditions and wound types.
```

### Prompt 2.2: AI Wound Analysis Engine
```
Create an advanced AI-powered wound analysis engine with machine learning capabilities:

ML MODEL ARCHITECTURE:
- Computer Vision models for wound classification and segmentation
- 3D point cloud analysis using PointNet++ architecture
- Multi-modal fusion of LiDAR data, RGB images, and thermal imaging
- Transfer learning from medical imaging datasets
- Ensemble methods for improved accuracy and reliability

WOUND ANALYSIS FEATURES:
- Automated wound type classification (diabetic ulcers, pressure sores, surgical wounds, burns, cuts)
- Wound severity assessment (mild, moderate, severe, critical)
- Healing stage identification (inflammatory, proliferative, maturation)
- Infection risk assessment based on visual and thermal indicators
- Treatment recommendations based on wound characteristics

BACKEND IMPLEMENTATION:
- Python FastAPI service for ML model serving
- TensorFlow/PyTorch model deployment with GPU acceleration
- Real-time inference pipeline with result caching
- Model versioning and A/B testing capabilities
- Batch processing for historical data analysis

APIs:
- POST /ai/analyze-wound - Submit wound data for AI analysis
- GET /ai/analysis/{analysisId} - Retrieve analysis results
- POST /ai/validate-analysis - Doctor validation of AI results
- GET /ai/models/performance - Model accuracy metrics
- POST /ai/retrain - Trigger model retraining with new data

DATABASE SCHEMA:
wound_analyses:
- id, wound_id, model_version, analysis_date, processing_time_ms
- wound_type_prediction, confidence_score, severity_level
- healing_stage, infection_risk, treatment_recommendations
- validated_by_doctor, doctor_feedback, accuracy_score

ml_model_metrics:
- id, model_version, accuracy, precision, recall, f1_score
- deployment_date, performance_data, validation_dataset_size

FLUTTER INTEGRATION:
- Real-time analysis progress indicators
- Interactive 3D wound visualization with analysis overlay
- Confidence score visualization and explanation
- Doctor override interface for AI suggestions
- Historical analysis comparison views

MEDICAL VALIDATION:
- Integration with doctor review workflow
- Confidence thresholds for automatic vs manual review
- Continuous learning from doctor corrections
- Medical literature integration for treatment recommendations
- Regulatory compliance for AI medical devices

Include proper error handling, model fallback mechanisms, and comprehensive logging for model performance monitoring.
```

## 3. Patient Management System

### Prompt 3.1: Comprehensive Patient Profile Management
```
Develop a complete patient management system with comprehensive medical record handling:

PATIENT PROFILE COMPONENTS:
- Personal information (demographics, contact details, emergency contacts)
- Medical history (chronic conditions, allergies, medications, surgeries)
- Insurance information and coverage details
- Family medical history and genetic predispositions
- Lifestyle factors (diet, exercise, smoking, alcohol consumption)
- Vital signs tracking (blood pressure, heart rate, temperature, weight)

FLUTTER SCREENS:
- Patient registration wizard with step-by-step data collection
- Profile dashboard with health summary and quick actions
- Medical history timeline with chronological view
- Medication tracker with dosage reminders and refill alerts
- Vital signs input forms with validation and trend analysis
- Emergency information quick access screen
- Document upload and management interface

BACKEND APIs:
- POST /patients - Create new patient profile
- GET /patients/{id} - Retrieve patient profile
- PUT /patients/{id} - Update patient information
- GET /patients/{id}/medical-history - Get medical history
- POST /patients/{id}/medical-history - Add medical history entry
- GET /patients/{id}/medications - Current medications list
- POST /patients/{id}/medications - Add new medication
- GET /patients/{id}/vitals - Vital signs history
- POST /patients/{id}/vitals - Record new vital signs
- GET /patients/{id}/documents - Medical documents list
- POST /patients/{id}/documents - Upload medical document

DATABASE SCHEMA:
patients:
- id, user_id, medical_record_number, first_name, last_name, date_of_birth
- gender, blood_type, height, weight, phone, email, address
- emergency_contact_name, emergency_contact_phone, created_at, updated_at

medical_history:
- id, patient_id, condition_name, diagnosis_date, status, severity
- diagnosed_by, treatment_notes, resolution_date, created_at

medications:
- id, patient_id, medication_name, dosage, frequency, start_date
- end_date, prescribed_by, pharmacy, refill_date, active_status

vital_signs:
- id, patient_id, measurement_date, blood_pressure_systolic, blood_pressure_diastolic
- heart_rate, temperature, weight, height, oxygen_saturation, recorded_by

patient_documents:
- id, patient_id, document_type, file_name, file_url, upload_date
- uploaded_by, description, tags, access_level

FORM VALIDATIONS:
- Medical record number format validation
- Date validations (birth date, medication dates)
- Vital signs range validations with medical thresholds
- Medication name validation against drug database
- Insurance information format validation
- Emergency contact validation requirements

FEATURES:
- Data export functionality for doctor visits
- Medical timeline visualization
- Medication interaction checking
- Health trend analysis and alerts
- Integration with wearable devices for automatic vital sign collection
- HIPAA-compliant data sharing with healthcare providers

Include comprehensive input validation, data encryption, and audit logging for all medical data operations.
```

### Prompt 3.2: Medical History & Document Management
```
Create a comprehensive medical document management system with advanced features:

DOCUMENT MANAGEMENT FEATURES:
- Medical document categorization (lab results, imaging, prescriptions, insurance)
- OCR integration for automatic text extraction from scanned documents
- Document version control and history tracking
- Secure sharing with healthcare providers
- Document expiration tracking and renewal reminders
- Advanced search and filtering capabilities

FLUTTER COMPONENTS:
- Document scanner with automatic edge detection
- Multi-page document compilation interface
- Document viewer with annotation capabilities
- Category-based organization with custom tags
- Shared document access management
- Document expiration alerts and reminders

BACKEND IMPLEMENTATION:
- File storage service with S3-compatible storage
- OCR service integration (AWS Textract/Google Cloud Vision)
- Document processing pipeline with queue management
- Metadata extraction and indexing
- Search service with full-text search capabilities
- Document sharing and permission management

APIs:
- POST /documents/upload - Upload new medical document
- GET /documents/{id} - Retrieve document details
- GET /documents/{id}/content - Download document file
- PUT /documents/{id}/metadata - Update document metadata
- POST /documents/{id}/share - Share document with healthcare provider
- GET /documents/search - Search documents with filters
- POST /documents/{id}/ocr - Extract text from document
- GET /documents/categories - Get document categories
- POST /documents/batch-upload - Upload multiple documents

DATABASE SCHEMA:
medical_documents:
- id, patient_id, category, subcategory, title, description
- file_name, file_size, file_type, file_url, upload_date
- expiration_date, tags, ocr_extracted_text, processed_status

document_shares:
- id, document_id, shared_with_type, shared_with_id, permission_level
- shared_by, shared_date, expires_at, access_count, last_accessed

document_annotations:
- id, document_id, user_id, annotation_type, coordinates
- content, created_at, updated_at

OCR PROCESSING:
- Automatic text extraction from medical reports
- Medical terminology recognition and highlighting
- Key information extraction (dates, medications, test results)
- Integration with medical coding systems (ICD-10, CPT)
- Confidence scoring for extracted information

SECURITY FEATURES:
- End-to-end encryption for sensitive documents
- Watermarking for shared documents
- Access logging and audit trails
- Permission-based document access
- Secure document deletion with verification

INTEGRATION FEATURES:
- Integration with healthcare provider systems
- Electronic Health Record (EHR) compatibility
- Medical imaging DICOM support
- Laboratory result integration
- Insurance claim document processing

Include proper file handling, progress indicators, and comprehensive error handling for all document operations.
```

## 4. Hospital & Doctor Directory System

### Prompt 4.1: Hospital Directory & Search
```
Develop a comprehensive hospital and healthcare provider directory system:

HOSPITAL DIRECTORY FEATURES:
- Comprehensive hospital database with detailed information
- Location-based search with radius filtering
- Specialization and service filtering
- Real-time availability and capacity information
- Rating and review system with verified patient feedback
- Insurance acceptance verification
- Emergency services availability status

FLUTTER COMPONENTS:
- Interactive map view with hospital markers
- Hospital detail pages with comprehensive information
- Advanced search and filter interface
- List view with sorting options (distance, rating, availability)
- Hospital comparison feature
- Reviews and ratings display
- Navigation integration with turn-by-turn directions

BACKEND APIs:
- GET /hospitals - Search hospitals with filters
- GET /hospitals/{id} - Get hospital details
- GET /hospitals/nearby - Find nearby hospitals by location
- GET /hospitals/{id}/departments - Hospital departments and services
- GET /hospitals/{id}/doctors - Doctors affiliated with hospital
- POST /hospitals/{id}/reviews - Submit hospital review
- GET /hospitals/{id}/reviews - Get hospital reviews
- GET /hospitals/{id}/availability - Real-time capacity information
- GET /hospitals/specializations - List of medical specializations

DATABASE SCHEMA:
hospitals:
- id, name, type, address, latitude, longitude, phone, email
- website, established_year, bed_capacity, emergency_services
- accreditation, ownership_type, created_at, updated_at

hospital_departments:
- id, hospital_id, department_name, head_of_department, contact_phone
- services_offered, operating_hours, emergency_available

hospital_specializations:
- id, hospital_id, specialization_name, certified, equipment_available
- specialists_count, success_rate, accreditation_details

hospital_reviews:
- id, hospital_id, patient_id, rating, review_text, service_type
- visit_date, verified_patient, helpful_count, created_at

hospital_insurance:
- id, hospital_id, insurance_provider, coverage_type, acceptance_status
- copay_amount, network_status, updated_at

SEARCH FEATURES:
- Geolocation-based search with distance calculation
- Multi-criteria filtering (specialty, insurance, rating, distance)
- Real-time search suggestions and auto-complete
- Voice search integration
- Favorite hospitals and recently viewed
- Emergency mode for urgent care facility finding

MAP INTEGRATION:
- Google Maps integration with custom markers
- Clustering for dense hospital areas
- Route optimization for multiple hospital visits
- Real-time traffic information
- Public transportation options
- Parking availability information

RATING SYSTEM:
- Multi-aspect rating (cleanliness, staff, facilities, wait time)
- Verified patient reviews only
- Review moderation and spam detection
- Photo uploads with reviews
- Response system for hospital management
- Trending and popular hospitals identification

Include offline capability for emergency situations and comprehensive caching for frequently accessed hospital data.
```

### Prompt 4.2: Doctor Profile & Appointment Booking
```
Create a comprehensive doctor profile and appointment booking system:

DOCTOR PROFILE FEATURES:
- Detailed doctor profiles with credentials and specializations
- Education and certification information
- Years of experience and patient satisfaction ratings
- Available appointment slots with real-time updates
- Consultation fees and insurance acceptance
- Languages spoken and communication preferences
- Telemedicine availability and platform integration

APPOINTMENT BOOKING SYSTEM:
- Real-time slot availability checking
- Multi-step booking process with confirmation
- Appointment types (consultation, follow-up, emergency)
- Recurring appointment scheduling
- Waitlist management for popular doctors
- Automatic reminder system (SMS, email, push notifications)
- Rescheduling and cancellation with policy enforcement

FLUTTER COMPONENTS:
- Doctor search and filter interface
- Doctor profile pages with comprehensive information
- Calendar-based appointment selection
- Booking confirmation and management screens
- Appointment history and upcoming appointments
- Rating and review system for doctors
- Telemedicine integration interface

BACKEND APIs:
- GET /doctors - Search doctors with filters
- GET /doctors/{id} - Get doctor profile details
- GET /doctors/{id}/availability - Get available appointment slots
- POST /appointments - Book new appointment
- GET /appointments/{id} - Get appointment details
- PUT /appointments/{id} - Reschedule appointment
- DELETE /appointments/{id} - Cancel appointment
- GET /patients/{id}/appointments - Patient appointment history
- POST /doctors/{id}/reviews - Submit doctor review
- GET /doctors/{id}/reviews - Get doctor reviews and ratings

DATABASE SCHEMA:
doctors:
- id, user_id, license_number, first_name, last_name, specialization
- sub_specialization, education, experience_years, consultation_fee
- languages_spoken, hospital_affiliations, telemedicine_available

doctor_availability:
- id, doctor_id, day_of_week, start_time, end_time, slot_duration
- max_appointments_per_slot, break_times, unavailable_dates

appointments:
- id, patient_id, doctor_id, hospital_id, appointment_date, appointment_time
- appointment_type, status, consultation_fee, payment_status
- notes, created_at, updated_at, cancelled_at, cancellation_reason

appointment_reminders:
- id, appointment_id, reminder_type, reminder_time, sent_status
- delivery_method, message_content, created_at

doctor_reviews:
- id, doctor_id, patient_id, appointment_id, rating, review_text
- communication_rating, expertise_rating, punctuality_rating
- would_recommend, verified_patient, created_at

BOOKING LOGIC:
- Slot availability checking with concurrent booking prevention
- Overbooking prevention with real-time validation
- Appointment buffer time configuration
- Emergency slot reservation system
- Waitlist management with automatic notification
- Recurring appointment pattern recognition

NOTIFICATION SYSTEM:
- Appointment confirmation notifications
- Reminder notifications (24 hours, 2 hours, 30 minutes before)
- Rescheduling and cancellation notifications
- Doctor availability change notifications
- Waitlist position updates
- Review request notifications post-appointment

PAYMENT INTEGRATION:
- Consultation fee calculation with taxes
- Multiple payment method support
- Advance payment for appointment booking
- Refund processing for cancellations
- Insurance claim integration
- Receipt generation and storage

TELEMEDICINE FEATURES:
- Video consultation platform integration
- Screen sharing capabilities for document review
- Prescription generation and digital signature
- Session recording with patient consent
- Follow-up scheduling from telemedicine sessions
- Technical support for connectivity issues

Include comprehensive validation for medical license verification, appointment conflict resolution, and proper handling of medical emergency situations.
```

## 5. E-commerce Medicine & Products

### Prompt 5.1: Medicine Catalog & Prescription Management
```
Develop a comprehensive medicine e-commerce platform with prescription management:

MEDICINE CATALOG FEATURES:
- Comprehensive drug database with detailed information
- Generic and brand name cross-referencing
- Drug interaction checking and warnings
- Dosage forms and strength variations
- Prescription requirement verification
- Price comparison across different manufacturers
- Availability tracking with pharmacy integration

PRESCRIPTION MANAGEMENT:
- Digital prescription upload and verification
- OCR-based prescription reading and validation
- Doctor prescription integration from appointments
- Prescription expiration tracking and renewal reminders
- Refill management with dosage tracking
- Insurance coverage verification for medications

FLUTTER COMPONENTS:
- Medicine search with auto-complete and suggestions
- Product detail pages with comprehensive drug information
- Prescription upload interface with camera integration
- Shopping cart with prescription verification
- Order tracking and delivery status
- Medicine reminder and refill alert system
- Drug interaction checker interface

BACKEND APIs:
- GET /medicines - Search medicines with filters
- GET /medicines/{id} - Get medicine details
- POST /prescriptions/upload - Upload prescription image
- GET /prescriptions/{id}/medicines - Get medicines from prescription
- POST /prescriptions/verify - Verify prescription authenticity
- GET /medicines/{id}/interactions - Check drug interactions
- POST /cart/add - Add medicine to cart
- GET /cart - Get current cart contents
- POST /orders - Place medicine order
- GET /orders/{id}/track - Track order status

DATABASE SCHEMA:
medicines:
- id, name, generic_name, brand_names, manufacturer, strength
- dosage_form, route_of_administration, therapeutic_class
- prescription_required, controlled_substance, price, availability

drug_interactions:
- id, medicine_id_1, medicine_id_2, interaction_type, severity_level
- clinical_significance, management_recommendation, reference_source

prescriptions:
- id, patient_id, doctor_id, prescription_date, expiry_date
- prescription_image_url, ocr_extracted_text, verification_status
- pharmacist_verified_by, verification_date, refill_count, max_refills

prescription_medicines:
- id, prescription_id, medicine_id, dosage, frequency, duration
- quantity_prescribed, quantity_dispensed, instructions, substitution_allowed

medicine_inventory:
- id, medicine_id, pharmacy_id, quantity_available, batch_number
- expiry_date, manufacturing_date, price, discount_percentage

PRESCRIPTION VERIFICATION:
- OCR integration for prescription text extraction
- Medical terminology recognition and validation
- Doctor signature verification
- Prescription format validation
- Cross-referencing with doctor appointment records
- Pharmacist verification workflow

DRUG SAFETY FEATURES:
- Allergy checking against patient medical history
- Drug interaction analysis with current medications
- Age and condition-based contraindication checking
- Pregnancy and breastfeeding safety categories
- Overdose prevention with dosage validation
- Side effect information and monitoring

INVENTORY MANAGEMENT:
- Real-time stock tracking across multiple pharmacies
- Expiry date monitoring and alerts
- Batch tracking for recalls and quality control
- Supplier integration for automatic reordering
- Price fluctuation tracking and alerts
- Geographic availability mapping

COMPLIANCE FEATURES:
- Controlled substance tracking and reporting
- Prescription audit trails for regulatory compliance
- Patient medication history maintenance
- Doctor prescription pattern analysis
- Pharmacy licensing verification
- FDA drug approval status tracking

Include proper handling of controlled substances, prescription privacy protection, and integration with pharmacy management systems.
```

### Prompt 5.2: Shopping Cart & Order Management
```
Create a comprehensive e-commerce shopping cart and order management system:

SHOPPING CART FEATURES:
- Persistent cart across devices and sessions
- Medicine quantity validation against prescription
- Alternative medicine suggestions for out-of-stock items
- Bulk ordering with quantity discounts
- Prescription requirement validation before checkout
- Cart sharing with family members or caregivers
- Saved cart templates for recurring orders

ORDER MANAGEMENT SYSTEM:
- Multi-step checkout process with validation
- Multiple payment method integration
- Prescription upload during checkout
- Delivery scheduling with time slot selection
- Order tracking with real-time updates
- Return and refund management
- Subscription orders for chronic medications

FLUTTER COMPONENTS:
- Interactive shopping cart with quantity adjustments
- Checkout flow with step-by-step progression
- Payment method selection and management
- Delivery address management with multiple addresses
- Order confirmation and receipt display
- Order history with detailed views
- Return and refund request interface

BACKEND APIs:
- POST /cart/items - Add item to cart
- PUT /cart/items/{id} - Update cart item quantity
- DELETE /cart/items/{id} - Remove item from cart
- GET /cart/summary - Get cart total and summary
- POST /checkout/validate - Validate cart before checkout
- POST /orders - Create new order
- GET /orders - Get user order history
- GET /orders/{id} - Get order details
- PUT /orders/{id}/cancel - Cancel order
- POST /orders/{id}/return - Request order return
- GET /orders/{id}/tracking - Get order tracking information

DATABASE SCHEMA:
shopping_carts:
- id, user_id, medicine_id, quantity, prescription_id, added_at
- unit_price, total_price, special_instructions, updated_at

orders:
- id, user_id, order_number, order_date, total_amount, tax_amount
- shipping_amount, discount_amount, payment_method, payment_status
- shipping_address, delivery_date, delivery_time_slot, order_status

order_items:
- id, order_id, medicine_id, quantity, unit_price, total_price
- prescription_id, substitution_made, substituted_medicine_id
- pharmacist_notes, dispensed_quantity

order_tracking:
- id, order_id, status, status_description, timestamp, location
- updated_by, tracking_notes, estimated_delivery_time

order_returns:
- id, order_id, return_reason, return_status, return_date
- refund_amount, return_tracking_number, processed_by, processed_date

PAYMENT PROCESSING:
- Multiple payment gateway integration (Razorpay, Stripe, PayPal)
- Secure tokenization of payment methods
- Recurring payment setup for subscriptions
- Insurance claim processing and co-pay calculation
- Wallet integration and loyalty points redemption
- EMI options for expensive medications

DELIVERY MANAGEMENT:
- Multiple delivery options (standard, express, same-day)
- Delivery time slot booking with capacity management
- GPS tracking for delivery personnel
- Proof of delivery with digital signature
- Special handling for temperature-sensitive medications
- Contactless delivery options

INVENTORY INTEGRATION:
- Real-time inventory checking during cart updates
- Automatic cart adjustment for out-of-stock items
- Alternative medicine suggestions with doctor approval
- Pharmacy location optimization for fastest delivery
- Back-order management with notification system
- Expiry date optimization for inventory rotation

SUBSCRIPTION MANAGEMENT:
- Recurring order setup for chronic medications
- Automatic prescription renewal reminders
- Flexible delivery scheduling for subscriptions
- Pause and resume subscription functionality
- Subscription modification and cancellation
- Predictive ordering based on usage patterns

COMPLIANCE AND SECURITY:
- PCI DSS compliance for payment processing
- HIPAA compliance for medical information
- Prescription verification before dispensing
- Age verification for restricted medications
- Geographic restrictions for controlled substances
- Audit logging for all transactions

Include comprehensive error handling, real-time validation, and proper integration with pharmacy management systems and delivery partners.
```

## 6. Caregiver & Nanny Services

### Prompt 6.1: Caregiver Profile & Matching System
```
Develop a comprehensive caregiver and nanny service platform with advanced matching algorithms:

CAREGIVER PROFILE SYSTEM:
- Detailed caregiver profiles with credentials and certifications
- Background check integration and verification status
- Skill set and specialization tracking (elderly care, child care, medical assistance)
- Experience history with previous client testimonials
- Availability scheduling with flexible time slots
- Rate setting with dynamic pricing based on demand
- Language preferences and cultural compatibility

MATCHING ALGORITHM:
- AI-powered matching based on patient needs and caregiver skills
- Location-based matching with travel time optimization
- Preference matching (gender, age, language, experience level)
- Availability synchronization and scheduling conflicts resolution
- Rating and review-based compatibility scoring
- Emergency caregiver matching for urgent needs
- Backup caregiver assignment for reliability

FLUTTER COMPONENTS:
- Caregiver search and filter interface
- Detailed caregiver profile pages with photo galleries
- Matching preferences setup wizard
- Booking calendar with availability visualization
- Real-time chat system for client-caregiver communication
- Rating and review system with photo uploads
- Emergency caregiver request interface

BACKEND APIs:
- GET /caregivers - Search caregivers with filters
- GET /caregivers/{id} - Get caregiver profile details
- POST /caregivers/match - Find matching caregivers for patient needs
- GET /caregivers/{id}/availability - Get caregiver availability
- POST /bookings - Book caregiver services
- GET /bookings/{id} - Get booking details
- PUT /bookings/{id} - Modify booking
- POST /caregivers/{id}/reviews - Submit caregiver review
- GET /messages/{conversationId} - Get conversation messages
- POST /emergency-requests - Request emergency caregiver

DATABASE SCHEMA:
caregivers:
- id, user_id, first_name, last_name, profile_image, date_of_birth
- gender, languages_spoken, experience_years, hourly_rate, daily_rate
- background_check_status, certifications, specializations, bio

caregiver_skills:
- id, caregiver_id, skill_name, proficiency_level, certified
- certification_body, certification_date, expiry_date

caregiver_availability:
- id, caregiver_id, day_of_week, start_time, end_time, available
- recurring_schedule, exception_dates, last_updated

service_bookings:
- id, patient_id, caregiver_id, service_type, start_date, end_date
- start_time, end_time, hourly_rate, total_amount, booking_status
- special_instructions, created_at, confirmed_at

caregiver_reviews:
- id, caregiver_id, patient_id, booking_id, overall_rating
- punctuality_rating, skill_rating, communication_rating
- review_text, would_recommend, verified_booking, created_at

patient_preferences:
- id, patient_id, preferred_gender, preferred_age_range, preferred_languages
- required_skills, care_level_needed, mobility_assistance_needed
- medical_conditions_experience, personality_preferences

MATCHING FEATURES:
- Machine learning-based compatibility scoring
- Geographic proximity optimization with traffic consideration
- Skill requirement matching with weighted importance
- Cultural and language preference alignment
- Schedule compatibility analysis
- Price range matching and negotiation support
- Previous client satisfaction prediction

BACKGROUND VERIFICATION:
- Criminal background check integration
- Professional reference verification
- Certification and license validation
- Identity verification with government documents
- Previous employer verification
- Medical fitness certification
- Insurance coverage verification

SERVICE TYPES:
- Companion care for elderly patients
- Medical assistance and medication management
- Personal care assistance (bathing, grooming, mobility)
- Childcare and nanny services
- Post-surgical recovery assistance
- Respite care for family caregivers
- Overnight care and live-in services

SAFETY FEATURES:
- Real-time location tracking during service hours
- Emergency alert system for caregivers and patients
- Check-in/check-out system with timestamp verification
- Family member notification system
- Incident reporting and documentation
- 24/7 support hotline for emergencies

Include comprehensive screening processes, insurance integration, and proper handling of sensitive medical information.
```

### Prompt 6.2: Service Booking & Management
```
Create a comprehensive service booking and management system for caregiver services:

BOOKING MANAGEMENT FEATURES:
- Flexible scheduling with recurring appointment options
- Multi-caregiver coordination for complex care needs
- Substitute caregiver assignment for coverage gaps
- Service modification and cancellation policies
- Emergency booking with rapid response protocols
- Family member access and approval workflows
- Insurance pre-authorization and claim processing

SERVICE TRACKING SYSTEM:
- Real-time service delivery tracking and monitoring
- Task completion verification with digital signatures
- Time tracking with GPS location verification
- Service quality monitoring through periodic check-ins
- Incident reporting and resolution tracking
- Care plan adherence monitoring and reporting
- Communication logs between all parties

FLUTTER COMPONENTS:
- Service booking wizard with detailed needs assessment
- Calendar-based scheduling interface with multiple view options
- Real-time service tracking dashboard
- Communication hub for all stakeholders
- Service history and care progress tracking
- Emergency request interface with one-touch activation
- Family member coordination and notification system

BACKEND APIs:
- POST /services/book - Book caregiver service
- GET /services/{id} - Get service booking details
- PUT /services/{id} - Modify service booking
- DELETE /services/{id} - Cancel service booking
- POST /services/{id}/check-in - Caregiver check-in
- POST /services/{id}/check-out - Caregiver check-out
- GET /services/{id}/tracking - Get real-time service tracking
- POST /services/{id}/incidents - Report service incident
- GET /services/history - Get service history
- POST /services/{id}/feedback - Submit service feedback

DATABASE SCHEMA:
service_bookings:
- id, patient_id, caregiver_id, service_type, booking_date, service_date
- start_time, end_time, duration_hours, hourly_rate, total_cost
- service_location, special_requirements, booking_status, created_at

service_sessions:
- id, booking_id, caregiver_id, actual_start_time, actual_end_time
- check_in_location, check_out_location, total_duration, overtime_hours
- session_notes, tasks_completed, patient_condition_notes

care_tasks:
- id, session_id, task_type, task_description, completion_status
- completion_time, notes, verification_method, completed_by

service_incidents:
- id, session_id, incident_type, incident_description, severity_level
- reported_by, reported_at, resolution_status, resolution_notes
- follow_up_required, escalated_to, resolved_at

family_notifications:
- id, service_id, notification_type, recipient_id, message_content
- sent_at, delivery_status, read_at, response_required

REAL-TIME TRACKING:
- GPS location tracking for caregivers during service hours
- Geofencing alerts for arrival and departure verification
- Activity monitoring through mobile app interactions
- Automatic time tracking with manual override capabilities
- Photo documentation of care activities (with consent)
- Medication administration tracking and verification

QUALITY ASSURANCE:
- Random quality check calls during service delivery
- Post-service satisfaction surveys for patients and families
- Performance metrics tracking for caregivers
- Compliance monitoring for care plan adherence
- Regular supervision and evaluation processes
- Continuous improvement feedback loops

PAYMENT AND BILLING:
- Automatic billing based on actual service hours
- Overtime calculation and approval workflows
- Insurance claim generation and submission
- Multiple payment method support with recurring billing
- Transparent pricing with no hidden fees
- Tip and bonus payment processing

COMMUNICATION SYSTEM:
- Secure messaging between patients, caregivers, and families
- Video calling capabilities for remote consultations
- Group chat functionality for care team coordination
- Document sharing for care plans and medical information
- Translation services for multilingual communication
- Emergency communication protocols

SCHEDULING FEATURES:
- Intelligent scheduling to optimize caregiver routes
- Recurring service pattern recognition and automation
- Holiday and special event scheduling adjustments
- Last-minute booking availability with premium pricing
- Caregiver schedule conflict resolution
- Patient preference learning and adaptation

REPORTING AND ANALYTICS:
- Detailed service reports for insurance and medical providers
- Care progress tracking with visual dashboards
- Medication adherence and health metric monitoring
- Service utilization analysis and optimization recommendations
- Cost analysis and budget planning tools
- Regulatory compliance reporting

Include proper integration with healthcare systems, insurance providers, and emergency services for comprehensive care coordination.
```

## 7. Payment Processing & Billing

### Prompt 7.1: Multi-Gateway Payment System
```
Develop a comprehensive payment processing system with multiple gateway integration:

PAYMENT GATEWAY INTEGRATION:
- Multiple gateway support (Razorpay, Stripe, PayPal, PhonePe, Google Pay)
- Gateway selection based on transaction type and amount
- Automatic fallback to secondary gateways on failure
- Currency conversion and international payment support
- Wallet integration (Paytm, Amazon Pay, Apple Pay, Google Pay)
- Bank transfer and UPI integration for Indian market
- Cryptocurrency payment option for privacy-conscious users

PAYMENT FEATURES:
- One-time payments for appointments and services
- Recurring payments for subscriptions and care plans
- Split payments for insurance co-pays and deductibles
- Escrow system for service-based transactions
- Refund processing with partial and full refund options
- Payment scheduling and installment plans
- Multi-currency support with real-time exchange rates

FLUTTER COMPONENTS:
- Payment method selection with saved payment options
- Secure payment form with PCI compliance
- Payment confirmation and receipt display
- Transaction history with detailed breakdowns
- Refund request interface with reason selection
- Payment dispute resolution interface
- Wallet and loyalty points management

BACKEND APIs:
- POST /payments/process - Process payment transaction
- GET /payments/{id} - Get payment details
- POST /payments/{id}/refund - Process refund
- GET /payments/methods - Get saved payment methods
- POST /payments/methods - Add new payment method
- DELETE /payments/methods/{id} - Remove payment method
- GET /payments/history - Get payment history
- POST /payments/disputes - File payment dispute
- GET /billing/invoices - Get billing invoices
- POST /billing/generate - Generate invoice

DATABASE SCHEMA:
payments:
- id, user_id, transaction_id, gateway_used, amount, currency
- payment_method, payment_status, transaction_type, reference_id
- gateway_response, created_at, processed_at, failed_reason

payment_methods:
- id, user_id, method_type, card_last_four, expiry_date
- bank_name, is_default, is_verified, created_at, last_used

transactions:
- id, payment_id, transaction_type, amount, description
- service_type, service_id, tax_amount, discount_amount
- final_amount, currency, exchange_rate, created_at

refunds:
- id, payment_id, refund_amount, refund_reason, refund_status
- requested_by, requested_at, processed_at, gateway_refund_id
- refund_method, processing_fee, net_refund_amount


invoices:
- id, user_id, invoice_number, invoice_date, due_date, total_amount
- tax_amount, discount_amount, paid_amount, balance_amount
- payment_status, invoice_type, service_details, created_at

payment_disputes:
- id, payment_id, dispute_reason, dispute_amount, dispute_status
- filed_by, filed_at, evidence_documents, resolution_notes
- resolved_by, resolved_at, resolution_amount

SECURITY FEATURES:
- PCI DSS compliance for card data handling
- Payment tokenization for secure storage
- Fraud detection and prevention algorithms
- Two-factor authentication for high-value transactions
- Real-time transaction monitoring and alerts
- Secure API endpoints with rate limiting
- Payment data encryption at rest and in transit

BILLING FEATURES:
- Automatic invoice generation for services
- Subscription billing with prorated charges
- Usage-based billing for variable services
- Tax calculation based on location and service type
- Discount and coupon code application
- Late payment fee calculation and application
- Bulk billing for corporate accounts

FINANCIAL REPORTING:
- Real-time transaction monitoring and reporting
- Revenue analytics with trend analysis
- Payment success rate optimization
- Gateway performance comparison
- Customer payment behavior analysis
- Tax reporting and compliance
- Financial reconciliation and settlement tracking

COMPLIANCE AND REGULATIONS:
- GDPR compliance for European customers
- PCI DSS Level 1 compliance
- SOX compliance for financial reporting
- Local banking regulations compliance
- Anti-money laundering (AML) checks
- Know Your Customer (KYC) verification
- Regulatory reporting and audit trails

Include proper error handling, retry mechanisms, and comprehensive logging for all payment operations.
```

### Prompt 7.2: Billing & Invoice Management
```
Create a comprehensive billing and invoice management system:

BILLING SYSTEM FEATURES:
- Automated billing cycles for different service types
- Prorated billing for mid-cycle service changes
- Usage-based billing with tiered pricing models
- Subscription management with upgrade/downgrade options
- Corporate billing with multiple payment methods
- Tax calculation based on location and regulations
- Discount and promotional code management

INVOICE GENERATION:
- Professional invoice templates with branding
- Automatic invoice generation based on service usage
- Bulk invoice processing for multiple services
- Recurring invoice scheduling and automation
- Invoice customization for different service types
- Multi-language invoice support
- PDF generation with digital signatures

FLUTTER COMPONENTS:
- Billing dashboard with payment status overview
- Invoice list with filtering and search capabilities
- Invoice detail view with payment options
- Payment history with transaction details
- Subscription management interface
- Billing address management
- Tax exemption certificate upload

BACKEND APIs:
- GET /billing/summary - Get billing summary for user
- GET /billing/invoices - Get invoice list with filters
- GET /billing/invoices/{id} - Get specific invoice details
- POST /billing/invoices/{id}/pay - Pay invoice
- GET /billing/subscriptions - Get active subscriptions
- PUT /billing/subscriptions/{id} - Update subscription
- POST /billing/tax-exemptions - Submit tax exemption
- GET /billing/payment-methods - Get payment methods
- POST /billing/disputes/{invoiceId} - Dispute invoice
- GET /billing/reports - Generate billing reports

DATABASE SCHEMA:
billing_accounts:
- id, user_id, account_type, billing_address, tax_id
- payment_terms, credit_limit, account_status, created_at

subscriptions:
- id, user_id, service_type, plan_name, billing_cycle
- start_date, end_date, renewal_date, amount, status
- auto_renewal, next_billing_date, created_at

usage_records:
- id, user_id, service_type, usage_date, quantity_used
- unit_price, total_amount, billing_period, recorded_at

tax_configurations:
- id, location, tax_type, tax_rate, applicable_services
- tax_authority, tax_code, effective_date, expiry_date

promotional_codes:
- id, code, discount_type, discount_value, min_amount
- max_uses, current_uses, valid_from, valid_until
- applicable_services, user_restrictions, created_by

BILLING AUTOMATION:
- Automated billing cycle processing
- Dunning management for overdue accounts
- Payment retry logic for failed transactions
- Automatic service suspend/resume based on payment status
- Revenue recognition and accrual accounting
- Automated tax calculation and reporting

PAYMENT COLLECTION:
- Multiple payment attempt strategies
- Payment reminder notifications
- Grace period management for services
- Collection agency integration for severely overdue accounts
- Payment plan setup for large outstanding amounts
- Automatic payment method updates from card issuers

FINANCIAL COMPLIANCE:
- SOX compliance for financial reporting
- GAAP compliance for revenue recognition
- Tax compliance for multiple jurisdictions
- Automated regulatory reporting
- Financial audit trail maintenance
- Anti-fraud monitoring and reporting

Include comprehensive error handling, audit logging, and integration with accounting systems.
```

## 8. Real-time Messaging & Communication

### Prompt 8.1: In-App Messaging System
```
Develop a comprehensive real-time messaging system for healthcare communication:

MESSAGING FEATURES:
- One-on-one messaging between patients, doctors, and caregivers
- Group messaging for care teams and family members
- Medical consultation chat with appointment integration
- Emergency messaging with priority alerts
- File sharing for medical documents and images
- Voice messaging for detailed explanations
- Video calling integration for remote consultations

REAL-TIME COMMUNICATION:
- WebSocket implementation for instant messaging
- Push notifications for new messages and alerts
- Offline message queuing and synchronization
- Message encryption for medical privacy
- Read receipts and delivery confirmations
- Typing indicators and online status
- Message threading for organized conversations

FLUTTER COMPONENTS:
- Chat interface with medical-specific features
- Contact list with role-based organization
- Message composition with rich text and attachments
- Video call interface with screen sharing
- Emergency alert system with one-touch activation
- Conversation history with search capabilities
- Message encryption status indicators

BACKEND APIs:
- WebSocket /ws/messages - Real-time message handling
- GET /messages/conversations - Get conversation list
- GET /messages/conversations/{id} - Get conversation messages
- POST /messages/send - Send new message
- PUT /messages/{id}/read - Mark message as read
- POST /messages/groups - Create group conversation
- POST /messages/emergency - Send emergency message
- GET /messages/search - Search messages
- POST /calls/initiate - Initiate video call
- POST /calls/{id}/end - End video call

DATABASE SCHEMA:
conversations:
- id, conversation_type, participant_count, created_by
- created_at, last_message_at, is_emergency, conversation_name

conversation_participants:
- id, conversation_id, user_id, role, joined_at
- left_at, is_active, notification_settings, permissions

messages:
- id, conversation_id, sender_id, message_type, content
- attachments, reply_to_message_id, is_emergency, encryption_key
- sent_at, delivered_at, read_at, edited_at

message_attachments:
- id, message_id, file_name, file_type, file_size
- file_url, thumbnail_url, encryption_status, uploaded_at

video_calls:
- id, conversation_id, initiated_by, call_type, start_time
- end_time, duration, participants, recording_url
- call_quality_metrics, ended_by, call_status

SECURITY FEATURES:
- End-to-end encryption for sensitive medical communications
- Message retention policies based on content type
- Secure file transfer with virus scanning
- Access control based on user roles and relationships
- Audit logging for all communications
- HIPAA compliance for medical conversations

EMERGENCY FEATURES:
- Instant emergency alert system
- Location sharing for emergency situations
- Automated emergency contact notification
- Priority message delivery for urgent communications
- Emergency broadcast to multiple recipients
- Integration with emergency services

MEDICAL INTEGRATION:
- Integration with appointment booking system
- Prescription sharing through secure messaging
- Lab result sharing with automatic notifications
- Care plan updates and notifications
- Medical record sharing with proper permissions
- Telemedicine session scheduling through chat

NOTIFICATION SYSTEM:
- Smart notification filtering based on message importance
- Do-not-disturb settings with emergency override
- Customizable notification sounds for different message types
- Badge count management for unread messages
- Email notification fallback for critical messages
- Notification scheduling based on user preferences

Include proper WebSocket handling, message queuing, and comprehensive security measures for medical communication.
```

### Prompt 8.2: Video Consultation Platform
```
Create a comprehensive video consultation platform integrated with the messaging system:

VIDEO CONSULTATION FEATURES:
- High-quality video calling with adaptive bitrate
- Screen sharing for document and test result review
- Virtual waiting room with queue management
- Recording capabilities with patient consent
- Multi-participant calls for family consultations
- Breakout rooms for private discussions
- Real-time chat during video sessions

TELEMEDICINE INTEGRATION:
- Appointment scheduling directly from video interface
- Digital prescription generation during consultation
- Vital sign monitoring integration with wearable devices
- Electronic health record access during calls
- Payment processing for consultation fees
- Insurance verification and coverage checking
- Follow-up appointment scheduling

FLUTTER COMPONENTS:
- Video call interface with medical-specific controls
- Virtual waiting room with queue position display
- Consultation booking interface with doctor availability
- Recording consent and management interface
- Screen sharing control panel
- Prescription review and approval interface
- Post-consultation feedback and rating system

BACKEND APIs:
- POST /consultations/schedule - Schedule consultation
- GET /consultations/{id} - Get consultation details
- POST /consultations/{id}/start - Start video consultation
- POST /consultations/{id}/end - End consultation
- GET /consultations/waiting-room/{id} - Join waiting room
- POST /consultations/{id}/record - Start/stop recording
- POST /consultations/{id}/prescription - Generate prescription
- GET /consultations/history - Get consultation history
- POST /consultations/{id}/feedback - Submit feedback
- GET /doctors/availability - Check doctor availability

DATABASE SCHEMA:
consultations:
- id, patient_id, doctor_id, scheduled_time, actual_start_time
- actual_end_time, consultation_type, status, recording_url
- consultation_fee, payment_status, prescription_generated

consultation_participants:
- id, consultation_id, participant_id, participant_role
- joined_at, left_at, connection_quality, device_info

consultation_recordings:
- id, consultation_id, recording_start_time, recording_end_time
- file_url, file_size, encryption_key, consent_obtained
- retention_period, auto_delete_date

digital_prescriptions:
- id, consultation_id, patient_id, doctor_id, generated_at
- prescription_data, digital_signature, verification_code
- validity_period, dispensed_status, pharmacy_id

waiting_room:
- id, consultation_id, patient_id, queue_position
- estimated_wait_time, joined_at, notified_at, status

TECHNICAL IMPLEMENTATION:
- WebRTC integration for peer-to-peer video communication
- STUN/TURN servers for NAT traversal
- Adaptive bitrate streaming based on connection quality
- Echo cancellation and noise reduction
- Bandwidth optimization for mobile networks
- Fallback to audio-only for poor connections

QUALITY ASSURANCE:
- Connection quality monitoring and reporting
- Automatic reconnection for dropped calls
- Bandwidth usage optimization
- Device compatibility testing
- Performance metrics tracking
- User experience optimization

SECURITY FEATURES:
- End-to-end encryption for video streams
- Secure recording storage with access controls
- HIPAA compliance for video consultations
- Watermarking for recorded sessions
- Participant authentication and verification
- Audit logging for all consultation activities

ACCESSIBILITY FEATURES:
- Closed captioning for hearing-impaired users
- High contrast mode for visually impaired users
- Keyboard navigation support
- Voice commands for hands-free operation
- Multi-language support for international users
- Sign language interpreter integration

INTEGRATION FEATURES:
- Integration with hospital management systems
- EHR integration for patient data access
- Pharmacy integration for prescription fulfillment
- Insurance system integration for claim processing
- Calendar integration for appointment management
- Billing system integration for automatic invoicing

Include proper error handling, connection monitoring, and comprehensive logging for all video consultation activities.
```

## 9. Analytics & Reporting System

### Prompt 9.1: Business Intelligence Dashboard
```
Develop a comprehensive analytics and reporting system for business intelligence:

ANALYTICS FEATURES:
- Real-time dashboard with key performance indicators
- User behavior analytics and engagement metrics
- Revenue analytics with trend analysis and forecasting
- Service utilization analytics across all modules
- Geographic analytics for service distribution
- Predictive analytics for demand forecasting
- Cohort analysis for user retention and lifetime value

REPORTING CAPABILITIES:
- Automated report generation and scheduling
- Custom report builder with drag-and-drop interface
- Multi-format export (PDF, Excel, CSV, PowerBI)
- Interactive visualizations with drill-down capabilities
- Regulatory compliance reports for healthcare authorities
- Financial reports for investors and stakeholders
- Performance benchmarking against industry standards

FLUTTER COMPONENTS:
- Executive dashboard with key metrics overview
- Interactive charts and graphs with filtering options
- Report configuration interface with custom parameters
- Data export and sharing capabilities
- Real-time notification system for critical metrics
- Mobile-optimized analytics views
- Role-based dashboard customization

BACKEND APIs:
- GET /analytics/dashboard - Get dashboard metrics
- GET /analytics/revenue - Get revenue analytics
- GET /analytics/users - Get user analytics
- GET /analytics/services - Get service utilization
- POST /reports/generate - Generate custom report
- GET /reports/{id} - Get generated report
- POST /reports/schedule - Schedule automated report
- GET /analytics/export - Export analytics data
- GET /analytics/real-time - Get real-time metrics
- POST /analytics/alerts - Configure metric alerts

DATABASE SCHEMA:
analytics_events:
- id, user_id, event_type, event_category, event_properties
- session_id, device_info, timestamp, ip_address, user_agent

business_metrics:
- id, metric_name, metric_value, metric_unit, calculation_method
- time_period, timestamp, metadata, created_at

user_analytics:
- id, user_id, session_duration, page_views, actions_taken
- conversion_events, revenue_generated, date, device_type

service_analytics:
- id, service_type, service_id, usage_count, success_rate
- average_rating, revenue_generated, date, location

custom_reports:
- id, report_name, report_type, parameters, schedule
- created_by, last_run, next_run, output_format, recipients

REAL-TIME ANALYTICS:
- Live user activity monitoring
- Real-time revenue tracking
- Service performance monitoring
- Alert system for critical metrics
- Anomaly detection and notification
- Live dashboard updates with WebSocket integration

DATA VISUALIZATION:
- Interactive charts using Chart.js and D3.js
- Geospatial visualizations for location-based analytics
- Trend analysis with predictive modeling
- Comparative analysis across different time periods
- Funnel analysis for user journey optimization
- Heatmaps for user interaction patterns

BUSINESS INTELLIGENCE:
- Customer segmentation analysis
- Churn prediction and prevention
- Lifetime value calculation and optimization
- Market basket analysis for product recommendations
- A/B testing framework and result analysis
- Competitive analysis and benchmarking

PERFORMANCE MONITORING:
- Application performance metrics
- API response time monitoring
- Error rate tracking and alerting
- Resource utilization monitoring
- Database performance analytics
- User experience metrics

COMPLIANCE REPORTING:
- HIPAA compliance reporting for healthcare data
- Financial reporting for regulatory requirements
- Service level agreement (SLA) performance reports
- Data privacy and security compliance reports
- Audit trail reports for regulatory inspections
- Risk assessment and mitigation reports

Include proper data aggregation, caching strategies, and real-time processing capabilities for large-scale analytics.
```

### Prompt 9.2: Medical Analytics & Insights
```
Create specialized medical analytics and insights system for healthcare data:

MEDICAL ANALYTICS FEATURES:
- Patient outcome tracking and analysis
- Treatment effectiveness measurement
- Disease pattern recognition and trends
- Medication adherence monitoring
- Care quality metrics and improvement suggestions
- Population health analytics and insights
- Predictive modeling for health risks

CLINICAL INSIGHTS:
- Diagnostic accuracy analysis for AI wound detection
- Treatment success rate tracking
- Patient satisfaction correlation with outcomes
- Care team performance analytics
- Resource utilization optimization
- Clinical workflow efficiency analysis
- Evidence-based medicine recommendations

FLUTTER COMPONENTS:
- Medical dashboard with clinical KPIs
- Patient outcome visualization with trend analysis
- Treatment effectiveness comparison charts
- Population health overview with geographic mapping
- Clinical alert system with prioritized notifications
- Research data export interface
- Regulatory compliance reporting dashboard

BACKEND APIs:
- GET /medical-analytics/outcomes - Get patient outcomes
- GET /medical-analytics/treatments - Get treatment effectiveness
- GET /medical-analytics/population - Get population health data
- GET /medical-analytics/quality - Get care quality metrics
- POST /medical-analytics/cohorts - Create patient cohorts
- GET /medical-analytics/predictions - Get health predictions
- GET /medical-analytics/compliance - Get compliance metrics
- POST /medical-analytics/research - Export research data
- GET /medical-analytics/alerts - Get clinical alerts
- POST /medical-analytics/interventions - Track interventions

DATABASE SCHEMA:
patient_outcomes:
- id, patient_id, condition_id, outcome_measure, baseline_value
- current_value, target_value, measurement_date, outcome_status
- contributing_factors, measured_by, notes

treatment_effectiveness:
- id, treatment_id, patient_id, condition_id, start_date
- end_date, outcome_score, side_effects, adherence_rate
- cost_effectiveness, success_rate, follow_up_required

clinical_quality_metrics:
- id, metric_name, metric_value, benchmark_value, performance_score
- measurement_period, department, improvement_actions, target_date

population_health_data:
- id, geographic_region, demographic_group, health_condition
- prevalence_rate, incidence_rate, risk_factors, social_determinants
- intervention_programs, outcome_trends, data_source

research_cohorts:
- id, cohort_name, inclusion_criteria, exclusion_criteria
- patient_count, study_duration, primary_endpoint, secondary_endpoints
- created_by, created_date, status, ethics_approval

PREDICTIVE ANALYTICS:
- Machine learning models for disease risk prediction
- Early warning systems for patient deterioration
- Readmission risk assessment and prevention
- Medication interaction prediction
- Treatment response prediction
- Resource demand forecasting

QUALITY IMPROVEMENT:
- Clinical pathway optimization
- Care gap identification and intervention
- Best practice identification and dissemination
- Performance benchmarking against standards
- Root cause analysis for adverse events
- Continuous quality improvement tracking

RESEARCH CAPABILITIES:
- Clinical trial patient identification
- Real-world evidence generation
- Comparative effectiveness research
- Post-market surveillance for devices and medications
- Pharmacovigilance and safety monitoring
- Health economics and outcomes research

REGULATORY COMPLIANCE:
- Clinical data governance and quality assurance
- Regulatory reporting for health authorities
- Adverse event reporting and management
- Clinical trial compliance monitoring
- Data integrity and audit trail maintenance
- Privacy and security compliance for medical data

POPULATION HEALTH:
- Social determinants of health analysis
- Health equity and disparities monitoring
- Community health needs assessment
- Public health surveillance and reporting
- Outbreak detection and response
- Health promotion program effectiveness

Include proper de-identification of patient data, statistical analysis capabilities, and integration with clinical decision support systems.
```

## 10. Notification & Alert System

### Prompt 10.1: Multi-Channel Notification System
```
Develop a comprehensive multi-channel notification and alert system:

NOTIFICATION CHANNELS:
- Push notifications for mobile apps with rich media support
- SMS notifications for critical alerts and reminders
- Email notifications with HTML templates and attachments
- In-app notifications with real-time updates
- WhatsApp Business API integration for messaging
- Voice calls for emergency situations
- Integration with wearable devices for health alerts

NOTIFICATION TYPES:
- Appointment reminders with customizable timing
- Medication reminders with dosage information
- Emergency alerts with location-based routing
- Service booking confirmations and updates
- Payment due notifications and receipts
- Health milestone achievements and encouragement
- System maintenance and service update notifications

FLUTTER COMPONENTS:
- Notification preferences management interface
- Real-time notification center with categorization
- Alert configuration with custom rules and triggers
- Notification history with read/unread status
- Emergency alert interface with one-touch response
- Quiet hours and do-not-disturb settings
- Notification template customization

BACKEND APIs:
- POST /notifications/send - Send notification
- GET /notifications/user/{userId} - Get user notifications
- PUT /notifications/{id}/read - Mark notification as read
- POST /notifications/preferences - Update notification preferences
- GET /notifications/templates - Get notification templates
- POST /notifications/bulk - Send bulk notifications
- POST /notifications/emergency - Send emergency alert
- GET /notifications/analytics - Get notification analytics
- POST /notifications/schedule - Schedule notification
- DELETE /notifications/{id} - Delete notification

DATABASE SCHEMA:
notifications:
- id, user_id, notification_type, title, message, data_payload
- channels, priority_level, scheduled_time, sent_time, delivery_status
- read_at, action_taken, expires_at, created_at

notification_preferences:
- id, user_id, notification_type, channels_enabled, quiet_hours_start
- quiet_hours_end, frequency_limit, emergency_override, created_at

notification_templates:
- id, template_name, template_type, subject_template, body_template
- variables, default_values, active, created_by, created_at

notification_delivery:
- id, notification_id, channel, delivery_status, delivery_time
- error_message, retry_count, delivery_cost, gateway_response

emergency_alerts:
- id, alert_type, severity_level, affected_users, message
- location_based, radius_km, alert_duration, escalation_rules
- created_by, created_at, resolved_at, resolution_notes

SMART NOTIFICATIONS:
- AI-powered notification timing optimization
- Personalized content based on user behavior
- Adaptive notification frequency to prevent fatigue
- Context-aware notifications based on user activity
- Predictive notifications for upcoming needs
- Batch processing for related notifications

EMERGENCY ALERT SYSTEM:
- Mass notification system for emergency situations
- Location-based emergency alerts with geofencing
- Escalation rules for critical health situations
- Integration with emergency services and hospitals
- Automated emergency contact notification
- Crisis communication templates and procedures

DELIVERY OPTIMIZATION:
- Multi-gateway routing for SMS and email
- Retry logic with exponential backoff
- Delivery tracking and analytics
- Cost optimization across different channels
- A/B testing for notification effectiveness
- Compliance with communication regulations

PERSONALIZATION:
- User preference learning and adaptation
- Behavioral trigger-based notifications
- Personalized content recommendations
- Timezone-aware notification scheduling
- Language localization and translation
- Cultural sensitivity in notification content

ANALYTICS AND REPORTING:
- Notification delivery rates and performance metrics
- User engagement analytics for different notification types
- Channel effectiveness comparison
- Cost analysis per notification channel
- User satisfaction metrics for notifications
- Compliance reporting for regulatory requirements

Include proper rate limiting, spam prevention, and comprehensive logging for all notification activities.
```

### Prompt 10.2: Health Monitoring & Alert System
```
Create a specialized health monitoring and alert system for medical situations:

HEALTH MONITORING FEATURES:
- Vital signs monitoring with wearable device integration
- Medication adherence tracking with automatic reminders
- Chronic condition monitoring with trend analysis
- Emergency health situation detection and response
- Care plan adherence monitoring and notifications
- Symptom tracking with pattern recognition
- Health goal progress monitoring and motivation

ALERT SYSTEMS:
- Critical health alerts with emergency response
- Medication interaction warnings
- Appointment and treatment reminders
- Abnormal vital sign alerts with escalation
- Care plan deviation notifications
- Preventive care reminders and health screenings
- Family member and caregiver notifications

FLUTTER COMPONENTS:
- Health dashboard with real-time monitoring
- Alert configuration with custom thresholds
- Emergency response interface with one-touch activation
- Medication reminder interface with confirmation
- Vital signs input with trend visualization
- Care plan tracking with progress indicators
- Family notification management system

BACKEND APIs:
- POST /health/vitals - Record vital signs
- GET /health/vitals/{patientId} - Get vital signs history
- POST /health/alerts/configure - Configure health alerts
- GET /health/alerts/active - Get active health alerts
- POST /health/emergency - Trigger emergency alert
- GET /health/medications/reminders - Get medication reminders
- POST /health/medications/taken - Confirm medication taken
- GET /health/monitoring/dashboard - Get monitoring dashboard
- POST /health/symptoms - Record symptoms
- GET /health/trends - Get health trend analysis

DATABASE SCHEMA:
health_monitoring:
- id, patient_id, monitoring_type, device_id, measurement_value
- measurement_unit, measurement_time, alert_triggered, notes
- recorded_by, data_source, quality_score

health_alerts:
- id, patient_id, alert_type, severity_level, threshold_value
- current_value, alert_message, triggered_at, acknowledged_at
- escalated_to, resolution_time, resolution_notes

medication_reminders:
- id, patient_id, medication_id, reminder_time, dosage
- taken_at, skipped, skip_reason, caregiver_notified
- adherence_score, next_reminder_time

emergency_contacts:
- id, patient_id, contact_type, contact_name, contact_phone
- contact_email, relationship, priority_order, notification_preferences
- alert_types, active_status, created_at

care_plan_alerts:
- id, patient_id, care_plan_id, task_name, due_date
- completion_status, alert_sent, completed_at, completed_by
- notes, next_due_date, recurring_pattern

WEARABLE INTEGRATION:
- Apple HealthKit integration for iOS devices
- Google Fit integration for Android devices
- Fitbit API integration for fitness tracking
- Samsung Health integration for comprehensive monitoring
- Custom wearable device integration via Bluetooth
- Real-time data synchronization and processing

SMART MONITORING:
- Machine learning for abnormal pattern detection
- Predictive analytics for health deterioration
- Personalized threshold setting based on individual baselines
- Context-aware alert suppression to reduce false alarms
- Intelligent alert routing based on severity and time
- Automated care plan adjustments based on monitoring data

EMERGENCY RESPONSE:
- Automated emergency service contact for critical situations
- GPS location sharing for emergency responders
- Medical information sharing with emergency contacts
- Escalation protocols for different emergency types
- Integration with hospital emergency departments
- Real-time communication with emergency response teams

CLINICAL INTEGRATION:
- Integration with electronic health records
- Automated clinical decision support
- Provider notification for concerning trends
- Integration with telemedicine platforms
- Clinical workflow integration for care teams
- Evidence-based care recommendations

FAMILY ENGAGEMENT:
- Family member dashboard for patient monitoring
- Automated family notifications for important events
- Shared care plan visibility and updates
- Communication tools for care coordination
- Emergency situation family alerts
- Progress sharing and celebration features

COMPLIANCE AND PRIVACY:
- HIPAA compliance for health data monitoring
- Consent management for family notifications
- Data encryption for sensitive health information
- Audit logging for all monitoring activities
- Privacy controls for different types of health data
- Regulatory compliance for medical device integration

Include proper data validation, medical-grade accuracy requirements, and integration with healthcare provider systems.
```

This completes the comprehensive functionality prompts document with all the major features and technical specifications needed for the Coherency medical app development. Each prompt is designed to be self-contained and executable, providing detailed requirements for frontend components, backend APIs, database schemas, and technical implementation details.