USE GD1C2025;
GO



---Eliminamos al esquema o lo creamos si no existe-----------------------------
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'QUERYOSOS')
BEGIN EXEC ('CREATE SCHEMA QUERYOSOS')
END
GO

------------------------------------------------------------------------------------------------
----- DROPEO DE TABLAS (respetar orden establecido) -----
------------------------------------------------------------------------------------------------

IF OBJECT_ID('QUERYOSOS.ItemDetallefactura', 'U') IS NOT NULL
    DROP TABLE QUERYOSOS.ItemDetallefactura;

IF OBJECT_ID('QUERYOSOS.ItemDetallePedido', 'U') IS NOT NULL
    DROP TABLE QUERYOSOS.ItemDetallePedido;

IF OBJECT_ID('QUERYOSOS.DetalleCompra', 'U') IS NOT NULL
    DROP TABLE QUERYOSOS.DetalleCompra;

IF OBJECT_ID('QUERYOSOS.MaterialSillon', 'U') IS NOT NULL
    DROP TABLE QUERYOSOS.MaterialSillon;

IF OBJECT_ID('QUERYOSOS.Sillon', 'U') IS NOT NULL
    DROP TABLE QUERYOSOS.Sillon;

IF OBJECT_ID('QUERYOSOS.Relleno', 'U') IS NOT NULL
    DROP TABLE QUERYOSOS.Relleno;

IF OBJECT_ID('QUERYOSOS.Madera', 'U') IS NOT NULL
    DROP TABLE QUERYOSOS.Madera;

IF OBJECT_ID('QUERYOSOS.Tela', 'U') IS NOT NULL
    DROP TABLE QUERYOSOS.Tela;

IF OBJECT_ID('QUERYOSOS.Material', 'U') IS NOT NULL
    DROP TABLE QUERYOSOS.Material;

IF OBJECT_ID('QUERYOSOS.Medida', 'U') IS NOT NULL
    DROP TABLE QUERYOSOS.Medida;

IF OBJECT_ID('QUERYOSOS.Modelo', 'U') IS NOT NULL
    DROP TABLE QUERYOSOS.Modelo;

IF OBJECT_ID('QUERYOSOS.Pedido', 'U') IS NOT NULL
    DROP TABLE QUERYOSOS.Pedido;

IF OBJECT_ID('QUERYOSOS.Compra', 'U') IS NOT NULL
    DROP TABLE QUERYOSOS.Compra;

IF OBJECT_ID('QUERYOSOS.Envio', 'U') IS NOT NULL
    DROP TABLE QUERYOSOS.Envio;

IF OBJECT_ID('QUERYOSOS.Factura', 'U') IS NOT NULL
    DROP TABLE QUERYOSOS.Factura;

IF OBJECT_ID('QUERYOSOS.Proveedor', 'U') IS NOT NULL
    DROP TABLE QUERYOSOS.Proveedor;

IF OBJECT_ID('QUERYOSOS.Cliente', 'U') IS NOT NULL
    DROP TABLE QUERYOSOS.Cliente;

IF OBJECT_ID('QUERYOSOS.Sucursal', 'U') IS NOT NULL
    DROP TABLE QUERYOSOS.Sucursal;

IF OBJECT_ID('QUERYOSOS.Motivo_cancelacion_pedido', 'U') IS NOT NULL
    DROP TABLE QUERYOSOS.Motivo_cancelacion_pedido;

IF OBJECT_ID('QUERYOSOS.Estado', 'U') IS NOT NULL
    DROP TABLE QUERYOSOS.Estado;

IF OBJECT_ID('QUERYOSOS.Direccion', 'U') IS NOT NULL
    DROP TABLE QUERYOSOS.Direccion;

IF OBJECT_ID('QUERYOSOS.Localidad', 'U') IS NOT NULL
    DROP TABLE QUERYOSOS.Localidad;

IF OBJECT_ID('QUERYOSOS.Provincia', 'U') IS NOT NULL
    DROP TABLE QUERYOSOS.Provincia;






--CREACION DE TABLAS Y DE SUS RESPECTIVAS PRIMARY KEYS

CREATE TABLE QUERYOSOS.Pedido(
nroDePedido decimal(18,0) CONSTRAINT PK_Pedido PRIMARY KEY,
fechaYHora DateTime2(6),
precioTotal decimal(18,2),
idCliente Integer,
estadoActual Integer, 
idSucursal Integer, 
fechaCancelacion DateTime2(6), 
idMotivoCancelacion Integer
)
GO


CREATE TABLE QUERYOSOS.ItemDetallePedido (
id_item_pedido Integer Identity(1,1) CONSTRAINT PK_Item_Detalle_Pedido PRIMARY KEY,
nroDePedido decimal(18,0),
idSillon BigInt,
cantidad_pedido BigInt,
subtotal decimal(18,2),
precioUnitario decimal(18,2)
)

CREATE TABLE QUERYOSOS.Factura (
nroFactura BIGINT CONSTRAINT PK_Factura PRIMARY KEY,
idCliente Integer,
idSucursal Integer,
fechaYHora DateTime2(6),
importeTotal decimal(38,2)
)

CREATE TABLE QUERYOSOS.Cliente (
idCliente Integer IDENTITY(1,1) CONSTRAINT PK_Cliente PRIMARY KEY,
nombre NVarchar(255),
apellido NVarchar(255),
nroDocumento BigInt,
fechaNacimiento DateTime2(6),
mail NVARCHAR(255),
telefono NVARCHAR(255),
idDireccion Integer
)

