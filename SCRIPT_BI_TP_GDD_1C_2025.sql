
USE GD1C2025;
GO


------------------------------------------------------------------------------------------------
----- DROPEO DE TABLAS (respetar orden establecido) -----
-----------------------------------------------------------------------------------------------
-- tablas de hechos 
IF OBJECT_ID('QUERYOSOS.BI_Envio','U')             IS NOT NULL DROP TABLE QUERYOSOS.BI_Envio;
IF OBJECT_ID('QUERYOSOS.BI_Compra','U')            IS NOT NULL DROP TABLE QUERYOSOS.BI_Compra;
IF OBJECT_ID('QUERYOSOS.BI_Pedido','U')            IS NOT NULL DROP TABLE QUERYOSOS.BI_Pedido;
IF OBJECT_ID('QUERYOSOS.BI_Facturacion','U')       IS NOT NULL DROP TABLE QUERYOSOS.BI_Facturacion;



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
DROP VIEW IF EXISTS QUERYOSOS.Factura_Promedio_Mensual
DROP VIEW IF EXISTS QUERYOSOS.Modelos_Mas_Vendidos
DROP VIEW IF EXISTS QUERYOSOS.Cantidad_Pedidos
DROP VIEW IF EXISTS QUERYOSOS.Conversion_Pedidos
DROP VIEW IF EXISTS QUERYOSOS.Punto6_TiempoPromedioFabricacion
DROP VIEW IF EXISTS QUERYOSOS.Punto7_PromedioCompras
DROP VIEW IF EXISTS QUERYOSOS.Punto8_ComprasPorTipoMaterial 
DROP VIEW IF EXISTS QUERYOSOS.Punto9_PorcentajeCumplimientoEnvios
DROP VIEW IF EXISTS QUERYOSOS.Punto10_LocalidadesMayorCostoEnvio




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
	idSucursal			INTEGER NOT NULL,
	idTiempo			INTEGER NOT NULL,
	idTurno				INTEGER NOT NULL,
	idUbicacion			INTEGER NOT NULL,
	idEstadoBI			INTEGER NOT NULL,
	cantidad_pedidos_registrados decimal(18,0)
	PRIMARY KEY (idSucursal, idTiempo, idTurno, idUbicacion, idEstadoBI)
);
GO

CREATE TABLE QUERYOSOS.BI_Facturacion(
	idRangoEtario    INTEGER NOT NULL,
	idSucursal       INTEGER NOT NULL,
	idTiempo         INTEGER NOT NULL,
	idModelo         BIGINT NOT NULL,
	idUbicacion		 INTEGER NOT NULL,
	total_ingresos	 DECIMAL(18,2),
	cantidad_facturas decimal(18,0),
	tiempo_promedio_fabricacion_en_dias DECIMAL(18,0)
	PRIMARY KEY (idRangoEtario, idSucursal, idTiempo, idModelo, idUbicacion)
);
GO

CREATE TABLE QUERYOSOS.BI_Envio (
	idTiempo			  INTEGER NOT NULL,
	idUbicacion			  INTEGER NOT NULL,
	costo_total_envio	  DECIMAL (18,2),
	cantidad_envios		  decimal(18,0),
	envios_cumplidos	  decimal(18,0)
	PRIMARY KEY (idTiempo, idUbicacion)
  );
GO

CREATE TABLE QUERYOSOS.BI_Compra (
	idTiempo        INTEGER NOT NULL,
	idMaterial	    INTEGER NOT NULL,
	idSucursal      INTEGER NOT NULL,
	idUbicacion		INTEGER NOT NULL,
	importe_total_gastado decimal(18,2),
	cantidad_compras decimal(18,0)
	PRIMARY KEY (idTiempo, idMaterial, idSucursal, idUbicacion)
);
GO

--------------------------------------------------------
-------- Rango Etario ----------------------------------
--------------------------------------------------------

UPDATE QUERYOSOS.BI_RangoEtario
SET desdeEdad =   0, hastaEdad =  24
WHERE idRangoEtario = 1;

UPDATE QUERYOSOS.BI_RangoEtario
SET desdeEdad =  25, hastaEdad =  34
WHERE idRangoEtario = 2;

