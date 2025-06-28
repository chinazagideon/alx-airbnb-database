# AirBnb Clone Database Schema

## Overview
This database schema implements a complete AirBnb clone system with proper normalization (1NF, 2NF, 3NF) and optimized performance through strategic indexing.

## Database Structure

### Tables Overview
1. **users** - User management and authentication
2. **properties** - Property listings and details
3. **bookings** - Reservation and booking management
4. **payments** - Payment processing and tracking
5. **reviews** - User reviews and ratings
6. **messages** - User communication system

## Entity Relationships

### Users Table
- **Primary Key**: `id` (AUTO_INCREMENT)
- **Unique Constraints**: `email`
- **Foreign Key Relationships**: 
  - Referenced by: `properties.host_id`, `bookings.user_id`, `reviews.user_id`, `messages.sender_id`, `messages.recipient_id`

### Properties Table
- **Primary Key**: `id` (AUTO_INCREMENT)
- **Foreign Key**: `host_id` → `users.id`
- **Foreign Key Relationships**:
  - Referenced by: `bookings.property_id`, `reviews.property_id`

### Bookings Table
- **Primary Key**: `id` (AUTO_INCREMENT)
- **Foreign Keys**: 
  - `property_id` → `properties.id`
  - `user_id` → `users.id`
- **Foreign Key Relationships**:
  - Referenced by: `payments.booking_id`

### Payments Table
- **Primary Key**: `id` (AUTO_INCREMENT)
- **Foreign Key**: `booking_id` → `bookings.id`

### Reviews Table
- **Primary Key**: `id` (AUTO_INCREMENT)
- **Foreign Keys**:
  - `property_id` → `properties.id`
  - `user_id` → `users.id`

### Messages Table
- **Primary Key**: `id` (AUTO_INCREMENT)
- **Foreign Keys**:
  - `sender_id` → `users.id`
  - `recipient_id` → `users.id`

## Data Types and Constraints

### User Entity
- `id`: INT AUTO_INCREMENT PRIMARY KEY
- `first_name`: VARCHAR(50) NOT NULL
- `last_name`: VARCHAR(50) NOT NULL
- `email`: VARCHAR(100) UNIQUE NOT NULL
- `password_hash`: VARCHAR(255) NOT NULL
- `phone_number`: VARCHAR(20) NULL
- `role`: ENUM('guest', 'host', 'admin') NOT NULL DEFAULT 'guest'
- `created_at`: TIMESTAMP DEFAULT CURRENT_TIMESTAMP

### Property Entity
- `id`: INT AUTO_INCREMENT PRIMARY KEY
- `host_id`: INT NOT NULL (FK to users.id)
- `name`: VARCHAR(100) NOT NULL
- `description`: TEXT NOT NULL
- `location`: VARCHAR(255) NOT NULL
- `price_per_night`: DECIMAL(10,2) NOT NULL
- `updated_at`: TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
- `created_at`: TIMESTAMP DEFAULT CURRENT_TIMESTAMP

### Booking Entity
- `id`: INT AUTO_INCREMENT PRIMARY KEY
- `property_id`: INT NOT NULL (FK to properties.id)
- `user_id`: INT NOT NULL (FK to users.id)
- `start_date`: DATE NOT NULL
- `end_date`: DATE NOT NULL
- `locked_price_per_night`: DECIMAL(10,2) NOT NULL
- `status`: ENUM('pending', 'confirmed', 'canceled') NOT NULL DEFAULT 'pending'
- `created_at`: TIMESTAMP DEFAULT CURRENT_TIMESTAMP

### Payment Entity
- `id`: INT AUTO_INCREMENT PRIMARY KEY
- `booking_id`: INT NOT NULL (FK to bookings.id)
- `amount`: DECIMAL(10,2) NOT NULL
- `payment_date`: DATE NOT NULL
- `payment_method`: ENUM('credit_card', 'paypal', 'stripe') NOT NULL

