CREATE DATABASE chat
COLLATE Japanese_CI_AS;
GO

USE chat
GO

CREATE LOGIN omouser WITH PASSWORD='$(pass)';
CREATE USER omouser FOR LOGIN omouser WITH DEFAULT_SCHEMA=omouser;
GO

CREATE SCHEMA omouser AUTHORIZATION omouser;
GO

EXEC sp_addrolemember N'db_owner', N'omouser'
GO

GRANT CONTROL ON DATABASE::chat TO omouser;
GO