CREATE TABLE QUERYOSOS.Envio (
nroDeEnvio Decimal(18,0) CONSTRAINT PK_Envio PRIMARY KEY,
nroDeFactura BigInt,
fechaProgramada DateTime2(6),
fechaYHoraEntrega DateTime2(6),
importeTraslado decimal(18,2),
importeSubida decimal (18,2),
envioTotal decimal(18,2)
)

CREATE TABLE QUERYOSOS.Compra (
nroDeCompra decimal(18,0) CONSTRAINT PK_Compra PRIMARY KEY ,
idSucursal Integer,
idProveedor Integer,
fechaCompra dateTime2(6),
total_compra decimal(18,2)
)

CREATE TABLE QUERYOSOS.DetalleCompra(
idDetalleCompra Integer IDENTITY(1,1) CONSTRAINT PK_Detalle_Compra PRIMARY KEY,
nroDeCompra Decimal (18,0),
precioUnitario decimal(18,2),
cantidad decimal(18,0),
subtotal decimal(18,2),
idMaterial Integer
)

Create Table QUERYOSOS.Proveedor (
idProveedor Integer IDENTITY(1,1) Constraint PK_Proveedor PRIMARY KEY,
mail NVarchar(255) not null,
telefono NVarchar(255) not null,
idDireccion Integer,
razonSocial NVarchar(255) not null,
cuit NVarchar (255) not null
)

CREATE TABLE QUERYOSOS.Sillon (
idSillon BigInt IDENTITY(1,1) CONSTRAINT PK_Sillon PRIMARY KEY,
SillonCodigo BigInt,
precioUnitario decimal(18,2),
SillonModeloCodigo BigInt,
idMedidaSillon Integer,
)

Create Table QUERYOSOS.Modelo (
sillon_modelo_codigo BigInt Constraint PK_Modelo PRIMARY KEY,
precio Decimal(18,2),
descripcion NVarchar(255)
)

Create Table QUERYOSOS.Medida(
idMedidaSillon Integer IDENTITY(1,1) CONSTRAINT PK_Medida PRIMARY KEY,
ancho decimal(18,2),
profundidad decimal(18,2),
alto decimal(18,2),
precio decimal(18,2)
)

Create Table QUERYOSOS.Material(
idMaterial Integer IDENTITY(1,1) CONSTRAINT PK_Material PRIMARY KEY ,
tipo NVarchar(255),
nombre NVarchar(255),
descripcion NVarchar(255)
)

Create Table QUERYOSOS.MaterialSillon(
idSillon BIGINT,
idMaterial Integer,
CONSTRAINT PK_Material_Sillon Primary Key (idSillon,idMaterial)
)


Create Table QUERYOSOS.Tela(
id_tela Integer IDENTITY(1,1) Constraint PK_Tela PRIMARY KEY,
IdMaterial Integer,
telaColor NVarchar(255),
telaTextura NVarchar(255),
precio_material decimal(18,2)
)

Create Table QUERYOSOS.Madera(
id_madera Integer IDENTITY(1,1) Constraint PK_Madera PRIMARY KEY,
IdMaterial Integer,
maderaColor NVarchar(255),
maderaDureza NVarchar(255),
precio_material decimal(18,2)
)

Create Table QUERYOSOS.Relleno(
id_relleno Integer IDENTITY(1,1) CONSTRAINT PK_Relleno PRIMARY KEY,
IdMaterial Integer,
rellenoDensidad decimal(18,2),
precio_material decimal(18,2)
)

Create Table QUERYOSOS.Direccion(
idDireccion Integer IDENTITY(1,1) Constraint PK_Direccion PRIMARY KEY,
idLocalidad Integer,
direccion NVarchar(255)NOT NULL,
UNIQUE(idLocalidad,direccion)
)

Create Table QUERYOSOS.Localidad(
idLocalidad Integer IDENTITY(1,1) Constraint PK_Localidad PRIMARY KEY,
nombre NVarchar(255) not null,
idProvincia Integer,
UNIQUE (nombre,idProvincia)
)

Create Table QUERYOSOS.Provincia(
idProvincia Integer IDENTITY(1,1) CONSTRAINT PK_Provincia PRIMARY KEY,
nombre NVarchar(255) not null unique
)

Create Table QUERYOSOS.Sucursal(
idSucursal Integer IDENTITY(1,1) Constraint PK_Sucursal PRIMARY KEY,
numeroSucursal BigInt,
idDireccion Integer,
telefono NVarchar(255),
mail NVarchar(255)
)

Create Table QUERYOSOS.Motivo_cancelacion_pedido(
id_motivo_cancelacion Integer identity(1,1) CONSTRAINT PK_Motivo_Cancelacion_Pedido PRIMARY KEY,
nombre NVarchar(255) not null UNIQUE
)

Create Table QUERYOSOS.Estado(
idEstado Integer IDENTITY(1,1) Constraint PK_Estado PRIMARY KEY,
estado NVarchar(255) not null,
)

