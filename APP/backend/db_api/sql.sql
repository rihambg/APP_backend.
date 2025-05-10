-- Create the database
DROP DATABASE IF EXISTS app_db;
CREATE DATABASE app_db;

-- Use the database
USE app_db;

-- Table: accounts
DROP TABLE IF EXISTS accounts;
CREATE TABLE accounts (
    account_id INT AUTO_INCREMENT PRIMARY KEY,
    user_name VARCHAR(255) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone_number VARCHAR(20),
    password VARCHAR(255) NOT NULL,
    account_type ENUM('Doctor','Patient'),
    status ENUM('Active', 'Inactive', 'Suspended', 'Deleted')
);

-- Table : locations
DROP TABLE IF EXISTS locations;
CREATE TABLE locations (
    id_location INT AUTO_INCREMENT PRIMARY KEY,
    address VARCHAR(255) NOT NULL,
    latitude DECIMAL(10, 8) NOT NULL,
    longitude DECIMAL(11, 8) NOT NULL
);


-- Table: hospitals
DROP TABLE IF EXISTS hospitals;
CREATE TABLE hospitals (
    id_hospital INT AUTO_INCREMENT PRIMARY KEY,
    name_hospital VARCHAR(255),
    postal_code VARCHAR(20),
    street VARCHAR(255),
    id_location INT,
    FOREIGN KEY (id_location) REFERENCES locations(id_location)
);

-- Table: users (abstract base class not implemented directly)
-- Table: patients
DROP TABLE IF EXISTS patients;
CREATE TABLE patients (
    id_profile INT AUTO_INCREMENT PRIMARY KEY,
    id_account INT NOT NULL,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    middle_name VARCHAR(255),
    sex BOOLEAN,
    date_birth DATE,
    public_phone_number VARCHAR(20),
    public_email VARCHAR(255),
    blood_type ENUM('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'),
    weight FLOAT,
    height FLOAT,
    diabete_type ENUM('Type 1', 'Type 2', 'Gestational'),
    FOREIGN KEY (id_account) REFERENCES accounts(account_id)
);

-- Table: doctors
DROP TABLE IF EXISTS doctors;
CREATE TABLE doctors (
    id_profile INT AUTO_INCREMENT PRIMARY KEY,
    id_account INT NOT NULL,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    middle_name VARCHAR(255),
    sex BOOLEAN,
    public_phone_number VARCHAR(20),
    public_email VARCHAR(255),
    speciality ENUM('Nutritionist', 'Cardiologist', 'Endocrinologist', 'Gynecologist'),
    id_location INT,
    bio TEXT,
    id_hospital INT,
    professional_id VARCHAR(255),
    FOREIGN KEY (id_account) REFERENCES accounts(account_id),
    FOREIGN KEY (id_hospital) REFERENCES hospitals(id_hospital),
    FOREIGN KEY (id_location) REFERENCES locations(id_location)
);



-- Table: community_posts
DROP TABLE IF EXISTS community_posts;
CREATE TABLE community_posts (
    id_post INT AUTO_INCREMENT PRIMARY KEY,
    id_account_writer INT NOT NULL,
    title VARCHAR(255),
    body TEXT,
    image VARCHAR(255),
    date_added DATETIME,
    date_edited DATETIME,
    FOREIGN KEY (id_account_writer) REFERENCES accounts(account_id)
);

-- Table: community_post_comments
DROP TABLE IF EXISTS community_post_comments;
CREATE TABLE community_post_comments (
    id_comment INT AUTO_INCREMENT PRIMARY KEY,
    id_post INT NOT NULL,
    id_account_writer INT NOT NULL,
    comment TEXT,
    date_added DATETIME,
    date_edited DATETIME,
    FOREIGN KEY (id_post) REFERENCES community_posts(id_post),
    FOREIGN KEY (id_account_writer) REFERENCES accounts(account_id)
);

-- Table: community_post_reactions
DROP TABLE IF EXISTS community_post_reactions;
CREATE TABLE community_post_reactions (
    id_post INT NOT NULL,
    id_account INT NOT NULL,
    reaction ENUM('like','dislike','love'),
    PRIMARY KEY (id_post, id_account),
    FOREIGN KEY (id_post) REFERENCES community_posts(id_post),
    FOREIGN KEY (id_account) REFERENCES accounts(account_id)
);

-- Table: community_post_comment_reactions
DROP TABLE IF EXISTS community_post_comment_reactions;
CREATE TABLE community_post_comment_reactions (
    id_comment INT NOT NULL,
    id_account INT NOT NULL,
    reaction ENUM('like','dislike','love'),
    PRIMARY KEY (id_comment, id_account),
    FOREIGN KEY (id_comment) REFERENCES community_post_comments(id_comment),
    FOREIGN KEY (id_account) REFERENCES accounts(account_id)
);

