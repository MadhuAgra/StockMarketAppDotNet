USE [master]
GO
/****** Object:  Database [StockMarket]    Script Date: 2/4/2019 6:13:53 PM ******/
CREATE DATABASE [StockMarket]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'StockMarket', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\StockMarket.mdf' , SIZE = 3072KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'StockMarket_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\StockMarket_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [StockMarket] SET COMPATIBILITY_LEVEL = 120
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [StockMarket].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [StockMarket] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [StockMarket] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [StockMarket] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [StockMarket] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [StockMarket] SET ARITHABORT OFF 
GO
ALTER DATABASE [StockMarket] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [StockMarket] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [StockMarket] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [StockMarket] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [StockMarket] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [StockMarket] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [StockMarket] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [StockMarket] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [StockMarket] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [StockMarket] SET  DISABLE_BROKER 
GO
ALTER DATABASE [StockMarket] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [StockMarket] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [StockMarket] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [StockMarket] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [StockMarket] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [StockMarket] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [StockMarket] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [StockMarket] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [StockMarket] SET  MULTI_USER 
GO
ALTER DATABASE [StockMarket] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [StockMarket] SET DB_CHAINING OFF 
GO
ALTER DATABASE [StockMarket] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [StockMarket] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [StockMarket] SET DELAYED_DURABILITY = DISABLED 
GO
USE [StockMarket]
GO
/****** Object:  Table [dbo].[stock_details]    Script Date: 2/4/2019 6:13:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[stock_details](
	[StockId] [int] IDENTITY(1,1) NOT NULL,
	[StockName] [nvarchar](50) NOT NULL,
	[StockValue] [decimal](18, 2) NOT NULL,
	[StockTrend] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_stock_details] PRIMARY KEY CLUSTERED 
(
	[StockId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[stock_holdings]    Script Date: 2/4/2019 6:13:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[stock_holdings](
	[UserId] [int] NULL,
	[StockId] [int] NULL,
	[Quantity] [int] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[user_details]    Script Date: 2/4/2019 6:13:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[user_details](
	[UserId] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [nvarchar](50) NOT NULL,
	[Email] [nvarchar](50) NOT NULL,
	[Password] [nvarchar](15) NOT NULL,
	[CashValue] [decimal](18, 4) NOT NULL CONSTRAINT [DF_user_details_CashValue]  DEFAULT ((50000)),
	[StockValue] [decimal](18, 4) NOT NULL,
 CONSTRAINT [PK_user_details] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[stock_holdings]  WITH CHECK ADD FOREIGN KEY([StockId])
REFERENCES [dbo].[stock_details] ([StockId])
GO
ALTER TABLE [dbo].[stock_holdings]  WITH CHECK ADD FOREIGN KEY([UserId])
REFERENCES [dbo].[user_details] ([UserId])
GO
/****** Object:  StoredProcedure [dbo].[spDecreaseQuantity]    Script Date: 2/4/2019 6:13:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spDecreaseQuantity]
@UserId int, @StockId int, @Quantity int
	
AS
BEGIN
	UPDATE stock_holdings
	SET Quantity = Quantity-@Quantity
	WHERE UserId=@UserId and StockId=@StockId
	DELETE FROM stock_holdings where Quantity=0
END

GO
/****** Object:  StoredProcedure [dbo].[spGetAllStockDetails]    Script Date: 2/4/2019 6:13:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGetAllStockDetails]
AS
BEGIN
	select * from stock_details 
	END

GO
/****** Object:  StoredProcedure [dbo].[spGetQuantity]    Script Date: 2/4/2019 6:13:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGetQuantity]
	@UserId int, @StockId int
AS
BEGIN
	select Quantity from stock_holdings where UserId=@UserId and StockId=@StockId
END

GO
/****** Object:  StoredProcedure [dbo].[spGetStockDetails]    Script Date: 2/4/2019 6:13:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGetStockDetails]
@StockId int
AS
BEGIN
	select * from stock_details where StockId=@StockId
	END

GO
/****** Object:  StoredProcedure [dbo].[spGetStockIds]    Script Date: 2/4/2019 6:13:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGetStockIds]
@UserId int
AS
BEGIN
	select * from stock_holdings where UserId=@UserId
	END

GO
/****** Object:  StoredProcedure [dbo].[spGetUser]    Script Date: 2/4/2019 6:13:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGetUser]
	@Email nvarchar(50)
AS
BEGIN
	select * from user_details where Email = @Email
END

GO
/****** Object:  StoredProcedure [dbo].[spInsertOrUpdateTransaction]    Script Date: 2/4/2019 6:13:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spInsertOrUpdateTransaction]
@UserId int, @StockId int, @Quantity int
as
begin
if (select UserId from stock_holdings where UserId=@UserId and StockId=@StockId )=@UserId 
	UPDATE stock_holdings
	SET Quantity = Quantity+@Quantity
	WHERE UserId=@UserId and StockId=@StockId
else 
	insert into stock_holdings values(@UserId, @StockId, @Quantity)
end

GO
/****** Object:  StoredProcedure [dbo].[spInsertTransaction]    Script Date: 2/4/2019 6:13:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spInsertTransaction]
@UserId int, @StockId int, @Quantity int
as
begin
insert into stock_holdings values(@UserId, @StockId, @Quantity)
end
GO
/****** Object:  StoredProcedure [dbo].[spInsertUser]    Script Date: 2/4/2019 6:13:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spInsertUser]
@Name nvarchar(50), @Email nvarchar(50), @Password nvarchar(15)
AS
BEGIN
	insert into user_details(UserName
      ,Email
      ,[Password],CashValue,StockValue) values(@Name,@Email,@Password,50000,0)
      
END
GO
/****** Object:  StoredProcedure [dbo].[spMatchUser]    Script Date: 2/4/2019 6:13:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spMatchUser]
	@Email nvarchar(50), @Password nvarchar(15)
AS
BEGIN
	select count(Email) from user_details 
	where Email=@Email AND [Password]=@Password
END
GO
/****** Object:  StoredProcedure [dbo].[spUpdateUser]    Script Date: 2/4/2019 6:13:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[spUpdateUser]
@UserId int, @CashValue decimal, @StockValue decimal
as
begin
UPDATE user_details
SET CashValue = @CashValue, StockValue=@StockValue
WHERE UserId = @UserId
end
GO
USE [master]
GO
ALTER DATABASE [StockMarket] SET  READ_WRITE 
GO
