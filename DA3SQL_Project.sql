/*2 Muestra los nombres de todas las películas con una clasificación por
edades de ‘Rʼ.*/

SELECT title AS "Título",
	   rating AS "Clasificación" 
	   --rating no es necesario, lo he añadido por estética
FROM film AS f 
WHERE rating = 'R' ;

--3 Encuentra los nombres de los actores que tengan un “actor_idˮ entre 30 y 40.
SELECT CONCAT(first_name, ' ', last_name) AS "Nombre_completo_actor"
	   --actor_id AS "ID_Actor"  Para ver el actor_id, quitamos el guión
FROM actor AS a
WHERE actor_id BETWEEN 30 AND 40; 


--4 Obtén las películas cuyo idioma coincide con el idioma original.
SELECT title AS "Título",
	   language_id AS "Idioma"
	   --COALESCE(original_language_id::text, 'NoData') AS "Idioma_Original"
FROM film AS f 
WHERE language_id = original_language_id ; --Si usamos COALESCE, hay que quitar este WHERE o NO veremos nada
--Ya que todos los original_language_id son NULL, NO hay coincidencias

/*SELECT original_language_id, 
         COUNT(*) as "Num_Películas"
FROM film AS f
GROUP BY original_language_id;*/

--5 Ordena las películas por duración de forma ascendente.
SELECT title AS "Título",
	   length AS "Duración"
FROM film AS f
ORDER BY length ASC;

--6 Encuentra el nombre y apellido de los actores que tengan ‘Allenʼ en su apellido.
SELECT CONCAT(first_name, ' ', last_name) AS "Nombre_completo_actor" 
FROM actor AS a 
WHERE last_name ILIKE '%Allen%';

/*7 Encuentra la cantidad total de películas en cada clasificación de la tabla
“filmˮ y muestra la clasificación junto con el recuento.*/
SELECT rating AS "Clasificación",
	   COUNT(*) AS "Num_Películas" 
FROM film AS f 
GROUP BY rating;


/*8 Encuentra el título de todas las películas que son ‘PG13ʼ o tienen una
duración mayor a 3 horas en la tabla film.*/
SELECT title AS "Título", 
CASE
	WHEN rating ='PG-13' AND length > 180 THEN 'Clasificación_y_Duración'
	WHEN rating = 'PG-13' THEN 'Clasificación'
	WHEN length > 180 THEN 'Duración'
END AS "Condición_cumplida"
FROM film AS f 
WHERE rating = 'PG-13' OR length > 180;
--He añadido el CASE para mostrar qué condiciones se cumplen

--9 Encuentra la variabilidad de lo que costaría reemplazar las películas.
SELECT CONCAT(ROUND(STDDEV(replacement_cost),2), '€') AS "Desviación_media_reemplazo"
FROM film AS f ;

--10 Encuentra la mayor y menor duración de una película de nuestra BBDD.
SELECT MAX(length) AS "Duración_máxima",
	   MIN(length) AS "Duración_mínima" 
FROM film AS f ;

--11 Encuentra lo que costó el antepenúltimo alquiler ordenado por día.
SELECT	CONCAT(p.amount, '€') AS "Coste",
		DATE(r.rental_date) AS "Fecha_pago"
FROM rental AS r 
JOIN payment AS p ON r.rental_id = p.rental_id 
ORDER BY r.rental_date DESC 
LIMIT 1 OFFSET 2;


/*12 Encuentra el título de las películas en la tabla “filmˮ que no sean ni ‘NC-
17ʼ ni ‘Gʼ en cuanto a su clasificación.*/
SELECT title AS "Título"
FROM film AS f 
WHERE rating NOT IN ('NC-17', 'G'); 

/*13 Encuentra el promedio de duración de las películas para cada
clasificación de la tabla film y muestra la clasificación junto con el
promedio de duración.*/
SELECT rating AS "Clasificación",
	   ROUND(AVG(length),2) AS "Duración_media"
FROM film AS f 
GROUP BY rating ;
--14 Encuentra el título de todas las películas que tengan una duración mayor a 180 minutos.
SELECT title AS "Título"
FROM film AS f 
WHERE length > 180;

--15 ¿Cuánto dinero ha generado en total la empresa?
SELECT CONCAT(ROUND(SUM(amount),2), '€') AS "Ingresos_totales" 
FROM payment AS p;

--16 Muestra los 10 clientes con mayor valor de id.
SELECT	CONCAT(first_name, ' ', last_name) AS "Nombre_completo_cliente",
		customer_id AS "ID_cliente" --para comprobar que es correcto (se puede eliminar)
FROM customer AS c 
ORDER BY customer_id DESC 
LIMIT 10;