UPDATE QUERYOSOS.BI_RangoEtario
SET desdeEdad =  35, hastaEdad =  49
WHERE idRangoEtario = 3;

UPDATE QUERYOSOS.BI_RangoEtario
SET desdeEdad =  50, hastaEdad = 500
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
            WHEN DATEDIFF(year, fechaNacimiento, GETDATE()) <= 24 THEN 0
            WHEN DATEDIFF(year, fechaNacimiento, GETDATE()) BETWEEN 25 AND 34 THEN 25
            WHEN DATEDIFF(year, fechaNacimiento, GETDATE()) BETWEEN 35 AND 49 THEN 35
            WHEN DATEDIFF(year, fechaNacimiento, GETDATE()) >= 50 THEN 50
        END,
        CASE 
            WHEN DATEDIFF(year, fechaNacimiento, GETDATE()) <= 24 THEN 24
            WHEN DATEDIFF(year, fechaNacimiento, GETDATE()) BETWEEN 25 AND 34 THEN 34
            WHEN DATEDIFF(year, fechaNacimiento, GETDATE()) BETWEEN 35 AND 49 THEN 49
            WHEN DATEDIFF(year, fechaNacimiento, GETDATE()) >= 50 THEN 500
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
	INSERT INTO QUERYOSOS.BI_Facturacion(idRangoEtario,idSucursal,idTiempo,idUbicacion,idModelo,total_ingresos,cantidad_facturas,tiempo_promedio_fabricacion_en_dias)
		SELECT  idRangoEtario, 
				bi_suc.idSucursal, 
				tiempo.idTiempo, 
				bi_ubi.idUbicacion, 
				bi_modelo.idModelo, 
				sum(isnull(item_fac.detalle_factura_subtotal,0)),
				COUNT(DISTINCT fac.nroFactura),
				sum(DATEDIFF(day,ped.fechaYHora,fac.fechaYHora))/COUNT(DISTINCT item_ped.id_item_pedido) 
		from QUERYOSOS.ItemDetallefactura item_fac 
			join QUERYOSOS.ItemDetallePedido item_ped	on item_fac.id_item_pedido = item_ped.id_item_pedido 
			join QUERYOSOS.Factura fac					on item_fac.nroFactura = fac.nroFactura
			JOIN QUERYOSOS.Pedido ped					ON item_ped.nroDePedido=ped.nroDePedido 
			JOIN QUERYOSOS.Cliente c					on fac.idCliente = c.idCliente
			JOIN QUERYOSOS.BI_RangoEtario rango			on DATEDIFF(year, c.fechaNacimiento, GETDATE()) between rango.desdeEdad and rango.hastaEdad
			JOIN QUERYOSOS.Sucursal suc					on fac.idSucursal = suc.idSucursal 
			JOIN QUERYOSOS.Direccion dire				on suc.idDireccion = dire.idDireccion
			JOIN QUERYOSOS.BI_Sucursal bi_suc			on dire.direccion = bi_suc.direccion 
			JOIN QUERYOSOS.Localidad loca				on dire.idLocalidad = loca.idLocalidad 
			JOIN QUERYOSOS.Provincia provincia			on provincia.idProvincia = loca.idProvincia 
			JOIN QUERYOSOS.BI_Ubicacion bi_ubi			on bi_ubi.direccion = dire.direccion and bi_ubi.localidad = loca.nombre and bi_ubi.provincia = provincia.nombre
			JOIN QUERYOSOS.BI_Tiempo tiempo				on tiempo.mes = month(fac.fechaYHora) and  tiempo.anio = year(fac.fechaYHora) 
			JOIN QUERYOSOS.Modelo modelo				on modelo.sillon_modelo_codigo = item_ped.sillon_modelo_codigo  
			JOIN QUERYOSOS.BI_Modelo bi_modelo			on bi_modelo.descripcion = modelo.descripcion

			GROUP BY bi_suc.idSucursal,idRangoEtario,tiempo.idTiempo,bi_ubi.idUbicacion,bi_modelo.idModelo
END
go



