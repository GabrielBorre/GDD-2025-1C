USE GD1C2025;
GO

------Primero dropeamos los procedures si ya existen-----
DROP PROCEDURE IF EXISTS QUERYOSOS.BI_MigrarTiempo
GO
------luego dropeamos las funciones si ya existen-----
DROP FUNCTION IF EXISTS QUERYOSOS.CUATRIMESTRE
DROP FUNCTION IF EXISTS QUERYOSOS.RANGO_EDAD
DROP FUNCTION IF EXISTS QUERYOSOS.RANGO_EDAD_STRING
GO
------------------------------------------------------------------------------------------------
----- DROPEO DE TABLAS (respetar orden establecido) -----
------------------------------------------------------------------------------------------------
/*
IF OBJECT_ID('QUERYOSOS.BI_Pedido', 'U') IS NOT NULL DROP TABLE QUERYOSOS.BI_Pedido;
IF OBJECT_ID('QUERYOSOS.BI_Facturacion', 'U') IS NOT NULL DROP TABLE QUERYOSOS.BI_Facturacion;
IF OBJECT_ID('QUERYOSOS.BI_Cliente','U') IS NOT NULL DROP TABLE QUERYOSOS.BI_Cliente;
IF OBJECT_ID('QUERYOSOS.BI_Fabricacion', 'U') IS NOT NULL DROP TABLE QUERYOSOS.BI_Fabricacion;
IF OBJECT_ID('QUERYOSOS.BI_Tiempo', 'U') IS NOT NULL DROP TABLE QUERYOSOS.BI_Tiempo;
IF OBJECT_ID('QUERYOSOS.BI_Ubicacion', 'U') IS NOT NULL DROP TABLE QUERYOSOS.BI_Ubicacion;
IF OBJECT_ID('QUERYOSOS.BI_RangoEtario', 'U') IS NOT NULL DROP TABLE QUERYOSOS.BI_RangoEtario;
IF OBJECT_ID('QUERYOSOS.BI_Turno', 'U') IS NOT NULL DROP TABLE QUERYOSOS.BI_Turno;
IF OBJECT_ID('QUERYOSOS.BI_Material', 'U') IS NOT NULL DROP TABLE QUERYOSOS.BI_Material;
IF OBJECT_ID('QUERYOSOS.BI_ModeloSillon', 'U') IS NOT NULL DROP TABLE QUERYOSOS.BI_ModeloSillon;
IF OBJECT_ID('QUERYOSOS.BI_EstadoPedido', 'U') IS NOT NULL DROP TABLE QUERYOSOS.BI_EstadoPedido;
IF OBJECT_ID('QUERYOSOS.BI_Envio', 'U') IS NOT NULL DROP TABLE QUERYOSOS.BI_Envio;
IF OBJECT_ID('QUERYOSOS.BI_Compra', 'U') IS NOT NULL DROP TABLE QUERYOSOS.BI_Compra;
IF OBJECT_ID('QUERYOSOS.BI_CompraMaterial', 'U') IS NOT NULL DROP TABLE QUERYOSOS.BI_CompraMaterial;
IF OBJECT_ID('QUERYOSOS.BI_Ganancia', 'U') IS NOT NULL DROP TABLE QUERYOSOS.BI_Ganancia;
IF OBJECT_ID('QUERYOSOS.BI_MotivoCancelacion','U') IS NOT NULL DROP TABLE QUERYOSOS.BI_MotivoCancelacion;
IF OBJECT_ID('QUERYOSOS.BI_Sucursal','U') IS NOT NULL DROP TABLE QUERYOSOS.BI_Sucursal;

*/
-- 1) Tablas de hechos (más dependientes)
IF OBJECT_ID('QUERYOSOS.BI_Fabricacion',       'U') IS NOT NULL DROP TABLE QUERYOSOS.BI_Fabricacion;
IF OBJECT_ID('QUERYOSOS.BI_Envio',             'U') IS NOT NULL DROP TABLE QUERYOSOS.BI_Envio;
IF OBJECT_ID('QUERYOSOS.BI_CompraMaterial',    'U') IS NOT NULL DROP TABLE QUERYOSOS.BI_CompraMaterial;
IF OBJECT_ID('QUERYOSOS.BI_Pedido',            'U') IS NOT NULL DROP TABLE QUERYOSOS.BI_Pedido;
IF OBJECT_ID('QUERYOSOS.BI_Compra',            'U') IS NOT NULL DROP TABLE QUERYOSOS.BI_Compra;
IF OBJECT_ID('QUERYOSOS.BI_Facturacion',       'U') IS NOT NULL DROP TABLE QUERYOSOS.BI_Facturacion;
IF OBJECT_ID('QUERYOSOS.BI_Ganancia',          'U') IS NOT NULL DROP TABLE QUERYOSOS.BI_Ganancia;

