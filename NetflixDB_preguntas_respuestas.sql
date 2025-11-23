EXPLORACIÓN NETFLIXDB:

-- 1. ¿Qué géneros son más prevalentes en la base de datos NetflixDB? 
-- Genera una lista de los distintos géneros y la cantidad de series por cada uno.

-- R: Ciencia ficcion: 3
      Drama: 2
      Drama histotico: 2

-- SQL: 
        SELECT genero AS 'Género', COUNT(serie_id) AS 'Cantidad de Series'
        FROM series
        GROUP BY genero
        ORDER BY COUNT(serie_id) DESC

-- Esta consulta SQL nos permite ver cuántas series hay en cada género dentro de la base de datos NetflixDB. 
-- Agrupando las series por su género y contándolas, podemos identificar cuáles géneros son más prevalentes.






-- 2. ¿Cuáles son las tres series con mayor rating IMDB y cuántos episodios tienen? 
-- Considera usar un JOIN para combinar la información de las tablas de series y episodios.

-- R: Arcane, rating: 9.227, # Episodios: 11
      Game of Thrones, rating: 9.166, # Episodios: 12
      Peaky Blinders, rating: 9.045, # Episodios: 11

-- SQL: 
        SELECT s.titulo AS 'Nombre de la Serie', 
               AVG(e.rating_imdb) AS 'Rating Promedio',
               COUNT(e.episodio_id) AS 'Cantidad de Episodios'
        FROM series AS s
        LEFT JOIN episodios AS e
        ON s.serie_id = e.serie_id
        GROUP BY s.titulo
        ORDER BY AVG(e.rating_imdb) DESC
        LIMIT 3

-- Con esta consulta, identificamos las tres series con el mayor rating IMDB 
-- en la base de datos y contamos cuántos episodios tiene cada una de ellas, combinando información de las tablas Series y Episodios.






-- 3.¿Cuál es la duración total de todos los episodios para la serie "Stranger Things"? 

-- R: Duracion: 1227 min

-- SQL (WHERE): 
                SELECT s.titulo AS 'Nombre de la Serie',
                       SUM(e.duracion) AS 'Duracion (min)'
                FROM series AS s
                LEFT JOIN episodios AS e
                ON s.serie_id = e.serie_id
                WHERE s.titulo = 'Stranger Things'
                GROUP BY s.titulo

-- SQL (HAVING): 
                 SELECT s.titulo AS 'Nombre de la Serie',
                        SUM(e.duracion) AS 'Duracion (min)'
                 FROM series AS s
                 LEFT JOIN episodios AS e
                 ON s.serie_id = e.serie_id
                 GROUP BY s.titulo
                 HAVING s.titulo = 'Stranger Things'

-- Este análisis nos permitirá entender el compromiso temporal necesario para ver una serie completa.





-- 4. Se desea mostrar todas las series de los tres generos más populares junto con la información de su titulo, año lanzamiento, genero y rating imdb promedio.
-- Los géneros mas populares son aquellos que tienen la mayor cantidad de series. 



-- Usando subconsultas:

                 SELECT s.titulo AS 'Titulo de la serie',
                        s.año_lanzamiento AS 'Año de lanzamiento',
                        s.genero AS 'Genero',
                        AVG(e.rating_imdb) AS Rating_IMBD
                 FROM series AS s
                 LEFT JOIN episodios AS e
                 ON s.serie_id = e.serie_id
                 WHERE s.genero IN (SELECT genero
                                    FROM (SELECT genero, COUNT(titulo) AS cantidad_series
					  FROM series
                                          GROUP BY genero
                                          ORDER BY cantidad_series DESC 
                                          LIMIT 3) AS Top_3)
                 GROUP BY s.titulo, s.año_lanzamiento, s.genero
                 ORDER BY Rating_IMBD DESC
  


-------------------------------------------------------------------------------



