-- AirBnb Clone Database Seed Data
-- Populates the database with realistic sample data for testing and development

USE airbnb_clone;

-- Insert sample users (guests, hosts, and admins)
INSERT INTO users (first_name, last_name, email, password_hash, phone_number, role, created_at) VALUES
-- Hosts
('Sarah', 'Johnson', 'sarah.johnson@email.com', '$2y$10$hashedpassword123', '+1-555-0101', 'host', '2023-01-15 10:30:00'),
('Michael', 'Chen', 'michael.chen@email.com', '$2y$10$hashedpassword456', '+1-555-0102', 'host', '2023-02-20 14:15:00'),
('Emily', 'Rodriguez', 'emily.rodriguez@email.com', '$2y$10$hashedpassword789', '+1-555-0103', 'host', '2023-03-10 09:45:00'),
('David', 'Thompson', 'david.thompson@email.com', '$2y$10$hashedpassword101', '+1-555-0104', 'host', '2023-04-05 16:20:00'),
('Lisa', 'Wang', 'lisa.wang@email.com', '$2y$10$hashedpassword112', '+1-555-0105', 'host', '2023-05-12 11:30:00'),

-- Guests
('John', 'Smith', 'john.smith@email.com', '$2y$10$hashedpassword131', '+1-555-0201', 'guest', '2023-01-20 08:15:00'),
('Maria', 'Garcia', 'maria.garcia@email.com', '$2y$10$hashedpassword141', '+1-555-0202', 'guest', '2023-02-25 12:45:00'),
('Robert', 'Brown', 'robert.brown@email.com', '$2y$10$hashedpassword151', '+1-555-0203', 'guest', '2023-03-15 15:30:00'),
('Jennifer', 'Davis', 'jennifer.davis@email.com', '$2y$10$hashedpassword161', '+1-555-0204', 'guest', '2023-04-10 10:20:00'),
('James', 'Wilson', 'james.wilson@email.com', '$2y$10$hashedpassword171', '+1-555-0205', 'guest', '2023-05-18 13:40:00'),
('Amanda', 'Taylor', 'amanda.taylor@email.com', '$2y$10$hashedpassword181', '+1-555-0206', 'guest', '2023-06-01 09:25:00'),
('Christopher', 'Anderson', 'christopher.anderson@email.com', '$2y$10$hashedpassword191', '+1-555-0207', 'guest', '2023-06-15 17:10:00'),
('Jessica', 'Martinez', 'jessica.martinez@email.com', '$2y$10$hashedpassword201', '+1-555-0208', 'guest', '2023-07-01 14:35:00'),

-- Admin
('Admin', 'User', 'admin@airbnb-clone.com', '$2y$10$adminhashedpassword', '+1-555-0001', 'admin', '2023-01-01 00:00:00');

-- Insert sample properties
INSERT INTO properties (host_id, name, description, location, price_per_night, created_at) VALUES
-- Sarah's properties
(1, 'Cozy Downtown Apartment', 'Modern 1-bedroom apartment in the heart of downtown. Walking distance to restaurants, shops, and public transportation. Fully equipped kitchen and comfortable living space.', 'Downtown, City Center', 120.00, '2023-01-20 11:00:00'),
(1, 'Luxury Penthouse Suite', 'Stunning 2-bedroom penthouse with panoramic city views. High-end amenities, private balcony, and 24/7 concierge service. Perfect for business travelers or luxury seekers.', 'Uptown, Luxury District', 350.00, '2023-02-15 14:30:00'),

-- Michael's properties
(2, 'Charming Garden Cottage', 'Quaint 1-bedroom cottage with beautiful garden views. Peaceful neighborhood, fully furnished, and includes parking. Ideal for couples or solo travelers seeking tranquility.', 'Suburban Area, Garden District', 95.00, '2023-02-25 09:15:00'),
(2, 'Modern Studio Loft', 'Contemporary studio loft with high ceilings and industrial design. Located in trendy arts district with easy access to galleries, cafes, and nightlife.', 'Arts District, Creative Quarter', 140.00, '2023-03-20 16:45:00'),