--17 Encuentra el nombre y apellido de los actores que aparecen en la película con título ‘Egg Igbyʼ.
SELECT	CONCAT(first_name, ' ', last_name) AS "Actor_EggIgby"
FROM film_actor AS fa 
JOIN film AS f ON fa.film_id = f.film_id 
JOIN actor AS a ON fa.actor_id = a.actor_id 
WHERE f.title ILIKE 'Egg Igby';

--18 Selecciona todos los nombres de las películas únicos.
SELECT DISTINCT title AS "Título"
FROM film AS f ;

/* 19. Encuentra el título de las películas que son comedias y tienen una
duración mayor a 180 minutos en la tabla “filmˮ. 
*/
SELECT	f.title AS "Título",
		f.length AS "Duración",
		c.name AS "Género"
FROM film_category AS fc 
JOIN film AS f ON fc.film_id = f.film_id 
JOIN category AS c ON fc.category_id = c.category_id 
WHERE c."name" ILIKE 'Comedy' AND f.length > 180;

/* 20. Encuentra las categorías de películas que tienen un promedio de
duración superior a 110 minutos y muestra el nombre de la categoría
junto con el promedio de duración. 
*/
SELECT	c.name AS "Categoría",
		ROUND(AVG(f.length), 2) AS "Duración_media"
FROM film_category AS fc 
JOIN film AS f ON fc.film_id = f.film_id 
JOIN category AS c ON fc.category_id = c.category_id 
GROUP BY c.name 
HAVING AVG(f.length) > 110
ORDER BY "Duración_media" DESC;

-- 21. ¿Cuál es la media de duración del alquiler de las películas?
SELECT AVG(r.return_date - r.rental_date) AS "Duración_media_alquiler"
FROM rental AS r ;

/* 22. Crea una columna con el nombre y apellidos de todos los actores y
actrices. 
*/
SELECT CONCAT(a.first_name, ' ', a.last_name) AS "Nombre_completo_actor"
FROM actor AS a 
ORDER BY "Nombre_completo_actor" ASC;

/* 23. Números de alquiler por día, ordenados por cantidad de alquiler de
forma descendente. 
*/
SELECT	COUNT(*) AS "Alquileres_día",
		DATE(r.rental_date) AS "Fecha"
FROM rental AS r 
GROUP BY DATE(r.rental_date) 
ORDER BY "Alquileres_día" DESC ;


-- 24. Encuentra las películas con una duración superior al promedio.
SELECT	f.title AS "Título",
		f.length AS "Duración"
FROM film AS f 
WHERE f.length > (SELECT AVG(f2.length) FROM film AS f2) ;


-- 25. Averigua el número de alquileres registrados por mes.
SELECT	DATE_TRUNC('month', r.rental_date)::date AS "Mes_Inicio",
		COUNT(*) AS "Num_Alquileres"
FROM rental AS r 
GROUP BY DATE_TRUNC('month', r.rental_date)
ORDER BY "Mes_Inicio";

/* 26. Encuentra el promedio, la desviación estándar y varianza del total
pagado. 
*/
SELECT	ROUND(AVG(p.amount), 2) AS "Promedio_pagado",
		ROUND(STDDEV(p.amount), 2) AS "Desv_estánar",
		ROUND(VARIANCE(p.amount), 2) AS "Varianza"
FROM payment AS p ;

-- 27. ¿Qué películas se alquilan por encima del precio medio?
--Opcional: muestra el precio y el precio medio

SELECT	f.title AS "Título",
		f.rental_rate AS "Precio_alquiler",
			(SELECT AVG(f.rental_rate)
			FROM film AS f) AS "Precio_medio"
FROM film AS f 
WHERE f.rental_rate >	(SELECT AVG(f.rental_rate)
						FROM film AS f)	;

/* 28. Muestra el id de los actores que hayan participado en más de 40
películas. 
*/
SELECT	fa.actor_id AS "ID_Actor"
		--COUNT(fa.film_id) AS "Películas"
FROM film_actor AS fa 
GROUP BY "ID_Actor"
HAVING COUNT(fa.film_id) > 40

/* 29. Obtener todas las películas y, si están disponibles en el inventario,
mostrar la cantidad disponible. 
*/
SELECT	f.title AS "Título",
		COUNT(i.film_id) AS "Cantidad_en_inventario" 
FROM film AS f 
LEFT JOIN inventory AS i ON f.film_id = i.film_id 
GROUP BY f.title 
/*HAVING COUNT(i.film_id) > 0  si uso esto, no obtendré TODAS las películas, y si no lo uso, no podré 
 cumplir con la condición "si están disponibles en el inventario" */
ORDER BY "Cantidad_en_inventario" DESC;

