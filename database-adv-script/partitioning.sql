-- Table Partitioning Implementation for Bookings Table
-- This file implements partitioning on the bookings table based on start_date
-- to optimize queries on large datasets

USE airbnb_clone;

-- ============================================================================
-- STEP 1: BACKUP ORIGINAL TABLE STRUCTURE
-- ============================================================================

-- First, let's create a backup of the original bookings table
CREATE TABLE bookings_backup AS SELECT * FROM bookings;

-- Verify backup was created successfully
SELECT COUNT(*) as backup_count FROM bookings_backup;
SELECT COUNT(*) as original_count FROM bookings;

-- ============================================================================
-- STEP 2: DROP ORIGINAL TABLE AND CREATE PARTITIONED VERSION
-- ============================================================================

-- Drop the original bookings table (foreign key constraints will be handled)
DROP TABLE IF EXISTS bookings;

-- Create the partitioned bookings table
CREATE TABLE bookings (
    id INT AUTO_INCREMENT,
    property_id INT NOT NULL,
    user_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    locked_price_per_night DECIMAL(10,2) NOT NULL,
    status ENUM('pending', 'confirmed', 'canceled') NOT NULL DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    PRIMARY KEY (id, start_date),  -- Include start_date in primary key for partitioning
    KEY idx_property_id (property_id),
    KEY idx_user_id (user_id),
    KEY idx_start_date (start_date),
    KEY idx_end_date (end_date),
    KEY idx_status (status),
    KEY idx_created_at (created_at),
    
    -- Check constraint for date validation
    CONSTRAINT chk_dates CHECK (start_date < end_date)
) PARTITION BY RANGE (YEAR(start_date)) (
    PARTITION p2020 VALUES LESS THAN (2021),
    PARTITION p2021 VALUES LESS THAN (2022),
    PARTITION p2022 VALUES LESS THAN (2023),
    PARTITION p2023 VALUES LESS THAN (2024),
    PARTITION p2024 VALUES LESS THAN (2025),
    PARTITION p2025 VALUES LESS THAN (2026),
    PARTITION p_future VALUES LESS THAN MAXVALUE
);

-- ============================================================================
-- STEP 3: RESTORE DATA TO PARTITIONED TABLE
-- ============================================================================

-- Insert data from backup into partitioned table
INSERT INTO bookings (
    id, property_id, user_id, start_date, end_date, 
    locked_price_per_night, status, created_at
)
SELECT 
    id, property_id, user_id, start_date, end_date, 
    locked_price_per_night, status, created_at
FROM bookings_backup
ORDER BY start_date;

-- Verify data was restored correctly
SELECT COUNT(*) as partitioned_count FROM bookings;
SELECT COUNT(*) as backup_count FROM bookings_backup;

-- ============================================================================
-- STEP 4: RECREATE FOREIGN KEY CONSTRAINTS
-- ============================================================================

-- Add foreign key constraints to the partitioned table
ALTER TABLE bookings 
ADD CONSTRAINT fk_bookings_property 
FOREIGN KEY (property_id) REFERENCES properties(id) ON DELETE CASCADE;

ALTER TABLE bookings 
ADD CONSTRAINT fk_bookings_user 
FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE;

-- ============================================================================
-- STEP 5: CREATE ADDITIONAL PARTITION-SPECIFIC INDEXES
-- ============================================================================

-- Create composite indexes optimized for partitioned queries
CREATE INDEX idx_bookings_status_date ON bookings (status, start_date);
CREATE INDEX idx_bookings_user_date ON bookings (user_id, start_date);
CREATE INDEX idx_bookings_property_date ON bookings (property_id, start_date);

-- ============================================================================
-- STEP 6: PERFORMANCE TESTING QUERIES
-- ============================================================================

-- Test 1: Query bookings by specific year (should use partition pruning)
EXPLAIN (ANALYZE, BUFFERS) 
SELECT COUNT(*) as bookings_2024
FROM bookings 
WHERE YEAR(start_date) = 2024;

-- Test 2: Query bookings by date range (should use partition pruning)
EXPLAIN (ANALYZE, BUFFERS) 
SELECT 
    b.id,
    b.start_date,
    b.end_date,
    b.status,
    u.first_name,
    u.last_name,
    p.name as property_name
