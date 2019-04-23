-- initiating the correct database
USE sakila;

-- 1A - 1B displaying and creating columns
SELECT first_name, last_name FROM actor;
SELECT UPPER(CONCAT(first_name, " ",last_name)) AS actor_name FROM actor;

-- 2A - 2D basic queries
SELECT actor_id, first_name, last_name FROM actor WHERE first_name = "Joe";
SELECT actor_id, first_name, last_name FROM actor WHERE last_name LIKE "%gen%";
SELECT actor_id, first_name, last_name FROM actor WHERE last_name LIKE "%li%" ORDER BY last_name, first_name;
SELECT country_id, country FROM country WHERE country IN ("Afghanistan", "Bangladesh", "China");

-- 3A - 3B creating and deleting columns and data types
ALTER TABLE actor ADD description BLOB;
ALTER TABLE actor DROP description;

-- 4A - 4D aggregations and entry updates
SELECT last_name, count(last_name) as count_last_name FROM actor GROUP BY last_name;
SELECT last_name, count(last_name) as count_last_name FROM actor GROUP BY last_name HAVING count_last_name > 1;
UPDATE actor SET first_name = "HARPO" WHERE first_name = "GROUCHO" AND last_name = "WILLIAMS";
UPDATE actor SET first_name = "GROUCHO" WHERE first_name = "HARPO";

-- 5A finding the address table schema
SHOW CREATE TABLE address;

-- 6A - 6E joins
	-- line to comment/uncomment to expore tables
		-- SELECT * FROM address LIMIT 5;
SELECT staff.first_name, staff.last_name, address.address
FROM staff JOIN address ON staff.address_id = address.address_id;

SELECT staff.first_name, staff.last_name, sum(payment.amount) as Total_Payment
FROM staff JOIN payment ON staff.staff_id = payment.staff_id
WHERE payment.payment_date LIKE "%2005-08%"GROUP BY staff.last_name;

SELECT film.title, count(film_actor.actor_id) AS "Count_of_Actors"
FROM film INNER JOIN film_actor USING(film_id)
GROUP BY film.title;

SELECT film.title, count(inventory_id) 
FROM film INNER JOIN inventory USING(film_id) 
WHERE film.title = "Hunchback Impossible";

SELECT customer.first_name, customer.last_name, sum(payment.amount)
FROM customer JOIN payment USING(customer_id)
GROUP BY customer.customer_id ORDER BY customer.last_name;

-- 7A - 7H subqueries and multiple joins
SELECT * FROM category LIMIT 20;
SELECT film.title  FROM film 
WHERE title LIKE "K%" OR title LIKE "Q%" AND language_id = 
	(SELECT language_id FROM language 
    WHERE name = "English" GROUP BY language_id);

SELECT actor.first_name, actor.last_name FROM actor
JOIN film_actor USING(actor_id) WHERE film_actor.film_id = 
	(SELECT film_id FROM film WHERE film.title = "Alone Trip");
    
SELECT first_name, last_name, email FROM customer
JOIN address USING(address_id)
JOIN city USING(city_id)
JOIN country USING(country_id)
WHERE country_id = 20;

SELECT title FROM film
JOIN film_category USING(film_id) WHERE category_id =
	(SELECT category_id FROM category WHERE name = "Family");

SELECT film.title, count(rental_id) as rental_count from film
JOIN inventory USING(film_id)
JOIN rental USING(inventory_id)
GROUP BY film.title ORDER BY rental_count DESC;

SELECT store_id, sum(amount) as total_revenue FROM payment
JOIN store ON payment.staff_id = store.manager_staff_id
GROUP BY store_id;

SELECT store_id, city, country FROM store
JOIN address USING(address_id)
JOIN city USING(city_id)
JOIN country USING(country_id)
GROUP BY store_id;

SELECT category.name, sum(amount) as revenue FROM category
JOIN film_category USING(category_id)
JOIN inventory USING(film_id)
JOIN rental USING(inventory_id)
JOIN payment USING(rental_id)
GROUP BY category.name ORDER BY revenue DESC LIMIT 5;

-- 8A - 8C creating and deleting views
CREATE VIEW top_5_genres_by_revenue AS
SELECT category.name, sum(amount) as revenue FROM category
JOIN film_category USING(category_id)
JOIN inventory USING(film_id)
JOIN rental USING(inventory_id)
JOIN payment USING(rental_id)
GROUP BY category.name ORDER BY revenue DESC LIMIT 5;

SELECT * FROM top_5_genres_by_revenue;

DROP VIEW top_5_genres_by_revenue;



