-- 2. Mostrar ventas con país + categoría
select
    p.desc_pais,
    c.desc_categoria,
    v.ventas
from
    h_ventas v

left join d_pais p
    on v.id_pais = p.id_pais

left join d_categoria c
    on v.id_categoria = c.id_categoria

order by 1;


-- 3. Mostrar ventas con: país, categoría y tipo de tarjeta
select
    p.desc_pais,
    c.desc_categoria,
    v.ventas,
    tt.desc_tipo_tarjeta
from
    h_ventas v

left join d_pais p
    on v.id_pais = p.id_pais

left join d_categoria c
    on v.id_categoria = c.id_categoria

left join d_tipo_tarjeta tt
    on v.id_tipo_tarjeta = tt.id_tipo_tarjeta

order by 1;


-- 4. Total ventas por país
select
    p.desc_pais,
    sum(v.ventas) as total_sales
from
    h_ventas v

left join d_pais p
    on v.id_pais = p.id_pais

group by 1;


-- 5. Total ventas por país y categoría
select
    p.desc_pais,
    c.desc_categoria,
    sum(v.ventas) as total_sales
from
    h_ventas v

left join d_pais p
    on v.id_pais = p.id_pais

left join d_categoria c
    on v.id_categoria = c.id_categoria

group by 1,2
order by 1;


-- 6. Total ventas por año
SELECT
    f.anyo,
    sum(v.ventas) as total_sales

FROM
    h_ventas v

LEFT JOIN d_fecha f
    ON v.id_fecha = f.id_fecha

GROUP BY 1
order by 1;


-- 7. Total ventas por año y país
SELECT
    f.anyo,
    p.desc_pais,
    sum(v.ventas) as total_sales

FROM
    h_ventas v

LEFT JOIN d_fecha f
ON v.id_fecha = f.id_fecha

left join d_pais p
    ON v.id_pais = p.id_pais

GROUP BY 1,2
ORDER BY f.anyo, total_sales DESC;


-- 8. Top 5 países por ventas
select
    p.desc_pais,
    sum(v.ventas) as total_sales
from
    h_ventas v

left join d_pais p
    on v.id_pais = p.id_pais

group by 1
order by total_sales DESC
Limit 5;


-- Windows Functions
-- 9. Top 3 países por ventas para cada año (con subconsulta)
SELECT *
FROM (
    SELECT
        f.anyo,
        p.desc_pais,
        SUM(v.ventas) AS total_sales,
        ROW_NUMBER() OVER (
            PARTITION BY f.anyo
            ORDER BY SUM(v.ventas) DESC
        ) AS ranking
    FROM h_ventas v

    LEFT JOIN d_fecha f
        ON v.id_fecha = f.id_fecha
    LEFT JOIN d_pais p
        ON v.id_pais = p.id_pais
    GROUP BY f.anyo, p.desc_pais

) t
WHERE ranking <= 3;


-- 9. Top 3 países por ventas para cada año (con CTE)
with ranking_table as (
    SELECT
        f.anyo,
        p.desc_pais,
        sum(v.ventas) as total_sales,
        row_number() over(
            partition by f.anyo
            order by sum(v.ventas) DESC
        ) as ranking
    FROM
        h_ventas v

    LEFT JOIN d_fecha f
        ON v.id_fecha = f.id_fecha

    LEFT JOIN d_pais p
        ON v.id_pais = p.id_pais
    GROUP BY f.anyo, p.desc_pais
) 

SELECT *
FROM ranking_table
WHERE
    ranking <=3;


-- 10. Obtener el país con más ventas para cada año, mostrando:
-- año, país, ventas totales y porcentaje que representa sobre el total de ventas de ese año.
with base as (
    SELECT
        f.anyo,
        p.desc_pais,
        sum(v.ventas) as total_sales,
        row_number() OVER(
            partition by f.anyo
            order by sum(v.ventas) DESC
        ) as ranking,
            count(ventas) as number_sales,
        SUM(sum(v.ventas)) OVER( 
            PARTITION BY f.anyo) as total_year_sales
    FROM
        h_ventas v

    LEFT JOIN d_fecha f
        ON v.id_fecha = f.id_fecha

    LEFT JOIN d_pais p
        ON v.id_pais = p.id_pais
    
    GROUP BY f.anyo, p.desc_pais
)
select 
    anyo,
    desc_pais,
    total_sales,
    total_sales/total_year_sales AS porcentaje
