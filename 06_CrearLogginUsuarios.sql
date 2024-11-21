--======================================================
-- Inicio creacion de loggin
--======================================================
USE Com5600G09;
GO

IF NOT EXISTS(SELECT name, type_desc 
				FROM sys.server_principals 
				WHERE name = 'Test1')
	CREATE LOGIN Test1 WITH PASSWORD = '1234', DEFAULT_DATABASE=Com5600G09, CHECK_POLICY = OFF;
GO

IF NOT EXISTS(SELECT name, type_desc 
				FROM sys.server_principals 
				WHERE name = 'Test2')
	CREATE LOGIN Test2 WITH PASSWORD = '1234', DEFAULT_DATABASE=Com5600G09, CHECK_POLICY = OFF;
GO

IF NOT EXISTS(SELECT name, type_desc 
				FROM sys.server_principals 
				WHERE name = 'Test3')
	CREATE LOGIN Test3 WITH PASSWORD = '1234', DEFAULT_DATABASE=Com5600G09, CHECK_POLICY = OFF;
GO

--======================================================
-- Fin creacion de loggin
--======================================================
--======================================================
-- Inicio creacion de Usuarios
--======================================================

-- Crear usuarios para los login

IF NOT EXISTS (SELECT * 
				FROM sys.database_principals 
				WHERE name = 'Test1User')
    CREATE USER Test1User FOR LOGIN Test1;
GO

IF NOT EXISTS (SELECT * 
				FROM sys.database_principals 
				WHERE name = 'Test2User')
    CREATE USER Test2User FOR LOGIN Test2;
GO

IF NOT EXISTS (SELECT * 
				FROM sys.database_principals 
				WHERE name = 'Test3User')
    CREATE USER Test3User FOR LOGIN Test3;
GO

-- Asignar roles a nivel BD a los usuarios

ALTER ROLE Vendedor ADD MEMBER Test1User;
GO
ALTER ROLE Supervisor ADD MEMBER Test2User;
GO
ALTER ROLE Administrador ADD MEMBER Test3User;
GO

--======================================================
-- Fin creacion de Usuarios
--======================================================

--==========================================================
-- Inicio ACLARACIONES
--==========================================================

-- Para realizar pruebas se pueden ejecutar de 2 maneras:

-- Se puede ejecutar este codigo para simular en esta pestaña el usuario (u omitir este paso y ejecutar todo como admin)
-- EXECUTE AS USER = 'Test1User';

-- select current_user (Para probar que se haya asignado correctamente)

-- O tambien se puede crear una nueva consulta a partir de loggearse con algun login creado (Ejemplo: Test1)
-- Y copiar los EXEC que quiera ejecutar en dicha sesion

--==========================================================
-- Fin ACLARACIONES
--==========================================================