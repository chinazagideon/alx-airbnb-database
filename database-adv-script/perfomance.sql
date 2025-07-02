-- Performance Analysis: Bookings with User, Property, and Payment Details
-- This file contains the initial query, performance analysis, and optimized versions

USE airbnb_clone;

-- ============================================================================
-- INITIAL QUERY (Unoptimized)
-- ============================================================================
-- This query retrieves all bookings with user, property, and payment details
-- but may have performance issues due to multiple joins and lack of optimization

SELECT 
    b.id as booking_id,
    b.start_date,
    b.end_date,
    b.locked_price_per_night,
    b.status,
    b.created_at as booking_created_at,
    
    -- User details
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.phone_number,
    u.role as user_role,
    u.created_at as user_created_at,
    
    -- Property details
    p.id as property_id,
    p.name as property_name,
    p.description as property_description,
    p.location,
    p.price_per_night,
    p.created_at as property_created_at,
    
    -- Host details
    h.user_id as host_id,
    h.first_name as host_first_name,
    h.last_name as host_last_name,
    h.email as host_email,
    
    -- Payment details
    pay.id as payment_id,
    pay.amount,
    pay.payment_date,
    pay.payment_method
FROM bookings b
LEFT JOIN users u ON b.user_id = u.user_id
LEFT JOIN properties p ON b.property_id = p.id
LEFT JOIN users h ON p.host_id = h.user_id
LEFT JOIN payments pay ON b.id = pay.booking_id
ORDER BY b.created_at DESC;

-- ============================================================================
-- PERFORMANCE ANALYSIS USING EXPLAIN
-- ============================================================================

-- Analyze the initial query performance
EXPLAIN (ANALYZE, BUFFERS) 
SELECT 
    b.id as booking_id,
    b.start_date,
    b.end_date,
    b.locked_price_per_night,
    b.status,
    b.created_at as booking_created_at,
    
    -- User details
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.phone_number,
    u.role as user_role,
    u.created_at as user_created_at,
    
    -- Property details
    p.id as property_id,
    p.name as property_name,
    p.description as property_description,
    p.location,
    p.price_per_night,
    p.created_at as property_created_at,
    
    -- Host details
    h.user_id as host_id,
    h.first_name as host_first_name,
    h.last_name as host_last_name,
    h.email as host_email,
    
    -- Payment details
    pay.id as payment_id,
    pay.amount,
    pay.payment_date,
    pay.payment_method
FROM bookings b
LEFT JOIN users u ON b.user_id = u.user_id
LEFT JOIN properties p ON b.property_id = p.id
LEFT JOIN users h ON p.host_id = h.user_id
LEFT JOIN payments pay ON b.id = pay.booking_id
ORDER BY b.created_at DESC;

-- ============================================================================
-- IDENTIFIED PERFORMANCE ISSUES
-- ============================================================================
/*
1. Multiple LEFT JOINs without proper indexing strategy
2. ORDER BY on a large dataset without index optimization
3. Selecting all columns including large TEXT fields (description)
4. No WHERE clause to limit the result set
5. Potential for duplicate data due to payment relationships
6. Inefficient join order
*/

-- ============================================================================
-- OPTIMIZED QUERY VERSION 1: Basic Optimization
-- ============================================================================
-- Improvements: Added WHERE clause, limited columns, better join order

EXPLAIN (ANALYZE, BUFFERS) 
SELECT 
    b.id as booking_id,
    b.start_date,
    b.end_date,
    b.locked_price_per_night,
    b.status,
    b.created_at as booking_created_at,
    
    -- User details (essential only)
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.role as user_role,
    
    -- Property details (essential only)
    p.id as property_id,
    p.name as property_name,
    p.location,
    p.price_per_night,
    
    -- Host details (essential only)
    h.first_name as host_first_name,
    h.last_name as host_last_name,
    
    -- Payment details
    pay.amount,
    pay.payment_method
