-- Crear la base de datos
CREATE DATABASE HubMega;
GO

-- Usar la base de datos recién creada
USE HubMega;
GO

-- Crear la tabla 'usuarios'
CREATE TABLE Usuarios (
    UsuarioID INT  IDENTITY(1,1) PRIMARY KEY,  --IDENTITY genera automáticamente valores numéricos únicos para una columna.
    Nombre   NVARCHAR(200) NOT NULL,
	Apellidos NVARCHAR(200) NOT NULL,
	NombreUsuario NVARCHAR(50) NOT NULL,
    Correo NVARCHAR(100) NOT NULL UNIQUE,
	ContrasenaHash VARBINARY(70) NOT NULL,
	Sal VARBINARY(32)  NOT NULL, -- PARA CONTRASENA
    FechaRegistro DATETIME DEFAULT GETDATE()
);
GO

-- Crear la tabla 'peliculas'
CREATE TABLE Peliculas (
    PeliculasID INT  IDENTITY(1,1) PRIMARY KEY,
    Titulo NVARCHAR(100) NOT NULL,
    Director NVARCHAR(100),
    FechaEstreno DATE,
    Genero NVARCHAR(50),
    Duracion int,-- duracion en minutos 
	Sinopsis NVARCHAR(MAX)
);
GO

-- Crear la tabla 'series'
CREATE TABLE Series (
    SeriesID INT IDENTITY(1,1) PRIMARY KEY,
    Titulo NVARCHAR(100) NOT NULL,
    Creador NVARCHAR(100),
    FechaEstreno DATE,
    Genero NVARCHAR(50),
	Temporada INT,
	Capitulos INT,
	Sipnosis NVARCHAR(MAX)
);
GO

-- procedimiento almacenado para usuarios 
  CREATE PROCEDURE CrearUsuarios
  @Nombre  NVARCHAR(200),
  @Apellidos NVARCHAR(200),
  @NombreUsario NVARCHAR(50),
  @Correo NVARCHAR(100),
  @Contrasena NVARCHAR(100)

  AS
  BEGIN 
      DECLARE @Sal VARBINARY(32) = NEWID();
      DECLARE @ContrasenaHash VARBINARY(70);

   -- HASH DE CONTRA USANDO LA SAL 
  SET @ContrasenaHash = HASHBYTES('SHA2_512', @ContrasenaHash +  @Sal);

   INSERT INTO Usuarios(Nombre, Apellidos, NombreUsuario, Correo, ContrasenaHash, Sal)
   VALUES (@Nombre, @Apellidos,@NombreUsario,@Correo,@ContrasenaHash,@Sal);
   END
   GO