-- 2) Tablas de dimensión (menos dependientes)
IF OBJECT_ID('QUERYOSOS.BI_Cliente',           'U') IS NOT NULL DROP TABLE QUERYOSOS.BI_Cliente;
IF OBJECT_ID('QUERYOSOS.BI_Sucursal',          'U') IS NOT NULL DROP TABLE QUERYOSOS.BI_Sucursal;
IF OBJECT_ID('QUERYOSOS.BI_ModeloSillon',      'U') IS NOT NULL DROP TABLE QUERYOSOS.BI_ModeloSillon;
IF OBJECT_ID('QUERYOSOS.BI_Material',          'U') IS NOT NULL DROP TABLE QUERYOSOS.BI_Material;
IF OBJECT_ID('QUERYOSOS.BI_Turno',             'U') IS NOT NULL DROP TABLE QUERYOSOS.BI_Turno;
IF OBJECT_ID('QUERYOSOS.BI_RangoEtario',       'U') IS NOT NULL DROP TABLE QUERYOSOS.BI_RangoEtario;
IF OBJECT_ID('QUERYOSOS.BI_MotivoCancelacion', 'U') IS NOT NULL DROP TABLE QUERYOSOS.BI_MotivoCancelacion;
IF OBJECT_ID('QUERYOSOS.BI_EstadoPedido',      'U') IS NOT NULL DROP TABLE QUERYOSOS.BI_EstadoPedido;
IF OBJECT_ID('QUERYOSOS.BI_Ubicacion',         'U') IS NOT NULL DROP TABLE QUERYOSOS.BI_Ubicacion;
IF OBJECT_ID('QUERYOSOS.BI_Tiempo',            'U') IS NOT NULL DROP TABLE QUERYOSOS.BI_Tiempo;
GO



----------------------------------
---- CREACION DE TABLAS Y PKs ----
----------------------------------
CREATE TABLE QUERYOSOS.BI_Cliente (
  idCliente      INTEGER    PRIMARY KEY,     
  idUbicacion    INTEGER,                    
  idRangoEtario  INTEGER                     
);
GO

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
  idRango       INTEGER NOT NULL IDENTITY(1,1) PRIMARY KEY,
  desdeEdad		INTEGER,
  hastaEdad		INTEGER,
  descripcion   VARCHAR(50)
);
GO

CREATE TABLE QUERYOSOS.BI_Turno (
  idTurno       INTEGER NOT NULL IDENTITY(1,1) PRIMARY KEY,
  descripcion   VARCHAR(50)
);
GO

CREATE TABLE QUERYOSOS.BI_Material (
  idMaterial  INTEGER NOT NULL IDENTITY(1,1) PRIMARY KEY,
  tipo          VARCHAR(50)
);
GO

CREATE TABLE QUERYOSOS.BI_ModeloSillon (
  idModeloB           INTEGER NOT NULL IDENTITY(1,1)  PRIMARY KEY,
  sillon_modelo_codigo  BIGINT
);
GO

CREATE TABLE QUERYOSOS.BI_EstadoPedido (
  idEstado    INTEGER NOT NULL PRIMARY KEY,
  estado        VARCHAR(50)
);
GO

CREATE TABLE QUERYOSOS.BI_MotivoCancelacion (
  idMotivoCancelacion INTEGER PRIMARY KEY,
  nombre              NVARCHAR(255)
);
GO

CREATE TABLE QUERYOSOS.BI_Sucursal(
	idSucursal	INTEGER IDENTITY(1,1) PRIMARY KEY,
	numeroSucursal	BIGINT,
	idUbicacion INTEGER
);
GO
-----------------------------------------------
-------- CREACION DE TABLAS DE HECHOS ---------
-----------------------------------------------

CREATE TABLE QUERYOSOS.BI_Pedido(
	idPedido			INTEGER NOT NULL IDENTITY(1,1) PRIMARY KEY,
	nroPedido			DECIMAL(18, 0),
	fechaYhora			DATETIME,
	precioTotal			DECIMAL(18,2),
	idCliente			INTEGER,
	idEstadoActual		INTEGER,
	idSucursal			INTEGER,
	fechaCancelacion	DATETIME,
	idMotivoCancelacion	INTEGER,
	cantidadPedidos		INTEGER,
	idTiempo			INTEGER,
	idTurno				INTEGER
);
GO

