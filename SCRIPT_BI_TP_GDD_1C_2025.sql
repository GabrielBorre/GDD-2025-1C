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
DROP PROCEDURE IF EXISTS QUERYOSOS.BI_MigrarModelos
DROP PROCEDURE IF EXISTS QUERYOSOS.BI_MigrarPedido
DROP PROCEDURE IF EXISTS QUERYOSOS.BI_MigrarEnvio
DROP PROCEDURE IF EXISTS QUERYOSOS.BI_MigrarCompra
GO
------luego dropeamos las funciones si ya existen-----
DROP FUNCTION IF EXISTS QUERYOSOS.CUATRIMESTRE
DROP FUNCTION IF EXISTS QUERYOSOS.RANGO_EDAD
DROP FUNCTION IF EXISTS QUERYOSOS.RANGO_EDAD_STRING
GO

------luego dropeamos las vistas si ya existen-----
DROP VIEW IF EXISTS QUERYOSOS.Ganancia_Total
DROP VIEW IF EXISTS QUERYOSOS.Punto9_PorcentajeCumplimientoEnvios
DROP VIEW IF EXISTS QUERYOSOS.Punto10_LocalidadesMayorCostoEnvio
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
  hastaEdad		INTEGER
);
GO

CREATE TABLE QUERYOSOS.BI_Turno (
  idTurno       INTEGER IDENTITY(1,1) PRIMARY KEY,
  desde TIME NOT NULL,
  hasta TIME NOT NULL

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
   descripcion	  NVARCHAR(255)
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
	nroPedido			DECIMAL(18,0)
	
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
	--fechaYHora       DATETIME2,
	nroFactura		 BIGINT,
	subtotal_item_factura  DECIMAL(18,2),

	PRIMARY KEY (idPedido, idRangoEtario, idSucursal, idTiempo, idModelo, idUbicacion)
);
GO

CREATE TABLE QUERYOSOS.BI_Envio (
	idPedido              BIGINT IDENTITY(1,1),
	idTiempo			  INTEGER NOT NULL,
	idUbicacion			  INTEGER NOT NULL,
	fechaProgramada	      DATETIME2,
	fechaHoraEntrega      DATETIME2,
	envioTotal			  DECIMAL(18,2),
	nroEnvio			  DECIMAL(18,0)
	PRIMARY KEY (idPedido, idTiempo, idUbicacion)
  );
GO

CREATE TABLE QUERYOSOS.BI_Compra (
	idPedido        INTEGER IDENTITY(1,1),
	idTiempo        INTEGER NOT NULL,
	idMaterial	    INTEGER NOT NULL,
	idSucursal      INTEGER NOT NULL,
	idUbicacion		INTEGER NOT NULL,
	importePromedio DECIMAL(12,2),
	nroCompra		DECIMAL(18,0),
	subtotal		DECIMAL(18,2)
	PRIMARY KEY (idPedido, idTiempo, idMaterial, idSucursal, idUbicacion)
);
GO

