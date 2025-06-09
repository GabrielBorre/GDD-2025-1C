USE GD1C2025;
GO

------Primero dropeamos los procedures si ya existen-----
DROP PROCEDURE IF EXISTS QUERYOSOS.BI_MigrarTiempo
DROP PROCEDURE IF EXISTS QUERYOSOS.BI_MigrarRangoEtario
DROP PROCEDURE IF EXISTS QUERYOSOS.BI_MigrarUbicaciones
DROP PROCEDURE IF EXISTS QUERYOSOS.BI_MigrarSucursales
DROP PROCEDURE IF EXISTS QUERYOSOS.BI_MigrarMaterial
DROP PROCEDURE IF EXISTS QUERYOSOS.BI_MigrarEstadoPedido
DROP PROCEDURE IF EXISTS QUERYOSOS.BI_MigrarTurnos
DROP PROCEDURE IF EXISTS QUERYOSOS.BI_MigrarFacturacion

GO
------luego dropeamos las funciones si ya existen-----
DROP FUNCTION IF EXISTS QUERYOSOS.CUATRIMESTRE
DROP FUNCTION IF EXISTS QUERYOSOS.RANGO_EDAD
DROP FUNCTION IF EXISTS QUERYOSOS.RANGO_EDAD_STRING
GO
------------------------------------------------------------------------------------------------
----- DROPEO DE TABLAS (respetar orden establecido) -----
------------------------------------------------------------------------------------------------

-- tablas de hechos 
IF OBJECT_ID('QUERYOSOS.BI_Fabricacion','U')       IS NOT NULL DROP TABLE QUERYOSOS.BI_Fabricacion;
IF OBJECT_ID('QUERYOSOS.BI_Envio','U')             IS NOT NULL DROP TABLE QUERYOSOS.BI_Envio;
IF OBJECT_ID('QUERYOSOS.BI_Compra','U')            IS NOT NULL DROP TABLE QUERYOSOS.BI_Compra;
IF OBJECT_ID('QUERYOSOS.BI_Pedido','U')            IS NOT NULL DROP TABLE QUERYOSOS.BI_Pedido;
IF OBJECT_ID('QUERYOSOS.BI_Facturacion','U')       IS NOT NULL DROP TABLE QUERYOSOS.BI_Facturacion;
IF OBJECT_ID('QUERYOSOS.BI_Ganancia','U')          IS NOT NULL DROP TABLE QUERYOSOS.BI_Ganancia;


-- tablas otras
IF OBJECT_ID('QUERYOSOS.BI_Sucursal','U')          IS NOT NULL DROP TABLE QUERYOSOS.BI_Sucursal;
IF OBJECT_ID('QUERYOSOS.BI_Modelo','U')           IS NOT NULL DROP TABLE QUERYOSOS.BI_Modelo;
IF OBJECT_ID('QUERYOSOS.BI_Turno','U')             IS NOT NULL DROP TABLE QUERYOSOS.BI_Turno;
IF OBJECT_ID('QUERYOSOS.BI_Material','U')          IS NOT NULL DROP TABLE QUERYOSOS.BI_Material;
IF OBJECT_ID('QUERYOSOS.BI_RangoEtario','U')       IS NOT NULL DROP TABLE QUERYOSOS.BI_RangoEtario;
IF OBJECT_ID('QUERYOSOS.BI_EstadoPedido','U')      IS NOT NULL DROP TABLE QUERYOSOS.BI_EstadoPedido;
IF OBJECT_ID('QUERYOSOS.BI_Ubicacion','U')         IS NOT NULL DROP TABLE QUERYOSOS.BI_Ubicacion;
IF OBJECT_ID('QUERYOSOS.BI_Tiempo','U')            IS NOT NULL DROP TABLE QUERYOSOS.BI_Tiempo;
GO



----------------------------------
---- CREACION DE TABLAS Y PKs ----
----------------------------------
CREATE TABLE QUERYOSOS.BI_Tiempo (
  idTiempo      INTEGER IDENTITY(1,1) PRIMARY KEY,
  anio          INTEGER,
  cuatrimestre  VARCHAR(255),
  mes           INTEGER
);
GO