-- Emily's properties
(3, 'Beachfront Condo', 'Spectacular 2-bedroom condo with direct beach access. Ocean views from every room, private balcony, and resort-style amenities. Perfect for beach lovers and families.', 'Beachfront, Coastal Area', 280.00, '2023-03-25 12:20:00'),
(3, 'Mountain Cabin Retreat', 'Rustic 3-bedroom cabin surrounded by nature. Hiking trails nearby, fireplace, and stunning mountain views. Great for outdoor enthusiasts and family getaways.', 'Mountain Region, Forest Area', 180.00, '2023-04-10 10:30:00'),

-- David's properties
(4, 'Historic Townhouse', 'Beautifully restored 3-bedroom townhouse in historic district. Original architectural details, modern amenities, and walking distance to museums and cultural sites.', 'Historic District, Cultural Quarter', 220.00, '2023-04-20 13:15:00'),
(4, 'Urban Loft Space', 'Spacious 1-bedroom loft in converted warehouse. Exposed brick walls, high ceilings, and modern furnishings. Located in vibrant neighborhood with great restaurants.', 'Industrial District, Urban Area', 160.00, '2023-05-05 15:40:00'),

-- Lisa's properties
(5, 'Lakeside Villa', 'Elegant 4-bedroom villa with private lake access. Boating, fishing, and water sports available. Large deck, gourmet kitchen, and perfect for large groups or family reunions.', 'Lakeside, Waterfront Area', 400.00, '2023-05-25 11:50:00'),
(5, 'Downtown Business Suite', 'Professional 1-bedroom suite designed for business travelers. High-speed internet, work desk, and walking distance to business district and conference centers.', 'Business District, Corporate Area', 200.00, '2023-06-10 14:25:00');

-- Insert sample bookings
INSERT INTO bookings (property_id, user_id, start_date, end_date, locked_price_per_night, status, created_at) VALUES
-- Confirmed bookings
(1, 6, '2024-01-15', '2024-01-18', 120.00, 'confirmed', '2023-12-20 10:30:00'),
(2, 7, '2024-01-20', '2024-01-25', 350.00, 'confirmed', '2023-12-25 14:15:00'),
(3, 8, '2024-02-01', '2024-02-05', 95.00, 'confirmed', '2024-01-05 09:45:00'),
(4, 9, '2024-02-10', '2024-02-12', 140.00, 'confirmed', '2024-01-10 16:20:00'),
(5, 10, '2024-02-15', '2024-02-20', 280.00, 'confirmed', '2024-01-15 11:30:00'),
(6, 11, '2024-03-01', '2024-03-05', 180.00, 'confirmed', '2024-01-20 13:45:00'),
(7, 12, '2024-03-10', '2024-03-15', 220.00, 'confirmed', '2024-01-25 15:10:00'),
(8, 13, '2024-03-20', '2024-03-22', 160.00, 'confirmed', '2024-02-01 10:25:00'),

-- Pending bookings
(1, 7, '2024-04-01', '2024-04-05', 120.00, 'pending', '2024-02-15 12:30:00'),
(3, 9, '2024-04-10', '2024-04-15', 95.00, 'pending', '2024-02-20 14:45:00'),
(5, 11, '2024-04-20', '2024-04-25', 280.00, 'pending', '2024-02-25 16:20:00'),
(7, 13, '2024-05-01', '2024-05-05', 220.00, 'pending', '2024-03-01 09:15:00'),

-- Canceled bookings
(2, 8, '2024-01-10', '2024-01-15', 350.00, 'canceled', '2023-12-15 11:20:00'),
(4, 10, '2024-02-05', '2024-02-08', 140.00, 'canceled', '2024-01-08 13:30:00'),
(6, 12, '2024-03-15', '2024-03-20', 180.00, 'canceled', '2024-02-10 15:45:00');

