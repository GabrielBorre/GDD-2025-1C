--23 tablas

CREATE SCHEMA QUERYOSOS

CREATE TABLE Pedido(nroDePedido decimal(18,0),
fechaYHora DateTime2(6),
precioTotal decimal(18,2),
idCliente Integer,
estadoActual Integer, 
idSucursal Integer, 
fechaCancelacion DateTime2(6), 
motivoCancelacion Varchar(255))
)

CREATE TABLE ItemDetallePedido (id_item_pedido Integer,
idPedido Integer,
idSillon Integer,
cantidad_pedido BigInt,
subtotal decimal(18,2),
precioUnitario decimal(18,2),
)

CREATE TABLE Factura (nroFactura BIGINT,
idCliente Integer,
idSucursal Integer,
fechaYHora DateTime2(6),
importeTotal decimal(38,2)
)

CREATE TABLE Cliente (idCliente Integer,
nombre NVarchar(255),
apellido NVarchar(255),
nroDocumento BigInt,
fechaNacimiento DateTime2(6),
mail NVARCHAR(255),
telefono NVARCHAR(255),
idDireccion Integer
)

CREATE TABLE Envio (nroDeEnvio Decimal(18,0),
nroDeFactura BigInt,
fechaProgramada DateTime2(6),
fechaYHoraEntrega DateTime2(6),
importeTraslado decimal(18,2),
importeSubida decimal (18,2),
envioTotal decimal(18,2)
)

CREATE TABLE Compra (nroDeCompra decimal(18,0),
idSucursal Integer,
idProveedor Integer,
fechaCompra dateTime2(6),
total_compra decimal(18,2)
)

CREATE TABLE DetalleCompra(idDetalleCompra Integer,
precioUnitario decimal(18,2),
cantidad decimal(18,0),
subtotal decimal(18,2),
idMaterial Integer
)

Create Table Proveedor (idProveedor Integer,
nombre NVarchar(255),
mail NVarchar(255),
telefono NVarchar(255),
idDireccion Integer,
razonSocial NVarchar(255),
cuit NVarchar(255)
)

CREATE TABLE Sillon (SillonCodigo BigInt,
precioUnitario decimal(18,2),
idModeloSillon Integer,
idMedidaSillon Integer,
codigo BigInt
)

Create Table Modelo (sillon_modelo_codigo BigInt,
precio Decimal(18,2),
descripcion NVarchar(255)
)

Create Table MaterialSillon(idSillon Integer,
idMaterial Integer
)

Create Table Medida(idMedidaSillon Integer,
ancho decimal(18,2),
profundidad decimal(18,2),
alto decimal(18,2),
precio decimal(18,2)
)

Create Table Material(idMaterial Integer,
tipo NVarchar(255),
nombre NVarchar(255),
descripcion NVarchar(255)
)

Create Table Tela(id_tela Integer,
IdMaterial Integer,
telaColor NVarchar(255),
telaTextura NVarchar(255)
precio_material decimal(18,2)
)

Create Table Madera(id_madera Integer,
IdMaterial Integer,
maderaColor NVarchar(255),
maderaDureza NVarchar(255),
precio_material decimal(18,2)
)

Create Table Relleno(id_relleno Integer,
IdMaterial Integer,
rellenoDensidad decimal(18,2),
precio_material decimal(18,2)
)

Create Table Direccion(idDireccion Integer,
idLocalidad Integer,
direccion NVarchar(255)
)

Create Table Localidad(idLocalidad Integer,
nombre NVarchar(255),
idProvincia Integer
)

Create Table Provincia(idProvincia Integer,
nombre NVarchar(255)
)

Create Table Sucursal(idSucursal Integer,
numeroSucursal BigInt,
idDireccion Integer,
telefono NVarchar(255),
mail NVarchar(255)
)

Create Table Motivo_cancelacion_pedido(id_motivo_cancelacion Integer,
nombre NVarchar(255)
)

Create Table Estado(idEstado Integer,
estado NVarchar(255),
idPedido Integer
)

Create Table ItemDetallefactura(nroFactura BigInt,
id_item_pedido Integer,
detalle_factura_precio decimal(18,2)
detalle_factura_cantidad decimal(18,0)
detalle_factura_subtotal decimal(18,2)
)