CREATE TABLE QUERYOSOS.BI_Ubicacion (
  idUbicacion   INTEGER IDENTITY(1,1) PRIMARY KEY,
  provincia	VARCHAR(255),
  localidad	VARCHAR(255),
  direccion	VARCHAR(255)
);
GO

CREATE TABLE QUERYOSOS.BI_RangoEtario (
  idRangoEtario 	INTEGER IDENTITY(1,1) PRIMARY KEY,
  desdeEdad		INTEGER,
  hastaEdad		INTEGER,
);
GO

CREATE TABLE QUERYOSOS.BI_Turno (
  idTurno       INTEGER IDENTITY(1,1) PRIMARY KEY,
  descripcion   VARCHAR(50)
);
GO

CREATE TABLE QUERYOSOS.BI_Material (
  idMaterial  INTEGER IDENTITY(1,1) PRIMARY KEY,
  tipo        NVARCHAR(255)
);
GO

CREATE TABLE QUERYOSOS.BI_Modelo (
   idModelo	  BIGINT IDENTITY(1,1)  PRIMARY KEY,
   cantidadVentas DECIMAL(18,0),
   descripcion	  NVARCHAR(255),
);
GO

CREATE TABLE QUERYOSOS.BI_EstadoPedido (
  idEstadoBI    INTEGER IDENTITY(1,1) PRIMARY KEY,
  estado        VARCHAR(50)
);
GO

CREATE TABLE QUERYOSOS.BI_Sucursal(
	idSucursal	INTEGER IDENTITY(1,1) PRIMARY KEY,
	numeroSucursal	BIGINT,
	direccion	VARCHAR(255)
);
GO
-----------------------------------------------
-------- CREACION DE TABLAS DE HECHOS ---------
-----------------------------------------------

CREATE TABLE QUERYOSOS.BI_Pedido(
	idPedido			INTEGER IDENTITY(1,1),
	idSucursal			INTEGER NOT NULL,
	idTiempo			INTEGER NOT NULL,
	idTurno				INTEGER NOT NULL,
	idUbicacion			INTEGER NOT NULL,
	idEstadoBI			INTEGER NOT NULL,
	fechaYhora			DATETIME2,
	precioTotal			DECIMAL(18,2),
	estadoActual		INTEGER,
	fechaCancelacion	DATETIME2,
	motivoCancelacion	INTEGER,
	cantidadPedidos		INTEGER,
	
	PRIMARY KEY (idPedido, idSucursal, idTiempo, idTurno, idUbicacion, idEstadoBI)
);
GO

CREATE TABLE QUERYOSOS.BI_Facturacion(
	idPedido		 BIGINT IDENTITY(1,1),
	idRangoEtario    INTEGER NOT NULL,
	idSucursal       INTEGER NOT NULL,
	idTiempo         INTEGER NOT NULL,
	idModelo         BIGINT NOT NULL,
	idUbicacion		 INTEGER NOT NULL,
	fechaYHora       DATETIME2,
	importeTotal     DECIMAL(38,2),
	promedioMensual  DECIMAL(18,2),

	PRIMARY KEY (idPedido, idRangoEtario, idSucursal, idTiempo, idModelo, idUbicacion)
);
GO

CREATE TABLE QUERYOSOS.BI_Envio (
	idPedido              DECIMAL(18,0),
	idTiempo			  INTEGER NOT NULL,
	idUbicacion			  INTEGER NOT NULL,
	fechaProgramada	      DATETIME2,
	fechaHoraEntrega      DATETIME2,
	envioTotal			  DECIMAL(18,2),
	localidadMayorEnvio   INTEGER,

	PRIMARY KEY (idPedido, idTiempo, idUbicacion)
  );
GO

CREATE TABLE QUERYOSOS.BI_Compra (
	idPedido        INTEGER IDENTITY(1,1),
	idTiempo        INTEGER NOT NULL,
	idMaterial	INTEGER NOT NULL,
	idSucursal      INTEGER NOT NULL,
	importePromedio DECIMAL(12,2),

	PRIMARY KEY (idPedido, idTiempo, idMaterial, idSucursal)
);
GO

CREATE TABLE QUERYOSOS.BI_Fabricacion (
  idPedido       INTEGER IDENTITY(1,1),
  idTiempo       INTEGER NOT NULL,
  tiempoPromedio INTEGER

  PRIMARY KEY (idPedido, idTiempo)

);
GO

