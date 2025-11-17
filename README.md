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

---