CREATE TABLE QUERYOSOS.BI_Facturacion(
	idFacturacion    BIGINT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	idRangoEtario    INTEGER,
	idSucursal       INTEGER,
	fechaYHora       DATETIME,
	importeTotal     DECIMAL(18,2),
	promedioMensual  DECIMAL(18,2),
	idTiempo         INTEGER,
	modelo_sillon    VARCHAR(100),
);
GO

CREATE TABLE QUERYOSOS.BI_Envio (
	idEnvio            DECIMAL(18,0) NOT NULL PRIMARY KEY,
	idFacturacion		BIGINT,
	fechaProgramada		DATETIME,
	fechaHoraEntrega	DATETIME,
	envioTotal			DECIMAL(18,2),
	idTiempo			INTEGER,
	idUbicacion			INTEGER,
	localidadMayorEnvio INTEGER,
  );
GO

CREATE TABLE QUERYOSOS.BI_Compra (
	idCompra           INTEGER IDENTITY(1,1) PRIMARY KEY,
	idTiempo           INTEGER,
	importePromedio    DECIMAL(12,2),
	idMaterial	       INTEGER
);
GO

CREATE TABLE QUERYOSOS.BI_CompraMaterial (
  idMaterial	INTEGER,
  idCompra      INTEGER,
  idSucursal    INTEGER,
  idTiempo      INTEGER,
  PRIMARY KEY (idMaterial, idCompra, idSucursal, idTiempo)
);
GO

CREATE TABLE QUERYOSOS.BI_Fabricacion (
  idFabricacion     INTEGER IDENTITY(1,1) PRIMARY KEY,
  idTiempo          INTEGER,
  idPedido          INTEGER,
  idFacturacion     BIGINT,
  tiempoPromedio    INTEGER
);
GO