-- Insert sample payments
INSERT INTO payments (booking_id, amount, payment_date, payment_method) VALUES
-- Payments for confirmed bookings
(1, 360.00, '2023-12-20', 'credit_card'),
(2, 1750.00, '2023-12-25', 'stripe'),
(3, 380.00, '2024-01-05', 'paypal'),
(4, 280.00, '2024-01-10', 'credit_card'),
(5, 1400.00, '2024-01-15', 'stripe'),
(6, 720.00, '2024-01-20', 'credit_card'),
(7, 1100.00, '2024-01-25', 'paypal'),
(8, 320.00, '2024-02-01', 'credit_card');

-- Insert sample reviews
INSERT INTO reviews (property_id, user_id, rating, comment, created_at) VALUES
-- Reviews for property 1
(1, 6, 5, 'Excellent location and very clean apartment. Sarah was a great host and responded quickly to all our questions. Would definitely stay here again!', '2024-01-19 10:30:00'),

-- Reviews for property 2
(2, 7, 4, 'Beautiful penthouse with amazing views. The amenities were top-notch and the service was impeccable. Only minor issue was the noise from nearby construction.', '2024-01-26 14:15:00'),

-- Reviews for property 3
(3, 8, 5, 'Perfect cottage for a peaceful getaway. The garden was beautiful and the neighborhood was quiet. Michael was very helpful with local recommendations.', '2024-02-06 09:45:00'),

-- Reviews for property 4
(4, 9, 4, 'Great loft space with cool industrial vibe. Location was perfect for exploring the arts district. Would recommend for anyone looking for a unique stay.', '2024-02-13 16:20:00'),

-- Reviews for property 5
(5, 10, 5, 'Absolutely stunning beachfront property! The ocean views were breathtaking and the condo was spotless. Emily was an excellent host.', '2024-02-21 11:30:00'),

-- Reviews for property 6
(6, 11, 4, 'Cozy mountain cabin with beautiful surroundings. The hiking trails were easily accessible and the cabin had everything we needed.', '2024-03-06 13:45:00'),

-- Reviews for property 7
(7, 12, 5, 'Historic charm meets modern comfort. David has done an amazing job restoring this townhouse. The location was perfect for exploring the city.', '2024-03-16 15:10:00'),

-- Reviews for property 8
(8, 13, 4, 'Great urban loft with character. The exposed brick and high ceilings gave it a unique feel. Perfect for a weekend in the city.', '2024-03-23 10:25:00'),

-- Additional reviews for variety
(1, 7, 4, 'Second time staying here and it was just as good as the first. Convenient location and comfortable space.', '2024-02-01 12:30:00'),
(3, 9, 5, 'Such a peaceful retreat! The garden cottage exceeded our expectations. Highly recommend!', '2024-02-20 14:45:00'),
(5, 11, 4, 'Beautiful beach condo with great amenities. The only downside was the weather during our stay, but the property was perfect.', '2024-03-01 16:20:00');

-- Insert sample messages
INSERT INTO messages (sender_id, recipient_id, message_body, sent_at) VALUES
-- Messages between guests and hosts
(6, 1, 'Hi Sarah! I\'m interested in your downtown apartment. Is it available for the weekend of January 15th?', '2023-12-18 10:30:00'),
(1, 6, 'Hi John! Yes, it\'s available for those dates. The check-in time is 3 PM and check-out is 11 AM. Let me know if you have any questions!', '2023-12-18 11:15:00'),
(6, 1, 'Perfect! I\'ll book it now. Is there parking available nearby?', '2023-12-18 11:45:00'),
(1, 6, 'Yes, there\'s street parking available and also a public garage just 2 blocks away. I\'ll send you the details after booking.', '2023-12-18 12:00:00'),

(7, 1, 'Hello Sarah! I love your penthouse suite. Do you offer any discounts for longer stays?', '2023-12-22 14:20:00'),
(1, 7, 'Hi Maria! Yes, I offer 10% discount for stays of 7 days or more. The penthouse is perfect for longer visits!', '2023-12-22 15:05:00'),

