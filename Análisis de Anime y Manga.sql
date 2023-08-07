-- Portafolio de Proyecto: Análisis de datos de Anime (2023) --

-- 1) Importar el archivo csv del conjunto de datos a SQL Server

-- 2) Mostrar las primeras 50 filas de la tabla

SELECT TOP 50
	Title,
	Rank,
	Type,
	Episodes,
	Aired,
	Members,
	Score
FROM PortafolioProyectos.dbo.MyAnimeList

-- ¿Cuántos registros tiene este conjunto de datos?
SELECT
	COUNT(*) AS conteo_registros
FROM PortafolioProyectos.dbo.MyAnimeList
  --Posee 1274 filas

  --De estas filas ¿cuántas son únicas?
SELECT
	COUNT ( DISTINCT Title) AS conteo_titulos
FROM PortafolioProyectos.dbo.MyAnimeList
  --Posee 12774

--De todos estos registros ¿Qué cantidad corresponde a animes, películas, ONAs, OVAs y especiales?
SELECT
	Type,
	COUNT(Title) AS numero_de_titulos
FROM PortafolioProyectos.dbo.MyAnimeList
GROUP BY Type
  --Esta consulta arrojó que existe un registro catalogado como 'desconocido'. Averiguaré qué es. 
SELECT
	*
FROM PortafolioProyectos.dbo.MyAnimeList
WHERE Type = 'Unknown'
  --Al parecer es una sere de cortometrajes de cuentos de hadas llamdo 'Sekai Meisaku Douwa'

--¿Cuáles son las categorías más populares?
SELECT
	Type,
	SUM(Members) AS numero_de_miembros
FROM PortafolioProyectos.dbo.MyAnimeList
GROUP BY Type
ORDER BY numero_de_miembros DESC
  --Los animes de TV son los más vistos seguido por las películas. 

--¿Cuáles son los 10 animes de TV con mejor Score?
SELECT TOP 10
	Title, 
	Score
FROM PortafolioProyectos.dbo.MyAnimeList
WHERE Type = 'TV'
ORDER BY Score DESC

--¿Cuáles son los 10 animes de TV con peor Score?
SELECT TOP 10
	Title, 
	Score
FROM PortafolioProyectos.dbo.MyAnimeList
WHERE Type = 'TV'
ORDER BY Score ASC

--¿Cuáles son los 10 animes de TV más populares?
SELECT TOP 10
	Title, 
	Members
FROM PortafolioProyectos.dbo.MyAnimeList
WHERE Type = 'TV'
ORDER BY Members DESC

-- ¿Cuáles son los 10 animes de TV menos populares?
SELECT TOP 10
	Title, 
	Members
FROM PortafolioProyectos.dbo.MyAnimeList
WHERE Type = 'TV'
ORDER BY Members ASC

-- ¿Cuales son las 10 peliculas de anime con el mejor score?
SELECT TOP 10
	Title,
	Score
FROM PortafolioProyectos.dbo.MyAnimeList
WHERE Type = 'Movie'
ORDER BY Score DESC

-- ¿Cuáles son las 10 películas de anime con el peor score?
SELECT TOP 10
	Title,
	Score
FROM PortafolioProyectos.dbo.MyAnimeList
WHERE Type = 'Movie'
ORDER BY Score ASC

-- ¿Cuáles son las 10 películas de anime más populares?
SELECT TOP 10
	Title,
	Members
FROM PortafolioProyectos.dbo.MyAnimeList
WHERE Type = 'Movie'
ORDER BY Members DESC

-- ¿Cuáles son las 10 películas de anime menos populares?
SELECT TOP 10
	Title,
	Members
FROM PortafolioProyectos.dbo.MyAnimeList
WHERE Type = 'Movie'
ORDER BY Members ASC

--¿Cuál es el número máximo y mínimo de miembros para anime de TV?
SELECT
	MAX(Members) as max_miembros,
	MIN(Members) as min_miembros
FROM PortafolioProyectos.dbo.MyAnimeList
WHERE Type = 'TV'

-- ¿Cual es el valor máximo y mínimo de score para anime de TV?
SELECT
	MAX(Score) as max_score,
	MIN(Score) as min_score
FROM PortafolioProyectos.dbo.MyAnimeList
WHERE Type = 'TV'

-- ¿Cuál es el promedio de miembros para un anime de TV?
SELECT
	AVG(Members) AS avg_miembros
FROM PortafolioProyectos.dbo.MyAnimeList
WHERE Type = 'TV' 
  -- El promedio es 155100 miembros

-- ¿Qué animes poseen un score de entre 8.5 a 10 y una cantidad de miembros arriba del promedio?
SELECT
	Title,
	Score,
	Members
FROM PortafolioProyectos.dbo.MyAnimeList
WHERE
	Type = 'TV'
	AND Score BETWEEN 8.5 AND 10
	AND Members >= 155100
ORDER BY Score DESC, Members DESC

-- ¿Qué animes poseen un score de entre 6 a 8.4 y una cantidad de miembros arriba del promedio?
SELECT
	Title,
	Score,
	Members