Create Table QUERYOSOS.ItemDetallefactura(
nroFactura BigInt,
id_item_pedido Integer,
detalle_factura_precio decimal(18,2),
detalle_factura_cantidad decimal(18,0),
detalle_factura_subtotal decimal(18,2),
CONSTRAINT PK_ItemDetalleFactura PRIMARY KEY (nroFactura, id_item_pedido)

)




--CREACION DE FOREIGN KEYS

--FOREIGN KEYS PARA PEDIDO---

ALTER TABLE QUERYOSOS.Pedido
ADD CONSTRAINT FK_Pedido_Cliente
FOREIGN KEY (idCliente) REFERENCES QUERYOSOS.Cliente(idCliente)

ALTER TABLE QUERYOSOS.Pedido
ADD CONSTRAINT FK_Pedido_Sucursal
FOREIGN KEY (idSucursal) REFERENCES QUERYOSOS.Sucursal(idSucursal)

ALTER TABLE QUERYOSOS.Pedido
ADD CONSTRAINT FK_Pedido_Estado
FOREIGN KEY (estadoActual) REFERENCES QUERYOSOS.Estado(idEstado)

ALTER TABLE QUERYOSOS.Pedido
ADD CONSTRAINT FK_Pedido_Motivo_Cancelacion
FOREIGN KEY (idMotivoCancelacion) REFERENCES QUERYOSOS.Motivo_cancelacion_pedido(id_motivo_cancelacion)

----FOREIGN KEYS PARA ITEM_DETALLE_PEDIDO

ALTER TABLE QUERYOSOS.ItemDetallePedido
ADD CONSTRAINT FK_Item_Detalle_Pedido_Pedido 
FOREIGN KEY (nroDePedido) References QUERYOSOS.Pedido(nroDePedido)

ALTER TABLE QUERYOSOS.ItemDetallePedido
ADD CONSTRAINT FK_Item_Detalle_Pedido_Sillon
FOREIGN KEY(idSillon) REFERENCES QUERYOSOS.Sillon(idSillon)

--FOREIGN KEYS PARA FACTURA

ALTER TABLE QUERYOSOS.Factura
ADD CONSTRAINT FK_Cliente
FOREIGN KEY (idCliente) References QUERYOSOS.Cliente(idCliente)


ALTER TABLE QUERYOSOS.Factura
ADD CONSTRAINT FK_Sucursal
FOREIGN KEY (idSucursal) REFERENCES QUERYOSOS.Sucursal(idSucursal)



--FOREIGN KEYS PARA Cliente


ALTER TABLE QUERYOSOS.Cliente
ADD CONSTRAINT FK_Direccion_Cliente
FOREIGN KEY (idDireccion) REFERENCES QUERYOSOS.Direccion(idDireccion)

--FOREIGN KEYS PARA Envio

ALTER TABLE QUERYOSOS.Envio
ADD CONSTRAINT FK_Envio_Factura
FOREIGN KEY (nroDeFactura) REFERENCES QUERYOSOS.Factura(nroFactura);

--FOREIGN KEYS PARA Compra



ALTER TABLE QUERYOSOS.Compra
ADD CONSTRAINT FK_Compra_Sucursal
FOREIGN KEY (idSucursal) REFERENCES QUERYOSOS.Sucursal(idSucursal);



ALTER TABLE QUERYOSOS.Compra
ADD CONSTRAINT FK_Compra_Proveedor
FOREIGN KEY (idProveedor) REFERENCES QUERYOSOS.Proveedor(idProveedor);



--FOREIGN KEYS PARA DetalleCompra

ALTER TABLE QUERYOSOS.DetalleCompra
ADD CONSTRAINT FK_DetalleCompra_Material
FOREIGN KEY (idMaterial) REFERENCES QUERYOSOS.Material(idMaterial);

ALTER TABLE QUERYOSOS.DetalleCompra
ADD CONSTRAINT FK_nroDeCompra
FOREIGN KEY (nroDeCompra) REFERENCES QUERYOSOS.Compra(nroDeCompra);

--FOREIGN KEYS PARA Proveedor

ALTER TABLE QUERYOSOS.Proveedor
ADD CONSTRAINT FK_Proveedor_Direccion
FOREIGN KEY (idDireccion) REFERENCES QUERYOSOS.Direccion(idDireccion);

--FOREIGN KEYS PARA Sillon

ALTER TABLE QUERYOSOS.Sillon
ADD CONSTRAINT FK_Sillon_Modelo
FOREIGN KEY (SillonModeloCodigo) REFERENCES QUERYOSOS.Modelo(sillon_modelo_codigo);

ALTER TABLE QUERYOSOS.Sillon
ADD CONSTRAINT FK_Sillon_Medida
FOREIGN KEY (idMedidaSillon) REFERENCES QUERYOSOS.Medida(idMedidaSillon);


--FOREIGN KEYS para MaterialSillon

ALTER TABLE QUERYOSOS.MaterialSillon
ADD CONSTRAINT FK_MaterialSillon_Sillon
FOREIGN KEY (idSillon) REFERENCES QUERYOSOS.Sillon(idSillon);

ALTER TABLE QUERYOSOS.MaterialSillon
ADD CONSTRAINT FK_MaterialSillon_Material
FOREIGN KEY (idMaterial) REFERENCES QUERYOSOS.Material(idMaterial);

--FOREIGN KEYS Para Tela, Madera y Relleno

ALTER TABLE QUERYOSOS.Tela
ADD CONSTRAINT FK_Tela_Material
FOREIGN KEY (IdMaterial) REFERENCES QUERYOSOS.Material(idMaterial);

