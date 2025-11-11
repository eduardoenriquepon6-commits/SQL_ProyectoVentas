Create SCHEMA ventas_directas;

CREATE TABLE ventas_directas.clientes
(
    id INT IDENTITY (1,1) PRIMARY KEY,
    nombre_completo NVARCHAR (150) NOT NULL,
    telefono NVARCHAR (50),
    correo NVARCHAR (150) UNIQUE,
    fecha_registro DATETIME DEFAULT SYSDATETIME()
)

CREATE TABLE ventas_directas.catalogo
(
    id INT IDENTITY (1,1) PRIMARY KEY,
    nombre_producto NVARCHAR (150) NOT NULL,
    descripcion_producto NVARCHAR (300),
    precio_unitario FLOAT NOT NULL,
    activo BIT DEFAULT 1
)

CREATE TABLE ventas_directas.inventario
(
    id INT IDENTITY (1,1) PRIMARY KEY,
    id_producto INT NOT NULL,
    cantidad_disponible INT DEFAULT 0,
    ubicacion NVARCHAR (100)
)

ALTER TABLE ventas_directas.inventario
ADD CONSTRAINT FK_Catalogo_Inventario
FOREIGN KEY (id_producto) REFERENCES ventas_directas.catalogo(id)

CREATE TABLE ventas_directas.Orden_compra
(
    id INT IDENTITY (1,1) PRIMARY KEY,
    id_cliente INT NOT NULL,
    fecha_orden DATETIME DEFAULT SYSDATETIME(),
    total FLOAT NOT NULL,
    estado_pago NVARCHAR (50) DEFAULT 'Pendiente',
    -- Pendiente, pagado, cancelado
    metodo_pago NVARCHAR (50)
)

ALTER TABLE ventas_directas.Orden_compra
ADD CONSTRAINT FK_Cliente_OrdenCompra
FOREIGN KEY (id_cliente) REFERENCES ventas_directas.clientes(id)

CREATE TABLE ventas_directas.Detalle_orden
(
    id INT IDENTITY (1,1) PRIMARY KEY,
    id_orden INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario FLOAT NOT NULL,
    subtotal AS (cantidad * precio_unitario) PERSISTED,
)

ALTER TABLE ventas_directas.Detalle_orden
ADD CONSTRAINT FK_OrdenCompra_DetalleOrden
FOREIGN KEY (id_orden) REFERENCES ventas_directas.Orden_compra(id)

ALTER TABLE ventas_directas.Detalle_orden
ADD CONSTRAINT FK_Catalogo_DetalleOrden
FOREIGN KEY (id_producto) REFERENCES ventas_directas.catalogo(id)