CREATE TABLE QUERYOSOS.BI_Fabricacion (
  idPedido       INTEGER IDENTITY(1,1),
  idTiempo       INTEGER NOT NULL,
  tiempoPromedio INTEGER,

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

ALTER TABLE QUERYOSOS.BI_Compra -- agrego FK a ubicacion
ADD CONSTRAINT FK_Compra_Ubicacion
FOREIGN KEY (idUbicacion) REFERENCES QUERYOSOS.BI_Ubicacion(idUbicacion);


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
        END
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
	INSERT INTO QUERYOSOS.BI_Sucursal(numeroSucursal, direccion)
	SELECT DISTINCT 
		numeroSucursal, 
		u.direccion
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

CREATE PROCEDURE QUERYOSOS.BI_MigrarTurnos
AS
BEGIN 
	INSERT INTO QUERYOSOS.BI_Turno(desde, hasta)
	VALUES 
		('08:00', '13:59'),
		('14:00', '20:00');
END
GO






CREATE PROCEDURE QUERYOSOS.BI_MigrarModelos AS 
BEGIN
	INSERT INTO QUERYOSOS.BI_Modelo(descripcion)
	SELECT descripcion FROM QUERYOSOS.Modelo
END
go


CREATE PROCEDURE QUERYOSOS.BI_MigrarFacturacion as
BEGIN
	INSERT INTO QUERYOSOS.BI_Facturacion(idRangoEtario,idSucursal,idTiempo,idUbicacion,idModelo,nroFactura,subtotal_item_factura)
	SELECT idRangoEtario,bi_suc.idSucursal,tiempo.idTiempo,bi_ubi.idUbicacion,bi_modelo.idModelo,fac.nroFactura,item_fac.detalle_factura_subtotal  FROM  QUERYOSOS.Factura fac JOIN QUERYOSOS.Cliente c on fac.idCliente=c.idCliente
	JOIN QUERYOSOS.BI_RangoEtario rango on DATEDIFF(year, c.fechaNacimiento, GETDATE()) between rango.desdeEdad and rango.hastaEdad
	JOIN QUERYOSOS.Sucursal suc on fac.idSucursal=suc.idSucursal JOIN QUERYOSOS.Direccion dire on suc.idDireccion=dire.idDireccion
	JOIN QUERYOSOS.BI_Sucursal bi_suc on dire.direccion=bi_suc.direccion JOIN QUERYOSOS.Localidad loca on dire.idLocalidad=loca.idLocalidad 
	JOIN QUERYOSOS.Provincia provincia on provincia.idProvincia=loca.idProvincia JOIN QUERYOSOS.BI_Ubicacion bi_ubi on bi_ubi.direccion=dire.direccion
	and bi_ubi.localidad=loca.nombre and bi_ubi.provincia=provincia.nombre
	JOIN QUERYOSOS.BI_Tiempo tiempo on tiempo.mes=month(fac.fechaYHora) and  tiempo.anio=year(fac.fechaYHora) JOIN QUERYOSOS.ItemDetallefactura item_fac
	on item_fac.nroFactura=fac.nroFactura JOIN QUERYOSOS.ItemDetallePedido item_ped on item_ped.id_item_pedido=item_fac.id_item_pedido JOIN QUERYOSOS.Modelo
	modelo on modelo.sillon_modelo_codigo=item_ped.sillon_modelo_codigo JOIN QUERYOSOS.BI_Modelo bi_modelo on bi_modelo.descripcion=modelo.descripcion
	

END
go


CREATE PROCEDURE QUERYOSOS.BI_MigrarPedido as
BEGIN
	INSERT INTO QUERYOSOS.BI_Pedido(idSucursal,idTiempo,idTurno,idUbicacion,idEstadoBI,nroPedido)
	SELECT bi_sucu.idSucursal,bi_tiempo.idTiempo,bi_turno.idTurno,bi_ubi.idUbicacion,bi_estado.idEstadoBI,pedido.nroDePedido FROM QUERYOSOS.Pedido pedido join QUERYOSOS.Sucursal sucursal on pedido.idSucursal=sucursal.idSucursal
	JOIN QUERYOSOS.Direccion dire on sucursal.idDireccion=dire.idDireccion JOIN QUERYOSOS.BI_Sucursal bi_sucu on bi_sucu.direccion=dire.direccion
	JOIN QUERYOSOS.BI_Tiempo bi_tiempo on year(pedido.fechaYHora)=bi_tiempo.anio and month(pedido.fechaYHora)=bi_tiempo.mes JOIN QUERYOSOS.Localidad loca on loca.idLocalidad=dire.idLocalidad
	JOIN QUERYOSOS.Provincia provincia on provincia.idProvincia=loca.idProvincia JOIN QUERYOSOS.BI_Ubicacion bi_ubi on bi_ubi.localidad=loca.nombre and bi_ubi.provincia=provincia.nombre and bi_ubi.direccion=dire.direccion
	JOIN QUERYOSOS.Estado estado_pedido on estado_pedido.idEstado=pedido.estadoActual JOIN QUERYOSOS.BI_EstadoPedido bi_estado ON estado_pedido.estado=bi_estado.estado
	JOIN QUERYOSOS.BI_Turno bi_turno on CAST(pedido.fechaYHora AS TIME) BETWEEN bi_turno.desde and bi_turno.hasta
END

GO



CREATE PROCEDURE QUERYOSOS.BI_MigrarEnvio as
BEGIN
	INSERT INTO QUERYOSOS.BI_Envio(idTiempo,idUbicacion,nroEnvio,fechaHoraEntrega,fechaProgramada, envioTotal)
	SELECT bi_tiempo.idTiempo,bi_ubi.idUbicacion,env.nroDeEnvio,env.fechaYHoraEntrega,env.fechaProgramada, env.envioTotal FROM QUERYOSOS.Envio env JOIN QUERYOSOS.BI_Tiempo bi_tiempo on year(env.fechaProgramada)=bi_tiempo.anio and month(env.fechaProgramada)=bi_tiempo.mes
	JOIN QUERYOSOS.Factura fact on env.nroDeFactura=fact.nroFactura JOIN QUERYOSOS.Cliente clie on fact.idCliente=clie.idCliente
	JOIN QUERYOSOS.Direccion dire on clie.idDireccion=dire.idDireccion JOIN QUERYOSOS.Localidad loca on loca.idLocalidad=dire.idLocalidad JOIN
	QUERYOSOS.Provincia prov on prov.idProvincia=loca.idProvincia JOIN QUERYOSOS.BI_Ubicacion bi_ubi on bi_ubi.direccion=dire.direccion and bi_ubi.localidad=loca.nombre and bi_ubi.provincia=prov.nombre
END
GO



CREATE PROCEDURE QUERYOSOS.BI_MigrarCompra as
BEGIN
	INSERT INTO QUERYOSOS.BI_Compra(idSucursal,idTiempo,idUbicacion,idMaterial,nroCompra,subtotal)
	SELECT bi_sucu.idSucursal,bi_tiempo.idTiempo,bi_ubi.idUbicacion,bi_material.idMaterial,compra.nroDeCompra,det_compra.subtotal FROM QUERYOSOS.Compra compra JOIN QUERYOSOS.DetalleCompra det_compra on compra.nroDeCompra=det_compra.nroDeCompra
	JOIN QUERYOSOS.Material material on det_compra.idMaterial=material.idMaterial JOIN QUERYOSOS.BI_Material bi_material on material.tipo=bi_material.tipo
	JOIN QUERYOSOS.Sucursal sucu on compra.idSucursal=sucu.idSucursal
	JOIN QUERYOSOS.Direccion dire on dire.idDireccion=sucu.idDireccion JOIN QUERYOSOS.BI_Sucursal bi_sucu on bi_sucu.direccion=dire.direccion
	JOIN QUERYOSOS.Localidad loca on loca.idLocalidad=dire.idLocalidad JOIN QUERYOSOS.Provincia provincia on provincia.idProvincia=loca.idProvincia
	JOIN QUERYOSOS.BI_Ubicacion bi_ubi on bi_ubi.localidad=loca.nombre and bi_ubi.provincia=provincia.nombre and bi_ubi.direccion=dire.direccion
	JOIN QUERYOSOS.BI_Tiempo bi_tiempo on bi_tiempo.anio=year(compra.fechaCompra) and bi_tiempo.mes=month(compra.fechaCompra)
END
GO
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
EXEC QUERYOSOS.BI_MigrarModelos
EXEC QUERYOSOS.BI_MigrarFacturacion
EXEC QUERYOSOS.BI_MigrarPedido
EXEC QUERYOSOS.BI_MigrarEnvio
EXEC QUERYOSOS.BI_MigrarCompra

GO
-------------------------------------
------- CREACION DE VISTAS ----------
-------------------------------------
-----------------------------------

---VISTA 1 (GANANCIA TOTAL)

--Punto 1
GO
CREATE VIEW QUERYOSOS.Ganancia_Total AS
SELECT bi_tiempo.mes mes, bi_sucursal.idSucursal sucursal, (SELECT sum(isnull(subtotal_item_factura,0)) FROM QUERYOSOS.BI_Facturacion bi_fact JOIN QUERYOSOS.BI_Tiempo bi_tiem on bi_fact.idTiempo=bi_tiem.idTiempo where bi_tiem.mes=bi_tiempo.mes and bi_fact.idSucursal=bi_sucursal.idSucursal) - (SELECT sum(isnull(bi_compra.subtotal,0)) FROM QUERYOSOS.BI_Compra bi_compra JOIN QUERYOSOS.BI_Tiempo bi_ti on bi_compra.idTiempo=bi_ti.idTiempo where bi_tiempo.mes=bi_tiempo.mes and bi_compra.idSucursal=bi_sucursal.idSucursal) ganancia_total
FROM QUERYOSOS.BI_Tiempo bi_tiempo CROSS JOIN QUERYOSOS.BI_Sucursal bi_sucursal
GO


--Punto 9: porcentaje de cumplimiento de envios
GO
CREATE VIEW QUERYOSOS.Punto9_PorcentajeCumplimientoEnvios AS
SELECT t.anio as AñoEnvio, t.mes as MesEnvio, STR(COUNT(CASE WHEN e1.fechaHoraEntrega = e1.fechaProgramada THEN 1 END)*100/COUNT(*),5,0)+'%' as Porcentaje  
FROM QUERYOSOS.BI_Envio e1 JOIN QUERYOSOS.BI_Tiempo t on t.anio = YEAR(e1.fechaHoraEntrega) AND t.mes = MONTH(e1.fechaHoraEntrega)
GROUP BY t.anio, t.mes
ORDER BY 1
GO

--Punto 10: localidades que pagan mayor costo de envio
GO
CREATE VIEW QUERYOSOS.Punto10_LocalidadesMayorCostoEnvio AS
SELECT TOP 3
     u.direccion AS localidad,
     AVG(e.envioTotal) AS promedioEnvio
FROM QUERYOSOS.BI_Facturacion  AS f
JOIN QUERYOSOS.BI_Envio        AS e
  ON f.idPedido    = e.idPedido
JOIN QUERYOSOS.BI_Ubicacion    AS u
  ON f.idUbicacion = u.idUbicacion
GROUP BY
     u.direccion
ORDER BY
     promedioEnvio DESC;
GO
-------------------------------------
--------------- TESTS ---------------
-------------------------------------
SELECT * FROM QUERYOSOS.Punto9_PorcentajeCumplimientoEnvios