-- Usando CTE's:

                 WITH top_generos AS (
                 SELECT genero, COUNT(titulo) AS cantidad_series
                 FROM series 
                 GROUP BY genero
                 ORDER BY cantidad_series DESC 
                 LIMIT 3
                 )

                 SELECT s.titulo AS 'Titulo de la serie',
                 	s.año_lanzamiento AS 'Año de lanzamiento',
                        s.genero AS 'Genero', 
                        AVG(e.rating_imdb) AS Rating_IMDB
                 FROM series AS s
                 LEFT JOIN episodios AS e
                 ON s.serie_id = e.serie_id
                 WHERE s.genero IN (SELECT genero
                                    FROM top_generos)
                 GROUP BY s.titulo, s.año_lanzamiento, s.genero
                 ORDER BY Rating_IMDB DESC 






-- 5. Ahora se busca generar un listado o ranking de series que contenga el titulo de la serie, la cantidad de episodios de cada serie y el rating imdb promedio de cada una de ellas.
--    El objetivo es identificar las series más exitosas basandonos en el rating imdb promedio de cada serie y en la cantidad de episodios.

-- Hay diversas formas de obtener o formar esta lista en base a diferentes formas de estructurar nuestras consultas, a continuación se muestran algunas de ellas:
   


-- a. Mediante el uso de JOINS tenemos la siguiente consulta:

                 SELECT s.titulo AS 'Titulo de la serie',
                        COUNT(e.titulo) AS 'Cantidad de episodios',
                        AVG(e.rating_imdb) AS 'Rating IMDB promedio'
                 FROM series AS s
                 LEFT JOIN episodios AS e
                 ON s.serie_id = e.serie_id
                 GROUP BY s.titulo
                 ORDER BY AVG(e.rating_imdb) DESC, COUNT(e.titulo) DESC


----------------------------------------------------------------------------------


-- b. Mediante el uso de 2 CTE's: 

                 WITH cantidad_episodios AS (

                 SELECT serie_id, COUNT(*) AS numero_de_episodios
                 FROM episodios
                 GROUP BY serie_id
                 ORDER BY numero_de_episodios DESC

                 ),

                 rating_promedio AS (

                 SELECT serie_id, AVG(rating_imdb) AS rating_imdb
                 FROM episodios 
                 GROUP BY serie_id
                 ORDER BY rating_imdb DESC 

                 )

                 SELECT s.titulo AS 'Titulo de la serie',
                        c.numero_de_episodios AS 'Cantidad de episodios',
                        r.rating_imdb AS 'Rating IMDB promedio'
                 FROM series AS s
                 LEFT JOIN cantidad_episodios AS c
                 ON s.serie_id = c.serie_id
                 LEFT JOIN rating_promedio AS r
                 ON s.serie_id = r.serie_id
                 ORDER BY r.rating_imdb DESC, c.numero_de_episodios DESC


--------------------------------------------------------------------------------


-- c. Forma alternativa mediante el uso de 1 CTE: 


                 WITH ranking_series AS (

                 SELECT serie_id, COUNT(*) AS cantidad_episodios, AVG(rating_imdb) AS rating_promedio
                 FROM episodios
                 GROUP BY serie_id

                 )

                 SELECT s.titulo AS 'Titulo de la serie',
                        r.cantidad_episodios AS 'Cantidad de episodios',
                        r.rating_promedio AS 'Rating IMDB promedio'
                 FROM series AS s
                 LEFT JOIN ranking_series AS r
                 ON s.serie_id = r.serie_id
                 ORDER BY r.rating_promedio DESC, r.cantidad_episodios DESC 


-------------------------------------------------------------------------------


-- d. Forma alternativa mediante el uso de 1 CTE: 


                 WITH ranking_series AS (

                 SELECT s.titulo AS 'Titulo de la serie',
                        COUNT(e.titulo) AS 'Cantidad de episodios',
                        AVG(e.rating_imdb) AS 'Rating IMDB promedio'
                 FROM series AS s
                 LEFT JOIN episodios AS e
                 ON s.serie_id = e.serie_id
                 GROUP BY s.titulo
                 ORDER BY AVG(e.rating_imdb) DESC, COUNT(e.titulo) DESC

                 )

                 SELECT *
                 FROM ranking_series




-- Sea cual se la consulta que se emplee para generar dicha lista el resultado será el mismo.

