CREATE PROCEDURE QUERYOSOS.BI_MigrarPedido as
BEGIN
	INSERT INTO QUERYOSOS.BI_Pedido(idSucursal,idTiempo,idTurno,idUbicacion,idEstadoBI,
	cantidad_pedidos_registrados)
	SELECT bi_sucu.idSucursal,bi_tiempo.idTiempo,bi_turno.idTurno,bi_ubi.idUbicacion,bi_estado.idEstadoBI,COUNT(DISTINCT pedido.nroDePedido)
	FROM QUERYOSOS.Pedido pedido join QUERYOSOS.Sucursal sucursal on pedido.idSucursal=sucursal.idSucursal
	JOIN QUERYOSOS.Direccion dire on sucursal.idDireccion=dire.idDireccion JOIN QUERYOSOS.BI_Sucursal bi_sucu on bi_sucu.direccion=dire.direccion
	JOIN QUERYOSOS.BI_Tiempo bi_tiempo on year(pedido.fechaYHora)=bi_tiempo.anio and month(pedido.fechaYHora)=bi_tiempo.mes JOIN QUERYOSOS.Localidad loca on loca.idLocalidad=dire.idLocalidad
	JOIN QUERYOSOS.Provincia provincia on provincia.idProvincia=loca.idProvincia JOIN QUERYOSOS.BI_Ubicacion bi_ubi on bi_ubi.localidad=loca.nombre and bi_ubi.provincia=provincia.nombre and bi_ubi.direccion=dire.direccion
	JOIN QUERYOSOS.Estado estado_pedido on estado_pedido.idEstado=pedido.estadoActual JOIN QUERYOSOS.BI_EstadoPedido bi_estado ON estado_pedido.estado=bi_estado.estado
	JOIN QUERYOSOS.BI_Turno bi_turno on CAST(pedido.fechaYHora AS TIME) BETWEEN bi_turno.desde and bi_turno.hasta
	GROUP BY bi_sucu.idSucursal,idTiempo,idTurno,idUbicacion,idEstadoBI
END

GO



CREATE PROCEDURE QUERYOSOS.BI_MigrarEnvio as
BEGIN
	INSERT INTO QUERYOSOS.BI_Envio(idTiempo,idUbicacion,costo_total_envio,cantidad_envios,envios_cumplidos)
	SELECT bi_tiempo.idTiempo,bi_ubi.idUbicacion,sum(isnull(env.envioTotal,0)),COUNT(DISTINCT env.nroDeEnvio),SUM(CASE WHEN envios_cumplidos.nroDeEnvio IS NOT NULL THEN 1 ELSE 0 END)envios_cumplidos FROM QUERYOSOS.Envio env JOIN QUERYOSOS.BI_Tiempo bi_tiempo on year(env.fechaProgramada)=bi_tiempo.anio and month(env.fechaProgramada)=bi_tiempo.mes
	JOIN QUERYOSOS.Factura fact on env.nroDeFactura=fact.nroFactura JOIN QUERYOSOS.Cliente clie on fact.idCliente=clie.idCliente
	JOIN QUERYOSOS.Direccion dire on clie.idDireccion=dire.idDireccion JOIN QUERYOSOS.Localidad loca on loca.idLocalidad=dire.idLocalidad JOIN
	QUERYOSOS.Provincia prov on prov.idProvincia=loca.idProvincia JOIN QUERYOSOS.BI_Ubicacion bi_ubi on bi_ubi.direccion=dire.direccion and bi_ubi.localidad=loca.nombre and bi_ubi.provincia=prov.nombre
    LEFT JOIN (SELECT nroDeEnvio FROM QUERYOSOS.Envio where fechaProgramada=fechaYHoraEntrega) envios_cumplidos on env.nroDeEnvio=envios_cumplidos.nroDeEnvio
	GROUP BY idTiempo,bi_ubi.idUbicacion
END
GO



