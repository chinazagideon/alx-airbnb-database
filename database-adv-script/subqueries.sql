--  query to find all properties where the average rating is greater than 4.0 using a subquery.
SELECT 
    properties.id AS property_id,
    properties.name AS property_name,
    AVG(reviews.rating) AS is_high_rating

FROM 
    properties
INNER JOIN 
    reviews ON properties.id = reviews.property_id
GROUP BY 
    properties.id, properties.name
HAVING 
    AVG(reviews.rating) > 4.0;


-- a correlated subquery to find users who have made more than 3 bookings.
SELECT * FROM users
WHERE 
    (SELECT COUNT(*) FROM bookings WHERE bookings.user_id = users.user_id) > 3;