FROM bookings b
INNER JOIN users u ON b.user_id = u.user_id
INNER JOIN properties p ON b.property_id = p.id
INNER JOIN users h ON p.host_id = h.user_id
LEFT JOIN payments pay ON b.id = pay.booking_id
WHERE b.created_at >= '2023-01-01'  -- Limit to recent bookings
ORDER BY b.created_at DESC
LIMIT 100;  -- Limit result set for performance testing

-- ============================================================================
-- OPTIMIZED QUERY VERSION 2: Advanced Optimization with Indexing Strategy
-- ============================================================================
-- Improvements: Composite indexes, pagination, selective column retrieval

-- First, let's create some additional composite indexes for better performance
CREATE INDEX IF NOT EXISTS idx_bookings_user_status_date ON bookings (user_id, status, created_at);
CREATE INDEX IF NOT EXISTS idx_properties_host_location ON properties (host_id, location);
CREATE INDEX IF NOT EXISTS idx_payments_booking_amount ON payments (booking_id, amount);

-- Now the optimized query
EXPLAIN (ANALYZE, BUFFERS) 
SELECT 
    b.id as booking_id,
    b.start_date,
    b.end_date,
    b.locked_price_per_night,
    b.status,
    b.created_at as booking_created_at,
    
    -- User details
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.role as user_role,
    
    -- Property details
    p.id as property_id,
    p.name as property_name,
    p.location,
    p.price_per_night,
    
    -- Host details
    h.first_name as host_first_name,
    h.last_name as host_last_name,
    
    -- Payment details (using subquery for better performance)
    (SELECT pay.amount FROM payments pay WHERE pay.booking_id = b.id LIMIT 1) as payment_amount,
    (SELECT pay.payment_method FROM payments pay WHERE pay.booking_id = b.id LIMIT 1) as payment_method
FROM bookings b
INNER JOIN users u ON b.user_id = u.user_id
INNER JOIN properties p ON b.property_id = p.id
INNER JOIN users h ON p.host_id = h.user_id
WHERE b.status IN ('confirmed', 'pending')  -- Filter by status
  AND b.created_at >= '2023-01-01'  -- Filter by date
ORDER BY b.created_at DESC
LIMIT 50 OFFSET 0;  -- Pagination

-- ============================================================================
-- OPTIMIZED QUERY VERSION 3: Materialized View Approach
-- ============================================================================
-- For frequently accessed data, consider creating a materialized view or summary table

-- Create a summary table for booking analytics
CREATE TABLE IF NOT EXISTS booking_summary (
    booking_id INT PRIMARY KEY,
    user_id INT,
    user_name VARCHAR(100),
    user_email VARCHAR(100),
    property_id INT,
    property_name VARCHAR(100),
    property_location VARCHAR(255),
    host_name VARCHAR(100),
    start_date DATE,
    end_date DATE,
    total_amount DECIMAL(10,2),
    status VARCHAR(20),
    booking_created_at TIMESTAMP,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_user_id (user_id),
    INDEX idx_property_id (property_id),
    INDEX idx_status_date (status, booking_created_at),
    INDEX idx_host_name (host_name)
);

-- Populate the summary table (run this periodically or on booking changes)
INSERT INTO booking_summary (
    booking_id, user_id, user_name, user_email, property_id, property_name, 
    property_location, host_name, start_date, end_date, total_amount, 
    status, booking_created_at
)
SELECT 
    b.id as booking_id,
    b.user_id,
    CONCAT(u.first_name, ' ', u.last_name) as user_name,
    u.email as user_email,
    b.property_id,
    p.name as property_name,
    p.location as property_location,
    CONCAT(h.first_name, ' ', h.last_name) as host_name,
    b.start_date,
    b.end_date,
    COALESCE(pay.amount, 0) as total_amount,
    b.status,
    b.created_at as booking_created_at
