/*
Enunciado:

Luego de decidirse por un motor de base de datos relacional, lleg� el momento de generar la 
base de datos. 
Deber� instalar el DMBS y documentar el proceso. No incluya capturas de pantalla. Detalle 
las configuraciones aplicadas (ubicaci�n de archivos, memoria asignada, seguridad, puertos, 
etc.) en un documento como el que le entregar�a al DBA. 
Cree la base de datos, entidades y relaciones. Incluya restricciones y claves. Deber� entregar 
un archivo .sql con el script completo de creaci�n (debe funcionar si se lo ejecuta �tal cual� es 
entregado). Incluya comentarios para indicar qu� hace cada m�dulo de c�digo.  
Genere store procedures para manejar la inserci�n, modificado, borrado (si corresponde, 
tambi�n debe decidir si determinadas entidades solo admitir�n borrado l�gico) de cada tabla. 
Los nombres de los store procedures NO deben comenzar con �SP�.  
Genere esquemas para organizar de forma l�gica los componentes del sistema y aplique esto 
en la creaci�n de objetos. NO use el esquema �dbo�.  
El archivo .sql con el script debe incluir comentarios donde consten este enunciado, la fecha 
de entrega, n�mero de grupo, nombre de la materia, nombres y DNI de los alumnos.  
Entregar todo en un zip cuyo nombre sea Grupo_XX.zip mediante la secci�n de pr�cticas de 
MIEL. Solo uno de los miembros del grupo debe hacer la entrega.

Fecha de entrega: 01/11/2024
Numero de grupo: 9
Nombre de la materia: Bases de Datos Aplicadas
Alumnos:
Arcodia Lautaro	     DNI: 41588362
Gorosito Candela     DNI: 43896171
Paez Maximiliano     DNI: 44004413
Delli Gatti Thomas   DNI: 42427810
*/

USE master
GO

--Crear base de datos
IF EXISTS (SELECT name 
			FROM master.dbo.sysdatabases 
			WHERE name = 'Com5600G09')
DROP DATABASE Com5600G09;
GO

CREATE DATABASE Com5600G09
GO