(8, 2, 'Hi Michael! Your garden cottage looks beautiful. Is it pet-friendly?', '2024-01-03 09:30:00'),
(2, 8, 'Hello Robert! Unfortunately, the cottage is not pet-friendly due to the garden and local regulations. I hope this doesn\'t affect your plans.', '2024-01-03 10:15:00'),
(8, 2, 'No problem, I understand. I\'ll still book it for myself. Looking forward to the peaceful stay!', '2024-01-03 10:45:00'),

(9, 2, 'Hi Michael! I\'m interested in your studio loft. What\'s the check-in process like?', '2024-01-08 16:30:00'),
(2, 9, 'Hi Jennifer! I use a keyless entry system. You\'ll receive a unique code 24 hours before check-in. The loft is on the 3rd floor with elevator access.', '2024-01-08 17:00:00'),

(10, 3, 'Hello Emily! Your beachfront condo looks amazing. Is the beach easily accessible?', '2024-01-12 11:45:00'),
(3, 10, 'Hi James! Yes, there\'s a private path directly from the condo to the beach. It\'s about a 2-minute walk. The beach is perfect for swimming and sunbathing!', '2024-01-12 12:30:00'),

(11, 3, 'Hi Emily! I\'m interested in your mountain cabin. Are there any hiking trails nearby?', '2024-01-18 13:20:00'),
(3, 11, 'Hello Amanda! Yes, there are several hiking trails within walking distance. I\'ll provide you with a map and trail recommendations when you arrive.', '2024-01-18 14:05:00'),

(12, 4, 'Hi David! Your historic townhouse looks fascinating. Is there a lot of history to explore in the area?', '2024-01-22 15:40:00'),
(4, 12, 'Hello Christopher! Absolutely! The historic district is full of museums, landmarks, and guided tours. I can recommend some great historical sites to visit.', '2024-01-22 16:15:00'),

(13, 4, 'Hi David! I\'m interested in your urban loft. What\'s the neighborhood like for dining?', '2024-01-28 10:10:00'),
(4, 13, 'Hi Jessica! The neighborhood is fantastic for food! There are dozens of restaurants within walking distance, from casual cafes to fine dining. I\'ll send you my recommendations.', '2024-01-28 10:45:00'),

-- Messages between guests
(6, 7, 'Hi Maria! I see you\'re also staying at Sarah\'s properties. Have you been to the downtown area before?', '2024-01-16 09:30:00'),
(7, 6, 'Hi John! Yes, I\'ve been here a few times. The downtown area is great for shopping and dining. We should meet up for coffee!', '2024-01-16 10:15:00'),

(8, 9, 'Hello Jennifer! I noticed you\'re staying at Michael\'s properties too. The garden cottage is wonderful, you\'ll love it!', '2024-02-02 14:20:00'),
(9, 8, 'Hi Robert! Thanks for the recommendation! I\'m really looking forward to the studio loft. How was your stay at the cottage?', '2024-02-02 15:05:00'),

-- Messages between hosts
(1, 2, 'Hi Michael! I love your garden cottage photos. Do you use a professional photographer?', '2024-01-10 11:30:00'),
(2, 1, 'Hi Sarah! Yes, I hired a local photographer. It really makes a difference in bookings. I can recommend her if you\'re interested!', '2024-01-10 12:15:00'),

(3, 4, 'Hello David! I saw your historic townhouse listing. The restoration work looks amazing!', '2024-01-15 16:40:00'),
(4, 3, 'Hi Emily! Thank you! It was quite a project, but worth it. Your beachfront condo is stunning too!', '2024-01-15 17:20:00');

-- Display summary of inserted data
SELECT 'Data insertion complete!' as status;
SELECT COUNT(*) as total_users FROM users;
SELECT COUNT(*) as total_properties FROM properties;
SELECT COUNT(*) as total_bookings FROM bookings;
SELECT COUNT(*) as total_payments FROM payments;
SELECT COUNT(*) as total_reviews FROM reviews;
SELECT COUNT(*) as total_messages FROM messages;