ALTER TABLE QUERYOSOS.Madera
ADD CONSTRAINT FK_Madera_Material
FOREIGN KEY (IdMaterial) REFERENCES QUERYOSOS.Material(idMaterial);

ALTER TABLE QUERYOSOS.Relleno
ADD CONSTRAINT FK_Relleno_Material
FOREIGN KEY (IdMaterial) REFERENCES QUERYOSOS.Material(idMaterial);


--FOREIGN KEY PARA DIRECCION

ALTER TABLE QUERYOSOS.Direccion
ADD CONSTRAINT FK_Direccion_Localidad
FOREIGN KEY (idLocalidad) REFERENCES QUERYOSOS.Localidad(idLocalidad);


--Foreign Key para Localidad

ALTER TABLE QUERYOSOS.Localidad
ADD CONSTRAINT FK_Localidad_Provincia
FOREIGN KEY (idProvincia) REFERENCES QUERYOSOS.Provincia(idProvincia);


--Foreign Key para Sucursal

ALTER TABLE QUERYOSOS.Sucursal
ADD CONSTRAINT FK_Sucursal_Direccion
FOREIGN KEY (idDireccion) REFERENCES QUERYOSOS.Direccion(idDireccion);


--FOREIGN KEYS Para ItemDetalleFactura

ALTER TABLE QUERYOSOS.ItemDetalleFactura
ADD CONSTRAINT FK_ItemDetalleFactura_Factura
FOREIGN KEY (nroFactura) REFERENCES QUERYOSOS.Factura(nroFactura);

ALTER TABLE QUERYOSOS.ItemDetalleFactura
ADD CONSTRAINT FK_ItemDetalleFactura_ItemDetallePedido
FOREIGN KEY (id_item_pedido) REFERENCES QUERYOSOS.ItemDetallePedido(id_item_pedido);

GO
/*
------------------------------------
------------------------------------
------EMPEZAMOS LA MIGRACIÓN---------
-------------------------------------
------------------------------------
*/

------Primero dropeamos los procedures si ya existen-----
DROP PROCEDURE IF EXISTS Migrar_Provincia
DROP PROCEDURE IF EXISTS Migrar_Localidad
DROP PROCEDURE IF EXISTS Migrar_Direccion
DROP PROCEDURE IF EXISTS Migrar_Sucursal
DROP PROCEDURE IF EXISTS Migrar_Cliente
DROP PROCEDURE IF EXISTS Migrar_Proveedor
DROP PROCEDURE IF EXISTS Migrar_Pedido
DROP PROCEDURE IF EXISTS Migrar_Compra
DROP PROCEDURE IF EXISTS Migrar_Factura
DROP PROCEDURE IF EXISTS Migrar_Modelo_Sillon
DROP PROCEDURE IF EXISTS Migrar_Medida_Sillon
DROP PROCEDURE IF EXISTS Migrar_Material
DROP PROCEDURE IF EXISTS Migrar_Tela
DROP PROCEDURE IF EXISTS Migrar_Madera
DROP PROCEDURE IF EXISTS Migrar_Relleno
DROP PROCEDURE IF EXISTS Migrar_Sillon
DROP PROCEDURE IF EXISTS Migrar_Material_Sillon
DROP PROCEDURE IF EXISTS Migrar_Item_Detalle_Pedido
DROP PROCEDURE IF EXISTS Migrar_Envio
GO



--Migracion de las Provincias

CREATE PROCEDURE Migrar_Provincia
AS
BEGIN


    INSERT INTO QUERYOSOS.Provincia (nombre)
    SELECT DISTINCT 
        Maestra.Sucursal_Provincia
    FROM gd_esquema.Maestra
    WHERE Maestra.Sucursal_Provincia IS NOT NULL
      AND NOT EXISTS (
          SELECT 1 
          FROM QUERYOSOS.Provincia P 
          WHERE P.nombre = Maestra.Sucursal_Provincia
      );

    INSERT INTO QUERYOSOS.Provincia (nombre)
    SELECT DISTINCT 
        Maestra.Cliente_Provincia
    FROM gd_esquema.Maestra
    WHERE Maestra.Cliente_Provincia IS NOT NULL
      AND NOT EXISTS (
          SELECT 1 
          FROM QUERYOSOS.Provincia P 
          WHERE P.nombre = Maestra.Cliente_Provincia
      );

    INSERT INTO QUERYOSOS.Provincia (nombre)
    SELECT DISTINCT 
        Maestra.Proveedor_Provincia
    FROM gd_esquema.Maestra
    WHERE Maestra.Proveedor_Provincia IS NOT NULL
      AND NOT EXISTS (
          SELECT 1 
          FROM QUERYOSOS.Provincia P 
          WHERE P.nombre = Maestra.Proveedor_Provincia
      );
END;

GO



 

