# 📊 Preguntas NetflixDB en proceso...

El proposito de este proyecto es explicar de forma breve el proceso que se debe realizar para la creación e inicialización de la base de datos NetflixDB en MySQL Workbench.

## Índice 

---

## 🔑 Diagrama entidad relación (DER)

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

### 4. Se desea saber el titulo, el año de lanzamiento, género y rating imdb promedio de todas las series que integran el top 3 de los generos mas populares por cantidad de series.

* A cotinuación se muestra el top 3 de los generos más populares por cantidad de series:

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
R//

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
R//

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




---
