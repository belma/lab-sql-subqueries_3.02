/*
1. How many copies of the film Hunchback Impossible exist in the inventory system?
*/
-- no clue, how to solve this with subquery.. 
SELECT f.title, COUNT(inventory_id)
FROM film f
INNER JOIN inventory i 
USING (film_id)
WHERE title = "Hunchback Impossible";

/*
2. List all films whose length is longer than the average of all the films.
*/

-- SELECT ROUND(AVG(length),2) from film; 

SELECT * FROM film 
WHERE length > 
(SELECT ROUND(AVG(length),2) from film);  -- 489 films are longer than average lenght
 
/*
3. Use subqueries to display all actors who appear in the film Alone Trip.
*/
 SELECT a.first_name, a.last_name FROM actor a
 WHERE a.actor_id IN(
	SELECT fa.actor_id FROM film_actor fa
	LEFT JOIN film f USING (film_id)
	WHERE f.title = 'Alone Trip'); -- 8 actors appear in that film.
 
-- Select film_id from film where title = 'Alone Trip'; --to double check results
-- Select count(actor_id) from film_actor where film_id = 17;-- to doublecheck number 8 actors.


/*
4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
*/

Select f.title, c.name AS category_name FROM film  f
JOIN film_category fc USING (film_id)
JOIN category c USING (category_id)
WHERE c.name = 'Family'; -- 69 Films in tis category

/*
5. Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
*/
-- With Subquery
SELECT concat(c.first_name,' ',c.last_name) AS 'Name', c.email AS 'E-mail'
FROM customer c
JOIN address a USING (address_id)
WHERE a.city_id IN(
	SELECT cy.city_id FROM city cy 
	JOIN country ct USING (country_id)
	WHERE ct.country = 'Canada');

-- WITH JOINS
SELECT concat(c.first_name,' ',c.last_name) AS 'Name', c.email AS 'E-mail'
FROM customer c
JOIN address a USING (address_id)
JOIN city cy USING (city_id)
JOIN country ct USING (country_id)
WHERE ct.country = 'Canada';

/*
6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
*/
SELECT count(fa.actor_id) AS Counts, a.first_name, a.last_name 
FROM actor a 
INNER JOIN film_actor  fa USING (actor_id)
GROUP BY fa.actor_id
ORDER BY Counts DESC
LIMIT 1;
/*

7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments
*/
-- most profitable customer: 
SELECT c.customer_id, c.first_name, c.last_name, amount.total_spend FROM customer c
LEFT JOIN(
	SELECT 
	p.customer_id, SUM(p.amount) AS total_spend
	FROM payment p
	LEFT JOIN customer c USING (customer_id)
    GROUP BY 1) 
AS amount USING (customer_id)
ORDER BY amount.total_spend DESC
LIMIT 1;

-- Find out which films were rente by customer_ id 526, who is the most profitable customer
SELECT title FROM film f
WHERE f.film_id IN (
	Select distinct film_id from rental r
    JOIN inventory i USING (inventory_id)
	WHERE r.customer_id = 526);
/*
8. Customers who spent more than the average payments.
*/

-- I editetd the previuous query (part1) by adding a condition and the average 
SELECT c.customer_id, c.first_name, c.last_name, amount.total_spend FROM customer c
LEFT JOIN(
	SELECT 
	p.customer_id, SUM(p.amount) AS total_spend, AVG(p.amount) AS average
	FROM payment p
	LEFT JOIN customer c USING (customer_id)
    GROUP BY 1) 
AS amount USING (customer_id)
WHERE amount.total_spend > amount.average; 

