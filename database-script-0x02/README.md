# AirBnb Clone Database Seed Data

## Overview
This directory contains the seed data implementation for the AirBnb clone database. The `seed.sql` file populates the database with realistic sample data for testing, development, and demonstration purposes.

## Seed Data Structure

### Sample Users (14 total)
- **5 Hosts**: Property owners with multiple listings
- **8 Guests**: Regular users who book properties
- **1 Admin**: System administrator

#### Host Profiles
- **Sarah Johnson**: Downtown apartment and luxury penthouse
- **Michael Chen**: Garden cottage and studio loft
- **Emily Rodriguez**: Beachfront condo and mountain cabin
- **David Thompson**: Historic townhouse and urban loft
- **Lisa Wang**: Lakeside villa and business suite

#### Guest Profiles
- **John Smith, Maria Garcia, Robert Brown, Jennifer Davis**
- **James Wilson, Amanda Taylor, Christopher Anderson, Jessica Martinez**

### Sample Properties (10 total)
Each host has 2 properties with diverse characteristics:

| Property | Type | Location | Price/Night | Features |
|----------|------|----------|-------------|----------|
| Cozy Downtown Apartment | 1BR Apartment | Downtown, City Center | $120 | Modern, walkable location |
| Luxury Penthouse Suite | 2BR Penthouse | Uptown, Luxury District | $350 | Panoramic views, concierge |
| Charming Garden Cottage | 1BR Cottage | Suburban Area, Garden District | $95 | Peaceful, garden views |
| Modern Studio Loft | Studio Loft | Arts District, Creative Quarter | $140 | Industrial design, trendy area |
| Beachfront Condo | 2BR Condo | Beachfront, Coastal Area | $280 | Ocean views, beach access |
| Mountain Cabin Retreat | 3BR Cabin | Mountain Region, Forest Area | $180 | Hiking trails, nature views |
| Historic Townhouse | 3BR Townhouse | Historic District, Cultural Quarter | $220 | Restored, cultural sites |
| Urban Loft Space | 1BR Loft | Industrial District, Urban Area | $160 | Exposed brick, vibrant area |
| Lakeside Villa | 4BR Villa | Lakeside, Waterfront Area | $400 | Lake access, water sports |
| Downtown Business Suite | 1BR Suite | Business District, Corporate Area | $200 | Business-focused, high-speed internet |

### Sample Bookings (14 total)
- **8 Confirmed bookings** with completed payments
- **4 Pending bookings** awaiting confirmation
- **3 Canceled bookings** for realistic scenarios

#### Booking Status Distribution
- **Confirmed**: 57% (8 bookings)
- **Pending**: 29% (4 bookings)
- **Canceled**: 14% (3 bookings)

### Sample Payments (8 total)
All confirmed bookings have corresponding payments using various methods:
- **Credit Card**: 4 payments
- **PayPal**: 2 payments
- **Stripe**: 2 payments

### Sample Reviews (11 total)
- **5-star reviews**: 6 reviews
- **4-star reviews**: 5 reviews
- **Average rating**: 4.5 stars

#### Review Content Examples
- Location and cleanliness feedback
- Host responsiveness comments
- Amenity and experience reviews
- Repeat guest testimonials

### Sample Messages (25 total)
- **Guest-Host conversations**: 16 messages
- **Guest-Guest conversations**: 4 messages
- **Host-Host conversations**: 5 messages

#### Message Topics
- Property availability inquiries
- Amenity and policy questions
- Check-in process discussions
- Local recommendations
- Community interactions

## Data Relationships

### Realistic Booking Patterns
- Multiple bookings per property
- Various booking durations (2-5 nights)
- Seasonal booking patterns
- Price variations based on property type

### Authentic User Interactions
- Host-guest communication about bookings
- Guest-to-guest community building
- Host-to-host professional networking
- Realistic inquiry and response patterns

### Payment Tracking
- Complete payment records for confirmed bookings
- Various payment methods reflecting real-world usage
- Accurate payment amounts based on booking duration

## Usage Instructions

### Running the Seed Script
1. Ensure the database schema is already created using `database-script-0x01/schema.sql`
2. Execute the seed script:
   ```sql
   mysql -u username -p airbnb_clone < database-script-0x02/seed.sql
   ```

### Verification Queries
After running the seed script, you can verify the data with these queries:

```sql
-- Check total records in each table
SELECT 'Users' as table_name, COUNT(*) as count FROM users
UNION ALL
SELECT 'Properties', COUNT(*) FROM properties
UNION ALL
SELECT 'Bookings', COUNT(*) FROM bookings
UNION ALL
SELECT 'Payments', COUNT(*) FROM payments
UNION ALL
SELECT 'Reviews', COUNT(*) FROM reviews
UNION ALL
SELECT 'Messages', COUNT(*) FROM messages;

-- Verify booking status distribution
SELECT status, COUNT(*) as count, 
       ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM bookings), 1) as percentage
FROM bookings 
GROUP BY status;

-- Check average property ratings
SELECT p.name, AVG(r.rating) as avg_rating, COUNT(r.id) as review_count
FROM properties p
LEFT JOIN reviews r ON p.id = r.property_id
GROUP BY p.id, p.name
ORDER BY avg_rating DESC;
```

## Sample Data Features

### Realistic Scenarios
- **Seasonal Booking Patterns**: Summer beach bookings, winter mountain retreats
- **Price Variations**: Different price points based on property type and location
- **User Roles**: Clear distinction between hosts, guests, and admin
- **Communication Flow**: Natural conversation patterns between users

### Data Quality
- **Referential Integrity**: All foreign keys properly linked
- **Date Consistency**: Logical sequence of booking, payment, and review dates
- **Realistic Content**: Authentic property descriptions and user interactions
- **Diverse Locations**: Various property types and locations

### Testing Scenarios
- **Booking Management**: Confirmed, pending, and canceled bookings
- **Payment Processing**: Multiple payment methods and amounts
- **Review System**: Various ratings and detailed feedback
- **Communication**: Different types of user interactions
- **Property Types**: Diverse accommodation options

## Development Benefits

### Testing
- Comprehensive test data for all application features
- Realistic user scenarios for UI/UX testing
- Various booking states for workflow testing
- Multiple payment methods for payment processing testing

### Demonstration
- Rich dataset for showcasing application capabilities
- Realistic user stories for presentations
- Diverse property types for feature demonstrations
- Authentic user interactions for user experience examples

### Development
- Ready-to-use data for development and debugging
- Consistent dataset across development environments
- Realistic constraints and relationships for testing
- Comprehensive coverage of all database entities

## Data Maintenance

### Adding New Data
To add more sample data, follow the existing patterns:
- Maintain referential integrity with existing data
- Use realistic values for dates, prices, and content
- Ensure proper foreign key relationships
- Follow the established naming conventions

### Updating Existing Data
When modifying seed data:
- Update related records to maintain consistency
- Preserve realistic relationships and constraints
- Update summary queries if needed
- Document any significant changes

## Security Notes

- **Password Hashes**: Sample password hashes are for demonstration only
- **Email Addresses**: All email addresses are fictional
- **Phone Numbers**: All phone numbers are placeholder values
- **Personal Data**: No real personal information is included

## Performance Considerations

- **Index Usage**: Sample data is designed to work efficiently with existing indexes
- **Query Optimization**: Data volume is optimized for development and testing
- **Scalability**: Structure supports easy expansion for larger datasets
- **Memory Usage**: Balanced data volume for efficient processing
