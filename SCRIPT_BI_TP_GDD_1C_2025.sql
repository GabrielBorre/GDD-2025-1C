USE GD1C2025;
GO

------------------------------------------------------------------------------------------------
----- DROPEO DE TABLAS (respetar orden establecido) -----
------------------------------------------------------------------------------------------------

IF OBJECT_ID('QUERYOSOS.BI_Tiempo', 'U') IS NOT NULL DROP TABLE QUERYOSOS.BI_Tiempo;
IF OBJECT_ID('QUERYOSOS.BI_Ubicacion', 'U') IS NOT NULL DROP TABLE QUERYOSOS.BI_Ubicacion;
IF OBJECT_ID('QUERYOSOS.BI_RangoEtario', 'U') IS NOT NULL DROP TABLE QUERYOSOS.BI_RangoEtario;
IF OBJECT_ID('QUERYOSOS.BI_Turno', 'U') IS NOT NULL DROP TABLE QUERYOSOS.BI_Turno;
IF OBJECT_ID('QUERYOSOS.BI_Material', 'U') IS NOT NULL DROP TABLE QUERYOSOS.BI_Material;
IF OBJECT_ID('QUERYOSOS.BI_ModeloSillon', 'U') IS NOT NULL DROP TABLE QUERYOSOS.BI_ModeloSillon;
IF OBJECT_ID('QUERYOSOS.BI_EstadoPedido', 'U') IS NOT NULL DROP TABLE QUERYOSOS.BI_EstadoPedido;
GO

----------------------------------
---- CREACION DE TABLAS Y PKs ----
----------------------------------

CREATE TABLE QUERYOSOS.BI_Tiempo (
  idTiempo      INTEGER NOT NULL IDENTITY(1,1) PRIMARY KEY,
  anio          INTEGER,
  cuatrimestre  VARCHAR(255),
  mes           INTEGER
);
GO

CREATE TABLE QUERYOSOS.BI_Ubicacion (
  idUbicacion   INTEGER NOT NULL IDENTITY(1,1) PRIMARY KEY,
  idProvincia   INTEGER,
  idLocalidad   INTEGER
);
GO

CREATE TABLE QUERYOSOS.BI_RangoEtario (
  idRango       INTEGER NOT NULL PRIMARY KEY,
  descripcion   VARCHAR(50)
);
GO

CREATE TABLE QUERYOSOS.BI_Turno (
  idTurno       INTEGER NOT NULL PRIMARY KEY,
  descripcion   VARCHAR(50)
);
GO

CREATE TABLE QUERYOSOS.BI_Material (
  idMaterialBI  INTEGER NOT NULL PRIMARY KEY,
  tipo          VARCHAR(50)
);
GO

CREATE TABLE QUERYOSOS.BI_ModeloSillon (
  idModeloBI            INTEGER  NOT NULL PRIMARY KEY,
  sillon_modelo_codigo  INTEGER
);
GO

CREATE TABLE QUERYOSOS.BI_EstadoPedido (
  idEstadoBI    INTEGER NOT NULL PRIMARY KEY,
  estado        VARCHAR(50)
);
GO

----------------------------------
-------- CREACION DE FKs ---------
----------------------------------
-- FOREIGN KEYS para BI_Ubicacion
ALTER TABLE QUERYOSOS.BI_Ubicacion
ADD CONSTRAINT FK_BI_Ubicacion_Provincia
FOREIGN KEY (idProvincia) REFERENCES QUERYOSOS.Provincia(idProvincia);

ALTER TABLE QUERYOSOS.BI_Ubicacion
ADD CONSTRAINT FK_BI_Ubicacion_Localidad
FOREIGN KEY (idLocalidad) REFERENCES QUERYOSOS.Localidad(idLocalidad);

-- FOREIGN KEY para BI_ModeloSillon
ALTER TABLE QUERYOSOS.BI_ModeloSillon
ADD CONSTRAINT FK_BI_ModeloSillon_Modelo
FOREIGN KEY (sillon_modelo_codigo) REFERENCES QUERYOSOS.Modelo(sillon_modelo_codigo);

-- FOREIGN KEY para BI_EstadoPedido
ALTER TABLE QUERYOSOS.BI_EstadoPedido
ADD CONSTRAINT FK_BI_EstadoPedido_Estado
FOREIGN KEY (estado) REFERENCES QUERYOSOS.Estado(estado);

GO


-----------------------------
--------- FUNCIONES ---------
-----------------------------

-------------------------------------
-------- MIGRACION DE DATOS ---------
-------------------------------------


------Primero dropeamos los procedures si ya existen-----
DROP PROCEDURE IF EXISTS Migrar_Nombre





-----------------------------------------
-----------------------------------------
------EJECUTAMOS LOS PROCEDURES PARA HACER
-------EFECTIVAS LAS MIGRACIONES (RESPETAR ORDEN)---------
-----------------------------------------
------------------------------------

--EXEC Migrar_Nombre

-------------------------------------
--------------- TESTS ---------------
-------------------------------------












