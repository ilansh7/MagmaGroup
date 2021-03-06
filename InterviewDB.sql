USE [master]
GO
/****** Object:  Database [MG_Interview]    Script Date: 15/12/2018 15:37:43 ******/
CREATE DATABASE [MG_Interview]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'GitHub', FILENAME = N'c:\Program Files\Microsoft SQL Server\MSSQL14.MSSQL14\MSSQL\DATA\GitHub.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'GitHub_log', FILENAME = N'c:\Program Files\Microsoft SQL Server\MSSQL14.MSSQL14\MSSQL\DATA\GitHub_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [MG_Interview].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [MG_Interview] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [MG_Interview] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [MG_Interview] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [MG_Interview] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [MG_Interview] SET ARITHABORT OFF 
GO
ALTER DATABASE [MG_Interview] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [MG_Interview] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [MG_Interview] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [MG_Interview] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [MG_Interview] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [MG_Interview] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [MG_Interview] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [MG_Interview] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [MG_Interview] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [MG_Interview] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [MG_Interview] SET  DISABLE_BROKER 
GO
ALTER DATABASE [MG_Interview] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [MG_Interview] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [MG_Interview] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [MG_Interview] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [MG_Interview] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [MG_Interview] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [MG_Interview] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [MG_Interview] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [MG_Interview] SET  MULTI_USER 
GO
ALTER DATABASE [MG_Interview] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [MG_Interview] SET DB_CHAINING OFF 
GO
ALTER DATABASE [MG_Interview] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [MG_Interview] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [MG_Interview]
GO
/****** Object:  StoredProcedure [dbo].[InsertRepositoryFromJson]    Script Date: 15/12/2018 15:37:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--DECLARE @RepositoryJson NVARCHAR(MAX)

CREATE PROCEDURE [dbo].[InsertRepositoryFromJson](@RepositoryJson NVARCHAR(MAX))
AS BEGIN
	INSERT INTO dbo._MG_Repositories (RepositoryID,Name,node_id,Language,UserID)
	--OUTPUT  INSERTED.RepositoryID
	--SELECT 1,'Name','node_id','Language',1 from dual 
	select RepositoryID, full_name, node_id, lang, user_id
	--select RepositoryJsonData.*
	FROM OPENJSON ( @RepositoryJson )
		WITH (	RepositoryID int, -- '$.Order.Number' ,
				full_name nvarchar(30),
				node_id nvarchar(10),
				lang nvarchar(100), --money N'strict $."Price"',
				user_id int) 
				as json --,
				--as RepositoryJsonData
				--Data nvarchar(max) AS JSON,
				--Tags nvarchar(max) AS JSON) as json
END


GO
/****** Object:  Table [dbo].[_MG_Repositories]    Script Date: 15/12/2018 15:37:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[_MG_Repositories](
	[RepositoryID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](254) NOT NULL,
	[node_id] [nvarchar](254) NOT NULL,
	[Language] [nvarchar](254) NOT NULL,
	[UserID] [int] NOT NULL,
 CONSTRAINT [PK__MG_Repositories] PRIMARY KEY CLUSTERED 
(
	[RepositoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX__MG_Repositories] UNIQUE NONCLUSTERED 
(
	[UserID] ASC,
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[_MG_Users]    Script Date: 15/12/2018 15:37:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[_MG_Users](
	[UserID] [int] IDENTITY(1,1) NOT NULL,
	[Username] [nvarchar](254) NOT NULL,
	[FullName] [nvarchar](254) NOT NULL,
	[Followers] [int] NOT NULL,
	[node_id] [nvarchar](254) NOT NULL,
	[Size] [float] NOT NULL,
 CONSTRAINT [PK__MG_Users] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX__MG_Users] UNIQUE NONCLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[_MG_Repositories]  WITH CHECK ADD  CONSTRAINT [FK__MG_Repositories__MG_Users] FOREIGN KEY([UserID])
REFERENCES [dbo].[_MG_Users] ([UserID])
GO
ALTER TABLE [dbo].[_MG_Repositories] CHECK CONSTRAINT [FK__MG_Repositories__MG_Users]
GO
USE [master]
GO
ALTER DATABASE [MG_Interview] SET  READ_WRITE 
GO
