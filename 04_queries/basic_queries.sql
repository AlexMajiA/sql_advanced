-- 1. Crear una tabla de forma directa. Se especifica el nombre de la tabla y el nombre, tipo y restricciones de cada una de sus columnas.
    CREATE OR REPLACE TABLE IF NOT EXISTS personas(
        id_per INT,
        nombre VARCHAR(255),
        apellido1 VARCHAR(255),
        apellido2 VARCHAR(255),
        id_dep INT,
        salario INT
        );

-- 2. Insertar 20 datos en la tabla
    INSERT INTO personas (id_per, nombre, apellido1, apellido2, id_dep, salario)
        VALUES
    (1, 'Antonio', 'Pérez', 'Gómez', 1, 30000),
    (2, 'Lucía', 'Martín', 'Sánchez', 2, 24500),
    (3, 'Pedro', 'Ruiz', 'González', 2, 26000),
    (4, 'Marta', 'López', 'Jiménez', 3, 41000),
    (5, 'Carlos', 'Fernández', 'Torres', 1, 22000),
    (6, 'Elena', 'Navarro', 'Díaz', 4, 37000),
    (7, 'David', 'Romero', 'Castro', 3, 29000),
    (8, 'Sara', 'Ortega', 'Molina', 2, 31500),
    (9, 'Javier', 'Gil', 'Morales', 1, 27000),
    (10, 'Laura', 'Serrano', 'Vega', 4, 45000),
    (11, 'Alejandro', 'Cano', 'Ruiz', 3, 33000),
    (12, 'Patricia', 'Iglesias', 'Herrera', 2, 24000),
    (13, 'Miguel', 'Reyes', 'Flores', 1, 39000),
    (14, 'Cristina', 'Medina', 'Peña', 4, 28000),
    (15, 'Raúl', 'Delgado', 'Santos', 3, 35000),
    (16, 'Natalia', 'Prieto', 'Méndez', 2, 26500),
    (17, 'Iván', 'Vargas', 'Ramos', 1, 31000),
    (18, 'Beatriz', 'Campos', 'Ortega', 4, 42000),
    (19, 'Sergio', 'León', 'Domínguez', 3, 29500),
    (20, 'Andrea', 'Fuentes', 'Nieto', 2, 27500);

    SELECT * FROM personas;

    TRUNCATE TABLE personas;

-- 3. Crear una tabla a partir de otra ya existente. Se especifica el nombre de la tabla y la query con la información especifica.
    CREATE TABLE personas2 AS
    SELECT * FROM personas;

    SELECT * FROM personas2;

-- 4. Agregar una columna nueva a una tabla ya creada.
    ALTER TABLE personas 
    ADD antiguedad_mes INT DEFAULT NULL;

-- 5. Modificar una columna de una tabla (nombre VARCHAR(50)).
    SELECT *
    FROM h_ventas;

-- 6. Eliminar una columna de una tabla (antiguedad_mes).
    ALTER TABLE personas
    DROP COLUMN antiguedad_mes;

-- 7. Devuelve las columnas especificadas en la selección de lista (nombre y apellido1).
    SELECT
        nombre,
        apellido1
    FROM
        personas;

-- 8. Devuelve las filas únicas, es decir, elimina las filas duplicadas de los resultados de la consulta (tabla personas).
    SELECT DISTINCT
        nombre,
        apellido1
    FROM
        personas;

-- 9. Devuelve las columnas especificadas en la selección de lista asignándole el nombre especificado en el alias (nombre a nombre_cliente).
    SELECT
        nombre AS nombre_cliente
    FROM
        personas;

-- 10. Devuelve el número de registros indicado (1).
    SELECT *
    FROM personas
    LIMIT 1;

-- 11. Obtener todos los empleados que pertenecen al departamento 1.
    SELECT *
    FROM personas
    WHERE
        id_dep = 1;

-- 12. Obtener los empleados cuyo id_dep sea 2 y cuyo nombre sea Antonio.
    SELECT *
    FROM personas
    WHERE
        id_dep = 2 
        AND nombre = 'Antonio';

-- 13. Obtener los empleados cuyo id_dep sea 1 o cuyo nombre sea Pedro.
    SELECT *
    FROM personas
    WHERE
        id_dep = 1 
        OR nombre = 'Pedro';

-- 14. Obtener los empleados cuyo nombre no sea Antonio.
    SELECT *
    FROM personas
    WHERE nombre <> 'Antonio'
 

-- 15. Obtener los empleados cuyo nombre empiece por la letra A.
    SELECT *
    FROM personas
    WHERE nombre LIKE 'A%'


-- 16. Obtener los empleados cuyo primer apellido tenga cuatro letras y empiece por “Ru”.
    SELECT *
    FROM personas
    WHERE 
        apellido1 LIKE 'Ru%'
    AND LENGTH(apellido1) = 4

-- 17. Obtener los empleados que pertenezcan al departamento 1 o 2.
    SELECT *
    FROM personas
    WHERE id_dep = 1 
        OR id_dep = 2

-- 18. Obtener los empleados cuyo nombre esté incluido en la tabla personas2.
    TRUNCATE TABLE personas2;

    INSERT INTO personas2 (id_per, nombre, apellido1, apellido2, id_dep, salario)
    VALUES
    (101, 'Antonio', 'Pérez', 'Gómez', 1, 30000),
    (102, 'Lucía', 'Martín', 'Sánchez', 2, 24500),
    (103, 'Pedro', 'Ruiz', 'González', 2, 26000),
    (104, 'Raquel', 'García', 'López', 1, 28000),
    (105, 'Rubén', 'Santos', 'Díaz', 3, 31000),
    (106, 'Elena', 'Navarro', 'Díaz', 4, 37000),
    (107, 'Iván', 'Moreno', 'Castro', 3, 29000),
    (108, 'Sara', 'Ortega', 'Molina', 2, 31500),
    (109, 'Noelia', 'Gil', 'Morales', 1, 27000),
    (110, 'Adrián', 'Serrano', 'Vega', 4, 45000);


    SELECT *
    FROM personas2

-- 19. Mostrar todos los registros de la tabla personas.

-- 20. Agrupar los empleados por departamento y mostrar los resultados ordenados de forma ascendente por id_dep.

-- 21. Calcular el salario medio, el salario máximo, el salario mínimo y el número total de empleados.

-- 22. Mostrar los grupos cuya suma total de saldo sea superior a 30000.

-- 23. Mostrar el nombre y apellido1 de cada empleado, indicando el nombre del departamento según su id_pep (Administración, Informática o No informado).

-- 24. Modificar el nombre del departamento con id_dep igual a 1, asignándole el valor “Comercial”.

-- 25. Unir los registros de tableA y tableB eliminando los duplicados.

-- 26. Unir los registros de tableA y tableB incluyendo los registros duplicados.

-- 27. Eliminar de la tabla personas el empleado cuyo id_per sea 1.

