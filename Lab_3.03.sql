-- 1. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT film_id, title, COUNT(inventory_id) AS 'number_of_films' FROM sakila.inventory i
JOIN sakila.film f USING (film_id)
WHERE title = 'Hunchback Impossible'
GROUP BY film_id;


SELECT COUNT(inventory_id) AS 'number_of_copies' FROM sakila.inventory
WHERE film_id = (
	SELECT film_id FROM sakila.film
	WHERE title = 'Hunchback Impossible'
    );


-- 2. List all films whose length is longer than the average of all the films.
SELECT title, length FROM sakila.film
WHERE length > (
	SELECT AVG(length) FROM sakila. film
        )
ORDER BY length DESC;


-- 3. Use subqueries to display all actors who appear in the film Alone Trip.
     
SELECT CONCAT(first_name, ' ', last_name) AS 'Name' FROM sakila.actor a
JOIN sakila.film_actor USING (actor_id)
JOIN sakila.film USING (film_id)
WHERE title = 'Alone Trip';


SELECT CONCAT(first_name, ' ', last_name) AS 'Name' FROM sakila.actor
WHERE actor_id IN (
	SELECT actor_id FROM sakila.film_actor
    WHERE film_id = (
		SELECT film_id FROM sakila.film
        WHERE title = 'Alone Trip')
        );



-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.

SELECT title, name FROM sakila.film
JOIN sakila.film_category USING (film_id)
JOIN sakila.category USING (category_id)
WHERE name = 'Family';


SELECT title FROM sakila.film
WHERE film_id IN (
	SELECT film_id FROM sakila.film_category
	WHERE category_id = (
		SELECT category_id FROM sakila.category
		WHERE name = 'Family')
        ); 



-- 5. Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.

SELECT CONCAT(first_name, ' ', last_name) AS 'Name', email FROM sakila.customer
JOIN sakila.address USING (address_id)
JOIN sakila.city USING (city_id)
JOIN sakila.country USING (country_id)
WHERE country = 'Canada';


SELECT CONCAT(first_name, ' ', last_name) AS 'Name', email FROM sakila.customer
WHERE address_id IN (
	SELECT address_id FROM sakila.address
	WHERE city_id IN (
		SELECT city_id  FROM sakila.city
		WHERE country_id =(
			SELECT country_id FROM sakila.country
			WHERE country = 'Canada')
			));


-- 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.


SELECT title FROM sakila.film
WHERE film_id IN (
	SELECT film_id FROM sakila.film_actor
	WHERE actor_id = (
		SELECT actor_id FROM(
			SELECT actor_id, COUNT(film_id) AS total_films FROM sakila.film_actor
			GROUP BY actor_id
			ORDER BY total_films DESC
			LIMIT 1) AS subq1)
            );





-- 7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments

SELECT title FROM sakila.film
WHERE film_id IN (
	SELECT film_id FROM sakila.inventory
	WHERE inventory_id IN (
		SELECT inventory_id FROM sakila.rental
		WHERE customer_id = (
			SELECT customer_id from (
				SELECT customer_id, SUM(amount) AS 'total' FROM sakila.payment
				GROUP BY customer_id) AS sub2
				WHERE total = (
					SELECT MAX(total2) FROM (
						SELECT customer_id, SUM(amount) AS 'total2' FROM sakila.payment
						GROUP BY customer_id) AS sub3)
						)));

    
-- 8. Customers who spent more than the average payments.

SELECT CONCAT(first_name, ' ', last_name) AS 'Name' FROM sakila.customer
WHERE customer_id IN (
	SELECT customer_id FROM sakila.payment
	GROUP BY customer_id
	HAVING SUM(amount) > (SELECT AVG(suma) FROM 
		(SELECT SUM(amount) AS suma FROM sakila.payment
		GROUP BY customer_id) AS sub1)
		);






