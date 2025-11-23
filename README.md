# 📊 Preguntas NetflixDB en proceso...

El proposito de este ejercicio es por medio de consultas SQL responder algunas preguntas sobre la popularidad y prevalencia de las series y géneros de series contenidos en la base de datos de prueba [NetflixDB](https://github.com/Sebastian-Diaz-Berdecia/NetflixDB-MySQL-Workbench), así como tambien sobre el compromiso temporal requerido para ver dichas series.

## 🗂 Índice 

* ### [Diagrama entidad relación](https://github.com/Sebastian-Diaz-Berdecia/Proyecto-2-netflixDB/tree/main#-diagrama-entidad-relaci%C3%B3n-para-la-base-de-datos-netflixdb-der)
* ### [Preguntas](https://github.com/Sebastian-Diaz-Berdecia/Proyecto-2-netflixDB#preguntas-1):
  *  [¿Qué géneros son más prevalentes en la base de datos NetflixDB?](https://github.com/Sebastian-Diaz-Berdecia/Proyecto-2-netflixDB#1-qu%C3%A9-g%C3%A9neros-son-m%C3%A1s-prevalentes-en-la-base-de-datos-netflixdb)
  *  [¿Cuáles son las tres series con mayor rating IMDB y cuántos episodios tienen?](https://github.com/Sebastian-Diaz-Berdecia/Proyecto-2-netflixDB/tree/main#2-cu%C3%A1les-son-las-tres-series-con-mayor-rating-imdb-y-cu%C3%A1ntos-episodios-tienen)
  *  [¿Cuál es la duración total de todos los episodios para la serie "Stranger Things"?](https://github.com/Sebastian-Diaz-Berdecia/Proyecto-2-netflixDB/tree/main#3-cu%C3%A1l-es-la-duraci%C3%B3n-total-de-todos-los-episodios-para-la-serie-stranger-things)
  *  [Se desea obtener un listado de todas las series cuyo género hace parte del top 3 de los generos mas populares por cantidad de series, así como tambien conocer el titulo, el año de lanzamiento, género y    rating imdb promedio.](https://github.com/Sebastian-Diaz-Berdecia/Proyecto-2-netflixDB/tree/main#4-se-desea-obtener-un-listado-de-todas-las-series-cuyo-g%C3%A9nero-hace-parte-del-top-3-de-los-generos-mas-populares-por-cantidad-de-series-as%C3%AD-como-tambien-conocer-el-titulo-el-a%C3%B1o-de-lanzamiento-g%C3%A9nero-y-rating-imdb-promedio)
  * [Ahora se busca generar un listado o ranking de series que contenga el titulo de la serie, la cantidad de episodios de cada serie y el rating imdb promedio de cada una de ellas. El objetivo es identificar las series más exitosas basandonos en el rating imdb promedio de cada serie y en la cantidad de episodios.](https://github.com/Sebastian-Diaz-Berdecia/Proyecto-2-netflixDB/tree/main#5-ahora-se-busca-generar-un-listado-o-ranking-de-series-que-contenga-el-titulo-de-la-serie-la-cantidad-de-episodios-de-cada-serie-y-el-rating-imdb-promedio-de-cada-una-de-ellas-el-objetivo-es-identificar-las-series-m%C3%A1s-exitosas-basandonos-en-el-rating-imdb-promedio-de-cada-serie-y-en-la-cantidad-de-episodios)

---

## 🔑 Diagrama entidad relación para la base de datos NetflixDB (DER) 

NetflixDB es una base de datos que consta de cuatro tablas: _series_, _actuaciones_, _actores_ y _episodios_ en donde se alamacena informacion sobre los episodios y actores de algunas series disponibles en el servicio de streaming de Neflix. A continuacion se muestra su diagrama entidad relación.

<img width="858" height="572" alt="image" src="https://github.com/user-attachments/assets/58e28b97-6de9-45a4-a568-39ae13a0999c" />

## Preguntas:
### 1. ¿Qué géneros son más prevalentes en la base de datos NetflixDB? 

```sql
SELECT genero, COUNT(titulo) AS cantidad_series
FROM series
GROUP BY genero
ORDER BY cantidad_series DESC
```
| Género            | Cantidad de series |
|:-------------------:|:--------------------:|
| Ciencia ficción   | 3                  |
| Drama             | 2                  |
| Drama histórico   | 2                  |
| Fantasía          | 2                  |
| Comedia           | 2                  |
| Animación         | 1                  |
| Biografía         | 1                  |

* R// Los géneros mas prevalentes en la base de datos son: Ciencia ficcion: 3 series,  Drama: 2 series y Drama histórico: 2 series.

>[!IMPORTANT]
> Esta consulta SQL nos permite ver cuántas series hay por cada género dentro de la base de datos NetflixDB. Agrupando las series por su género y contándolas, podemos identificar cuáles géneros son más prevalentes.

#

### 2. ¿Cuáles son las tres series con mayor rating IMDB y cuántos episodios tienen? 

```sql
SELECT s.titulo, AVG(e.rating_imdb) AS Rating_IMDB, COUNT(e.titulo) AS cantidad_episodios
FROM series AS s
LEFT JOIN episodios AS e
ON s.serie_id = e.serie_id
GROUP BY  s.titulo 
ORDER BY Rating_IMDB DESC, cantidad_episodios DESC 
LIMIT 3
```

| Título           | Rating IMDB | Cantidad de episodios |
|:------------------:|:-------------:|:------------------------:|
| Arcane           | 9.22727     | 11                     |
| Game of Thrones  | 9.16667     | 12                     |
| Peaky Blinders   | 9.04545     | 11                     |

* R// Las series con mayor rating imdb son: Arcane, Game of Thrones y Peaky Blinders

>[!IMPORTANT]
> Con esta consulta, identificamos las tres series con el mayor rating IMDB 
en la base de datos y contamos cuántos episodios tiene cada una de ellas, combinando información de las tablas Series y Episodios.

#

### 3. ¿Cuál es la duración total de todos los episodios para la serie "Stranger Things"? 
* Alternativa 1: Usando la clausula WHERE.

```sql
SELECT s.titulo, SUM(e.duracion) AS "Duracion total (min)"
FROM series AS s
LEFT JOIN episodios AS e
ON s.serie_id = e.serie_id
WHERE s.titulo = 'Stranger Things'
GROUP BY  s.titulo
```
* Alternativa 2: Usando la clausula HAVING.
```sql
SELECT s.titulo, SUM(e.duracion) AS "Duracion total (min)"
FROM series AS s
LEFT JOIN episodios AS e
ON s.serie_id = e.serie_id
GROUP BY  s.titulo
HAVING s.titulo = 'Stranger Things'
```

| Título           | Duración total (min) |
|:------------------:|:-----------------------:|
| Stranger Things   | 1227                 |

* R// La duración total de todos los episodios de la serie "Stranger Things" es de 1227 min.

>[!IMPORTANT]
>Este análisis nos permitirá entender el compromiso temporal necesario para ver una serie completa.

#

### 4. Se desea obtener un listado de todas las series cuyo género hace parte del top 3 de los generos mas populares por cantidad de series, así como tambien conocer el titulo, el año de lanzamiento, género y rating imdb promedio.

* Primero es conveniente analizar cuales son los generos mas populares por lo que a cotinuación se muestra el top 3 de los generos más populares por cantidad de series:

```sql

SELECT genero, COUNT(titulo) AS cantidad_series
FROM series 
GROUP BY genero
ORDER BY cantidad_series DESC
LIMIT 3

```

| Género           | Cantidad de series |
|:------------------:|:--------------------:|
| Ciencia ficción  | 3                  |
| Drama            | 2                  |
| Drama histórico  | 2                  |

* Por medio del uso de subconsultas se tiene lo siguiente:

```sql

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

```
R// A continuación se muestran todas las series cuyo género hace parte del top 3 de generos mas populares:

| Título de la serie | Año de lanzamiento | Género           | Rating IMDB |
|:--------------------:|:--------------------:|:------------------:|:-------------:|
| Peaky Blinders     | 2013               | Drama histórico  | 9.04545     |
| Stranger Things    | 2016               | Ciencia ficción  | 8.96087     |
| The Mandalorian    | 2019               | Ciencia ficción  | 8.91818     |
| Sherlock           | 2010               | Drama            | 8.89091     |
| The Crown          | 2016               | Drama histórico  | 8.88182     |
| Breaking Bad       | 2008               | Drama            | 8.86364     |
| Black Mirror       | 2011               | Ciencia ficción  | 7.60000     |


* Usando CTE's como alternativa se llega a lo siguiente:

```sql
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

```
R// A continuación se muestran todas las series cuyo género hace parte del top 3 de generos mas populares:

| Título de la serie | Año de lanzamiento | Género           | Rating IMDB |
|:--------------------:|:--------------------:|:------------------:|:-------------:|
| Peaky Blinders     | 2013               | Drama histórico  | 9.04545     |
| Stranger Things    | 2016               | Ciencia ficción  | 8.96087     |
| The Mandalorian    | 2019               | Ciencia ficción  | 8.91818     |
| Sherlock           | 2010               | Drama            | 8.89091     |
| The Crown          | 2016               | Drama histórico  | 8.88182     |
| Breaking Bad       | 2008               | Drama            | 8.86364     |
| Black Mirror       | 2011               | Ciencia ficción  | 7.60000     |

Ya sea por medio del uso de CTE's o de subconsultas se llega a la misma lista de series como se puede observar al comparar las tablas obtenidas como resultado de la ejecución de las consultas SQL.


>[!IMPORTANT]
>Como se puede observar en las tablas obtenidas, el top 3 de los generos mas populares son Ciencia ficción, Drama histórico y Drama. Las series cuyo genero se encuentra dentro de este top 3 se pueden observar en las dos ultimas tablas obtenidas.

#

### 5. Ahora se busca generar un listado o ranking de series que contenga el titulo de la serie, la cantidad de episodios de cada serie y el rating imdb promedio de cada una de ellas. El objetivo es identificar las series más exitosas basandonos en el rating imdb promedio de cada serie y en la cantidad de episodios.

* ####  Hay diversas formas de obtener o formar esta lista en base a diferentes formas de estructurar nuestras consultas, a continuación se muestran algunas de ellas:

* A. Mediante el uso de JOINS tenemos la siguiente consulta:

```sql

SELECT s.titulo AS 'Titulo de la serie',
       COUNT(e.titulo) AS 'Cantidad de episodios',
       AVG(e.rating_imdb) AS 'Rating IMDB promedio'
FROM series AS s
LEFT JOIN episodios AS e
ON s.serie_id = e.serie_id
GROUP BY s.titulo
ORDER BY AVG(e.rating_imdb) DESC, COUNT(e.titulo) DESC

``` 

La ejecución de esta consulta da por resultado la siguiente tabla/lista: 

| Título de la serie   | Cantidad de episodios | Rating IMDB promedio |
|:-----------------------:|:------------------------:|:------------------------:|
| Arcane                | 11                     | 9.22727                |
| Game of Thrones       | 12                     | 9.16667                |
| Peaky Blinders        | 11                     | 9.04545                |
| Stranger Things       | 23                     | 8.96087                |
| The Mandalorian       | 11                     | 8.91818                |
| Sherlock              | 11                     | 8.89091                |
| The Crown             | 11                     | 8.88182                |
| Breaking Bad          | 11                     | 8.86364                |
| Narcos                | 11                     | 8.83636                |
| BoJack Horseman       | 11                     | 8.81818                |
| The Witcher           | 11                     | 8.79091                |
| The Office            | 12                     | 8.33333                |
| Black Mirror          | 11                     | 7.60000                |


* B. Mediante el uso de 2 CTE's: 

```sql

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

```

La ejecución de esta consulta da por resultado la siguiente tabla/lista: 

| Título de la serie   | Cantidad de episodios | Rating IMDB promedio |
|:-----------------------:|:------------------------:|:------------------------:|
| Arcane                | 11                     | 9.22727                |
| Game of Thrones       | 12                     | 9.16667                |
| Peaky Blinders        | 11                     | 9.04545                |
| Stranger Things       | 23                     | 8.96087                |
| The Mandalorian       | 11                     | 8.91818                |
| Sherlock              | 11                     | 8.89091                |
| The Crown             | 11                     | 8.88182                |
| Breaking Bad          | 11                     | 8.86364                |
| Narcos                | 11                     | 8.83636                |
| BoJack Horseman       | 11                     | 8.81818                |
| The Witcher           | 11                     | 8.79091                |
| The Office            | 12                     | 8.33333                |
| Black Mirror          | 11                     | 7.60000                |


* C. Forma alternativa mediante el uso de 1 CTE: 


```sql

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

```

La ejecución de esta consulta da por resultado la siguiente tabla/lista: 

| Título de la serie   | Cantidad de episodios | Rating IMDB promedio |
|:-----------------------:|:------------------------:|:------------------------:|
| Arcane                | 11                     | 9.22727                |
| Game of Thrones       | 12                     | 9.16667                |
| Peaky Blinders        | 11                     | 9.04545                |
| Stranger Things       | 23                     | 8.96087                |
| The Mandalorian       | 11                     | 8.91818                |
| Sherlock              | 11                     | 8.89091                |
| The Crown             | 11                     | 8.88182                |
| Breaking Bad          | 11                     | 8.86364                |
| Narcos                | 11                     | 8.83636                |
| BoJack Horseman       | 11                     | 8.81818                |
| The Witcher           | 11                     | 8.79091                |
| The Office            | 12                     | 8.33333                |
| Black Mirror          | 11                     | 7.60000                |


* D. Forma alternativa mas simple mediante el uso de 1 CTE:

```sql

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

```

La ejecución de esta consulta da por resultado la siguiente tabla/lista: 

| Título de la serie   | Cantidad de episodios | Rating IMDB promedio |
|:-----------------------:|:------------------------:|:------------------------:|
| Arcane                | 11                     | 9.22727                |
| Game of Thrones       | 12                     | 9.16667                |
| Peaky Blinders        | 11                     | 9.04545                |
| Stranger Things       | 23                     | 8.96087                |
| The Mandalorian       | 11                     | 8.91818                |
| Sherlock              | 11                     | 8.89091                |
| The Crown             | 11                     | 8.88182                |
| Breaking Bad          | 11                     | 8.86364                |
| Narcos                | 11                     | 8.83636                |
| BoJack Horseman       | 11                     | 8.81818                |
| The Witcher           | 11                     | 8.79091                |
| The Office            | 12                     | 8.33333                |
| Black Mirror          | 11                     | 7.60000                |


* Organizando la lista de series por rating imdb de mayor a menor se observa que las tres series mas populares son las siguientes: Arcane, Game of Thrones y Peaky Blinders. De esta forma observamos como de cuatro formas diferentes podemos llegar al mismo resultado.


>[!NOTE]
>Sea cual sea la consulta que se emplee para generar dicha lista el resultado será el mismo.



---
























