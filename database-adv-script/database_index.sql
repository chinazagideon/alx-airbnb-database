-- Identify high-usage columns in your User, Booking, and Property tables (e.g., columns used in WHERE, JOIN, ORDER BY clauses).

-- First, let's identify existing indexes and analyze table structure
SELECT 
    table_name,
    column_name,
    data_type,
    is_nullable,
    column_key
FROM information_schema.columns 
WHERE table_schema = 'airbnb_clone' 
AND table_name IN ('users', 'bookings', 'properties')
ORDER BY table_name, ordinal_position;

-- Check existing indexes
SELECT 
    table_name,
    index_name,
    column_name,
    seq_in_index,
    non_unique
FROM information_schema.statistics 
WHERE table_schema = 'airbnb_clone' 
AND table_name IN ('users', 'bookings', 'properties')
ORDER BY table_name, index_name, seq_in_index;

-- Analyze high-usage columns based on common query patterns:

-- 1. USERS TABLE - High-usage columns identified:
--    - user_id (PRIMARY KEY) - Used in JOINs, WHERE clauses
--    - email (UNIQUE) - Authentication, user lookup
--    - role (ENUM) - Access control, filtering
--    - created_at (TIMESTAMP) - Date range queries, analytics

-- 2. BOOKINGS TABLE - High-usage columns identified:
--    - id (PRIMARY KEY) - Booking lookup, JOINs
--    - user_id (FOREIGN KEY) - User booking history, JOINs
--    - property_id (FOREIGN KEY) - Property booking history, JOINs
--    - start_date (DATE) - Date range queries, availability checks
--    - end_date (DATE) - Date range queries, availability checks
--    - status (ENUM) - Booking status filtering
--    - created_at (TIMESTAMP) - Date range queries, analytics

-- 3. PROPERTIES TABLE - High-usage columns identified:
--    - id (PRIMARY KEY) - Property lookup, JOINs
--    - host_id (FOREIGN KEY) - Host property listings, JOINs
--    - location (VARCHAR) - Location-based searches
--    - price_per_night (DECIMAL) - Price filtering, sorting
--    - created_at (TIMESTAMP) - Date range queries, analytics

-- Create indexes for high-usage columns that don't already exist
-- Note: Primary keys and unique constraints already create indexes

-- Users table indexes (check if they exist first)
CREATE INDEX IF NOT EXISTS idx_users_role ON users (role);
CREATE INDEX IF NOT EXISTS idx_users_created_at ON users (created_at);

-- Bookings table indexes (check if they exist first)
CREATE INDEX IF NOT EXISTS idx_bookings_user_id ON bookings (user_id);
CREATE INDEX IF NOT EXISTS idx_bookings_property_id ON bookings (property_id);
CREATE INDEX IF NOT EXISTS idx_bookings_start_date ON bookings (start_date);
CREATE INDEX IF NOT EXISTS idx_bookings_end_date ON bookings (end_date);
CREATE INDEX IF NOT EXISTS idx_bookings_status ON bookings (status);
CREATE INDEX IF NOT EXISTS idx_bookings_created_at ON bookings (created_at);

-- Properties table indexes (check if they exist first)
CREATE INDEX IF NOT EXISTS idx_properties_host_id ON properties (host_id);
CREATE INDEX IF NOT EXISTS idx_properties_location ON properties (location);
CREATE INDEX IF NOT EXISTS idx_properties_price_per_night ON properties (price_per_night);
CREATE INDEX IF NOT EXISTS idx_properties_created_at ON properties (created_at);

-- Create composite indexes for common query patterns
CREATE INDEX IF NOT EXISTS idx_bookings_dates_range ON bookings (property_id, start_date, end_date);
CREATE INDEX IF NOT EXISTS idx_bookings_user_status ON bookings (user_id, status);
CREATE INDEX IF NOT EXISTS idx_properties_host_location ON properties (host_id, location);
CREATE INDEX IF NOT EXISTS idx_properties_price_location ON properties (price_per_night, location);

-- Measure the query performance before and after adding indexes using EXPLAIN or ANALYZE.

-- Performance measurement queries to demonstrate index impact

-- 1. User authentication query (high frequency)
EXPLAIN (ANALYZE, BUFFERS) 
SELECT user_id, first_name, last_name, role 
FROM users 
WHERE email = 'john.smith@gmail.com';

-- 2. User booking history (common user dashboard query)
EXPLAIN (ANALYZE, BUFFERS) 
SELECT b.id, b.start_date, b.end_date, b.status, p.name as property_name
FROM bookings b
JOIN properties p ON b.property_id = p.id
WHERE b.user_id = 6
ORDER BY b.created_at DESC;

