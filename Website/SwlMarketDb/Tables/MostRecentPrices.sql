﻿CREATE TABLE [dbo].[MostRecentPrices]
(
    [Id] INT NOT NULL IDENTITY,
    [ItemId] INT NOT NULL PRIMARY KEY, 
    [Time] DATETIME NOT NULL,
    [Marks] INT NOT NULL,
    [ExpiresIn] INT NULL, 
    [IPId] INT NULL
)

GO