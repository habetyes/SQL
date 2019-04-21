USE sakila;
-- 1a
SELECT first_name, last_name FROM actor;

-- 1b
SELECT CONCAT(first_name, ' ' , last_name) AS 'Actor Name' FROM actor;

-- 2a
SELECT actor_id, first_name, last_name FROM actor
WHERE first_name = 'Joe';

-- 2b
SELECT actor_id, first_name, last_name FROM actor
WHERE last_name LIKE '%GEN%';

-- 2c
SELECT actor_id, first_name, last_name FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY last_name, first_name;

-- 2d
SELECT country_id, country FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

-- 3a
ALTER TABLE actor
ADD COLUMN description BLOB;

-- 3b
ALTER TABLE actor
DROP COLUMN description;

-- 4a
SELECT last_name, count(*) as '# of actors' FROM actor
GROUP BY last_name;

-- 4b
SELECT last_name, count(*) as '# of actors' FROM actor
GROUP BY last_name
HAVING `# of actors`>1;

-- 4c
UPDATE actor
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';

-- 4d
UPDATE actor
SET first_name = 'GROUCHO'
WHERE first_name = 'HARPO' AND last_name = 'WILLIAMS';

-- 5a
SHOW CREATE TABLE address;
-- address	CREATE TABLE `address` (
--  `address_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
--  `address` varchar(50) NOT NULL,
--  `address2` varchar(50) DEFAULT NULL,
--  `district` varchar(20) NOT NULL,
--  `city_id` smallint(5) unsigned NOT NULL,
--  `postal_code` varchar(10) DEFAULT NULL,
--  `phone` varchar(20) NOT NULL,
--  `location` geometry NOT NULL,
--  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
--  PRIMARY KEY (`address_id`),
--  KEY `idx_fk_city_id` (`city_id`),
--  SPATIAL KEY `idx_location` (`location`),
--  CONSTRAINT `fk_address_city` FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`) ON UPDATE CASCADE
-- ) ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8

-- 6a
SELECT s.first_name, s.last_name, a.address FROM staff as s
INNER JOIN address as a
ON s.address_id=a.address_id;

-- 6b
SELECT concat(s.first_name, ' ' ,s.last_name) as 'Staff Member', sum(p.amount) as 'TOTAL Amount' FROM staff as s
INNER JOIN payment as p
ON s.staff_id=p.staff_id
where payment_date like '2005-08%'
GROUP BY `Staff Member`;

-- 6c
SELECT f.title, COUNT(actor_id) AS 'Actors' FROM film as f
INNER JOIN film_actor as fa
ON f.film_id=fa.film_id
GROUP BY f.title;

-- 6d
SELECT f.title, count(i.inventory_id) as 'Copies' FROM film as f
INNER JOIN inventory as i
ON f.film_id=i.film_id
WHERE f.title = 'Hunchback Impossible'
GROUP BY f.title;

-- 6e
SELECT c.first_name, c.last_name, SUM(p.amount) FROM customer as c
INNER JOIN payment as p
ON c.customer_id=p.customer_id
GROUP BY c.customer_id
ORDER BY c.last_name;

-- 7a
SELECT title FROM film
WHERE title LIKE 'K%' OR title LIKE'Q%' AND language_id IN	
	(SELECT language_id FROM language
    WHERE name = 'English');

-- 7b
SELECT first_name, last_name FROM actor
WHERE actor_id IN
	(SELECT actor_id FROM film_actor
	WHERE film_id in
		(SELECT film_id FROM film
		WHERE title = 'Alone Trip'));

-- 7c
SELECT c.first_name, c.last_name, c.email FROM customer as c
INNER JOIN address as a
ON c.address_id=a.address_id
INNER JOIN city 
ON a.city_id=city.city_id
INNER JOIN country
ON city.country_id=country.country_id
WHERE country = 'Canada';

-- 7d
SELECT f.title, fc.category_id, c.name FROM film as f
INNER JOIN film_category as fc
ON f.film_id=fc.film_id
INNER JOIN category as c
ON fc.category_id=c.category_id
WHERE c.name = 'Family';

-- 7e
SELECT f.title, count(r.rental_date) as 'Rent Count' FROM FILM as f
INNER JOIN inventory as i
ON f.film_id=i.film_id
INNER JOIN rental as r
ON i.inventory_id=r.inventory_id
GROUP BY title
ORDER BY `Rent Count` DESC;

-- 7f
SELECT s.store_id, sum(p.amount) as 'Revenue' FROM payment as p
INNER JOIN staff as s
ON p.staff_id=s.staff_id
INNER JOIN store
ON s.store_id=store.store_id
GROUP BY store.store_id;

-- 7g
SELECT s.store_id, c.city, ct.country FROM store as s
INNER JOIN address as a
ON s.address_id=a.address_id
INNER JOIN city as c
ON a.city_id=c.city_id
INNER JOIN country as ct
ON c.country_id=ct.country_id;

-- 7h
SELECT c.name AS 'Genre', sum(p.amount) AS 'Revenue' FROM payment p
INNER JOIN rental r
ON p.rental_id=r.rental_id
INNER JOIN inventory i
ON r.inventory_id=i.inventory_id
INNER JOIN film_category fc
ON i.film_id=fc.film_id
INNER JOIN category c
ON fc.category_id=c.category_id
GROUP BY c.name
ORDER BY Revenue DESC
LIMIT 5;

-- 8a
CREATE VIEW Top_Grossing_Genres AS
	SELECT c.name AS 'Genre', sum(p.amount) AS 'Revenue' FROM payment p
	INNER JOIN rental r
	ON p.rental_id=r.rental_id
	INNER JOIN inventory i
	ON r.inventory_id=i.inventory_id
	INNER JOIN film_category fc
	ON i.film_id=fc.film_id
	INNER JOIN category c
	ON fc.category_id=c.category_id
	GROUP BY c.name
	ORDER BY Revenue DESC
	LIMIT 5;

-- 8b
SELECT * FROM top_grossing_genres;

-- 8c
DROP VIEW top_grossing_genres