USE HHelp;
GO

-- Drop existing stored procedures if they exist
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SOCIETY_SELECT_TOP10]') AND type in (N'P', N'PC'))
    DROP PROCEDURE [dbo].[SOCIETY_SELECT_TOP10]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SOCIETY_SELECT]') AND type in (N'P', N'PC'))
    DROP PROCEDURE [dbo].[SOCIETY_SELECT]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[HOUSE_SELECT_BY_SNAME_FOR_NEW_HOUSE]') AND type in (N'P', N'PC'))
    DROP PROCEDURE [dbo].[HOUSE_SELECT_BY_SNAME_FOR_NEW_HOUSE]
GO

-- Create Society table if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Society]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Society](
        [SocietyID] [int] IDENTITY(1,1) NOT NULL,
        [SocietyName] [nvarchar](100) NOT NULL,
        [Address] [nvarchar](200) NOT NULL,
        [City] [nvarchar](50) NOT NULL,
        [State] [nvarchar](50) NOT NULL,
        [Pincode] [nvarchar](10) NOT NULL,
        [ContactNumber] [nvarchar](15) NULL,
        [Email] [nvarchar](100) NULL,
        [Description] [nvarchar](500) NULL,
        [CreatedDate] [datetime] DEFAULT GETDATE(),
        [IsActive] [bit] DEFAULT 1,
        CONSTRAINT [PK_Society] PRIMARY KEY CLUSTERED ([SocietyID] ASC)
    )
END
GO

-- Create Houses table if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Houses]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Houses](
        [HID] [int] IDENTITY(1,1) NOT NULL,
        [BlockNo] [nvarchar](50) NOT NULL,
        [SocietyID] [int] NOT NULL,
        [OwnerID] [int] NULL,
        [Title] [nvarchar](100) NOT NULL,
        [Description] [nvarchar](500) NULL,
        [Address] [nvarchar](200) NOT NULL,
        [City] [nvarchar](50) NOT NULL,
        [State] [nvarchar](50) NOT NULL,
        [Pincode] [nvarchar](10) NOT NULL,
        [Price] [decimal](18, 2) NOT NULL,
        [PropertyType] [nvarchar](50) NOT NULL,
        [Bedrooms] [int] NULL,
        [Bathrooms] [int] NULL,
        [Area] [decimal](10, 2) NULL,
        [ListingType] [nvarchar](20) NOT NULL,
        [Status] [nvarchar](20) DEFAULT 'Available',
        [CreatedDate] [datetime] DEFAULT GETDATE(),
        [IsActive] [bit] DEFAULT 1,
        CONSTRAINT [PK_Houses] PRIMARY KEY CLUSTERED ([HID] ASC),
        CONSTRAINT [FK_Houses_Society] FOREIGN KEY ([SocietyID]) REFERENCES [dbo].[Society] ([SocietyID])
    )
END
GO

-- Create Users table if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Users]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Users](
        [UserID] [int] IDENTITY(1,1) NOT NULL,
        [Username] [nvarchar](50) NOT NULL,
        [Password] [nvarchar](100) NOT NULL,
        [Email] [nvarchar](100) NOT NULL,
        [FullName] [nvarchar](100) NOT NULL,
        [PhoneNumber] [nvarchar](15) NULL,
        [BirthDate] [datetime] NULL,
        [HouseID] [int] NULL,
        [SocietyID] [int] NULL,
        [MemberNumber] [int] NULL,
        [PhotoPath] [nvarchar](200) NULL,
        [UserType] [nvarchar](20) NOT NULL,
        [CreatedDate] [datetime] DEFAULT GETDATE(),
        [IsActive] [bit] DEFAULT 1,
        CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED ([UserID] ASC),
        CONSTRAINT [FK_Users_Society] FOREIGN KEY ([SocietyID]) REFERENCES [dbo].[Society] ([SocietyID]),
        CONSTRAINT [FK_Users_Houses] FOREIGN KEY ([HouseID]) REFERENCES [dbo].[Houses] ([HID])
    )
END
GO

-- Create Rent table if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Rent]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Rent](
        [RID] [int] IDENTITY(1,1) NOT NULL,
        [HID] [int] NOT NULL,
        [UID] [int] NOT NULL,
        [Rent] [decimal](18, 2) NOT NULL,
        [EntryDate] [datetime] DEFAULT GETDATE(),
        [Status] [nvarchar](20) DEFAULT 'Active',
        CONSTRAINT [PK_Rent] PRIMARY KEY CLUSTERED ([RID] ASC),
        CONSTRAINT [FK_Rent_Houses] FOREIGN KEY ([HID]) REFERENCES [dbo].[Houses] ([HID]),
        CONSTRAINT [FK_Rent_Users] FOREIGN KEY ([UID]) REFERENCES [dbo].[Users] ([UserID])
    )