----------------------------
--Migracion de las Localidades
----------------------------
CREATE PROCEDURE Migrar_Localidad
AS
BEGIN

    -- Sucursal
    INSERT INTO QUERYOSOS.Localidad (nombre, idProvincia)
    SELECT DISTINCT 
        M.Sucursal_Localidad,
        P.idProvincia
    FROM gd_esquema.Maestra M
    INNER JOIN QUERYOSOS.Provincia P ON P.nombre = M.Sucursal_Provincia
    WHERE M.Sucursal_Localidad IS NOT NULL
      AND NOT EXISTS (
          SELECT 1 
          FROM QUERYOSOS.Localidad L 
          WHERE L.nombre = M.Sucursal_Localidad AND L.idProvincia = P.idProvincia
      );

    -- Cliente
    INSERT INTO QUERYOSOS.Localidad (nombre, idProvincia)
    SELECT DISTINCT 
        M.Cliente_Localidad,
        P.idProvincia
    FROM gd_esquema.Maestra M
    JOIN QUERYOSOS.Provincia P ON P.nombre = M.Cliente_Provincia
    WHERE M.Cliente_Localidad IS NOT NULL
      AND NOT EXISTS (
          SELECT 1 
          FROM QUERYOSOS.Localidad L 
          WHERE L.nombre = M.Cliente_Localidad AND L.idProvincia = P.idProvincia
      );

    -- Proveedor
    INSERT INTO QUERYOSOS.Localidad (nombre, idProvincia)
    SELECT DISTINCT 
        M.Proveedor_Localidad,
        P.idProvincia
    FROM gd_esquema.Maestra M
    JOIN QUERYOSOS.Provincia P ON P.nombre = M.Proveedor_Provincia
    WHERE M.Proveedor_Localidad IS NOT NULL
      AND NOT EXISTS (
          SELECT 1 
          FROM QUERYOSOS.Localidad L 
          WHERE L.nombre = M.Proveedor_Localidad AND L.idProvincia = P.idProvincia
      );
END;
GO



-----------------------------
--Migracion de las Direcciones
-------------------------------
CREATE PROCEDURE Migrar_Direccion
AS
BEGIN
    -- Cliente
    INSERT INTO QUERYOSOS.Direccion (idLocalidad, direccion)
    SELECT DISTINCT l.idLocalidad, m.Cliente_Direccion
    FROM gd_esquema.Maestra m
     JOIN QUERYOSOS.Provincia p ON p.nombre = m.Cliente_Provincia
     JOIN QUERYOSOS.Localidad l ON l.nombre = m.Cliente_Localidad AND l.idProvincia = p.idProvincia
    WHERE m.Cliente_Direccion IS NOT NULL
      AND NOT EXISTS (
          SELECT 1 FROM QUERYOSOS.Direccion d
          WHERE d.direccion = m.Cliente_Direccion AND d.idLocalidad = l.idLocalidad
      );

    -- Sucursal
    INSERT INTO QUERYOSOS.Direccion (idLocalidad, direccion)
    SELECT DISTINCT l.idLocalidad, m.Sucursal_Direccion
    FROM gd_esquema.Maestra m
     JOIN QUERYOSOS.Provincia p ON p.nombre = m.Sucursal_Provincia
     JOIN QUERYOSOS.Localidad l ON l.nombre = m.Sucursal_Localidad AND l.idProvincia = p.idProvincia
    WHERE m.Sucursal_Direccion IS NOT NULL
      AND NOT EXISTS (
          SELECT 1 FROM QUERYOSOS.Direccion d
          WHERE d.direccion = m.Sucursal_Direccion AND d.idLocalidad = l.idLocalidad
      );

    -- Proveedor
    INSERT INTO QUERYOSOS.Direccion (idLocalidad, direccion)
    SELECT DISTINCT l.idLocalidad, m.Proveedor_Direccion
    FROM gd_esquema.Maestra m
     JOIN QUERYOSOS.Provincia p ON p.nombre = m.Proveedor_Provincia
     JOIN QUERYOSOS.Localidad l ON l.nombre = m.Proveedor_Localidad AND l.idProvincia = p.idProvincia
    WHERE m.Proveedor_Direccion IS NOT NULL
      AND NOT EXISTS (
          SELECT 1 FROM QUERYOSOS.Direccion d
          WHERE d.direccion = m.Proveedor_Direccion AND d.idLocalidad = l.idLocalidad
      );
END;
GO
----------------------------------------------
--Migracion de Motivo de Cancelacion del Pedido
----------------------------------------------
INSERT INTO Queryosos.Motivo_cancelacion_pedido (nombre)
SELECT DISTINCT Pedido_Cancelacion_Motivo
from gd_esquema.Maestra
where Pedido_Cancelacion_Motivo is not null
GO

-----------------------------------
--Migracion de Estados del Pedido
--------------------------------
INSERT INTO QUERYOSOS.Estado (estado)
SELECT DISTINCT Pedido_Estado
FROM gd_esquema.Maestra
where Pedido_Estado is not NULL

-----------------------
GO 





--MIGRAMOS LAS SUCURSALES--

CREATE PROCEDURE Migrar_Sucursal
AS 
BEGIN
	INSERT INTO QUERYOSOS.Sucursal(numeroSucursal,telefono,idDireccion,mail)

	SELECT DISTINCT  m.Sucursal_NroSucursal,m.Sucursal_telefono,d.idDireccion,m.Sucursal_mail
	FROM gd_esquema.Maestra m
	JOIN QUERYOSOS.Direccion d on m.Sucursal_Direccion=d.direccion JOIN
	QUERYOSOS.Localidad l on l.nombre=m.Sucursal_Localidad and d.idLocalidad=l.idLocalidad
	JOIN QUERYOSOS.Provincia p on p.nombre=m.Sucursal_Provincia and p.idProvincia=l.idProvincia