CREATE TABLE QUERYOSOS.BI_Ganancia (
  idGanancia        INTEGER IDENTITY(1,1),
  idTiempo          INTEGER NOT NULL,
  idSucursal	    INTEGER NOT NULL,
  idUbicacion	    INTEGER NOT NULL,
  totalIngresos     DECIMAL(12,2),
  totalEgresos      DECIMAL(12,2),
  gananciaTotal     DECIMAL(12,2),

   PRIMARY KEY (idGanancia, idTiempo, idSucursal, idUbicacion)
);
GO

--------------------------------------------------------
-------- Rango Etario ----------------------------------
--------------------------------------------------------

UPDATE QUERYOSOS.BI_RangoEtario
SET desdeEdad =   0, hastaEdad =  24
WHERE idRangoEtario = 1;

UPDATE QUERYOSOS.BI_RangoEtario
SET desdeEdad =  25, hastaEdad =  35
WHERE idRangoEtario = 2;

UPDATE QUERYOSOS.BI_RangoEtario
SET desdeEdad =  36, hastaEdad =  50
WHERE idRangoEtario = 3;

UPDATE QUERYOSOS.BI_RangoEtario
SET desdeEdad =  51, hastaEdad = 500
WHERE idRangoEtario = 4;
GO

--------------------------------------------------------
-------- CREACION DE FKs para tablas de hechos ---------
--------------------------------------------------------

-- BI_Pedido
ALTER TABLE QUERYOSOS.BI_Pedido
ADD CONSTRAINT FK_idBISucursal		
FOREIGN KEY (idSucursal) REFERENCES QUERYOSOS.BI_Sucursal(idSucursal);

ALTER TABLE QUERYOSOS.BI_Pedido
ADD CONSTRAINT FK_Pedido_Tiempo		
FOREIGN KEY (idTiempo) REFERENCES QUERYOSOS.BI_Tiempo(idTiempo);

ALTER TABLE QUERYOSOS.BI_Pedido
ADD CONSTRAINT FK_Pedido_Turno		
FOREIGN KEY (idTurno) REFERENCES QUERYOSOS.BI_Turno(idTurno);

ALTER TABLE QUERYOSOS.BI_Pedido
ADD CONSTRAINT FK_Pedido_idUbicacion
FOREIGN KEY (idUbicacion) REFERENCES QUERYOSOS.BI_Ubicacion(idUbicacion);

ALTER TABLE QUERYOSOS.BI_Pedido
ADD CONSTRAINT FK_estadoActual		
FOREIGN KEY (idEstadoBI) REFERENCES QUERYOSOS.BI_EstadoPedido(idEstadoBI);


-- BI_Facturacion
ALTER TABLE QUERYOSOS.BI_Facturacion
ADD CONSTRAINT FK_Facturacion_Rango     
FOREIGN KEY (idRangoEtario) REFERENCES QUERYOSOS.BI_RangoEtario(idRangoEtario);

ALTER TABLE QUERYOSOS.BI_Facturacion
ADD CONSTRAINT FK_Facturacion_Sucursal  
FOREIGN KEY (idSucursal) REFERENCES QUERYOSOS.BI_Sucursal(idSucursal);

ALTER TABLE QUERYOSOS.BI_Facturacion
ADD CONSTRAINT FK_Facturacion_Tiempo    
FOREIGN KEY (idTiempo) REFERENCES QUERYOSOS.BI_Tiempo(idTiempo);

ALTER TABLE QUERYOSOS.BI_Facturacion
ADD CONSTRAINT FK_Facturacion_Modelo   
FOREIGN KEY (idModelo) REFERENCES QUERYOSOS.BI_Modelo(idModelo);

ALTER TABLE QUERYOSOS.BI_Facturacion
ADD CONSTRAINT FK_Facturacion_Ubicacion   
FOREIGN KEY (idUbicacion) REFERENCES QUERYOSOS.BI_Ubicacion(idUbicacion);


-- BI_Envio
ALTER TABLE QUERYOSOS.BI_Envio
ADD CONSTRAINT FK_Envio_Tiempo        
FOREIGN KEY (idTiempo) REFERENCES QUERYOSOS.BI_Tiempo(idTiempo);