-- 30. Obtener los actores y el número de películas en las que ha actuado.
SELECT	CONCAT(a.first_name, ' ', a.last_name) AS "Nombre",
		(SELECT COUNT(fa.film_id)
		FROM film_actor AS fa
		WHERE fa.actor_id = a.actor_id) AS "Num_Películas"
FROM actor AS a
ORDER BY "Num_Películas" DESC;

--O

SELECT	CONCAT(a.first_name, ' ', a.last_name) AS "Nombre",
		COUNT(fa.film_id) AS "Num_Películas"
FROM actor AS a 
LEFT JOIN film_actor AS fa ON a.actor_id = fa.actor_id 
GROUP BY a.actor_id 
ORDER BY "Num_Películas" DESC;

/*También puedo usar un método más simple:
 SELECT  actor_id AS "ID_Actor",
		count(film_id) AS "Num_Películas"
FROM film_actor AS fa 
GROUP BY actor_id ;*/

 
/* 31. Obtener todas las películas y mostrar los actores que han actuado en
ellas, incluso si algunas películas no tienen actores asociados. 
*/

SELECT	f.title AS "Título",
		COUNT(fa.film_id) AS "Num_Actores"
FROM film AS f 
LEFT JOIN film_actor AS fa ON f.film_id = fa.film_id 
GROUP BY "Título"
--HAVING COUNT(fa.film_id) = 0
;

SELECT	f.title AS "Título",
		CONCAT(a.first_name, ' ', a.last_name) AS "Nombre_actor"
FROM film AS f 
LEFT JOIN film_actor AS fa ON f.film_id = fa.film_id 
LEFT JOIN actor AS a ON fa.actor_id = a.actor_id 
ORDER BY "Título";


/* 32. Obtener todos los actores y mostrar las películas en las que han
actuado, incluso si algunos actores no han actuado en ninguna película. 
*/

SELECT	CONCAT(a.first_name, ' ', a.last_name) AS "Nombre",
		f.title AS "Título"
FROM actor AS a 
LEFT JOIN film_actor AS fa ON a.actor_id = fa.actor_id 
LEFT JOIN film AS f ON fa.film_id = f.film_id 
ORDER BY "Nombre" ASC;


/* 33. Obtener todas las películas que tenemos y todos los registros de
alquiler. 
*/
SELECT	f.title AS "Título",
		r.rental_id AS "Registro_Alquiler"
FROM film AS f 
LEFT JOIN inventory AS i ON f.film_id = i.film_id 
LEFT JOIN rental AS r ON i.inventory_id = r.inventory_id
ORDER BY "Título" ASC, r.rental_date DESC ;
--No uso full porque no puede haber alquileres sin película


-- 34. Encuentra los 5 clientes que más dinero se hayan gastado con nosotros.
SELECT	p.customer_id AS "ID_Cliente",
		CONCAT(SUM(amount), '€') AS "Gasto"
FROM payment AS p 
GROUP BY "ID_Cliente"
ORDER BY SUM(amount) DESC --NO uso el alias aquí para evitar que ordene de forma alfabética en lugar de numérica
LIMIT 5;
 

-- 35. Selecciona todos los actores cuyo primer nombre es 'Johnny'.
SELECT CONCAT(a.first_name, ' ', a.last_name) AS "Actor"
FROM actor AS a 
WHERE a.first_name ILIKE 'johnny';


/* 36. Renombra la columna “first_nameˮ como Nombre y “last_nameˮ como Apellido. */
SELECT	a.first_name AS "Nombre", 
		a.last_name AS "Apellido"
FROM actor AS a ;


-- 37. Encuentra el ID del actor más bajo y más alto en la tabla actor.
SELECT	MAX(a.actor_id) AS "ID_más_alto",
		MIN(a.actor_id) AS "ID_más_bajo"
FROM actor AS a ;

--O

SELECT	a.actor_id AS "ID_Actor", 
    	a.first_name AS "Nombre", 
    	a.last_name AS "Apellido"
FROM actor AS a 
WHERE 
    a.actor_id = (SELECT MIN(actor_id) FROM actor) 
    OR 
    a.actor_id = (SELECT MAX(actor_id) FROM actor);

-- 38. Cuenta cuántos actores hay en la tabla “actorˮ.

SELECT COUNT(a.actor_id) AS "Num_Actores"
FROM actor AS a 

/* 39. Selecciona todos los actores y ordénalos por apellido en orden
ascendente. */

SELECT CONCAT(a.last_name, ' ', a.first_name) AS "Nombre_actor_apellidoPrimero"
FROM actor AS a 
ORDER BY "Nombre_actor_apellidoPrimero" ASC

-- 40. Selecciona las primeras 5 películas de la tabla “filmˮ.

SELECT f.title AS "Título"
FROM film AS f 
--ORDER BY "Título"
LIMIT 5

