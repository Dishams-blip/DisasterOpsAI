-- ============================================================
-- DisasterOps AI
-- Database Schema
-- Database: disasterops_ai
-- ============================================================

CREATE DATABASE IF NOT EXISTS disasterops_ai;

USE disasterops_ai;


-- ============================================================
-- 1. USERS
-- ============================================================

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    phone VARCHAR(20),
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('CITIZEN', 'ADMIN') NOT NULL DEFAULT 'CITIZEN',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- ============================================================
-- 2. SOS REQUESTS
-- ============================================================

CREATE TABLE sos_requests (
    id INT AUTO_INCREMENT PRIMARY KEY,
    citizen_id INT NOT NULL,

    emergency_type VARCHAR(50) NOT NULL,

    people_affected INT NOT NULL,

    injury_severity ENUM(
        'NO_KNOWN_INJURIES',
        'MINOR',
        'SERIOUS',
        'CRITICAL',
        'UNKNOWN'
    ) NOT NULL,

    latitude DECIMAL(10, 7) NOT NULL,
    longitude DECIMAL(10, 7) NOT NULL,

    location_address VARCHAR(255),

    description TEXT,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    status ENUM(
        'RECEIVED',
        'UNDER_REVIEW',
        'ASSIGNED',
        'IN_PROGRESS',
        'RESOLVED',
        'CANCELLED'
    ) NOT NULL DEFAULT 'RECEIVED',

    CONSTRAINT fk_sos_citizen
        FOREIGN KEY (citizen_id)
        REFERENCES users(id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);


-- ============================================================
-- 3. ML PREDICTIONS
-- ============================================================

CREATE TABLE ml_predictions (
    id INT AUTO_INCREMENT PRIMARY KEY,

    sos_id INT NOT NULL UNIQUE,

    priority ENUM(
        'CRITICAL',
        'HIGH',
        'MEDIUM',
        'LOW'
    ) NOT NULL,

    confidence DECIMAL(5, 4) NOT NULL,

    reason TEXT,

    model_version VARCHAR(50),

    predicted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_prediction_sos
        FOREIGN KEY (sos_id)
        REFERENCES sos_requests(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);


-- ============================================================
-- 4. RESCUE TEAMS
-- ============================================================

CREATE TABLE rescue_teams (
    id INT AUTO_INCREMENT PRIMARY KEY,

    team_name VARCHAR(100) NOT NULL,

    specialization VARCHAR(100) NOT NULL,

    latitude DECIMAL(10, 7) NOT NULL,
    longitude DECIMAL(10, 7) NOT NULL,

    status ENUM(
        'AVAILABLE',
        'DISPATCHED',
        'EN_ROUTE',
        'ON_MISSION',
        'UNAVAILABLE'
    ) NOT NULL DEFAULT 'AVAILABLE',

    contact_number VARCHAR(20),

    equipment TEXT,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- ============================================================
-- 5. RESOURCES
-- ============================================================

CREATE TABLE resources (
    id INT AUTO_INCREMENT PRIMARY KEY,

    resource_type VARCHAR(100) NOT NULL,

    total_quantity INT NOT NULL DEFAULT 0,

    available_quantity INT NOT NULL DEFAULT 0,

    location VARCHAR(255),

    status ENUM(
        'AVAILABLE',
        'PARTIALLY_AVAILABLE',
        'UNAVAILABLE'
    ) NOT NULL DEFAULT 'AVAILABLE',

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_resource_quantity
        CHECK (
            total_quantity >= 0
            AND available_quantity >= 0
            AND available_quantity <= total_quantity
        )
);


-- ============================================================
-- 6. SHELTERS
-- ============================================================

CREATE TABLE shelters (
    id INT AUTO_INCREMENT PRIMARY KEY,

    name VARCHAR(150) NOT NULL,

    latitude DECIMAL(10, 7) NOT NULL,
    longitude DECIMAL(10, 7) NOT NULL,

    capacity INT NOT NULL,

    current_occupancy INT NOT NULL DEFAULT 0,

    facilities TEXT,

    contact VARCHAR(20),

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_shelter_capacity
        CHECK (
            capacity >= 0
            AND current_occupancy >= 0
            AND current_occupancy <= capacity
        )
);


-- ============================================================
-- 7. MISSIONS
-- ============================================================

CREATE TABLE missions (
    id INT AUTO_INCREMENT PRIMARY KEY,

    request_id INT NOT NULL,

    team_id INT NOT NULL,

    dispatch_time DATETIME NULL,

    arrival_time DATETIME NULL,

    completion_time DATETIME NULL,

    status ENUM(
        'PENDING',
        'ASSIGNED',
        'DISPATCHED',
        'EN_ROUTE',
        'ARRIVED',
        'RESCUE_IN_PROGRESS',
        'COMPLETED',
        'CANCELLED'
    ) NOT NULL DEFAULT 'PENDING',

    notes TEXT,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_mission_request
        FOREIGN KEY (request_id)
        REFERENCES sos_requests(id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT fk_mission_team
        FOREIGN KEY (team_id)
        REFERENCES rescue_teams(id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);


-- ============================================================
-- 8. RESOURCE ALLOCATIONS
-- ============================================================

CREATE TABLE resource_allocations (
    id INT AUTO_INCREMENT PRIMARY KEY,

    mission_id INT NOT NULL,

    resource_id INT NOT NULL,

    quantity INT NOT NULL,

    allocated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    returned_at TIMESTAMP NULL,

    CONSTRAINT fk_allocation_mission
        FOREIGN KEY (mission_id)
        REFERENCES missions(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_allocation_resource
        FOREIGN KEY (resource_id)
        REFERENCES resources(id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT chk_allocation_quantity
        CHECK (quantity > 0)
);


-- ============================================================
-- 9. MISSION STATUS HISTORY
-- ============================================================

CREATE TABLE mission_status_history (
    id INT AUTO_INCREMENT PRIMARY KEY,

    mission_id INT NOT NULL,

    status VARCHAR(50) NOT NULL,

    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    notes TEXT,

    CONSTRAINT fk_status_history_mission
        FOREIGN KEY (mission_id)
        REFERENCES missions(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);


-- ============================================================
-- 10. NOTIFICATIONS
-- ============================================================

CREATE TABLE notifications (
    id INT AUTO_INCREMENT PRIMARY KEY,

    user_id INT NOT NULL,

    sos_id INT NULL,

    mission_id INT NULL,

    notification_type VARCHAR(50) NOT NULL,

    message TEXT NOT NULL,

    is_read BOOLEAN NOT NULL DEFAULT FALSE,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_notification_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_notification_sos
        FOREIGN KEY (sos_id)
        REFERENCES sos_requests(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_notification_mission
        FOREIGN KEY (mission_id)
        REFERENCES missions(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);


-- ============================================================
-- 11. AUDIT LOGS
-- ============================================================

CREATE TABLE audit_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,

    user_id INT NULL,

    action VARCHAR(100) NOT NULL,

    entity_type VARCHAR(50) NOT NULL,

    entity_id INT NULL,

    details TEXT,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_audit_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);