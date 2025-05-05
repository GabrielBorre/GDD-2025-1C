--23 tablas

CREATE SCHEMA QUERYOSOS 
--esto me parece q no va 


CREATE TABLE Pedido(
nroDePedido decimal(18,0) PRIMARY KEY,
fechaYHora DateTime2(6),
precioTotal decimal(18,2),
idCliente Integer,
estadoActual Integer, 
idSucursal Integer, 
fechaCancelacion DateTime2(6), 
motivoCancelacion Varchar(255))
)

CREATE TABLE ItemDetallePedido (
id_item_pedido Integer PRIMARY KEY,
nroDePedido decimal(18,0),
sillonCodigo BigInt,
cantidad_pedido BigInt,
subtotal decimal(18,2),
precioUnitario decimal(18,2),
)

CREATE TABLE Factura (
nroFactura BIGINT PRIMARY KEY,
idCliente Integer,
idSucursal Integer,
fechaYHora DateTime2(6),
importeTotal decimal(38,2)
)

CREATE TABLE Cliente (
idCliente Integer PRIMARY KEY,
nombre NVarchar(255),
apellido NVarchar(255),
nroDocumento BigInt,
fechaNacimiento DateTime2(6),
mail NVARCHAR(255),
telefono NVARCHAR(255),
idDireccion Integer
)

CREATE TABLE Envio (
nroDeEnvio Decimal(18,0) PRIMARY KEY,
nroDeFactura BigInt,
fechaProgramada DateTime2(6),
fechaYHoraEntrega DateTime2(6),
importeTraslado decimal(18,2),
importeSubida decimal (18,2),
envioTotal decimal(18,2)
)

CREATE TABLE Compra (
nroDeCompra decimal(18,0) PRIMARY KEY,
idSucursal Integer,
idProveedor Integer,
fechaCompra dateTime2(6),
total_compra decimal(18,2)
)

CREATE TABLE DetalleCompra(
idDetalleCompra Integer PRIMARY KEY,
precioUnitario decimal(18,2),
cantidad decimal(18,0),
subtotal decimal(18,2),
idMaterial Integer
)

Create Table Proveedor (
idProveedor Integer PRIMARY KEY,
nombre NVarchar(255),
mail NVarchar(255),
telefono NVarchar(255),
idDireccion Integer,
razonSocial NVarchar(255),
cuit NVarchar(255)
)

CREATE TABLE Sillon (
SillonCodigo BigInt PRIMARY KEY,
precioUnitario decimal(18,2),
SillonModeloCodigo BigInt,
idMedidaSillon Integer,
codigo BigInt
)

Create Table Modelo (
sillon_modelo_codigo BigInt PRIMARY KEY,
precio Decimal(18,2),
descripcion NVarchar(255)
)

Create Table Medida(
idMedidaSillon Integer PRIMARY KEY,
ancho decimal(18,2),
profundidad decimal(18,2),
alto decimal(18,2),
precio decimal(18,2)
)

Create Table Material(
idMaterial Integer PRIMARY KEY,
tipo NVarchar(255),
nombre NVarchar(255),
descripcion NVarchar(255)
)

Create Table MaterialSillon(
idSillon Integer,
idMaterial Integer, 
PRIMARY KEY(idSillon, idMaterial),
FOREIGN KEY (idSillon) REFERENCES Sillon(SillonCodigo), --tipo de dato no coincide, o es big int o es integer 
FOREIGN KEY (idMaterial) REFERENCES Material(idMaterial)
)


Create Table Tela(
id_tela Integer PRIMARY KEY,
IdMaterial Integer,
telaColor NVarchar(255),
telaTextura NVarchar(255),
precio_material decimal(18,2)
)

Create Table Madera(
id_madera Integer PRIMARY KEY,
IdMaterial Integer,
maderaColor NVarchar(255),
maderaDureza NVarchar(255),
precio_material decimal(18,2)
)

Create Table Relleno(
id_relleno Integer PRIMARY KEY,
IdMaterial Integer,
rellenoDensidad decimal(18,2),
precio_material decimal(18,2)
)

Create Table Direccion(
idDireccion Integer PRIMARY KEY,
idLocalidad Integer,
direccion NVarchar(255)
)

Create Table Localidad(
idLocalidad Integer PRIMARY KEY,
nombre NVarchar(255),
idProvincia Integer
)

Create Table Provincia(
idProvincia Integer PRIMARY KEY,
nombre NVarchar(255)
)

Create Table Sucursal(
idSucursal Integer PRIMARY KEY,
numeroSucursal BigInt,
idDireccion Integer,
telefono NVarchar(255),
mail NVarchar(255)
)

Create Table Motivo_cancelacion_pedido(
id_motivo_cancelacion Integer PRIMARY KEY,
nombre NVarchar(255)
)

Create Table Estado(
idEstado Integer PRIMARY KEY,
estado NVarchar(255),
idPedido Integer
)

Create Table ItemDetallefactura(
nroFactura BigInt PRIMARY KEY,
id_item_pedido Integer,
detalle_factura_precio decimal(18,2),
detalle_factura_cantidad decimal(18,0),
detalle_factura_subtotal decimal(18,2)
)