CREATE PROCEDURE QUERYOSOS.BI_MigrarCompra as
BEGIN
	INSERT INTO QUERYOSOS.BI_Compra(idSucursal,idTiempo,idUbicacion,idMaterial,importe_total_gastado,cantidad_compras)
	SELECT bi_sucu.idSucursal,bi_tiempo.idTiempo,bi_ubi.idUbicacion,bi_material.idMaterial, sum(isnull(det_compra.subtotal,0)),COUNT(DISTINCT compra.nroDeCompra) FROM QUERYOSOS.Compra compra JOIN QUERYOSOS.DetalleCompra det_compra on compra.nroDeCompra=det_compra.nroDeCompra
	JOIN QUERYOSOS.Material material on det_compra.idMaterial=material.idMaterial JOIN QUERYOSOS.BI_Material bi_material on material.tipo=bi_material.tipo
	JOIN QUERYOSOS.Sucursal sucu on compra.idSucursal=sucu.idSucursal
	JOIN QUERYOSOS.Direccion dire on dire.idDireccion=sucu.idDireccion JOIN QUERYOSOS.BI_Sucursal bi_sucu on bi_sucu.direccion=dire.direccion
	JOIN QUERYOSOS.Localidad loca on loca.idLocalidad=dire.idLocalidad JOIN QUERYOSOS.Provincia provincia on provincia.idProvincia=loca.idProvincia
	JOIN QUERYOSOS.BI_Ubicacion bi_ubi on bi_ubi.localidad=loca.nombre and bi_ubi.provincia=provincia.nombre and bi_ubi.direccion=dire.direccion
	JOIN QUERYOSOS.BI_Tiempo bi_tiempo on bi_tiempo.anio=year(compra.fechaCompra) and bi_tiempo.mes=month(compra.fechaCompra)
	GROUP BY bi_sucu.idSucursal,idTiempo,idUbicacion,bi_material.idMaterial
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

CREATE VIEW QUERYOSOS.Ganancia_Total as
SELECT bi_tiempo.anio,bi_tiempo.mes,bi_sucu.numeroSucursal,isnull((SELECT sum(isnull(total_ingresos,0)) FROM QUERYOSOS.BI_Facturacion bi_fact JOIN QUERYOSOS.BI_Tiempo bi_tiem on bi_fact.idTiempo=bi_tiem.idTiempo
where mes=bi_tiempo.mes and bi_tiem.anio=bi_tiempo.anio and bi_fact.idSucursal=bi_sucu.idSucursal),0) - isnull((SELECT sum(isnull(importe_total_gastado,0)) FROM QUERYOSOS.BI_Compra bi_compra JOIN QUERYOSOS.BI_Tiempo bi_tiemp on bi_compra.idTiempo=bi_tiemp.idTiempo
where bi_tiemp.mes=bi_tiempo.mes and bi_tiemp.anio=bi_tiempo.anio and bi_compra.idSucursal=bi_sucu.idSucursal),0) AS GANANCIA_TOTAL
FROM QUERYOSOS.BI_Tiempo bi_tiempo CROSS JOIN QUERYOSOS.BI_Sucursal bi_sucu
GROUP BY bi_tiempo.mes,bi_sucu.numeroSucursal,bi_sucu.idSucursal,bi_tiempo.anio
GO





---VISTA 2 (FACTURA PROMEDIO Mensual)

CREATE VIEW QUERYOSOS.Factura_Promedio_Mensual AS
select bi_ubi.provincia,bi_tiempo.cuatrimestre,bi_tiempo.anio, sum(isnull(total_ingresos,0))/ sum(isnull(cantidad_facturas,0)) AS promedio_por_cuatrimestre
from QUERYOSOS.BI_Facturacion fact JOIN QUERYOSOS.BI_Ubicacion bi_ubi on bi_ubi.idUbicacion=fact.idUbicacion 
JOIN QUERYOSOS.BI_Tiempo bi_tiempo on bi_tiempo.idTiempo=fact.idTiempo
GROUP BY bi_ubi.provincia,bi_tiempo.cuatrimestre,bi_tiempo.anio

GO

--VISTA 3 (Rendimiento de modelos)