-- 3. Property availability check (critical for booking system)
EXPLAIN (ANALYZE, BUFFERS) 
SELECT COUNT(*) as conflicting_bookings
FROM bookings 
WHERE property_id = 1 
AND status = 'confirmed'
AND (
    (start_date <= '2024-02-15' AND end_date >= '2024-02-10') OR
    (start_date >= '2024-02-10' AND start_date < '2024-02-15')
);

-- 4. Host property listings (host dashboard)
EXPLAIN (ANALYZE, BUFFERS) 
SELECT p.id, p.name, p.location, p.price_per_night, COUNT(b.id) as total_bookings
FROM properties p
LEFT JOIN bookings b ON p.id = b.property_id
WHERE p.host_id = 1
GROUP BY p.id, p.name, p.location, p.price_per_night
ORDER BY p.created_at DESC;

-- 5. Location-based property search (common search functionality)
EXPLAIN (ANALYZE, BUFFERS) 
SELECT id, name, location, price_per_night
FROM properties 
WHERE location LIKE '%Downtown%'
AND price_per_night BETWEEN 100 AND 300
ORDER BY price_per_night ASC;

-- 6. Booking status analysis (admin/reporting query)
EXPLAIN (ANALYZE, BUFFERS) 
SELECT status, COUNT(*) as booking_count, 
       AVG(DATEDIFF(end_date, start_date)) as avg_duration
FROM bookings 
WHERE created_at >= '2024-01-01'
GROUP BY status
ORDER BY booking_count DESC;

-- 7. User activity analysis (analytics query)
EXPLAIN (ANALYZE, BUFFERS) 
SELECT u.user_id, u.first_name, u.last_name, u.role,
       COUNT(b.id) as total_bookings,
       COUNT(CASE WHEN b.status = 'confirmed' THEN 1 END) as confirmed_bookings
FROM users u
LEFT JOIN bookings b ON u.user_id = b.user_id
WHERE u.created_at >= '2023-01-01'
GROUP BY u.user_id, u.first_name, u.last_name, u.role
HAVING total_bookings > 0
ORDER BY total_bookings DESC;

-- 8. Performance comparison: Before vs After indexes
-- Run these queries and compare execution times:

-- Before creating indexes (if indexes don't exist):
-- EXPLAIN (ANALYZE, BUFFERS) SELECT * FROM users WHERE email = 'john.smith@email.com';

-- After creating indexes:
-- EXPLAIN (ANALYZE, BUFFERS) SELECT * FROM users WHERE email = 'john.smith@email.com';

-- 9. Check index usage statistics
SELECT 
    schemaname,
    tablename,
    indexname,
    idx_scan as index_scans,
    idx_tup_read as tuples_read,
    idx_tup_fetch as tuples_fetched
FROM pg_stat_user_indexes
WHERE tablename IN ('users', 'bookings', 'properties')
ORDER BY idx_scan DESC;

-- 10. Monitor query performance over time
SELECT 
    query,
    calls,
    total_time,
    mean_time,
    rows
FROM pg_stat_statements
WHERE query LIKE '%users%' OR query LIKE '%bookings%' OR query LIKE '%properties%'
ORDER BY total_time DESC
LIMIT 10;

-- 11. Analyze index effectiveness
SELECT 
    t.tablename,
    indexname,
    c.reltuples AS num_rows,
    pg_size_pretty(pg_relation_size(quote_ident(t.schemaname)||'.'||quote_ident(t.tablename)::regclass)) AS table_size,
    pg_size_pretty(pg_relation_size(quote_ident(t.schemaname)||'.'||quote_ident(t.indexname)::regclass)) AS index_size,
    CASE WHEN indisunique THEN 'Y' ELSE 'N' END AS UNIQUE,
    idx_scan as number_of_scans,
    idx_tup_read as tuples_read,
    idx_tup_fetch as tuples_fetched
FROM pg_tables t
LEFT OUTER JOIN pg_class c ON c.relname=t.tablename
LEFT OUTER JOIN (
    SELECT c.relname AS ctablename, ipg.relname AS indexname, x.indnatts AS number_of_columns, idx_scan, idx_tup_read, idx_tup_fetch, indexrelname, indisunique FROM pg_index x
    JOIN pg_class c ON c.oid = x.indrelid
    JOIN pg_class ipg ON ipg.oid = x.indexrelid
    JOIN pg_stat_all_indexes psai ON x.indexrelid = psai.indexrelid
) AS foo
ON t.tablename = foo.ctablename
WHERE t.schemaname='airbnb_clone'
AND t.tablename IN ('users', 'bookings', 'properties')
ORDER BY 1,2;