END
GO

-- Create Sell table if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Sell]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Sell](
        [SID] [int] IDENTITY(1,1) NOT NULL,
        [HID] [int] NOT NULL,
        [UID] [int] NOT NULL,
        [Sell] [decimal](18, 2) NOT NULL,
        [EntryDate] [datetime] DEFAULT GETDATE(),
        [Status] [nvarchar](20) DEFAULT 'Active',
        CONSTRAINT [PK_Sell] PRIMARY KEY CLUSTERED ([SID] ASC),
        CONSTRAINT [FK_Sell_Houses] FOREIGN KEY ([HID]) REFERENCES [dbo].[Houses] ([HID]),
        CONSTRAINT [FK_Sell_Users] FOREIGN KEY ([UID]) REFERENCES [dbo].[Users] ([UserID])
    )
END
GO

-- Create stored procedures
CREATE PROCEDURE [dbo].[SOCIETY_SELECT_TOP10]
AS
BEGIN
    SELECT TOP 10 
        SocietyID,
        SocietyName,
        Address,
        City,
        State,
        Pincode,
        ContactNumber,
        Email,
        Description,
        CreatedDate,
        IsActive
    FROM Society
    WHERE IsActive = 1
    ORDER BY CreatedDate DESC;
END
GO

CREATE PROCEDURE [dbo].[SOCIETY_SELECT]
AS
BEGIN
    SELECT 
        SocietyID,
        SocietyName,
        Address,
        City,
        State,
        Pincode,
        ContactNumber,
        Email,
        Description,
        CreatedDate,
        IsActive
    FROM Society
    WHERE IsActive = 1;
END
GO

CREATE PROCEDURE [dbo].[HOUSE_SELECT_BY_SNAME_FOR_NEW_HOUSE]
    @SocietyName NVARCHAR(100)
AS
BEGIN
    SELECT 
        HouseID,
        SocietyID,
        OwnerID,
        Title,
        Description,
        Address,
        City,
        State,
        Pincode,
        Price,
        PropertyType,
        Bedrooms,
        Bathrooms,
        Area,
        ListingType,
        Status,
        CreatedDate,
        IsActive
    FROM Houses
    WHERE SocietyID IN (SELECT SocietyID FROM Society WHERE SocietyName = @SocietyName)
    AND IsActive = 1;
END
GO

-- Insert sample data for testing
IF NOT EXISTS (SELECT * FROM Society)
BEGIN
    INSERT INTO Society (SocietyName, Address, City, State, Pincode, ContactNumber, Email, Description)
    VALUES 
    ('Green Valley Society', '123 Main Street', 'Mumbai', 'Maharashtra', '400001', '9876543210', 'info@greenvalley.com', 'A beautiful society with modern amenities'),
    ('Sunshine Heights', '456 Park Road', 'Delhi', 'Delhi', '110001', '9876543211', 'info@sunshine.com', 'Peaceful living with great facilities'),
    ('Royal Gardens', '789 Garden Street', 'Bangalore', 'Karnataka', '560001', '9876543212', 'info@royalgardens.com', 'Luxury living at its best');
END
GO

-- RENT_SELECT_FOR_USER
IF OBJECT_ID('dbo.RENT_SELECT_FOR_USER', 'P') IS NOT NULL
    DROP PROCEDURE dbo.RENT_SELECT_FOR_USER
GO
CREATE PROCEDURE dbo.RENT_SELECT_FOR_USER
AS
BEGIN
    SELECT 
        r.RID,
        h.HID,
        h.BlockNo,
        h.PropertyType AS Type,
        s.SocietyName AS Sname,
        r.UID,
        r.Rent,
        r.EntryDate
    FROM Rent r
    JOIN Houses h ON r.HID = h.HID
    JOIN Society s ON h.SocietyID = s.SocietyID
END
GO

-- SELL_SELECT_FOR_USER
IF OBJECT_ID('dbo.SELL_SELECT_FOR_USER', 'P') IS NOT NULL
    DROP PROCEDURE dbo.SELL_SELECT_FOR_USER
GO
CREATE PROCEDURE dbo.SELL_SELECT_FOR_USER
AS
BEGIN
    SELECT 
        s.SID,
        h.HID,
        h.BlockNo,
        h.PropertyType AS Type,
        so.SocietyName AS Sname,
        s.UID,
        s.Sell,
        s.EntryDate
    FROM Sell s
    JOIN Houses h ON s.HID = h.HID
    JOIN Society so ON h.SocietyID = so.SocietyID
END
GO 