FROM PortafolioProyectos.dbo.MyAnimeList
WHERE
	Type = 'TV'
	AND Score BETWEEN 6 AND 8.4
	AND Members >= 155100
ORDER BY Members DESC

-- ¿Qué animes de TV poseen un score de entre 8.5 a 10 y una cantidad de miembros por debajo promedio?
SELECT
	Title,
	Score,
	Members,
	page_url
FROM PortafolioProyectos.dbo.MyAnimeList
WHERE
	Type = 'TV'
	AND Score BETWEEN 8.5 AND 10
	AND Members <= 155100
ORDER BY Score DESC, Members DESC

-- ¿Cuál es el promedio de miembros para un película de anime?
SELECT
	AVG(Members) AS avg_miembros
FROM PortafolioProyectos.dbo.MyAnimeList
WHERE Type = 'Movie' 
-- el promedio es de 40405

-- ¿Qué películas poseen un score de entre 8.5 a 10 y una cantidad de miembros arriba del promedio?
SELECT
	Title,
	Score,
	Members
FROM PortafolioProyectos.dbo.MyAnimeList
WHERE
	Type = 'Movie'
	AND Score BETWEEN 8.5 AND 10
	AND Members >= 40405
ORDER BY Score DESC, Members DESC

-- ¿Qué películas poseen un score de entre 8.5 a 10 y una cantidad de miembros debajo del promedio?
SELECT
	Title,
	Score,
	Members
FROM PortafolioProyectos.dbo.MyAnimeList
WHERE
	Type = 'Movie'
	AND Score BETWEEN 8.5 AND 10
	AND Members <= 40405
ORDER BY Score DESC, Members DESC


-- ¿Cuál es el promedio de miembros para una OVA?
SELECT
	AVG(Members) AS avg_miembros
FROM PortafolioProyectos.dbo.MyAnimeList
WHERE Type = 'OVA' 
-- el promedio es de 23527

-- ¿Qué OVAs poseen un score de entre 8.5 a 10 y una cantidad de miembros arriba del promedio?
SELECT
	Title,
	Score,
	Members
FROM PortafolioProyectos.dbo.MyAnimeList
WHERE
	Type = 'OVA'
	AND Score BETWEEN 8.5 AND 10
	AND Members >= 23527
ORDER BY Score DESC, Members DESC

-- ¿Qué OVAs poseen un score de entre 8 a 10 y una cantidad de miembros debajo del promedio?
SELECT
	Title,
	Score,
	Members
FROM PortafolioProyectos.dbo.MyAnimeList
WHERE
	Type = 'OVA'
	AND Score BETWEEN 8 AND 10
	AND Members <= 23527
ORDER BY Score DESC, Members DESC


--Ahora me gustaría probar algo más. Voy agregar una tabla con datos de manga. 

--Importé el archivo de manga de este mismo sitio web, así que haré una pequeña limpieza de datos en la columna de volumenes.
--Esta columna posee '?' en algunas celdas y las cambiaré a nulls para poder tener un tipo de dato numérico.
--Esto lo hago para que concuerde con la table de anime. De esta forma en el futuro podré utilizarlo para otros análisis. 

  --Primero recuperaremos esas celdas
SELECT
	Title,
	Volumes
FROM PortafolioProyectos.dbo.MyMangaList
WHERE volumes = '?'

  --Ahora voy a reemplazar los signos por nulls.
UPDATE PortafolioProyectos.dbo.MyMangaList
SET volumes = NULL
WHERE volumes = '?'

  --Voy a cambiar el tipo de dato.
ALTER TABLE PortafolioProyectos.dbo.MyMangaList
ALTER COLUMN volumes INT

  --Comprobaré el cambio
SELECT
	Title,
	Volumes
FROM PortafolioProyectos.dbo.MyMangaList
WHERE volumes  IS NULL  
  --Todo en orden

--Ahora juntaré las dos tablas usando la columa título y crearé un CTE para hacer las consultas y que sea más legible.
--Tengo curiosidad por saber qué es más popular, el anime o el manga de los mismos títulos.

WITH anime_manga_list AS
	(
	SELECT
		DISTINCT anime.Title,
		anime.Members AS anime_members,
		manga.Members AS manga_members,
		anime.Score AS anime_score,
		manga.Score AS manga_score,
		manga.Published,
		anime.Aired,
		manga.page_url AS manga_url,
		anime.page_url AS anime_url
	FROM PortafolioProyectos.dbo.MyAnimeList anime JOIN
		PortafolioProyectos.dbo.MyMangaList manga ON
			anime.Title =  manga.Title
	WHERE anime.Type = 'TV' 
		AND manga.Type = 'Manga' 
	)
--SELECT
--	SUM(anime_members) AS SUM_miembros_anime,
--	SUM(manga_members) AS SUM_miembros_manga
--FROM anime_manga_list
--Los animes ganan en miembros.

--Ahora busquemos qué mangas son más populares que sus animes.
SELECT 
	Title,
	manga_members,
	anime_members,
	Published,
	Aired,
	manga_url,
	anime_url
FROM anime_manga_list
WHERE manga_members > anime_members
