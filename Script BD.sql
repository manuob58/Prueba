USE [EmpresaMOIZ]
GO
/****** Object:  Table [dbo].[Departamentos]    Script Date: 13/01/2018 10:00:56 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Departamentos](
	[Puesto] [int] NOT NULL,
	[Descripcion] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Puesto] PRIMARY KEY CLUSTERED 
(
	[Puesto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Empleados]    Script Date: 13/01/2018 10:00:57 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Empleados](
	[Clave_Emp] [int] NOT NULL,
	[Nombre] [varchar](50) NOT NULL,
	[ApPaterno] [varchar](50) NOT NULL,
	[ApMaterno] [varchar](50) NOT NULL,
	[FecNac] [datetime] NOT NULL,
	[Departamento] [int] NOT NULL,
	[Sueldo] [money] NOT NULL,
 CONSTRAINT [PK_Empleado] PRIMARY KEY CLUSTERED 
(
	[Clave_Emp] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[Departamentos] ([Puesto], [Descripcion]) VALUES (1, N'Contabilidad')
GO
INSERT [dbo].[Departamentos] ([Puesto], [Descripcion]) VALUES (2, N'Recursos Humanos')
GO
INSERT [dbo].[Departamentos] ([Puesto], [Descripcion]) VALUES (3, N'Soporte')
GO
INSERT [dbo].[Departamentos] ([Puesto], [Descripcion]) VALUES (4, N'Sistemas')
GO
INSERT [dbo].[Empleados] ([Clave_Emp], [Nombre], [ApPaterno], [ApMaterno], [FecNac], [Departamento], [Sueldo]) VALUES (2, N'Manuel obed', N'Gutierrez', N'Zepeda', CAST(N'2010-03-31T00:00:00.000' AS DateTime), 4, 28000.0000)
GO
INSERT [dbo].[Empleados] ([Clave_Emp], [Nombre], [ApPaterno], [ApMaterno], [FecNac], [Departamento], [Sueldo]) VALUES (3, N'sharin', N'gutierrez', N'valenzuela', CAST(N'2018-01-01T00:00:00.000' AS DateTime), 3, 25000.0000)
GO
INSERT [dbo].[Empleados] ([Clave_Emp], [Nombre], [ApPaterno], [ApMaterno], [FecNac], [Departamento], [Sueldo]) VALUES (4, N'alexia', N'Gutierrez', N'gutierrez', CAST(N'2018-01-24T00:00:00.000' AS DateTime), 2, 222000.0000)
GO
INSERT [dbo].[Empleados] ([Clave_Emp], [Nombre], [ApPaterno], [ApMaterno], [FecNac], [Departamento], [Sueldo]) VALUES (5, N'juanito', N'perez', N'perez', CAST(N'2000-04-20T00:00:00.000' AS DateTime), 1, 1000.0000)
GO
ALTER TABLE [dbo].[Empleados]  WITH CHECK ADD  CONSTRAINT [FK_Emp_Dep] FOREIGN KEY([Departamento])
REFERENCES [dbo].[Departamentos] ([Puesto])
GO
ALTER TABLE [dbo].[Empleados] CHECK CONSTRAINT [FK_Emp_Dep]
GO
/****** Object:  StoredProcedure [dbo].[SP_ABC_EMPLEADOS]    Script Date: 13/01/2018 10:00:59 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_ABC_EMPLEADOS]
@Clave_Emp int,
@Nombre varchar(50),
@ApPaterno varchar(50),
@ApMaterno varchar(50),
@FecNac varchar(10),
@Departamento int,
@Sueldo money,
@Opc tinyint
as 
BEGIN
    --INSERTAR
    IF @Opc = 1
    BEGIN
		set @Clave_Emp = (Select coalesce(max(Clave_Emp),0)+1 as cve_emp from Empleados)
        INSERT INTO Empleados
        values (@Clave_Emp,@Nombre,@ApPaterno,@ApMaterno,CAST(@FecNac as datetime),@Departamento,@Sueldo)
	select @@ROWCOUNT
    END
    
    --MODIFICAR
    IF @Opc = 2
    BEGIN
        UPDATE Empleados
        SET Nombre=@Nombre,ApPaterno=@ApPaterno,ApMaterno=@ApMaterno,FecNac=Cast(@FecNac as datetime),Departamento=@Departamento,Sueldo =@Sueldo
        WHERE Clave_Emp = @Clave_Emp
	select @@ROWCOUNT
    END
    
    --ELIMINAR
    IF @Opc = 3
    BEGIN
        DELETE FROM Empleados
        WHERE Clave_Emp = @Clave_Emp
	select @@ROWCOUNT
    END
END
GO
/****** Object:  StoredProcedure [dbo].[sp_obtenerInformacion]    Script Date: 13/01/2018 10:00:59 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_obtenerInformacion]
@Clave_Emp int,
@Opc tinyint
as 
BEGIN
	SET LANGUAGE Español
	
    --MOSTRAR TODOS LOS DATOS
    IF @Opc = 1
    BEGIN
        SELECT e.Nombre+' '+e.ApPaterno + ' '+ ApMaterno AS NombreCompleto,Rtrim(CONVERT(char(10), FecNac, 103)) as Fecnac,d.Descripcion AS Departamento, CONVERT(varchar, CAST(Sueldo AS money), 1) as Sueldo,Clave_Emp AS Clave_EmpE,Clave_Emp AS Clave_EmpB 
		FROM empleados e Left join Departamentos d ON d.Puesto = e.Departamento
    END
    
    --MOSTRAR TODOS LOS DATOS DE UN EMPLEADO EN ESPECIFICO
    IF @Opc = 2
    BEGIN
        SELECT Clave_Emp, Nombre, ApPaterno, ApMaterno, Rtrim(CONVERT(char(10), FecNac, 103))  as FecNac, Departamento, Sueldo 
		FROM Empleados
        WHERE Clave_Emp = @Clave_Emp
    END
END


GO