END

--MIGRAMOS LOS CLIENTES--
GO

CREATE PROCEDURE Migrar_Cliente
AS 
BEGIN
	INSERT INTO QUERYOSOS.Cliente(nombre,apellido,nroDocumento,mail,idDireccion,telefono,fechaNacimiento)

	SELECT DISTINCT m.Cliente_Nombre,m.Cliente_Apellido,m.Cliente_Dni,m.Cliente_Mail,d.idDireccion,m.Cliente_Telefono,m.Cliente_FechaNacimiento
	FROM gd_esquema.Maestra m
	JOIN QUERYOSOS.Direccion d on m.Cliente_Direccion=d.direccion JOIN
	QUERYOSOS.Localidad l on l.nombre=m.Cliente_Localidad and d.idLocalidad=l.idLocalidad
	JOIN QUERYOSOS.Provincia p on p.nombre=m.Cliente_Provincia and p.idProvincia=l.idProvincia 
END

GO


---MIGRAMOS LOS PROVEEDORES

CREATE PROCEDURE Migrar_Proveedor
AS 
BEGIN
	INSERT INTO QUERYOSOS.Proveedor(mail,telefono,idDireccion,razonSocial,cuit)
	SELECT DISTINCT m.Proveedor_Mail,m.Proveedor_Telefono,d.idDireccion,m.Proveedor_RazonSocial,m.Proveedor_Cuit
	FROM gd_esquema.Maestra m
	JOIN QUERYOSOS.Direccion d on m.Proveedor_Direccion=d.direccion JOIN
	QUERYOSOS.Localidad l on l.nombre=m.Proveedor_Localidad and d.idLocalidad=l.idLocalidad
	JOIN QUERYOSOS.Provincia p on m.Proveedor_Provincia=p.nombre and l.idProvincia=p.idProvincia 

END


GO




------MIGRAMOS LOS PEDIDOS 

CREATE PROCEDURE Migrar_Pedido
AS 
BEGIN
	INSERT INTO  QUERYOSOS.Pedido(nroDePedido,fechaCancelacion,precioTotal,idCliente,estadoActual,idSucursal,idMotivoCancelacion,fechaYHora)
	SELECT DISTINCT Pedido_Numero,Pedido_Cancelacion_Fecha,Pedido_Total,c.idCliente,e.idEstado,s.idSucursal,mot.id_motivo_cancelacion,m.Pedido_Fecha
	FROM gd_esquema.Maestra m JOIN QUERYOSOS.Cliente c on m.Cliente_Nombre=c.nombre and m.Cliente_Apellido=c.apellido
	and m.Cliente_FechaNacimiento=c.fechaNacimiento and c.mail=m.Cliente_Mail and c.nroDocumento=m.Cliente_Dni 
	and c.telefono=m.Cliente_Telefono JOIN QUERYOSOS.Direccion d on d.direccion=m.Cliente_Direccion JOIN Queryosos.Localidad l
	on Cliente_Localidad=l.nombre and d.idLocalidad=l.idLocalidad and c.idDireccion=d.idDireccion JOIN QUERYOSOS.Estado e on m.Pedido_Estado=e.estado
	JOIN QUERYOSOS.Sucursal s on m.Sucursal_NroSucursal=s.numeroSucursal JOIN QUERYOSOS.Direccion d2 ON m.Sucursal_Direccion=d2. direccion and 
	d2.idDireccion=s.idDireccion  LEFT JOIN QUERYOSOS.Motivo_cancelacion_pedido mot on m.Pedido_Cancelacion_Motivo=mot.nombre
	where Detalle_Pedido_Cantidad is null
END

GO


--------------------------------------
------MIGRAMOS LAS COMPRAS------------
-------------------------------------



CREATE PROCEDURE Migrar_Compra
AS 
BEGIN
	INSERT INTO QUERYOSOS.Compra(nroDeCompra,idSucursal,idProveedor,fechaCompra,total_compra)
	SELECT DISTINCT m.Compra_Numero,s1.idSucursal,p1.idProveedor,m.Compra_Fecha,m.Compra_Total
	FROM gd_esquema.Maestra m JOIN Queryosos.Proveedor p1 on 
	m.Proveedor_Cuit=p1.cuit and m.Proveedor_Mail=p1.mail and p1.telefono=m.Proveedor_Telefono LEFT JOIN  QUERYOSOS.Sucursal s1 on m.Sucursal_NroSucursal=s1.numeroSucursal
	and m.Sucursal_mail=s1.mail and m.Sucursal_telefono=s1.telefono 
	where m.Compra_Numero is not null
END

GO

--------------------------------------
------MIGRAMOS LAS FACTURAS------------
-------------------------------------