-- Table: perspections
DROP TABLE IF EXISTS perspections;
CREATE TABLE perspections (
    id_perspection INT AUTO_INCREMENT PRIMARY KEY,
    id_account_doctor INT NOT NULL,
    id_appointement INT NOT NULL,
    id_account_patient INT NOT NULL,
    description TEXT,
    code VARCHAR(255),
    date_time DATETIME,
    FOREIGN KEY (id_account_doctor) REFERENCES doctors(id_profile),
    FOREIGN KEY (id_account_patient) REFERENCES patients(id_profile)
);

-- Table: medicals
DROP TABLE IF EXISTS medicals;
CREATE TABLE medicals (
    id_medical INT AUTO_INCREMENT PRIMARY KEY,
    medical_type ENUM('Insulin', 'Complementary'),
    medical_dose VARCHAR(255),
    medical_name VARCHAR(255),
    medical_description TEXT
);

-- Table: perspection_medical
DROP TABLE IF EXISTS perspection_medical;
CREATE TABLE perspection_medical (
    id_perspection INT NOT NULL,
    id_medical INT NOT NULL,
    frequency VARCHAR(255),
    date_start DATE,
    date_end DATE,
    PRIMARY KEY (id_perspection, id_medical),
    FOREIGN KEY (id_perspection) REFERENCES perspections(id_perspection),
    FOREIGN KEY (id_medical) REFERENCES medicals(id_medical)
);

-- Table: challenges
DROP TABLE IF EXISTS challenges;
CREATE TABLE challenges (
    id_challenge INT AUTO_INCREMENT PRIMARY KEY,
    id_account_doctor INT NOT NULL,
    title VARCHAR(255),
    description TEXT,
    start_date DATE,
    end_date DATE,
    FOREIGN KEY (id_account_doctor) REFERENCES doctors(id_profile)
);

-- Table: diet_plan
DROP TABLE IF EXISTS diet_plan;
CREATE TABLE diet_plan (
    id_plan INT AUTO_INCREMENT PRIMARY KEY,
    id_account_doctor INT NOT NULL,
    id_account_patient INT NOT NULL,
    title VARCHAR(255),
    description TEXT,
    start_date DATE,
    end_date DATE,
    id_challenge INT,
    FOREIGN KEY (id_account_doctor) REFERENCES doctors(id_profile),
    FOREIGN KEY (id_account_patient) REFERENCES patients(id_profile),
    FOREIGN KEY (id_challenge) REFERENCES challenges(id_challenge)
);

-- Table: physical_activity
DROP TABLE IF EXISTS physical_activity;
CREATE TABLE physical_activity (
    id_activity INT AUTO_INCREMENT PRIMARY KEY,
    activity_type ENUM('Walking', 'Running', 'Swimming', 'Cycling', 'Other'),
    period INT,
    burned_calories FLOAT,
    date_time_activity DATETIME,
    id_diet_plan INT,
    FOREIGN KEY (id_diet_plan) REFERENCES diet_plan(id_plan)
);

-- Table: challenge_participant
DROP TABLE IF EXISTS challenge_participant;
CREATE TABLE challenge_participant (
    id_challenge INT NOT NULL,
    id_account INT NOT NULL,
    PRIMARY KEY (id_challenge, id_account),
    FOREIGN KEY (id_challenge) REFERENCES challenges(id_challenge),
    FOREIGN KEY (id_account) REFERENCES patients(id_profile)
);

-- Table: meals
DROP TABLE IF EXISTS meals;
CREATE TABLE meals (
    id_meal INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255),
    calories FLOAT,
    carbs FLOAT,
    protein FLOAT,
    fat FLOAT,
    faber FLOAT,
    meal_type ENUM('breakfast', 'lunch', 'dinner', 'snack')
);

-- Table: meal_eaten
DROP TABLE IF EXISTS meal_eaten;
CREATE TABLE meal_eaten (
    id_patient INT ,
    id_meal INT NOT NULL,
    date_time DATETIME,
    PRIMARY KEY (id_patient, id_meal, date_time),
    FOREIGN KEY (id_meal) REFERENCES meals(id_meal),
    FOREIGN KEY (id_patient) REFERENCES patients(id_profile)
);

-- Table: meal_diet
DROP TABLE IF EXISTS meal_diet;
CREATE TABLE meal_diet (
    id_meal INT NOT NULL,
    id_diet_plan INT NOT NULL,
    PRIMARY KEY (id_meal, id_diet_plan),
    FOREIGN KEY (id_meal) REFERENCES meals(id_meal),
    FOREIGN KEY (id_diet_plan) REFERENCES diet_plan(id_plan)
);

-- Table: blood_sugar_records
DROP TABLE IF EXISTS blood_sugar_records;
CREATE TABLE blood_sugar_records (
    id_record INT AUTO_INCREMENT PRIMARY KEY,
    id_account_patient INT NOT NULL,
    date_time DATETIME,
    level FLOAT,
    record_type ENUM('fasting', 'after_meal'),
    FOREIGN KEY (id_account_patient) REFERENCES patients(id_profile)
);