FROM bookings b
INNER JOIN users u ON b.user_id = u.user_id
INNER JOIN properties p ON b.property_id = p.id
WHERE b.start_date BETWEEN '2024-01-01' AND '2024-12-31'
  AND b.status = 'confirmed'
ORDER BY b.start_date;

-- Test 3: Query bookings by month (should use partition pruning)
EXPLAIN (ANALYZE, BUFFERS) 
SELECT 
    MONTH(start_date) as month,
    COUNT(*) as booking_count,
    SUM(locked_price_per_night) as total_value
FROM bookings 
WHERE start_date >= '2024-01-01' AND start_date < '2025-01-01'
GROUP BY MONTH(start_date)
ORDER BY month;

-- Test 4: Complex query with multiple joins (partitioned vs non-partitioned)
EXPLAIN (ANALYZE, BUFFERS) 
SELECT 
    b.id as booking_id,
    b.start_date,
    b.end_date,
    b.locked_price_per_night,
    b.status,
    CONCAT(u.first_name, ' ', u.last_name) as guest_name,
    p.name as property_name,
    p.location,
    CONCAT(h.first_name, ' ', h.last_name) as host_name,
    COALESCE(SUM(pay.amount), 0) as total_paid
FROM bookings b
INNER JOIN users u ON b.user_id = u.user_id
INNER JOIN properties p ON b.property_id = p.id
INNER JOIN users h ON p.host_id = h.user_id
LEFT JOIN payments pay ON b.id = pay.booking_id
WHERE b.start_date >= '2024-01-01' 
  AND b.start_date < '2024-07-01'
  AND b.status IN ('confirmed', 'pending')
GROUP BY b.id, u.first_name, u.last_name, p.name, p.location, 
         h.first_name, h.last_name, b.start_date, b.end_date, 
         b.locked_price_per_night, b.status
ORDER BY b.start_date DESC
LIMIT 100;

-- ============================================================================
-- STEP 7: PARTITION MANAGEMENT QUERIES
-- ============================================================================

-- Check partition information
SELECT 
    partition_name,
    partition_ordinal_position,
    partition_method,
    partition_expression,
    partition_description,
    table_rows
FROM information_schema.partitions 
WHERE table_schema = 'airbnb_clone' 
AND table_name = 'bookings'
ORDER BY partition_ordinal_position;

-- Check which partitions are being used in queries
EXPLAIN PARTITIONS 
SELECT COUNT(*) FROM bookings WHERE start_date >= '2024-01-01' AND start_date < '2024-12-31';

-- ============================================================================
-- STEP 8: ADDITIONAL PARTITIONING STRATEGIES
-- ============================================================================

-- Option 1: Monthly partitioning for more granular control
-- (Uncomment if you want monthly partitions instead of yearly)

/*
-- Drop existing table and recreate with monthly partitions
DROP TABLE IF EXISTS bookings_monthly;

CREATE TABLE bookings_monthly (
    id INT AUTO_INCREMENT,
    property_id INT NOT NULL,
    user_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    locked_price_per_night DECIMAL(10,2) NOT NULL,
    status ENUM('pending', 'confirmed', 'canceled') NOT NULL DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    PRIMARY KEY (id, start_date),
    KEY idx_property_id (property_id),
    KEY idx_user_id (user_id),
    KEY idx_start_date (start_date),
    KEY idx_end_date (end_date),
    KEY idx_status (status),
    KEY idx_created_at (created_at),
    
    CONSTRAINT chk_dates CHECK (start_date < end_date)
) PARTITION BY RANGE (TO_DAYS(start_date)) (
    PARTITION p2024_01 VALUES LESS THAN (TO_DAYS('2024-02-01')),
    PARTITION p2024_02 VALUES LESS THAN (TO_DAYS('2024-03-01')),
    PARTITION p2024_03 VALUES LESS THAN (TO_DAYS('2024-04-01')),
    PARTITION p2024_04 VALUES LESS THAN (TO_DAYS('2024-05-01')),
    PARTITION p2024_05 VALUES LESS THAN (TO_DAYS('2024-06-01')),
    PARTITION p2024_06 VALUES LESS THAN (TO_DAYS('2024-07-01')),
    PARTITION p2024_07 VALUES LESS THAN (TO_DAYS('2024-08-01')),
    PARTITION p2024_08 VALUES LESS THAN (TO_DAYS('2024-09-01')),
    PARTITION p2024_09 VALUES LESS THAN (TO_DAYS('2024-10-01')),
    PARTITION p2024_10 VALUES LESS THAN (TO_DAYS('2024-11-01')),
    PARTITION p2024_11 VALUES LESS THAN (TO_DAYS('2024-12-01')),
    PARTITION p2024_12 VALUES LESS THAN (TO_DAYS('2025-01-01')),
    PARTITION p_future VALUES LESS THAN MAXVALUE
);
*/

