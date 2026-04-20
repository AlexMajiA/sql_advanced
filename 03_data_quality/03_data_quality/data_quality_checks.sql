/* =========================================
   DATA QUALITY - PROYECTO SQL AVANZADO
   Modelo: h_ventas + dimensiones
   ========================================= */


/* =========================================
   1. FOREIGN KEYS INVÁLIDAS
   ========================================= */

-- Categoría inexistente
SELECT hv.*
FROM h_ventas hv
LEFT JOIN d_categoria dc ON hv.id_categoria = dc.id_categoria
WHERE dc.id_categoria IS NULL;

-- Fecha inexistente
SELECT hv.*
FROM h_ventas hv
LEFT JOIN d_fecha df ON hv.id_fecha = df.id_fecha
WHERE df.id_fecha IS NULL;

-- País inexistente
SELECT hv.*
FROM h_ventas hv
LEFT JOIN d_pais dp ON hv.id_pais = dp.id_pais
WHERE dp.id_pais IS NULL;

-- Tipo tarjeta inexistente
SELECT hv.*
FROM h_ventas hv
LEFT JOIN d_tipo_tarjeta dt ON hv.id_tipo_tarjeta = dt.id_tipo_tarjeta
WHERE dt.id_tipo_tarjeta IS NULL;


/* =========================================
   2. NULLs NO ESPERADOS
   ========================================= */

SELECT *
FROM h_ventas
WHERE id_fecha IS NULL
   OR id_categoria IS NULL
   OR id_pais IS NULL
   OR id_tipo_tarjeta IS NULL
   OR ventas IS NULL;


/* =========================================
   3. DUPLICADOS
   ========================================= */

-- Posibles duplicados en la fact
SELECT id_fecha, id_categoria, id_pais, id_tipo_tarjeta, COUNT(*) AS total
FROM h_ventas
GROUP BY id_fecha, id_categoria, id_pais, id_tipo_tarjeta
HAVING COUNT(*) > 1;


/* =========================================
   4. VALORES INVÁLIDOS
   ========================================= */

-- Ventas negativas o cero
SELECT *
FROM h_ventas
WHERE ventas <= 0;

-- Fechas incoherentes en dimensión
SELECT *
FROM d_fecha
WHERE mes < 1 OR mes > 12
   OR dia < 1 OR dia > 31;


/* =========================================
   5. INCONSISTENCIAS DE TEXTO
   ========================================= */

-- País con formato raro
SELECT *
FROM d_pais
WHERE desc_pais != TRIM(desc_pais);

-- Categorías vacías o raras
SELECT *
FROM d_categoria
WHERE desc_categoria IS NULL
   OR desc_categoria = '';


/* =========================================
   6. CHECKS DE NEGOCIO
   ========================================= */

-- Ventas extremadamente altas (outliers básicos)
SELECT *
FROM h_ventas
WHERE ventas > 1000000;

-- Combinaciones sin sentido (ejemplo: sin ventas en fechas existentes)
SELECT df.anyo, df.mes, COUNT(hv.ventas) AS total_ventas
FROM d_fecha df
LEFT JOIN h_ventas hv ON df.id_fecha = hv.id_fecha
GROUP BY df.anyo, df.mes
HAVING COUNT(hv.ventas) = 0
ORDER BY df.anyo, df.mes;


/* =========================================
   7. TABLA EDIT (problemas intencionados)
   ========================================= */

-- Descuentos mal formateados
SELECT *
FROM h_ventas_edit
WHERE descuento NOT LIKE '%\%%';

-- Ventas como texto raro en descuento
SELECT *
FROM h_ventas_edit
WHERE descuento ~ '[^0-9%]';  -- regex postgres


/* =========================================
   8. RESUMEN RÁPIDO
   ========================================= */

SELECT 
    COUNT(*) AS total_filas,
    SUM(CASE WHEN ventas <= 0 THEN 1 ELSE 0 END) AS ventas_invalidas
FROM h_ventas;