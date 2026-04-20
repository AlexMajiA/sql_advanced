# SQL Avanzado – Proyecto de Práctica

Proyecto personal enfocado en el desarrollo y validación de consultas SQL avanzadas utilizando PostgreSQL.

El objetivo es simular un entorno real de trabajo donde no solo se consulta información, sino que también se valida su calidad y consistencia antes del análisis.

---

## 🗂 Estructura del Proyecto

### 01_schema  
Definición del modelo de datos (enfoque tipo estrella):
- Tablas de dimensiones (`d_*`)
- Tabla de hechos (`h_ventas`)
- Definición de claves primarias y relaciones

---

### 02_data  
Carga de datos para pruebas:
- Inserción de dimensiones
- Inserción de tabla de hechos
- Inclusión de datos inconsistentes de forma intencionada (para testing de calidad)

---

### 03_data_quality  
Validación de calidad de datos:

- Detección de integridad referencial (aunque no existan constraints activos)
- Identificación de valores NULL no esperados
- Búsqueda de duplicados en la tabla de hechos
- Validación de rangos y valores inválidos (ventas negativas, fechas incoherentes)
- Control de formatos en dimensiones
- Análisis de coherencia temporal (fechas sin actividad)
- Validación de campos mal formateados en `h_ventas_edit` (simulación de datos sucios)

Este módulo simula tareas reales de un Data Engineer antes de exponer datos para análisis.

---

### 04_queries  
Ejercicios técnicos avanzados:

- JOINs complejos entre fact y dimensiones  
- Uso de CTE (Common Table Expressions)  
- Window functions  
- Rankings y particiones  
- Agregaciones avanzadas  
- Subqueries  

---

### 05_analisis  
Consultas orientadas a negocio:

- Evolución de ventas por mes y año  
- Comparativas entre países  
- Análisis por categoría  
- Identificación de tendencias  
- Métricas agregadas para reporting  

---

## 🎯 Objetivo del Proyecto

Desarrollar habilidades prácticas en:

- Modelado relacional (modelo estrella)
- Validación de calidad de datos
- Escritura de SQL avanzado
- Uso de funciones analíticas
- Interpretación de datos para negocio

---

## 🧠 Enfoque

Este proyecto no se centra solo en “consultar datos”, sino en trabajar como en un entorno real:

1. Construcción del modelo  
2. Carga de datos (incluyendo errores)  
3. Validación de calidad  
4. Análisis  

---

## 🛠 Stack

- PostgreSQL  
- VS Code  
- SQLTools  
- Git / GitHub  

---

## 📌 Notas

- La tabla `h_ventas_edit` contiene datos intencionadamente incorrectos para pruebas de calidad.  
- Algunas validaciones se realizan mediante consultas y no mediante constraints para simular entornos reales donde los datos no siempre están controlados desde origen.  

---

Proyecto desarrollado como práctica estructurada para portfolio técnico en Data Engineering.