from base
where ranking = 1;


-- 11. Obtener: país, total ventas con descuento aplicado, total ventas sin descuento, diferencia.
WITH base AS(
SELECT
    p.desc_pais,
    v.ventas,
    CAST(REPLACE(REPLACE(v.descuento, ',','.'), '%', '') AS DECIMAL (5,4)) as descuento_clean

FROM
    h_ventas_edit v

LEFT JOIN d_pais p
    ON v.id_pais = p.id_pais

),

aggregated AS (
    SELECT
        desc_pais,
        SUM(ventas)                     AS total_ventas_bruto,
        SUM(ventas * descuento_clean)   AS descuento_total

    FROM
        base

    GROUP BY desc_pais
)

SELECT
    desc_pais,
    total_ventas_bruto                          AS ventas_sin_descuento,
    total_ventas_bruto - descuento_total        AS ventas_con_descuento,
    descuento_total                             AS diferencia

FROM
    aggregated;


-- 12. Obtener los países que cumplen: ventas netas (con descuento aplicado) > 5000
-- y que tengan más de 10 registros de ventas
WITH base as (
    select
        p.desc_pais,
        v.ventas,
        CAST(REPLACE(REPLACE(v.descuento, ',','.'), '%', '') AS DECIMAL (5,4)) as descuento_clean
    FROM
        h_ventas_edit v

    INNER JOIN d_pais p
        ON v.id_pais = p.id_pais

), aggregated AS (
    SELECT
        desc_pais,
        SUM(ventas)                         AS total_sales,
        SUM(ventas * descuento_clean)       AS total_discount,
        SUM(ventas * (1 - descuento_clean)) AS net_sales
    FROM
        base

    GROUP BY desc_pais
    HAVING
        COUNT(*) > 10
        AND SUM(ventas * (1 - descuento_clean)) > 5000

)

SELECT
    desc_pais,
    net_sales

FROM aggregated
ORDER BY net_sales DESC;
        

-- 13. Top 3 países por ventas netas por año.
WITH base AS (
    SELECT
        f.anyo,
        p.desc_pais,
        v.ventas,
        CAST(REPLACE(REPLACE(v.descuento, ',','.'), '%', '') AS DECIMAL (5,4)) AS descuento_clean
        
    FROM
        h_ventas_edit v
    INNER JOIN d_pais p
        ON V.id_pais = P.id_pais
    LEFT JOIN d_fecha f
    ON v.id_fecha = f.id_fecha
),

aggregated AS(
    SELECT
        anyo,
        desc_pais,
        SUM(ventas)                     AS total_sales,
        SUM(ventas * descuento_clean)   AS total_discount,

        ROW_NUMBER()OVER(
            PARTITION BY anyo
            ORDER BY SUM(ventas) - SUM(ventas * descuento_clean) DESC) AS ranking
    FROM    
        base

    GROUP BY anyo, desc_pais
)

SELECT 
    anyo,
    desc_pais,
    total_sales - total_discount        AS net_sales,
    ranking
FROM aggregated
WHERE ranking <=3;


-- 14. porcentaje de ventas por país dentro de cada año (window functions)
WITH base AS (
    SELECT
        p.desc_pais,
        v.ventas,
        f.anyo,
        CAST(REPLACE(REPLACE(v.descuento, ',','.'), '%', '') AS DECIMAL (5,4)) AS descuento_clean
    FROM
        h_ventas_edit v

    INNER JOIN d_fecha f
        ON v.id_fecha = f.id_fecha
    INNER JOIN d_pais p
        ON v.id_pais = p.id_pais

), 

aggregated as (
    SELECT
        anyo,
        desc_pais,
        SUM(ventas) AS total_sales,
        SUM(SUM(ventas)) OVER (PARTITION BY anyo) AS total_year_sales,

        ROW_NUMBER() OVER(
            PARTITION BY anyo
            ORDER BY SUM(ventas) DESC 
            ) AS ranking

    FROM
        base

    GROUP BY anyo, desc_pais

)

SELECT 
    anyo,
    desc_pais,
    total_sales,
    total_year_sales,
    total_sales / total_year_sales AS percentage,
    ranking

FROM aggregated
ORDER BY anyo, ranking;