### Review Entity
- `id`: INT AUTO_INCREMENT PRIMARY KEY
- `property_id`: INT NOT NULL (FK to properties.id)
- `user_id`: INT NOT NULL (FK to users.id)
- `rating`: INT NOT NULL (CHECK: 1-5)
- `comment`: TEXT NOT NULL
- `created_at`: TIMESTAMP DEFAULT CURRENT_TIMESTAMP

### Message Entity
- `id`: INT AUTO_INCREMENT PRIMARY KEY
- `sender_id`: INT NOT NULL (FK to users.id)
- `recipient_id`: INT NOT NULL (FK to users.id)
- `message_body`: TEXT NOT NULL
- `sent_at`: TIMESTAMP DEFAULT CURRENT_TIMESTAMP

## Constraints and Validations

### Check Constraints
- **Bookings**: `start_date < end_date`
- **Reviews**: `rating >= 1 AND rating <= 5`
- **Messages**: `sender_id != recipient_id` (prevents self-messaging)

### Foreign Key Constraints
All foreign keys use `ON DELETE CASCADE` to maintain referential integrity.

## Performance Optimization

### Indexes
The schema includes comprehensive indexing for optimal query performance:

#### Single Column Indexes
- `users`: email, role, created_at
- `properties`: host_id, location, price_per_night, created_at
- `bookings`: property_id, user_id, start_date, end_date, status, created_at
- `payments`: booking_id, payment_date, payment_method
- `reviews`: property_id, user_id, rating, created_at
- `messages`: sender_id, recipient_id, sent_at

#### Composite Indexes
- `idx_booking_dates`: (property_id, start_date, end_date) - for date range queries
- `idx_review_property_rating`: (property_id, rating) - for property rating analysis
- `idx_message_conversation`: (sender_id, recipient_id, sent_at) - for conversation threads

## Normalization Compliance

### 1NF (First Normal Form)
- All tables contain atomic values
- No repeating groups or arrays
- Each column contains single values

### 2NF (Second Normal Form)
- All tables are in 1NF
- No partial dependencies on primary keys
- Proper foreign key relationships established

### 3NF (Third Normal Form)
- All tables are in 2NF
- No transitive dependencies
- Eliminated derived data (e.g., total_price)
- Used `locked_price_per_night` for audit tracking

## Usage Instructions

### Database Setup
1. Execute the `schema.sql` file in your MySQL server
2. The script will create the `airbnb_clone` database and all tables
3. All necessary indexes and constraints will be automatically created

### Example Queries

#### Find all properties by a specific host
```sql
SELECT p.*, u.first_name, u.last_name 
FROM properties p 
JOIN users u ON p.host_id = u.id 
WHERE u.id = ?;
```

#### Get booking history for a user
```sql
SELECT b.*, p.name as property_name, p.location
FROM bookings b
JOIN properties p ON b.property_id = p.id
WHERE b.user_id = ?
ORDER BY b.created_at DESC;
```

#### Calculate average rating for a property
```sql
SELECT AVG(rating) as avg_rating, COUNT(*) as review_count
FROM reviews
WHERE property_id = ?;
```

## Security Considerations

1. **Password Storage**: Uses `password_hash` field for secure password storage
2. **Data Validation**: Check constraints prevent invalid data entry
3. **Referential Integrity**: Foreign key constraints maintain data consistency
4. **Access Control**: Role-based user system (guest, host, admin)

## Scalability Features

1. **Efficient Indexing**: Strategic indexes for common query patterns
2. **Audit Trail**: Timestamp fields for tracking data changes
3. **Flexible Pricing**: `locked_price_per_night` for historical price tracking
4. **Message System**: Supports user-to-user communication
5. **Review System**: Comprehensive rating and feedback mechanism

## Maintenance Notes

- Regular index maintenance may be required for large datasets
- Consider partitioning for high-volume tables (bookings, messages)
- Monitor foreign key performance on frequently updated tables
- Backup strategy should account for referential integrity constraints