CREATE VIEW QUERYOSOS.Modelos_mas_vendidos AS 
SELECT bi_tiempo.anio,bi_tiempo.cuatrimestre,bi_ubi.localidad,bi_rango.desdeEdad,bi_rango.hastaEdad,bi_modelo.descripcion
FROM QUERYOSOS.BI_Facturacion bi_fact JOIN QUERYOSOS.BI_Tiempo bi_tiempo on bi_fact.idTiempo=bi_tiempo.idTiempo
JOIN QUERYOSOS. BI_Ubicacion bi_ubi on bi_ubi.idUbicacion=bi_fact.idUbicacion JOIN QUERYOSOS.BI_Modelo bi_modelo on bi_modelo.idModelo=bi_fact.idModelo
JOIN QUERYOSOS.BI_RangoEtario bi_rango on bi_fact.idRangoEtario=bi_rango.idRangoEtario
GROUP BY bi_modelo.idModelo,bi_modelo.descripcion,bi_tiempo.cuatrimestre,bi_tiempo.anio,bi_ubi.localidad,bi_rango.idRangoEtario,bi_rango.desdeEdad,bi_rango.hastaEdad
HAVING bi_modelo.idModelo in (SELECT TOP 3 modelo.idModelo FROM QUERYOSOS.BI_Facturacion fact JOIN QUERYOSOS.BI_Tiempo tiemp on fact.idTiempo=tiemp.idTiempo 
JOIN QUERYOSOS.BI_Ubicacion ubi on fact.idUbicacion=ubi.idUbicacion JOIN QUERYOSOS.BI_RangoEtario rango_etario on fact.idRangoEtario=rango_etario.idRangoEtario
JOIN QUERYOSOS.BI_Modelo modelo on fact.idModelo=modelo.idModelo
where ubi.localidad=bi_ubi.localidad and tiemp.cuatrimestre=bi_tiempo.cuatrimestre and tiemp.anio=bi_tiempo.anio and rango_etario.idRangoEtario=bi_rango.idRangoEtario
GROUP BY modelo.idModelo 
ORDER BY sum(isnull(cantidad_facturas,0))DESC)

GO

--VISTA 4 (Volumen de Pedidos)

CREATE VIEW QUERYOSOS.Cantidad_Pedidos as
SELECT bi_tiempo.anio,bi_tiempo.mes,bi_sucu.numeroSucursal,bi_turno.desde,bi_turno.hasta, sum(isnull(cantidad_pedidos_registrados,0)) as cantidad_pedidos_registrados
FROM QUERYOSOS.BI_Pedido bi_pedido JOIN QUERYOSOS.BI_Turno bi_turno on bi_pedido.idTurno=bi_turno.idTurno
JOIN QUERYOSOS.BI_Tiempo bi_tiempo on bi_pedido.idTiempo=bi_tiempo.idTiempo JOIN QUERYOSOS.BI_Sucursal bi_sucu on bi_pedido.idSucursal=bi_sucu.idSucursal
GROUP BY bi_turno.idTurno,bi_tiempo.anio,bi_tiempo.mes,bi_tiempo.anio,bi_sucu.idSucursal,bi_sucu.numeroSucursal,bi_turno.desde,bi_turno.hasta

GO


--VISTA 5 (PORCENTAJE_DE_PEDIDOS_SEGUN_ESTADO)

CREATE VIEW QUERYOSOS.Conversion_Pedidos as
SELECT bi_estado.estado,bi_tiempo.anio,bi_tiempo.cuatrimestre,bi_sucu.idSucursal, sum(cantidad_pedidos_registrados)/(SELECT sum(isnull(cantidad_pedidos_registrados,0)) FROM QUERYOSOS.BI_Pedido pedido JOIN QUERYOSOS.BI_Tiempo tiempo on pedido.idTiempo=tiempo.idTiempo
where pedido.idSucursal=bi_sucu.idSucursal and tiempo.cuatrimestre=bi_tiempo.cuatrimestre and tiempo.anio=bi_tiempo.anio)*100 as porcentaje_pedidos
FROM QUERYOSOS.BI_Pedido bi_pedido join QUERYOSOS.BI_Tiempo bi_tiempo on bi_pedido.idTiempo=bi_tiempo.idTiempo
JOIN QUERYOSOS.BI_Sucursal bi_sucu on bi_sucu.idSucursal=bi_pedido.idSucursal
JOIN QUERYOSOS.BI_EstadoPedido bi_estado on bi_pedido.idEstadoBI=bi_estado.idEstadoBI
GROUP BY bi_estado.idEstadoBI,bi_tiempo.cuatrimestre,bi_sucu.idSucursal,bi_tiempo.anio,bi_estado.estado



