USE [Master_CarManager]
GO

CREATE UNIQUE NONCLUSTERED INDEX NonIndex_AUTH_Login  
    ON [dbo].[AUTHENTICATION] (Login)
	INCLUDE (Password, idUser, DisableUser)
	WITH (FILLFACTOR = 80)
GO

CREATE CLUSTERED INDEX ClIndex_ServicesDetail_DetailService 
    ON [dbo].[ServicesDetails] (idService, idDetail)
	WITH (FILLFACTOR = 80)
GO