CREATE PROCEDURE Migrar_Factura
AS 
BEGIN
	INSERT INTO QUERYOSOS.Factura(nroFactura,idCliente,idSucursal,fechaYHora,importeTotal)
	SELECT DISTINCT m.Factura_Numero,c.idCliente,s.idSucursal,m.Factura_Fecha,m.Factura_Total
	 FROM gd_esquema.Maestra m JOIN QUERYOSOS.Cliente c on m.Cliente_Nombre=c.nombre and m.Cliente_Apellido=c.apellido
	and m.Cliente_FechaNacimiento=c.fechaNacimiento and c.mail=m.Cliente_Mail and c.nroDocumento=m.Cliente_Dni 
	and c.telefono=m.Cliente_Telefono JOIN QUERYOSOS.Direccion d on d.direccion=m.Cliente_Direccion JOIN Queryosos.Localidad l
	on Cliente_Localidad=l.nombre and d.idLocalidad=l.idLocalidad and c.idDireccion=d.idDireccion JOIN QUERYOSOS.Sucursal s on m.Sucursal_NroSucursal=s.numeroSucursal JOIN QUERYOSOS.Direccion d2 ON m.Sucursal_Direccion=d2. direccion and 
	d2.idDireccion=s.idDireccion 
	where Detalle_Factura_Cantidad is null and m.Factura_Numero is not null

END
GO
SELECT * FROM QUERYOSOS.ItemDetallePedido

--------------------------------------
------MIGRAMOS LOS ENVIOS------------
-------------------------------------
CREATE PROCEDURE Migrar_Envio
AS
BEGIN
	INSERT INTO QUERYOSOS.Envio (nroDeEnvio,nroDeFactura,fechaProgramada,fechaYHoraEntrega,importeTraslado,importeSubida,envioTotal)
	SELECT DISTINCT m.Envio_Numero,f.nroFactura,m.Envio_Fecha_Programada,m.Envio_Fecha,m.Envio_ImporteTraslado,m.Envio_importeSubida,m.Envio_Total
	FROM gd_esquema.Maestra m join QUERYOSOS.Factura f on m.Factura_Numero=f.nroFactura 
	where m.Envio_Numero is not null
END 
GO
----------------------
----MIGRAMOS LOS MODELOS DE SILLONES-----
---------------------------------------


go
CREATE PROCEDURE Migrar_Modelo_Sillon
AS
BEGIN
	INSERT INTO QUERYOSOS.Modelo(sillon_modelo_codigo,precio,descripcion)
	SELECT DISTINCT Sillon_Modelo_Codigo,Sillon_Modelo_Precio,Sillon_Modelo_Descripcion FROM gd_esquema.Maestra
	WHERE Sillon_Modelo_Codigo is not null
END
go

---------------------------------------
----MIGRAMOS LAS MEDIDAS DE SILLONES-----
---------------------------------------
CREATE PROCEDURE Migrar_Medida_Sillon
AS
BEGIN
	INSERT INTO QUERYOSOS.Medida(ancho,profundidad,alto,precio)
	SELECT DISTINCT m.Sillon_Medida_Ancho,Sillon_Medida_Profundidad,Sillon_Medida_Alto,Sillon_Medida_Precio  FROM gd_esquema.Maestra m
	WHERE Sillon_Medida_Ancho is not null and Sillon_Medida_Alto is not null and Sillon_Medida_Profundidad is not null

END
go



---------------------------------------
----MIGRAMOS LA TABLA MATERIAL-----
---------------------------------------

CREATE PROCEDURE Migrar_Material
AS
BEGIN
	INSERT INTO QUERYOSOS.Material(tipo,nombre,descripcion)
	SELECT DISTINCT m.Material_Tipo,m.Material_Nombre,m.Material_Descripcion  FROM gd_esquema.Maestra m
	WHERE m.Material_Tipo is not null and m.Material_Nombre is not null and m.Material_Descripcion is not null

END
go

---------------------------------------
----MIGRAMOS DATOS A LA TABLA TELA -----------
---------------------------------------

CREATE PROCEDURE Migrar_Tela
AS
BEGIN
	INSERT INTO QUERYOSOS.Tela(IdMaterial,telaColor,telaTextura,precio_material)
	SELECT DISTINCT mat.idMaterial,m.Tela_Color,m.Tela_Textura,m.Material_Precio
	FROM gd_esquema.Maestra m JOIN QUERYOSOS.Material mat on mat.tipo=m.Material_Tipo
	and mat.nombre=m.Material_Nombre and mat.descripcion=m.Material_Descripcion 
	where m.Material_Tipo='Tela'
END
go

---------------------------------------
----MIGRAMOS DATOS A LA TABLA MADERA -----------
---------------------------------------
CREATE PROCEDURE Migrar_Madera
AS
BEGIN
	INSERT INTO QUERYOSOS.Madera(IdMaterial,maderaColor,maderaDureza,precio_material)
	SELECT DISTINCT mat.idMaterial,m.Madera_Color,m.Madera_Dureza,m.Material_Precio
	FROM gd_esquema.Maestra m JOIN QUERYOSOS.Material mat on mat.tipo=m.Material_Tipo
	and mat.nombre=m.Material_Nombre and mat.descripcion=m.Material_Descripcion 
	where m.Material_Tipo='Madera'
END
go

---------------------------------------
----MIGRAMOS DATOS A LA TABLA RELLENO -----------
---------------------------------------

CREATE PROCEDURE Migrar_Relleno
AS
BEGIN
	INSERT INTO QUERYOSOS.Relleno(IdMaterial,rellenoDensidad,precio_material)
	SELECT DISTINCT mat.idMaterial,m.Relleno_Densidad,m.Material_Precio
	FROM gd_esquema.Maestra m JOIN QUERYOSOS.Material mat on mat.tipo=m.Material_Tipo
	and mat.nombre=m.Material_Nombre and mat.descripcion=m.Material_Descripcion 
	where m.Material_Tipo='Relleno'