CREATE TABLE QUERYOSOS.BI_Ganancia (
  idGanancia        INTEGER IDENTITY(1,1) PRIMARY KEY,
  idTiempo          INTEGER,
  totalIngresos     DECIMAL(12,2),
  idSucursal        INTEGER
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
FOREIGN KEY (idEstado) REFERENCES QUERYOSOS.Estado(idEstado);

ALTER TABLE QUERYOSOS.BI_Cliente
ADD CONSTRAINT FK_Cliente_Ubicacion
FOREIGN KEY (idUbicacion) REFERENCES QUERYOSOS.BI_Ubicacion(idUbicacion);

ALTER TABLE QUERYOSOS.BI_Cliente
ADD CONSTRAINT FK_Cliente_RangoEtario
FOREIGN KEY (idRangoEtario) REFERENCES QUERYOSOS.BI_RangoEtario(idRango);
GO

ALTER TABLE QUERYOSOS.BI_SUCURSAL
ADD CONSTRAINT FK_Sucursal_Ubicacion 
FOREIGN KEY (idUbicacion) REFERENCES QUERYOSOS.BI_Ubicacion(idUbicacion);
GO

--------------------------------------------------------
-------- Rango Etario ----------------------------------
--------------------------------------------------------

UPDATE QUERYOSOS.BI_RangoEtario
SET desdeEdad =   0, hastaEdad =  24
WHERE idRango = 1;

UPDATE QUERYOSOS.BI_RangoEtario
SET desdeEdad =  25, hastaEdad =  35
WHERE idRango = 2;

UPDATE QUERYOSOS.BI_RangoEtario
SET desdeEdad =  36, hastaEdad =  50
WHERE idRango = 3;

UPDATE QUERYOSOS.BI_RangoEtario
SET desdeEdad =  51, hastaEdad = 999
WHERE idRango = 4;
GO

--------------------------------------------------------
-------- CREACION DE FKs para tablas de hechos ---------
--------------------------------------------------------

-- BI_Pedido
ALTER TABLE QUERYOSOS.BI_Pedido
  ADD CONSTRAINT FK_estadoActual		FOREIGN KEY (idEstadoActual)
    REFERENCES QUERYOSOS.BI_EstadoPedido(idEstado);
ALTER TABLE QUERYOSOS.BI_Pedido
  ADD CONSTRAINT FK_idBISucursal		FOREIGN KEY (idSucursal)
    REFERENCES QUERYOSOS.BI_Sucursal(idSucursal);
ALTER TABLE QUERYOSOS.BI_Pedido
  ADD CONSTRAINT FK_Pedido_Tiempo		FOREIGN KEY (idTiempo)
    REFERENCES QUERYOSOS.BI_Tiempo(idTiempo);
ALTER TABLE QUERYOSOS.BI_Pedido
  ADD CONSTRAINT FK_Pedido_Turno		FOREIGN KEY (idTurno)
    REFERENCES QUERYOSOS.BI_Turno(idTurno);
ALTER TABLE QUERYOSOS.BI_Pedido
  ADD CONSTRAINT FK_Pedido_idCliente	FOREIGN KEY (idCliente)
    REFERENCES QUERYOSOS.BI_Cliente(idCliente);
--desnormalizo hecho
ALTER TABLE QUERYOSOS.BI_Pedido
  ADD CONSTRAINT FK_Pedido_id_motivo_cancelacion	FOREIGN KEY (idMotivoCancelacion)
    REFERENCES QUERYOSOS.BI_MotivoCancelacion(idMotivoCancelacion);

-- BI_Facturacion
ALTER TABLE QUERYOSOS.BI_Facturacion
  ADD CONSTRAINT FK_Facturacion_Rango     FOREIGN KEY (idRangoEtario)
    REFERENCES QUERYOSOS.BI_RangoEtario(idRango);
ALTER TABLE QUERYOSOS.BI_Facturacion
  ADD CONSTRAINT FK_Facturacion_Sucursal  FOREIGN KEY (idSucursal)
    REFERENCES QUERYOSOS.BI_Sucursal(idSucursal);
ALTER TABLE QUERYOSOS.BI_Facturacion
  ADD CONSTRAINT FK_Facturacion_Tiempo    FOREIGN KEY (idTiempo)
    REFERENCES QUERYOSOS.BI_Tiempo(idTiempo);

-- BI_Envio
ALTER TABLE QUERYOSOS.BI_Envio
  ADD CONSTRAINT FK_Envio_Facturacion  FOREIGN KEY (idFacturacion)
    REFERENCES QUERYOSOS.BI_Facturacion(idFacturacion);
ALTER TABLE QUERYOSOS.BI_Envio
  ADD CONSTRAINT FK_Envio_Tiempo        FOREIGN KEY (idTiempo)
    REFERENCES QUERYOSOS.BI_Tiempo(idTiempo);
ALTER TABLE QUERYOSOS.BI_Envio
  ADD CONSTRAINT FK_Envio_Ubicacion     FOREIGN KEY (idUbicacion)
    REFERENCES QUERYOSOS.BI_Ubicacion(idUbicacion);

-- BI_Compra
ALTER TABLE QUERYOSOS.BI_Compra
  ADD CONSTRAINT FK_Compra_Tiempo       FOREIGN KEY (idTiempo)
    REFERENCES QUERYOSOS.BI_Tiempo(idTiempo);
ALTER TABLE QUERYOSOS.BI_Compra
  ADD CONSTRAINT FK_Compra_Material     FOREIGN KEY (idMaterial)
    REFERENCES QUERYOSOS.BI_Material(idMaterial);

-- BI_Compra_Material
ALTER TABLE QUERYOSOS.BI_CompraMaterial
  ADD CONSTRAINT FK_Cm_Material         FOREIGN KEY (idMaterial)
    REFERENCES QUERYOSOS.BI_Material(idMaterial);
ALTER TABLE QUERYOSOS.BI_CompraMaterial
  ADD CONSTRAINT FK_Cm_Compra           FOREIGN KEY (idCompra)
    REFERENCES QUERYOSOS.BI_Compra(idCompra);
ALTER TABLE QUERYOSOS.BI_CompraMaterial
  ADD CONSTRAINT FK_Cm_Sucursal         FOREIGN KEY (idSucursal)
    REFERENCES QUERYOSOS.BI_Sucursal(idSucursal);
ALTER TABLE QUERYOSOS.BI_CompraMaterial
  ADD CONSTRAINT FK_Cm_Tiempo           FOREIGN KEY (idTiempo)
    REFERENCES QUERYOSOS.BI_Tiempo(idTiempo);

-- BI_Fabricacion
ALTER TABLE QUERYOSOS.BI_Fabricacion
  ADD CONSTRAINT FK_Fab_Tiempo          FOREIGN KEY (idTiempo)
    REFERENCES QUERYOSOS.BI_Tiempo(idTiempo);
ALTER TABLE QUERYOSOS.BI_Fabricacion
  ADD CONSTRAINT FK_Fab_Pedido          FOREIGN KEY (idPedido)
    REFERENCES QUERYOSOS.BI_Pedido(idPedido);
ALTER TABLE QUERYOSOS.BI_Fabricacion
  ADD CONSTRAINT FK_Fab_Facturacion     FOREIGN KEY (idFacturacion)
    REFERENCES QUERYOSOS.BI_Facturacion(idFacturacion);

-- BI_Ganancia
ALTER TABLE QUERYOSOS.BI_Ganancia
  ADD CONSTRAINT FK_Gan_Tiempo          FOREIGN KEY (idTiempo)
    REFERENCES QUERYOSOS.BI_Tiempo(idTiempo);
ALTER TABLE QUERYOSOS.BI_Ganancia
  ADD CONSTRAINT FK_Gan_Sucursal        FOREIGN KEY (idSucursal)
    REFERENCES QUERYOSOS.BI_Sucursal(idSucursal);
GO

-----------------------------
--------- FUNCIONES ---------
-----------------------------
GO
CREATE FUNCTION QUERYOSOS.CUATRIMESTRE(@Fecha DATETIME)
RETURNS INT
AS
BEGIN
    DECLARE @Cuatrimestre INT;

    SET @Cuatrimestre = 
        CASE
            WHEN MONTH(@Fecha) BETWEEN 1 AND 4 THEN 1
            WHEN MONTH(@Fecha) BETWEEN 5 AND 8 THEN 2
            WHEN MONTH(@Fecha) BETWEEN 9 AND 12 THEN 3
            ELSE NULL
        END;

    RETURN @Cuatrimestre;
END
GO

GO
CREATE FUNCTION QUERYOSOS.RANGO_EDAD(@Edad INT)
RETURNS INT
AS
BEGIN
    DECLARE @Rango INT;

    SELECT @Rango = idRango
      FROM QUERYOSOS.BI_RangoEtario
     WHERE @Edad BETWEEN desdeEdad AND hastaEdad;

    RETURN @Rango;
END
GO

CREATE FUNCTION QUERYOSOS.RANGO_EDAD_STRING(@Edad INT)
RETURNS VARCHAR(255)
AS
BEGIN
    DECLARE @Rango VARCHAR(255);

    SET @Rango = 
        CASE
            WHEN @Edad < 25 THEN 'Menor a 25'
            WHEN @Edad BETWEEN 25 AND 35 THEN 'Entre 25 y 35'
            WHEN @Edad BETWEEN 35 AND 50 THEN 'Entre 35 y 50'
            WHEN @Edad > 50 THEN 'Mayor a 50'
        END;

    RETURN @Rango;
END
GO



-------------------------------------
-------- MIGRACION DE DATOS ---------
-------------------------------------
GO 
CREATE PROCEDURE QUERYOSOS.BI_MigrarTiempo AS
BEGIN 
	INSERT INTO QUERYOSOS.BI_Tiempo(anio, mes, cuatrimestre)
	SELECT DISTINCT 
		YEAR(fechaYHora) as anio,
		MONTH(fechaYHora) as mes,
		QUERYOSOS.CUATRIMESTRE(fechaYHora) as cuatrimestre
		FROM QUERYOSOS.Factura
		WHERE fechaYHora IS NOT NULL AND NOT EXISTS(
		SELECT 1 
		FROM QUERYOSOS.BI_Tiempo
		WHERE anio = YEAR(fechaYHora) AND mes = MONTH(fechaYHora) AND cuatrimestre = QUERYOSOS.CUATRIMESTRE(fechaYHora));
END
GO


GO

/*
CREATE PROCEDURE QUERYOSOS.BI_MigrarModeloSillon

CREATE PROCEDURE QUERYOSOS.BI_MigrarEstadoPedido

CREATE PROCEDURE QUERYOSOS.BI_MigrarMaterial

CREATE PROCEDURE QUERYOSOS.BI_MigrarEnvio

CREATE PROCEDURE QUERYOSOS.BI_MigrarCompra


CREATE PROCEDURE QUERYOSOS.BI_MigrarPedido

*/



-------------------------------------
------- CREACION DE VISTAS ----------
-------------------------------------

-----------------------------------------
-----------------------------------------
------EJECUTAMOS LOS PROCEDURES PARA HACER
-------EFECTIVAS LAS MIGRACIONES (RESPETAR ORDEN)---------
-----------------------------------------
------------------------------------

EXEC QUERYOSOS.BI_MigrarTiempo

SELECT * FROM QUERYOSOS.BI_Tiempo ORDER BY anio, mes;

-------------------------------------
--------------- TESTS ---------------
-------------------------------------












