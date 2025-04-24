
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


CREATE TABLE Item_detalle_pedido (idPedido Integer,
idSillon Integer,
cantidad_pedido BigInt,
cantidad_factura decimal(18,0),
subtotal decimal(18,2),
precioUnitario decimal(18,2),
idFactura integer)


CREATE TABLE Factura (nroFactura BIGINT,
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
CREATE TABLE Compra (nroDeCompra decimal(18,0),
idSucursal Integer,
idProveedor Integer,
fechaCompra dateTime2(6),
idDetalleCompra Integer,
total_compra decimal(18,2)
)

CREATE TABLE DetalleCompra(
	idDetalleCompra Integer,
	precioUnitario decimal(18,2),
	cantidad decimal(18,0),
	subtotal decimal(18,2),
	idMaterial Integer
)

Create Table Proveedor (idProveedor Integer,
nombre NVarchar(255),
mail NVarchar(255),
telefono NVarchar(255),
idDireccion NVarchar(255),
razonSocial NVarchar(255),
cuit NVarchar(255)
)


CREATE TABLE Sillon (idSillon Integer,
precioUnitario decimal(18,2),
idModeloSillon Integer,
idMedidaSillon Integer,
codigo BigInt
)

Create Table Modelo( idModeloSillon Integer,
precio Decimal(18,2),
codigo NVarchar(255),
descripcion NVarchar(255)

)

Create Table MaterialSillon(idMaterial Integer,
tipo NVarchar(255),
nombre NVarchar(255),
precioAdicional decimal(38,2),
carcteristica NVarchar(255),
descripcion NVarchar(255),
telaColor NVarchar(255),
telaTextura NVarchar(255),
maderaColor NVarchar(255),
maderaDureza NVarchar(255),
rellenoDensidad NVarchar(255)
)

Create Table Material_Sillon(idSillon Integer,
idMaterial Integer)

