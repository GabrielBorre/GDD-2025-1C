
CREATE SCHEMA QUERYOSOS

CREATE TABLE Pedido(nroDePedido decimal(18,0),
fechaYHora DateTime2(6),
precioTotal decimal(18,2),
idCliente INTEGER,
estadoActual Integer, 
idSucursal Integer, 
pagado BIT, 
fechaCancelacion DATETIME2(6), 
motivoCancelacion Varchar(255))


CREATE TABLE ITEM_DETALLE_PEDIDO (idPedido Integer,
idSillon Integer,
cantidad_pedido BigInt,
cantidad_factura decimal(18,0),
subtotal decimal(18,2),
precioUnitario decimal(18,2),
idFactura integer)


CREATE TABLE FACTURA (nroFactura BIGINT,
idCliente Integer,
idSucursal Integer,
fechaYHora DateTime2(6),
importeTotal decimal(38,2)
)

CREATE TABLE Cliente (idCliente Integer,
nombre NVarchar(255),
apellido NVarchar(255),
nroDocumento BIGINT,
tipoDocumento NVARCHAR(255),
fechaNacimiento NVARCHAR(255),
mail NVARCHAR(255),
telefono NVARCHAR(255),
idDireccion Integer
)

CREATE TABLE Envio (nroDeEnvio Decimal(18,0),
nroDeFactura BIGINT,
fechaProgramada DateTime2(6),
fechaYHoraEntrega DateTime2(6),
importeTraslado decimal(18,2),
importeSubida decimal (18,2),
pisos_a_subir Integer,
envioTotal decimal(18,2)
)