ALTER TABLE QUERYOSOS.BI_Envio
ADD CONSTRAINT FK_Envio_Ubicacion     
FOREIGN KEY (idUbicacion) REFERENCES QUERYOSOS.BI_Ubicacion(idUbicacion);


-- BI_Compra
ALTER TABLE QUERYOSOS.BI_Compra
ADD CONSTRAINT FK_Compra_Tiempo       
FOREIGN KEY (idTiempo) REFERENCES QUERYOSOS.BI_Tiempo(idTiempo);

ALTER TABLE QUERYOSOS.BI_Compra
ADD CONSTRAINT FK_Compra_Material     
FOREIGN KEY (idMaterial) REFERENCES QUERYOSOS.BI_Material(idMaterial);

ALTER TABLE QUERYOSOS.BI_Compra
ADD CONSTRAINT FK_Compra_Suc     -- ya tenemos una FK llamada FK_Compra_Sucursal en el otro script en QUERYOSOS.Compra
FOREIGN KEY (idSucursal) REFERENCES QUERYOSOS.BI_Sucursal(idSucursal);


-- BI_Fabricacion
ALTER TABLE QUERYOSOS.BI_Fabricacion
ADD CONSTRAINT FK_Fab_Tiempo          
FOREIGN KEY (idTiempo) REFERENCES QUERYOSOS.BI_Tiempo(idTiempo);

-- BI_Ganancia
ALTER TABLE QUERYOSOS.BI_Ganancia
ADD CONSTRAINT FK_Gan_Tiempo          
FOREIGN KEY (idTiempo) REFERENCES QUERYOSOS.BI_Tiempo(idTiempo);

ALTER TABLE QUERYOSOS.BI_Ganancia
ADD CONSTRAINT FK_Gan_Sucursal        
FOREIGN KEY (idSucursal) REFERENCES QUERYOSOS.BI_Sucursal(idSucursal);

ALTER TABLE QUERYOSOS.BI_Ganancia
ADD CONSTRAINT FK_Gan_Ubicacion        
FOREIGN KEY (idUbicacion) REFERENCES QUERYOSOS.BI_Ubicacion(idUbicacion);

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

    SELECT @Rango = idRangoEtario
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

CREATE PROCEDURE QUERYOSOS.BI_MigrarRangoEtario AS
BEGIN 
	INSERT INTO QUERYOSOS.BI_RangoEtario(desdeEdad, hastaEdad)
    SELECT DISTINCT
        CASE 
            WHEN DATEDIFF(year, fechaNacimiento, GETDATE()) < 25 THEN 0
            WHEN DATEDIFF(year, fechaNacimiento, GETDATE()) BETWEEN 25 AND 35 THEN 25
            WHEN DATEDIFF(year, fechaNacimiento, GETDATE()) BETWEEN 35 AND 50 THEN 35
            WHEN DATEDIFF(year, fechaNacimiento, GETDATE()) > 50 THEN 50
        END,
        CASE 
            WHEN DATEDIFF(year, fechaNacimiento, GETDATE()) < 25 THEN 25
            WHEN DATEDIFF(year, fechaNacimiento, GETDATE()) BETWEEN 25 AND 35 THEN 35
            WHEN DATEDIFF(year, fechaNacimiento, GETDATE()) BETWEEN 35 AND 50 THEN 50
            WHEN DATEDIFF(year, fechaNacimiento, GETDATE()) > 50 THEN 500
        END/*, esto no iria porque no tenemos una columna "descripcion"
        CASE 
            WHEN DATEDIFF(year, fechaNacimiento, GETDATE()) < 25 THEN 'Menor a 25'
            WHEN DATEDIFF(year, fechaNacimiento, GETDATE()) BETWEEN 25 AND 35 THEN 'Entre 25 y 35'
            WHEN DATEDIFF(year, fechaNacimiento, GETDATE()) BETWEEN 35 AND 50 THEN 'Entre 35 y 50'
            WHEN DATEDIFF(year, fechaNacimiento, GETDATE()) > 50 THEN 'Mayor a 50'
        END*/
		FROM QUERYOSOS.Cliente
END
GO