-- Option 2: Hash partitioning for even distribution
-- (Uncomment if you want hash-based partitioning)

/*
-- Drop existing table and recreate with hash partitions
DROP TABLE IF EXISTS bookings_hash;

CREATE TABLE bookings_hash (
    id INT AUTO_INCREMENT,
    property_id INT NOT NULL,
    user_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    locked_price_per_night DECIMAL(10,2) NOT NULL,
    status ENUM('pending', 'confirmed', 'canceled') NOT NULL DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    PRIMARY KEY (id),
    KEY idx_property_id (property_id),
    KEY idx_user_id (user_id),
    KEY idx_start_date (start_date),
    KEY idx_end_date (end_date),
    KEY idx_status (status),
    KEY idx_created_at (created_at),
    
    CONSTRAINT chk_dates CHECK (start_date < end_date)
) PARTITION BY HASH(id) PARTITIONS 8;
*/

-- ============================================================================
-- STEP 9: PERFORMANCE COMPARISON WITH ORIGINAL TABLE
-- ============================================================================

-- Create a temporary non-partitioned table for comparison
CREATE TABLE bookings_non_partitioned AS SELECT * FROM bookings_backup;

-- Add indexes to non-partitioned table for fair comparison
ALTER TABLE bookings_non_partitioned 
ADD INDEX idx_start_date (start_date),
ADD INDEX idx_status (status),
ADD INDEX idx_user_id (user_id),
ADD INDEX idx_property_id (property_id);

-- Performance comparison: Partitioned vs Non-partitioned
-- Test 1: Date range query
EXPLAIN (ANALYZE, BUFFERS) 
SELECT COUNT(*) FROM bookings 
WHERE start_date >= '2024-01-01' AND start_date < '2024-12-31';

EXPLAIN (ANALYZE, BUFFERS) 
SELECT COUNT(*) FROM bookings_non_partitioned 
WHERE start_date >= '2024-01-01' AND start_date < '2024-12-31';

-- Test 2: Complex join query
EXPLAIN (ANALYZE, BUFFERS) 
SELECT b.id, b.start_date, u.first_name, p.name
FROM bookings b
INNER JOIN users u ON b.user_id = u.user_id
INNER JOIN properties p ON b.property_id = p.id
WHERE b.start_date >= '2024-01-01' AND b.start_date < '2024-07-01'
ORDER BY b.start_date;

EXPLAIN (ANALYZE, BUFFERS) 
SELECT b.id, b.start_date, u.first_name, p.name
FROM bookings_non_partitioned b
INNER JOIN users u ON b.user_id = u.user_id
INNER JOIN properties p ON b.property_id = p.id
WHERE b.start_date >= '2024-01-01' AND b.start_date < '2024-07-01'
ORDER BY b.start_date;

-- ============================================================================
-- STEP 10: CLEANUP
-- ============================================================================

-- Drop temporary tables (uncomment when ready to clean up)
-- DROP TABLE IF EXISTS bookings_backup;
-- DROP TABLE IF EXISTS bookings_non_partitioned;

-- ============================================================================
-- STEP 11: MONITORING AND MAINTENANCE QUERIES
-- ============================================================================

-- Monitor partition usage
SELECT 
    partition_name,
    table_rows,
    data_length,
    index_length
FROM information_schema.partitions 
WHERE table_schema = 'airbnb_clone' 
AND table_name = 'bookings';

-- Check for partition pruning effectiveness
EXPLAIN PARTITIONS 
SELECT COUNT(*) FROM bookings WHERE start_date = '2024-06-15';

-- Monitor query performance over time
SELECT 
    query,
    calls,
    total_time,
    mean_time,
    rows
FROM pg_stat_statements
WHERE query LIKE '%bookings%'
ORDER BY total_time DESC
LIMIT 10; 