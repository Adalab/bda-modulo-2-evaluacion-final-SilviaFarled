USE sakila;

-- 1. Selecciona todos los nombres de las películas sin que aparezcan duplicados.
SELECT DISTINCT title Nombre_Pelicula_Unico
FROM film;

--  2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".
SELECT title Pelicula_PG_13
FROM film
WHERE rating = 'PG-13';

--  3. Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.
SELECT title Pelicula, description Descripcion_amazing
FROM film
WHERE description LIKE '%amazing%';

-- 4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos
SELECT title Pelicula_Larga
FROM film 
WHERE length > 120
ORDER BY title;

--  5. Encuentra los nombres de todos los actores, muestralos en una sola columna que se llame nombre_actor y contenga nombre y apellido.
SELECT CONCAT(first_name, ' ', last_name) Nombre_Actor_Concatenado
FROM actor
ORDER BY nombre_actor_concatenado;

--  6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.
SELECT CONCAT(last_name, ', ', first_name) Nombre_Actor_Gibson
FROM actor 
WHERE last_name LIKE '%GIBSON%';

--  7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.
SELECT CONCAT(first_name, ' ', last_name) Nombre_Actor_Seleccionado
FROM actor
WHERE actor_id BETWEEN 10 AND 20
ORDER BY actor_id;

--  8. Encuentra el título de las películas en la tabla film que no tengan clasificacion "R" ni "PG-13".
SELECT title Titulo_Pelicula_Clasificados
FROM film
WHERE rating NOT IN ('R', 'PG-13');

-- 9. Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento
SELECT rating Clasificacion, COUNT(*) Num_Peliculas
FROM film
GROUP BY rating
ORDER BY rating;

-- 10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.
SELECT c.customer_id ID_Cliente, CONCAT(c.first_name, ' ', c.last_name) Nombre_Cliente, COUNT(r.rental_id) Num_Peliculas_Alquiladas
FROM customer c
LEFT JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY id_cliente;

-- 11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.
SELECT c.name Categoria, COUNT(r.rental_id) Total_Peliculas_Alquiladas
FROM rental r 
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film_category fc ON i.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY c.name;

-- 12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.
SELECT rating Clasificacion, AVG(length) Promedio_Duracion
FROM film 
GROUP BY rating
ORDER BY rating;

--  13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".
SELECT CONCAT(a.last_name, ', ', a.first_name) Nombre_Actor_Indian_Love
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
JOIN actor a ON fa.actor_id = a.actor_id
WHERE f.title = 'INDIAN LOVE'
ORDER BY a.last_name;

--  14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.
SELECT title Titulo_Pelicula_Animal
FROM film
WHERE description REGEXP 'dog|cat' ;

--  15. Hay algún actor o actriz que no apareca en ninguna película en la tabla film_actor
SELECT CONCAT(a.last_name, ', ', a.first_name) No_Hay_Actores_Sin_Peli
FROM actor a
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
WHERE fa.film_id IS NULL;

--  16. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.
SELECT title Pelicula_En_Rango
FROM film
WHERE release_year BETWEEN 2005 and 2010;

--  17. Encuentra el título de todas las películas que son de la misma categoría que "Family".

SELECT f.title Pelicula_Family
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Family'
ORDER BY f.title;

-- 18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.
SELECT CONCAT(a.last_name, ', ', a.first_name) Nombre_Actor, COUNT(fa.film_id) Numero_Peliculas
FROM actor a 
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.first_name, a.last_name
HAVING COUNT(fa.film_id) > 10
ORDER BY a.last_name;

-- 19. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film.
SELECT title Pelicula_Clasif_Larga
FROM film
WHERE rating = 'R' 
AND length > 120
ORDER BY title;

-- 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y muestra el nombre de la categoría junto con el promedio de duración.
SELECT c.name Categoria, AVG(f.length) Duracion
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id
GROUP BY c.name
HAVING AVG(f.length) > 120
ORDER BY c.name;

--  21. Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la cantidad de películas en las que han actuado.
SELECT CONCAT(a.last_name, ', ', a.first_name) Nombre_Actor, COUNT(fa.film_id) Num_Peliculas
FROM actor a 
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.last_name, a.first_name
HAVING COUNT(fa.film_id) >= 5
ORDER BY CONCAT(a.last_name, ', ', a.first_name);

--  22. Encuentra el título de todas las películas que fueron alquiladas durante más de 5 días. Utiliza una subconsulta para encontrar los rental_ids con una 
-- duración superior a 5 días y luego selecciona las películas correspondientes. Pista: Usamos DATEDIFF para calcular la diferencia entre una 
-- fecha y otra, ej: DATEDIFF(fecha_inicial, fecha_final)
SELECT title Pelicula_alquilada
FROM film
WHERE film_id IN (
	SELECT film_id
	FROM inventory
	WHERE inventory_id IN(
		SELECT inventory_id
		FROM rental
		WHERE DATEDIFF(return_date, rental_date) > 5))
ORDER BY title;


-- 23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror". 
-- Utiliza una subconsulta para encontrar los actores que han actuado en películas de la categoría "Horror" y luego exclúyelos de la lista de actores.
SELECT CONCAT(last_name, ', ', first_name) Nombre_Actor_Antimiedo
FROM actor
WHERE actor_id NOT IN (
	SELECT a.actor_id
	FROM actor a 
    JOIN film_actor fa 	ON a.actor_id = fa.actor_id
	JOIN film_category fc ON fa.film_id = fc.film_id
	JOIN category c ON fc.category_id = c.category_id
	WHERE c.name = 'Horror')
ORDER BY nombre_actor_antimiedo;

SELECT CONCAT(last_name, ', ', first_name) Nombre_Actor_Antimiedo
FROM actor
WHERE actor_id NOT IN(
	SELECT actor_id
	FROM film_actor
	WHERE film_id IN(
		SELECT film_id
		FROM film_category
		WHERE category_id IN (
			SELECT category_id
			FROM category
			WHERE name = 'Horror')))
ORDER BY nombre_actor_antimiedo;

-- 24. BONUS: Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla film con subconsultas

SELECT title Comedia_Muy_Larga
FROM film
WHERE film_id IN (
	SELECT film_id
	FROM film_category 
	WHERE category_id IN (
		SELECT category_id
		FROM category
		WHERE name = 'Comedy'))
AND length > 180;

-- 25. BONUS: Encuentra todos los actores que han actuado juntos en al menos una película. La consulta debe mostrar el nombre y apellido de los actores 
-- y el número de películas en las que han actuado juntos. Pista: Podemos hacer un JOIN de una tabla consigo misma, poniendole un alias diferente.
SELECT CONCAT(a1.last_name, ', ', a1.first_name) Actor_1, CONCAT(a2.first_name, ' ', a2.last_name) Actor_2, COUNT(*) Pelicula_Compartida
FROM film_actor fa1
JOIN film_actor fa2 ON fa1.film_id = fa2.film_id AND fa1.actor_id < fa2.actor_id
JOIN actor a1 ON fa1.actor_id = a1.actor_id
JOIN actor a2 ON fa2.actor_id = a2.actor_id
GROUP BY fa1.actor_id, fa2.actor_id
ORDER BY Pelicula_Compartida;


;
SELECT * FROM customer;
SELECT * FROM rental;
SELECT * FROM inventory;
SELECT * FROM film_category;
SELECT * FROM category;
SELECT * FROM film;
SELECT * FROM film_actor;
SELECT * FROM actor;