FROM bookings b
INNER JOIN users u ON b.user_id = u.user_id
INNER JOIN properties p ON b.property_id = p.id
INNER JOIN users h ON p.host_id = h.user_id
LEFT JOIN payments pay ON b.id = pay.booking_id
ON DUPLICATE KEY UPDATE
    user_name = VALUES(user_name),
    user_email = VALUES(user_email),
    property_name = VALUES(property_name),
    property_location = VALUES(property_location),
    host_name = VALUES(host_name),
    total_amount = VALUES(total_amount),
    status = VALUES(status),
    last_updated = CURRENT_TIMESTAMP;

-- Query the summary table (much faster)
EXPLAIN (ANALYZE, BUFFERS) 
SELECT * FROM booking_summary 
WHERE status IN ('confirmed', 'pending')
  AND booking_created_at >= '2023-01-01'
ORDER BY booking_created_at DESC
LIMIT 50;

-- ============================================================================
-- PERFORMANCE COMPARISON QUERIES
-- ============================================================================

-- Compare execution times for different approaches
-- Run these queries and compare the results

-- 1. Count total bookings for performance baseline
SELECT COUNT(*) as total_bookings FROM bookings;

-- 2. Check index usage
SELECT 
    table_name,
    index_name,
    column_name,
    cardinality
FROM information_schema.statistics 
WHERE table_schema = 'airbnb_clone' 
AND table_name IN ('bookings', 'users', 'properties', 'payments')
ORDER BY table_name, index_name;

-- 3. Analyze table sizes
SELECT 
    table_name,
    table_rows,
    ROUND(((data_length + index_length) / 1024 / 1024), 2) AS 'Size (MB)'
FROM information_schema.tables 
WHERE table_schema = 'airbnb_clone'
AND table_name IN ('bookings', 'users', 'properties', 'payments')
ORDER BY (data_length + index_length) DESC;

-- ============================================================================
-- RECOMMENDATIONS FOR FURTHER OPTIMIZATION
-- ============================================================================
/*
1. Implement database partitioning for large tables (by date or status)
2. Use read replicas for reporting queries
3. Implement query result caching at application level
4. Consider using JSON columns for flexible property attributes
5. Implement database connection pooling
6. Use prepared statements for repeated queries
7. Monitor slow query log and optimize based on actual usage patterns
8. Consider using views for complex, frequently-used queries
9. Implement proper database maintenance schedules (ANALYZE, OPTIMIZE)
10. Use appropriate data types and avoid over-indexing
*/

-- ============================================================================
-- FINAL OPTIMIZED QUERY (Production Ready)
-- ============================================================================
-- This is the recommended query for production use

EXPLAIN (ANALYZE, BUFFERS) 
SELECT 
    b.id as booking_id,
    b.start_date,
    b.end_date,
    b.locked_price_per_night,
    b.status,
    b.created_at as booking_created_at,
    
    -- User details
    u.user_id,
    CONCAT(u.first_name, ' ', u.last_name) as user_full_name,
    u.email,
    u.role as user_role,
    
    -- Property details
    p.id as property_id,
    p.name as property_name,
    p.location,
    p.price_per_night,
    
    -- Host details
    CONCAT(h.first_name, ' ', h.last_name) as host_full_name,
    
    -- Payment details (aggregated)
    COALESCE(SUM(pay.amount), 0) as total_paid_amount,
    COUNT(pay.id) as payment_count
FROM bookings b
INNER JOIN users u ON b.user_id = u.user_id
INNER JOIN properties p ON b.property_id = p.id
INNER JOIN users h ON p.host_id = h.user_id
LEFT JOIN payments pay ON b.id = pay.booking_id
WHERE b.status IN ('confirmed', 'pending')
  AND b.created_at >= '2023-01-01'
GROUP BY b.id, u.user_id, u.first_name, u.last_name, u.email, u.role,
         p.id, p.name, p.location, p.price_per_night,
         h.first_name, h.last_name, b.start_date, b.end_date, 
         b.locked_price_per_night, b.status, b.created_at
ORDER BY b.created_at DESC
LIMIT 50;