/* 41. Agrupa los actores por su nombre y cuenta cuántos actores tienen el
mismo nombre. ¿Cuál es el nombre más repetido? */

SELECT	a.first_name AS "Nombre_actor",
		COUNT(a.first_name) AS "Cuenta_Nombres"
FROM actor AS a 
GROUP BY "Nombre_actor"
ORDER BY "Cuenta_Nombres" DESC;

--Los más repetidos son Kenneth, Penelope y Julia

/* 42. Encuentra todos los alquileres y los nombres de los clientes que los
realizaron. */
SELECT	r.rental_id AS "Registro_alquiler",
		CONCAT(c.first_name, ' ', c.last_name) AS "Cliente"
FROM rental AS r 
JOIN customer AS c ON r.customer_id = c.customer_id 
ORDER BY "Cliente"

/* 43. Muestra todos los clientes y sus alquileres si existen, incluyendo
aquellos que no tienen alquileres. */

SELECT	CONCAT(c.first_name, ' ', c.last_name) AS "Nombre_cliente",
		r.rental_id AS "Registro_alquiler"
FROM customer AS c 
LEFT JOIN rental AS r ON c.customer_id = r.customer_id 
ORDER BY "Nombre_cliente" ASC;

/* 44. Realiza un CROSS JOIN entre las tablas film y category. ¿Aporta valor
esta consulta? ¿Por qué? Deja después de la consulta la contestación. */

SELECT *
FROM film AS f
CROSS JOIN category AS c;
--No aporta ningún valor, ya que es información falsa


/* 45. Encuentra los actores que han participado en películas de la categoría
'Action'. */

-- 46. Encuentra todos los actores que no han participado en películas.



/* 47. Selecciona el nombre de los actores y la cantidad de películas en las
que han participado. */

SELECT	CONCAT(a.first_name, ' ', a.last_name) AS "Nombre",
		(SELECT COUNT(fa.film_id)
		FROM film_actor AS fa
		WHERE fa.actor_id = a.actor_id) AS "Num_Películas"
FROM actor AS a
ORDER BY "Num_Películas" DESC;

/* 48. Crea una vista llamada “actor_num_peliculasˮ que muestre los nombres
de los actores y el número de películas en las que han participado. */

-- 49. Calcula el número total de alquileres realizados por cada cliente.

SELECT	CONCAT(c.first_name, ' ', c.last_name) AS "Nombre_cliente",
		COUNT(r.rental_id) AS "Num_alquileres"
FROM customer AS c 
LEFT JOIN rental AS r ON c.customer_id = r.customer_id 
GROUP BY "Nombre_cliente"
ORDER BY "Nombre_cliente" ASC;

-- 50. Calcula la duración total de las películas en la categoría 'Action'.

/* 51. Crea una tabla temporal llamada “cliente_rentas_temporalˮ para
almacenar el total de alquileres por cliente. */

/* 52. Crea una tabla temporal llamada “peliculas_alquiladasˮ que almacene las
películas que han sido alquiladas al menos 10 veces. */

/* 53. Encuentra el título de las películas que han sido alquiladas por el cliente
con el nombre ‘Tammy Sandersʼ y que aún no se han devuelto. Ordena
los resultados alfabéticamente por título de película. */

/* 54. Encuentra los nombres de los actores que han actuado en al menos una
película que pertenece a la categoría ‘Sci-Fiʼ. Ordena los resultados
alfabéticamente por apellido. */

/* 55. Encuentra el nombre y apellido de los actores que han actuado en
películas que se alquilaron después de que la película ‘Spartacus
Cheaperʼ se alquilara por primera vez. Ordena los resultados
alfabéticamente por apellido. */

/* 56. Encuentra el nombre y apellido de los actores que no han actuado en
ninguna película de la categoría ‘Musicʼ. */

/* 57. Encuentra el título de todas las películas que fueron alquiladas por más
de 8 días. */

/* 58. Encuentra el título de todas las películas que son de la misma categoría
que ‘Animationʼ. */

/* 59. Encuentra los nombres de las películas que tienen la misma duración
que la película con el título ‘Dancing Feverʼ. Ordena los resultados
alfabéticamente por título de película. */

/* 60. Encuentra los nombres de los clientes que han alquilado al menos 7
películas distintas. Ordena los resultados alfabéticamente por apellido. */

/* 61. Encuentra la cantidad total de películas alquiladas por categoría y
muestra el nombre de la categoría junto con el recuento de alquileres. */

-- 62. Encuentra el número de películas por categoría estrenadas en 2006.

/* 63. Obtén todas las combinaciones posibles de trabajadores con las tiendas
que tenemos. */

/* 64. Encuentra la cantidad total de películas alquiladas por cada cliente y
muestra el ID del cliente, su nombre y apellido junto con la cantidad de
películas alquiladas. */


