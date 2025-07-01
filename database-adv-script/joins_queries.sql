-- a query using an INNER JOIN to retrieve all bookings and the respective users who made those bookings.
SELECT 
    bookings.booking_id,
    bookings.booking_date,
    users.user_id,
    users.first_name,
    users.last_name
FROM 
    bookings
INNER JOIN 
    users ON bookings.user_id = users.user_id
ORDER BY 
    bookings.booking_date DESC;



    -- a query using a LEFT JOIN to retrieve all properties and their reviews, including properties that have no reviews.
SELECT 
    properties.id AS property_id,
    properties.name AS property_name,
    reviews.rating,
    reviews.comment,
    reviews.created_at AS review_date
FROM        
    properties
LEFT JOIN 
    reviews ON properties.id = reviews.property_id
ORDER BY 
    properties.name ASC,
    reviews.created_at DESC;



-- a query using a FULL OUTER JOIN to retrieve all users and all bookings,
--  even if the user has no booking or a booking is not linked to a user.
SELECT 
    users.user_id,
    users.first_name,
    users.last_name,
    bookings.booking_id,
    bookings.booking_date
FROM 
    users
FULL OUTER JOIN 
    bookings ON users.user_id = bookings.user_id
ORDER BY 
    users.user_id ASC,
    bookings.booking_date DESC;



-- a query using a SELF JOIN to retrieve all properties that have the same number of bedrooms.
SELECT 
    p1.id AS property_id,
    p1.name AS property_name,
    p1.bedrooms AS bedrooms
FROM 
    properties p1
INNER JOIN 
    properties p2 ON p1.bedrooms = p2.bedrooms AND p1.id <> p2.id;