CREATE PROCEDURE QUERYOSOS.BI_MigrarUbicaciones AS
BEGIN 
	INSERT INTO QUERYOSOS.BI_Ubicacion(provincia, localidad, direccion)
	SELECT DISTINCT 
		p.nombre AS provincia, 
		l.nombre AS localidad, 
		d.direccion AS direccion
	FROM QUERYOSOS.Direccion d JOIN QUERYOSOS.Localidad l on d.idLocalidad = l.idLocalidad
	JOIN QUERYOSOS.Provincia p on l.idProvincia = p.idProvincia

END
GO

CREATE PROCEDURE QUERYOSOS.BI_MigrarSucursales AS
BEGIN 
	INSERT INTO QUERYOSOS.BI_Sucursal(numeroSucursal, idUbicacion)
	SELECT DISTINCT 
		numeroSucursal, 
		u.idUbicacion
	FROM QUERYOSOS.Sucursal s JOIN QUERYOSOS.Direccion d  on s.idDireccion = d.idDireccion
	JOIN QUERYOSOS.Localidad l on d.idLocalidad = l.idLocalidad
	JOIN QUERYOSOS.Provincia p on l.idProvincia = p.idProvincia
	JOIN QUERYOSOS.BI_Ubicacion AS u
		on u.provincia = p.nombre
		AND u.localidad = l.nombre
		AND u.direccion = d.direccion;

END
GO

CREATE PROCEDURE QUERYOSOS.BI_MigrarMaterial AS
BEGIN 
	INSERT INTO QUERYOSOS.BI_Material(tipo)
	SELECT DISTINCT tipo FROM QUERYOSOS.Material;
END
GO

CREATE PROCEDURE QUERYOSOS.BI_MigrarEstadoPedido AS
BEGIN 
	INSERT INTO QUERYOSOS.BI_EstadoPedido(estado)
	SELECT DISTINCT estado FROM QUERYOSOS.Estado
END
GO

CREATE PROCEDURE QUERYOSOS.BI_MigrarTurnos AS
BEGIN 
	INSERT INTO QUERYOSOS.BI_Turno(descripcion)
	VALUES 
		('8:00 - 14:00'),
		('14:00 - 20:00')
END
GO
--esto funciona salvo modelo sillon :(
/* 
CREATE PROCEDURE QUERYOSOS.BI_MigrarFacturacion AS
BEGIN
	INSERT INTO QUERYOSOS.BI_Facturacion(idRangoEtario, idSucursal, fechaYHora, 
		importeTotal, promedioMensual, idTiempo, modelo_sillon)
	SELECT QUERYOSOS.RANGO_EDAD(DATEDIFF(YEAR,c.fechaNacimiento, f.fechaYHora)),
	f.idSucursal, 
	f.fechaYhora,
	f.importeTotal, 
	(SELECT AVG(f2.importeTotal) FROM QUERYOSOS.Factura f2 
		WHERE YEAR(f2.fechaYhora)  = YEAR(f.fechaYhora) AND MONTH(f2.fechaYhora) = MONTH(f.fechaYhora) AND f2.idSucursal = f.idSucursal),
	(SELECT t.idTiempo FROM QUERYOSOS.BI_Tiempo AS t WHERE t.anio = YEAR(f.fechaYHora) AND t.mes = MONTH(f.fechaYHora)),
	(SELECT TOP 1 m.descripcion FROM QUERYOSOS.ItemDetallePedido i JOIN QUERYOSOS.Modelo m on m.sillon_modelo_codigo = i.sillon_modelo_codigo
	WHERE i.nroFactura = f.nroFactura GROUP BY m.descripcion order by SUM(i.cantidad_pedido))
	FROM QUERYOSOS.Factura f JOIN QUERYOSOS.Cliente c on c.idCliente = f.idCliente
END
GO

SELECT * FROM QUERYOSOS.BI_Facturacion
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
EXEC QUERYOSOS.BI_MigrarRangoEtario
EXEC QUERYOSOS.BI_MigrarUbicaciones
EXEC QUERYOSOS.BI_MigrarSucursales
EXEC QUERYOSOS.BI_MigrarMaterial
EXEC QUERYOSOS.BI_MigrarEstadoPedido
EXEC QUERYOSOS.BI_MigrarTurnos
--EXEC QUERYOSOS.BI_MigrarFacturacion
GO
-------------------------------------
--------------- TESTS ---------------
-------------------------------------
--SELECT * FROM QUERYOSOS.BI_Tiempo ORDER BY anio, mes;

