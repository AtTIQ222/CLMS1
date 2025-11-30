-- Computer Lab Management System Database
-- Database: lab_db
-- Combined schema from computer_lab_db.sql and enhanced_schema.sql

-- Run this to set up/update the database without errors

CREATE DATABASE IF NOT EXISTS lab_db;
USE lab_db;

-- Create tables only if they don't exist
CREATE TABLE IF NOT EXISTS labs (
    lab_id INT AUTO_INCREMENT PRIMARY KEY,
    lab_name VARCHAR(50) NOT NULL,
    location VARCHAR(100),
    capacity INT DEFAULT 30
);

CREATE TABLE IF NOT EXISTS admin_user (
    admin_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    role VARCHAR(20) DEFAULT 'admin'
);

CREATE TABLE IF NOT EXISTS staff (
    staff_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    cnic VARCHAR(15) UNIQUE,
    designation VARCHAR(50),
    lab_id INT,
    university VARCHAR(100) DEFAULT 'University of Sindh, Laar Campus',
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(20) DEFAULT 'staff',
    status ENUM('active', 'inactive') DEFAULT 'active',
    FOREIGN KEY (lab_id) REFERENCES labs(lab_id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS computer (
    computer_id INT AUTO_INCREMENT PRIMARY KEY,
    lab_name VARCHAR(50) NOT NULL,
    computer_number VARCHAR(20) UNIQUE NOT NULL,
    brand VARCHAR(50),
    model VARCHAR(50),
    processor VARCHAR(100),
    ram VARCHAR(50),
    storage VARCHAR(50),
    status ENUM('working', 'damaged', 'repair') DEFAULT 'working',
    assigned_to INT NULL,
    FOREIGN KEY (assigned_to) REFERENCES staff(staff_id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS accessory (
    accessory_id INT AUTO_INCREMENT PRIMARY KEY,
    item_name VARCHAR(100) NOT NULL,
    quantity INT NOT NULL DEFAULT 0,
    condition_status VARCHAR(50),
    added_date DATE DEFAULT CURRENT_DATE
);

CREATE TABLE IF NOT EXISTS maintenance (
    maintenance_id INT AUTO_INCREMENT PRIMARY KEY,
    computer_id INT NOT NULL,
    issue_description TEXT NOT NULL,
    request_by INT NOT NULL,
    request_date DATE DEFAULT CURRENT_DATE,
    status ENUM('pending', 'reviewed', 'in-progress', 'completed', 'closed') DEFAULT 'pending',
    resolved_date DATE NULL,
    issue_type ENUM('Hardware', 'Software', 'Network', 'Electrical', 'Other') DEFAULT 'Other',
    priority ENUM('Low', 'Medium', 'High', 'Critical') DEFAULT 'Medium',
    assigned_technician INT NULL,
    student_id INT NULL,
    review_notes TEXT NULL,
    solution_notes TEXT NULL,
    before_images TEXT NULL,
    after_images TEXT NULL,
    estimated_completion DATE NULL,
    actual_completion DATE NULL,
    feedback TEXT NULL,
    FOREIGN KEY (computer_id) REFERENCES computer(computer_id) ON DELETE CASCADE,
    FOREIGN KEY (request_by) REFERENCES staff(staff_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS lab_usage (
    usage_id INT AUTO_INCREMENT PRIMARY KEY,
    staff_id INT NOT NULL,
    computer_id INT NOT NULL,
    login_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    logout_time DATETIME NULL,
    purpose TEXT,
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id) ON DELETE CASCADE,
    FOREIGN KEY (computer_id) REFERENCES computer(computer_id) ON DELETE CASCADE
);

-- Add students table
CREATE TABLE IF NOT EXISTS students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    roll_number VARCHAR(20) UNIQUE NOT NULL,
    department VARCHAR(50),
    semester VARCHAR(20),
    lab_id INT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(20) DEFAULT 'student',
    status ENUM('active', 'inactive') DEFAULT 'active',
    registration_date DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (lab_id) REFERENCES labs(lab_id) ON DELETE SET NULL
);

-- Add technician table
CREATE TABLE IF NOT EXISTS technician (
    technician_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    specialization VARCHAR(50),
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(20) DEFAULT 'technician',
    status ENUM('active', 'inactive') DEFAULT 'active',
    hire_date DATE DEFAULT CURRENT_DATE
);

-- Add foreign key constraints for enhanced maintenance table (only if they don't exist)
SET @constraint_exists = (SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
                         WHERE TABLE_SCHEMA = DATABASE()
                         AND TABLE_NAME = 'maintenance'
                         AND CONSTRAINT_NAME = 'fk_assigned_technician');

SET @sql = IF(@constraint_exists = 0,
    'ALTER TABLE maintenance ADD CONSTRAINT fk_assigned_technician FOREIGN KEY (assigned_technician) REFERENCES technician(technician_id) ON DELETE SET NULL',
    'DO 0');

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @constraint_exists = (SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
                         WHERE TABLE_SCHEMA = DATABASE()
                         AND TABLE_NAME = 'maintenance'
                         AND CONSTRAINT_NAME = 'fk_student_maintenance');

SET @sql = IF(@constraint_exists = 0,
    'ALTER TABLE maintenance ADD CONSTRAINT fk_student_maintenance FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE',
    'DO 0');

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Add student usage tracking
CREATE TABLE IF NOT EXISTS student_lab_usage (
    usage_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    computer_id INT NOT NULL,
    login_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    logout_time DATETIME NULL,
    purpose TEXT,
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (computer_id) REFERENCES computer(computer_id) ON DELETE CASCADE
);

-- Insert data with IGNORE to avoid duplicates
INSERT IGNORE INTO admin_user (username, password, name, email, role) VALUES
('admin', 'admin123', 'Administrator', 'admin@example.com', 'admin');

INSERT IGNORE INTO labs (lab_name, location, capacity) VALUES
('Lab 1', 'Laar Campus, Block A', 30),
('Lab 2', 'Laar Campus, Block B', 30),
('Lab 3', 'Laar Campus, Block C', 30),
('Lab 4', 'Laar Campus, Block D', 30),
('Lab 5', 'Laar Campus, Block E', 30);

INSERT IGNORE INTO staff (name, email, phone, cnic, designation, lab_id, university, username, password, role, status) VALUES
('Ahmed Khan', 'ahmed.khan@usindh.edu.pk', '03001234567', '42101-1234567-1', 'Lab Assistant', 1, 'University of Sindh, Laar Campus', 'staff1', 'staff123', 'staff', 'active'),
('Fatima Baloch', 'fatima.baloch@usindh.edu.pk', '03002345678', '42101-2345678-2', 'Lab Technician', 2, 'University of Sindh, Laar Campus', 'staff2', 'staff123', 'staff', 'active'),
('Muhammad Ali', 'muhammad.ali@usindh.edu.pk', '03003456789', '42101-3456789-3', 'Lab Incharge', 3, 'University of Sindh, Laar Campus', 'staff3', 'staff123', 'staff', 'active'),
('Ayesha Mughal', 'ayesha.mughal@usindh.edu.pk', '03004567890', '42101-4567890-4', 'Lab Assistant', 4, 'University of Sindh, Laar Campus', 'staff4', 'staff123', 'staff', 'active'),
('Hassan Rajput', 'hassan.rajput@usindh.edu.pk', '03005678901', '42101-5678901-5', 'Lab Technician', 5, 'University of Sindh, Laar Campus', 'staff5', 'staff123', 'staff', 'active');

-- Insert sample computers for each lab
INSERT IGNORE INTO computer (lab_name, computer_number, brand, model, processor, ram, storage, status, assigned_to) VALUES
('Lab 1', 'L1-PC-01', 'Dell', 'OptiPlex 3080', 'Intel Core i5', '8GB', '512GB SSD', 'working', 1),
('Lab 1', 'L1-PC-02', 'HP', 'ProDesk 400', 'Intel Core i3', '8GB', '256GB SSD', 'working', NULL),
('Lab 1', 'L1-PC-03', 'Lenovo', 'ThinkCentre M70', 'Intel Core i5', '16GB', '1TB HDD', 'working', NULL),
('Lab 2', 'L2-PC-01', 'Dell', 'OptiPlex 3090', 'Intel Core i7', '16GB', '1TB SSD', 'working', 2),
('Lab 2', 'L2-PC-02', 'HP', 'EliteDesk 800', 'Intel Core i5', '8GB', '512GB SSD', 'damaged', NULL),
('Lab 3', 'L3-PC-01', 'Lenovo', 'ThinkCentre M90', 'Intel Core i7', '32GB', '2TB SSD', 'working', 3),
('Lab 3', 'L3-PC-02', 'Dell', 'Precision 3450', 'Intel Core i9', '64GB', '4TB SSD', 'working', NULL),
('Lab 4', 'L4-PC-01', 'HP', 'Z2 Mini', 'Intel Core i7', '16GB', '1TB SSD', 'working', 4),
('Lab 4', 'L4-PC-02', 'Lenovo', 'ThinkStation P330', 'Intel Xeon', '32GB', '2TB SSD', 'repair', NULL),
('Lab 5', 'L5-PC-01', 'Dell', 'XPS 8940', 'Intel Core i9', '32GB', '1TB SSD', 'working', 5),
('Lab 5', 'L5-PC-02', 'HP', 'Pavilion Desktop', 'AMD Ryzen 5', '16GB', '512GB SSD', 'working', NULL);

-- Insert sample accessories
INSERT IGNORE INTO accessory (item_name, quantity, condition_status) VALUES
('Mouse (Optical)', 50, 'good'),
('Keyboard (USB)', 45, 'good'),
('Monitor (22 inch)', 30, 'excellent'),
('Printer Cartridge (Black)', 20, 'new'),
('Network Cable (Cat6)', 100, 'new'),
('USB Flash Drive (16GB)', 25, 'good'),
('External Hard Drive (1TB)', 10, 'excellent'),
('Webcam (HD)', 15, 'good'),
('Headphones', 20, 'good'),
('Projector Bulb', 5, 'new');

-- Insert sample students
INSERT IGNORE INTO students (name, email, roll_number, department, semester, lab_id, username, password, status) VALUES
('Ahmed Ali', 'ahmed.ali@student.usindh.edu.pk', '2020-CS-001', 'Computer Science', '6th', 1, 'student1', 'student123', 'active'),
('Fatima Khan', 'fatima.khan@student.usindh.edu.pk', '2020-CS-002', 'Computer Science', '6th', 1, 'student2', 'student123', 'active'),
('Muhammad Saeed', 'muhammad.saeed@student.usindh.edu.pk', '2020-IT-001', 'Information Technology', '6th', 2, 'student3', 'student123', 'active'),
('Ayesha Ahmed', 'ayesha.ahmed@student.usindh.edu.pk', '2020-SE-001', 'Software Engineering', '6th', 3, 'student4', 'student123', 'active'),
('Hassan Raza', 'hassan.raza@student.usindh.edu.pk', '2020-CS-003', 'Computer Science', '6th', 1, 'student5', 'student123', 'active');

-- Insert sample technicians
INSERT IGNORE INTO technician (name, email, specialization, username, password, status) VALUES
('Ali Technician', 'ali.tech@usindh.edu.pk', 'Hardware', 'tech1', 'tech123', 'active'),
('Sara Support', 'sara.support@usindh.edu.pk', 'Software', 'tech2', 'tech123', 'active'),
('Ahmed Network', 'ahmed.network@usindh.edu.pk', 'Network', 'tech3', 'tech123', 'active');

-- Insert sample maintenance requests
INSERT IGNORE INTO maintenance (computer_id, issue_description, request_by, status, request_date, resolved_date) VALUES
(2, 'Monitor not displaying properly', 1, 'pending', '2024-11-25', NULL),
(5, 'Computer not starting up', 2, 'completed', '2024-11-20', '2024-11-22'),
(8, 'Keyboard keys not working', 4, 'pending', '2024-11-26', NULL),
(9, 'System running very slow', 4, 'completed', '2024-11-15', '2024-11-18'),
(11, 'Internet connection issues', 5, 'pending', '2024-11-27', NULL);

-- Insert sample enhanced maintenance records
INSERT IGNORE INTO maintenance (computer_id, issue_type, priority, issue_description, request_by, student_id, status, request_date) VALUES
(1, 'Hardware', 'High', 'Monitor not displaying properly', 1, 1, 'pending', '2024-11-25'),
(4, 'Software', 'Medium', 'System running very slow', 2, 2, 'reviewed', '2024-11-26'),
(6, 'Network', 'Critical', 'Internet connection completely down', 3, 3, 'in-progress', '2024-11-27'),
(8, 'Hardware', 'Medium', 'Keyboard keys not working', 4, 4, 'completed', '2024-11-20');

-- Insert sample lab usage records
INSERT IGNORE INTO lab_usage (staff_id, computer_id, login_time, logout_time, purpose) VALUES
(1, 1, '2024-11-25 09:00:00', '2024-11-25 12:00:00', 'Software Development Lab'),
(2, 4, '2024-11-25 10:00:00', '2024-11-25 13:00:00', 'Database Management Class'),
(3, 6, '2024-11-25 11:00:00', '2024-11-25 14:00:00', 'Research Work'),
(4, 8, '2024-11-25 14:00:00', '2024-11-25 17:00:00', 'Programming Assignment'),
(5, 10, '2024-11-25 15:00:00', '2024-11-25 18:00:00', 'Project Work'),
(1, 1, '2024-11-26 09:30:00', NULL, 'Morning Lab Session');

-- Insert sample student usage
INSERT IGNORE INTO student_lab_usage (student_id, computer_id, login_time, logout_time, purpose) VALUES
(1, 1, '2024-11-25 09:00:00', '2024-11-25 12:00:00', 'Programming Assignment'),
(2, 4, '2024-11-25 10:00:00', '2024-11-25 13:00:00', 'Database Project'),
(3, 6, '2024-11-25 11:00:00', '2024-11-25 14:00:00', 'Research Work'),
(4, 8, '2024-11-25 14:00:00', '2024-11-25 17:00:00', 'Software Development'),
(5, 10, '2024-11-25 15:00:00', '2024-11-25 18:00:00', 'Final Year Project');