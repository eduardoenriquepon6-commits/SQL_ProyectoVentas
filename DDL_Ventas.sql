CREATE SCHEMA ventas_directas;

CREATE TABLE ventas_directas.usuarios
(
    id INT IDENTITY (1,1) PRIMARY KEY,
    nombre_completo NVARCHAR (150) NOT NULL,
    telefono NVARCHAR (50),
    correo NVARCHAR (150) UNIQUE,
    fecha_registro DATETIME DEFAULT SYSDATETIME()
)

CREATE TABLE ventas_directas.categorias
(
    id INT IDENTITY (1,1) PRIMARY KEY,
    nombre_categoria NVARCHAR (100) NOT NULL
)

CREATE TABLE ventas_directas.productos
(
    id INT IDENTITY (1,1) PRIMARY KEY,
    nombre_producto NVARCHAR (150) NOT NULL,
    descripcion_producto NVARCHAR (300),
    activo BIT DEFAULT 1
)

ALTER TABLE ventas_directas.productos
ADD id_categoria INT NOT NULL;

ALTER TABLE ventas_directas.productos
ADD CONSTRAINT FK_Productos_Categoria
FOREIGN KEY (id_categoria) REFERENCES ventas_directas.categorias(id)


CREATE TABLE ventas_directas.stock
(
    id INT IDENTITY (1,1) PRIMARY KEY,
    id_producto INT NOT NULL,
    cantidad INT DEFAULT 0
)

ALTER TABLE ventas_directas.stock
ADD CONSTRAINT FK_productos_stock
FOREIGN KEY (id_producto) REFERENCES ventas_directas.productos(id)

ALTER TABLE ventas_directas.stock 
ADD precio_unitario FLOAT;

CREATE TABLE ventas_directas.Orden_pedido
(
    id INT IDENTITY (1,1) PRIMARY KEY,
    id_usuario INT NOT NULL,
    fecha_orden DATETIME DEFAULT SYSDATETIME(),
    estado_pago NVARCHAR (50) DEFAULT 'Pendiente',
    metodo_pago NVARCHAR (50)
)

ALTER TABLE ventas_directas.Orden_pedido
ADD CONSTRAINT FK_usuario_OrdenPedido
FOREIGN KEY (id_usuario) REFERENCES ventas_directas.usuarios(id)

CREATE TABLE ventas_directas.Detalle_pedido
(
    id INT IDENTITY (1,1) PRIMARY KEY,
    id_orden INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario FLOAT NOT NULL,
    subtotal AS (cantidad * precio_unitario) PERSISTED,
)

ALTER TABLE ventas_directas.Detalle_pedido
ADD CONSTRAINT FK_OrdenPedido_DetallePedido
FOREIGN KEY (id_orden) REFERENCES ventas_directas.Orden_pedido(id)

ALTER TABLE ventas_directas.Detalle_pedido
ADD CONSTRAINT FK_productos_DetallePedido
FOREIGN KEY (id_producto) REFERENCES ventas_directas.productos(id)