END
go


---------------------------------------
----MIGRAMOS DATOS A LA TABLA SILLON -----------
---------------------------------------

CREATE PROCEDURE Migrar_Sillon
AS
BEGIN
	INSERT INTO QUERYOSOS.Sillon(SillonCodigo,SillonModeloCodigo,idMedidaSillon,precioUnitario)
	SELECT DISTINCT m.Sillon_Codigo,m.Sillon_Modelo_Codigo,medida.idMedidaSillon, m.Sillon_Modelo_Precio+m.Sillon_Medida_Precio+sum(m.Material_Precio)
	FROM gd_esquema.Maestra m JOIN QUERYOSOS.Medida medida on m.Sillon_Medida_Ancho=medida.ancho and m.Sillon_Medida_Precio=medida.precio
	and m.Sillon_Medida_Alto=medida.alto and m.Sillon_Medida_Profundidad=medida.profundidad
	Where m.Sillon_Codigo is not null and m.Sillon_Modelo_Codigo is not null
	GROUP BY m.Sillon_Codigo,m.Sillon_Modelo_Codigo,medida.idMedidaSillon,m.Sillon_Modelo_Precio,Sillon_Medida_Precio
END
go

----------------------------------------------------------------
----MIGRAMOS DATOS A LA TABLA INTERMEDIA Material_Sillon -----------
----------------------------------------------------------------

CREATE PROCEDURE Migrar_Material_Sillon
AS
BEGIN
	INSERT INTO QUERYOSOS.MaterialSillon(idSillon,idMaterial)
	SELECT DISTINCT s.idSillon, material.idMaterial
	FROM gd_esquema.Maestra m JOIN QUERYOSOS.Sillon s
	on s.SillonCodigo=m.Sillon_Codigo
	and s.SillonModeloCodigo=m.Sillon_Modelo_Codigo
	JOIN QUERYOSOS.Medida med on s.idMedidaSillon=med.idMedidaSillon
	JOIN QUERYOSOS.Material material on  material.nombre=m.Material_Nombre
	and material.tipo=m.Material_Tipo  and m.Material_Descripcion=material.descripcion

	
END
go

----------------------------------------------------------------
----MIGRAMOS DATOS A LA TABLA ItemDetallePedido -----------
----------------------------------------------------------------
CREATE PROCEDURE Migrar_Item_Detalle_Pedido
AS
BEGIN
  INSERT INTO QUERYOSOS.ItemDetallePedido
    ( nroDePedido
    , sillonCodigo    
    , cantidad_pedido
    , subtotal
    , precioUnitario
    )
  SELECT
    m.Pedido_Numero,
    s.idSillon,                      
    m.Detalle_Compra_Cantidad,
    m.Detalle_Compra_SubTotal,
    m.Detalle_Pedido_Precio
  FROM gd_esquema.Maestra AS m
  INNER JOIN QUERYOSOS.Pedido AS p
    ON p.nroDePedido = m.Pedido_Numero
  INNER JOIN QUERYOSOS.Sillon AS s
    ON s.SillonCodigo       = m.Sillon_Codigo
   AND s.SillonModeloCodigo = m.Sillon_Modelo_Codigo;
END;
GO

----------------------------------------------------------------
----MIGRAMOS DATOS A LA TABLA ItemDetalleFactura -----------
----------------------------------------------------------------
CREATE PROCEDURE Migrar_Item_Detalle_Factura
AS
BEGIN
  INSERT INTO QUERYOSOS.ItemDetallefactura
    (nroFactura --FK, PK
	, id_item_pedido -- FK, PK
	, detalle_factura_precio, detalle_factura_cantidad, detalle_factura_subtotal)
  SELECT
    f.nroFactura,
    p.id_item_pedido,                      
    m.Detalle_Factura_Precio,
    m.Detalle_Factura_Cantidad,
    m.Detalle_Factura_SubTotal
  FROM gd_esquema.Maestra AS m
    JOIN QUERYOSOS.Factura AS f ON nroFactura = m.Factura_Numero
	JOIN QUERYOSOS.ItemDetallePedido AS p ON id_item_pedido = p.id_item_pedido;
END;
GO


----------------------------------------------------------------
----MIGRAMOS DATOS A LA TABLA ITEM_DETALLE_PEDIDO -----------
----------------------------------------------------------------

-----------------------------------------
-----------------------------------------
------EJECUTAMOS LOS PROCEDURES PARA HACER
-------EFECTIVAS LAS MIGRACIONES (RESPETAR ORDEN)---------
-----------------------------------------
------------------------------------

EXEC Migrar_Provincia
EXEC Migrar_Localidad
EXEC Migrar_Direccion
EXEC Migrar_Sucursal
EXEC Migrar_Cliente
EXEC Migrar_Proveedor
EXEC Migrar_Pedido
EXEC Migrar_Compra
EXEC Migrar_Factura
EXEC Migrar_Envio
EXEC Migrar_Modelo_Sillon
EXEC Migrar_Medida_Sillon
EXEC Migrar_Material
EXEC Migrar_Tela
EXEC Migrar_Madera
EXEC Migrar_Relleno
EXEC Migrar_Sillon
EXEC Migrar_Material_Sillon
EXEC Migrar_Item_Detalle_Pedido
EXEC Migrar_Item_Detalle_Factura



















