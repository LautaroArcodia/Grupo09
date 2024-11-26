/*
Enunciado:

Cuando un cliente reclama la devolución de un producto se genera una nota de crédito por el
valor del producto o un producto del mismo tipo.
En el caso de que el cliente solicite la nota de crédito, solo los Supervisores tienen el permiso
para generarla.
Tener en cuenta que la nota de crédito debe estar asociada a una Factura con estado pagada.
Asigne los roles correspondientes para poder cumplir con este requisito.
Por otra parte, se requiere que los datos de los empleados se encuentren encriptados, dado
que los mismos contienen información personal.
La información de las ventas es de vital importancia para el negocio, por ello se requiere que
se establezcan políticas de respaldo tanto en las ventas diarias generadas como en los
reportes generados.
Plantee una política de respaldo adecuada para cumplir con este requisito y justifique la
misma.

Fecha de entrega: 15/11/2024
Numero de grupo: 9
Nombre de la materia: Bases de Datos Aplicadas
Alumnos:
Arcodia Lautaro	     DNI: 41588362
Gorosito Candela     DNI: 43896171
Paez Maximiliano     DNI: 44004413
*/

USE Com5600G09;
GO

--===============================================
-- Inicio creacion roles
--===============================================

IF NOT EXISTS (SELECT 1 
				FROM sys.database_principals 
				WHERE type = 'R' 
				AND name = 'Vendedor')
	CREATE ROLE Vendedor;
GO

IF NOT EXISTS (SELECT 1 
				FROM sys.database_principals 
				WHERE type = 'R' 
				AND name = 'Supervisor')
	CREATE ROLE Supervisor;
GO

IF NOT EXISTS (SELECT 1 
				FROM sys.database_principals 
				WHERE type = 'R' 
				AND name = 'Administrador')
	CREATE ROLE Administrador;
GO

--===============================================
-- Fin creacion roles
--===============================================
--===============================================
-- Inicio creacion permisos rol Administrador
--===============================================

GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::administracion TO Administrador;
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::ventas TO Administrador;
GRANT EXECUTE ON SCHEMA::administracion TO Administrador;
GRANT EXECUTE ON SCHEMA::ventas TO Administrador;

--===============================================
-- Fin creacion permisos rol Administrador
--===============================================
--===============================================
-- Inicio creacion permisos rol Supervisor
--===============================================

GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::ventas TO Supervisor;
GRANT EXECUTE ON SCHEMA::ventas TO Supervisor;

GRANT SELECT, INSERT, UPDATE, DELETE ON administracion.Producto TO Supervisor;
GRANT SELECT, INSERT, UPDATE, DELETE ON administracion.NotaDeCredito TO Supervisor;
GRANT SELECT, INSERT, UPDATE, DELETE ON administracion.DetalleNotaDeCredito TO Supervisor;

GRANT SELECT ON administracion.Empleado TO Supervisor;
GRANT SELECT ON administracion.FacturaControl TO Supervisor;

GRANT EXECUTE ON administracion.InsertarProducto TO Supervisor;
GRANT EXECUTE ON administracion.ModificarProducto TO Supervisor;
GRANT EXECUTE ON administracion.EliminarProducto TO Supervisor;

GRANT EXECUTE ON TYPE::administracion.DetalleNotaDeCreditoVar TO Supervisor;
GRANT EXECUTE ON administracion.InsertarNotaDeCreditoConDetalles TO Supervisor;
GRANT EXECUTE ON administracion.CancelarNotaDeCredito TO Supervisor;

--===============================================
-- Fin creacion permisos rol Administrador
--===============================================
--===============================================
-- Inicio creacion permisos rol Vendedor
--===============================================

GRANT SELECT, INSERT ON ventas.Venta TO Vendedor;
GRANT SELECT, INSERT ON ventas.DetalleVenta TO Vendedor;

DENY SELECT, INSERT, UPDATE, DELETE ON SCHEMA::administracion TO Vendedor;
DENY EXECUTE ON SCHEMA::administracion TO Vendedor;

-- Ventas
GRANT EXECUTE ON ventas.IniciarVenta TO Vendedor;
GRANT EXECUTE ON ventas.AgregarDetalleVenta TO Vendedor;
GRANT EXECUTE ON ventas.ConfirmarVenta TO Vendedor;
GRANT EXECUTE ON ventas.ConfirmarPago TO Vendedor;
GRANT EXECUTE ON ventas.CambiarMetodoPago TO Vendedor;
GRANT EXECUTE ON ventas.CancelarVenta TO Vendedor;

-- Clientes
GRANT EXECUTE ON ventas.InsertarCliente TO Vendedor;
GRANT EXECUTE ON ventas.ModificarCliente TO Vendedor;
GRANT EXECUTE ON ventas.EliminarCliente TO Vendedor;

--===============================================
-- Fin creacion permisos rol Vendedor
--===============================================