-- Table: notification
DROP TABLE IF EXISTS notification;
CREATE TABLE notification (
    id_notification INT AUTO_INCREMENT PRIMARY KEY,
    id_user INT NOT NULL,
    type_notification ENUM('appointment', 'perspection', 'medical', 'diet_plan', 'challenge', 'general'),
    message TEXT,
    timestamp DATETIME,
    FOREIGN KEY (id_user) REFERENCES accounts(account_id)
);

-- Table: articles
DROP TABLE IF EXISTS articles;
CREATE TABLE articles (
    id_article INT AUTO_INCREMENT PRIMARY KEY,
    id_account_writer INT NOT NULL,
    title VARCHAR(255),
    content TEXT,
    publish_date DATETIME,
    FOREIGN KEY (id_account_writer) REFERENCES doctors(id_profile)
);

-- Table: appointements
DROP TABLE IF EXISTS appointements;
CREATE TABLE appointements (
    id_appointement INT AUTO_INCREMENT PRIMARY KEY,
    appointement_type ENUM('in_person', 'video_call', 'phone_call'),
    date_time DATETIME,
    doctor_id INT NOT NULL,
    patient_id INT NOT NULL,
    appointement_status ENUM('pending', 'confirmed', 'cancelled', 'completed'),
    FOREIGN KEY (doctor_id) REFERENCES doctors(id_profile),
    FOREIGN KEY (patient_id) REFERENCES patients(id_profile)
);

-- Table: contacts
DROP TABLE IF EXISTS contacts;
CREATE TABLE contacts (
    id_contact INT AUTO_INCREMENT PRIMARY KEY,
    id_account_sender INT NOT NULL,
    id_account_reciver INT NOT NULL,
    contact_status ENUM('Pending', 'Accepted', 'Blocked'),
    is_emergency_contact BOOLEAN,
    FOREIGN KEY (id_account_sender) REFERENCES accounts(account_id),
    FOREIGN KEY (id_account_reciver) REFERENCES accounts(account_id)
);

-- Table: messages
DROP TABLE IF EXISTS messages;
CREATE TABLE messages (
    id_message INT AUTO_INCREMENT PRIMARY KEY,
    id_contact INT NOT NULL,
    message_text TEXT,
    date_time DATETIME,
    message_status ENUM('Sent', 'Delivered', 'Read', 'Failed'),
    FOREIGN KEY (id_contact) REFERENCES contacts(id_contact)
);

-- Table: additionnal_infos
DROP TABLE IF EXISTS additionnal_infos;
CREATE TABLE additionnal_infos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_patient INT NOT NULL,
    last_diagnosis ENUM('less-than-1-year', 'between-1-and-5-years', 'between-5-and-10-years', 'more-than-10-years'),
    has_allergies BOOLEAN,
    other_chronic_condition ENUM('none', 'hypertension', 'heart-disease', 'kidney-disease', 'obesity'),
    already_taken_medicines ENUM('none', 'insulin', 'oral-medication', 'both'),
    frequecy_sugar_food ENUM('occasionally', 'regularly', 'frequently', 'very-often'),
    diet ENUM('low-carb', 'vegan', 'keto', 'mediterranean', 'none'),
    exercise_frequency ENUM('never', 'occasionally', 'rarely', 'sometimes', 'daily'),
    smoking_status ENUM('non-smoker', 'smoker'),
    alcohol_consumption ENUM('non-drinker', 'drinker'),
    goal ENUM('improve-diet', 'monitor-blood-sugar', 'lose-gain-weight', 'all-of-the-above'),
    FOREIGN KEY (id_patient) REFERENCES patients(id_profile)
);

-- Table: woman_additionnal_infos
DROP TABLE IF EXISTS woman_additionnal_infos;
CREATE TABLE woman_additionnal_infos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_patient INT NOT NULL,
    last_diagnosis ENUM('less-than-1-year', 'between-1-and-5-years', 'between-5-and-10-years', 'more-than-10-years'),
    has_allergies BOOLEAN,
    other_chronic_condition ENUM('none', 'hypertension', 'heart-disease', 'kidney-disease', 'obesity'),
    already_taken_medicines ENUM('none', 'insulin', 'oral-medication', 'both'),
    frequecy_sugar_food ENUM('occasionally', 'regularly', 'frequently', 'very-often'),
    diet ENUM('low-carb', 'vegan', 'keto', 'mediterranean', 'none'),
    exercise_frequency ENUM('never', 'occasionally', 'rarely', 'sometimes', 'daily'),
    smoking_status ENUM('non-smoker', 'smoker'),
    alcohol_consumption ENUM('non-drinker', 'drinker'),
    goal ENUM('improve-diet', 'monitor-blood-sugar', 'lose-gain-weight', 'all-of-the-above'),
    pregnancy_status ENUM('not-pregnant', 'pregnant'),
    FOREIGN KEY (id_patient) REFERENCES patients(id_profile)
);