go


-----VISTA 6 (Tiempo promedio de fabricacion)


CREATE VIEW QUERYOSOS.Punto6_TiempoPromedioFabricacion as
SELECT bi_tiempo.anio,bi_tiempo.cuatrimestre,bi_sucu.numeroSucursal, ROUND(SUM(bi_pedido.tiempo_promedio_fabricacion_en_dias) / NULLIF(COUNT(*), 0), 0) tiempo_promedio_fabricacion_en_dias
FROM QUERYOSOS.BI_Facturacion bi_pedido join QUERYOSOS.BI_Sucursal bi_sucu on bi_pedido.idSucursal=bi_sucu.idSucursal
JOIN QUERYOSOS.BI_Tiempo bi_tiempo on bi_pedido.idTiempo=bi_tiempo.idTiempo
GROUP BY bi_sucu.idSucursal,bi_sucu.numeroSucursal,bi_tiempo.anio,bi_tiempo.cuatrimestre



go

--VISTA 7 (PROMEDIO DE COMPRAS)

CREATE VIEW QUERYOSOS.Punto7_PromedioCompras AS
SELECT sum(isnull(importe_total_gastado,0))/ sum(isnull(cantidad_compras,0)) monto_promedio_gastado
FROM QUERYOSOS.BI_Compra bi_compra JOIN QUERYOSOS.BI_Tiempo bi_tiempo on bi_compra.idTiempo=bi_tiempo.idTiempo
GROUP BY bi_tiempo.anio,bi_tiempo.mes



go
--VISTA 8 (Compras por tipo de material)


CREATE VIEW QUERYOSOS.Punto8_ComprasPorTipoMaterial as
SELECT bi_tiempo.anio,bi_tiempo.cuatrimestre,bi_sucu.numeroSucursal, bi_material.tipo, sum(isnull(importe_total_gastado,0)) importe_total_gastado
FROM QUERYOSOS.BI_Compra bi_compra JOIN QUERYOSOS.BI_Sucursal bi_sucu on bi_compra.idSucursal=bi_sucu.idSucursal
JOIN QUERYOSOS.BI_Tiempo bi_tiempo on bi_compra.idTiempo=bi_tiempo.idTiempo JOIN QUERYOSOS.BI_Material bi_material on bi_material.idMaterial=bi_compra.idMaterial
GROUP BY bi_tiempo.idTiempo,bi_tiempo.cuatrimestre,bi_tiempo.anio,bi_sucu.idSucursal,bi_sucu.numeroSucursal,bi_material.idMaterial,bi_material.tipo


go
--VISTA 9 (Porcentaje de cumplimiento de envios)

CREATE VIEW QUERYOSOS.Punto9_PorcentajeCumplimientoEnvios AS
SELECT bi_tiempo.anio,bi_tiempo.mes,sum(isnull(envios_cumplidos,0))/sum(isnull(cantidad_envios,0)) *100 porcentaje_cumplimiento_envios
FROM QUERYOSOS.BI_Envio bi_envio JOIN QUERYOSOS.BI_Tiempo bi_tiempo on bi_envio.idTiempo=bi_tiempo.idTiempo
GROUP BY bi_tiempo.anio,bi_tiempo.mes,bi_tiempo.idTiempo


go
--VISTA 10 (Localidades con mayor costo de envio promedio)


CREATE VIEW QUERYOSOS.Punto10_LocalidadesMayorCostoEnvio AS
SELECT TOP 3 bi_ubi.localidad
FROM QUERYOSOS.BI_Envio bi_envio JOIN QUERYOSOS.BI_Ubicacion bi_ubi on bi_envio.idUbicacion=bi_ubi.idUbicacion
GROUP BY bi_ubi.localidad
ORDER  BY (sum(isnull(costo_total_envio,0))/sum(isnull(cantidad_envios,0)))DESC




