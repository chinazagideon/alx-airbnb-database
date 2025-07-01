-- a query to find the total number of bookings made by each user, using the COUNT function and GROUP BY clause.

SELECT 
    users.user_id,
    users.first_name,
    users.last_name,
    COUNT(bookings.booking_id) AS total_bookings
FROM 
    users
INNER JOIN 
    bookings ON users.user_id = bookings.user_id
GROUP BY 
    users.user_id, users.first_name, users.last_name;


-- a window function (ROW_NUMBER, RANK) to rank properties based on the total number of bookings they have received.

SELECT 
    properties.id AS property_id,
    properties.name AS property_name,
    COUNT(bookings.booking_id) AS total_bookings,
    ROW_NUMBER() OVER (ORDER BY COUNT(bookings.booking_id) DESC) AS rank
FROM 
    properties
INNER JOIN 
    bookings ON properties.id = bookings.property_id
GROUP BY 
    properties.id, properties.name;