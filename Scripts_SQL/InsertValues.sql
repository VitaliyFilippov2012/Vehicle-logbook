INSERT INTO [dbo].[Users](Sex,Birthday,Name,Lastname,Patronymic,Address,Phone,City) VALUES
	('m',cast('23.02.2000' as date),'Vitali','Filippov','Leonidovich','Perekopskay 22-71','+375298954635','Orsha')
GO

INSERT INTO [dbo].[AUTHENTICATION]([idUser],[Password],[Login],[LastModify],[DisableUser]) VALUES
           ('9E3E27E7-65C7-4EDD-AD80-800DAEED2355','2037617037','2037617037',GETDATE(),0)
GO

INSERT INTO [dbo].[Cars]([TypeFuel],[TypeTransmission],[Mark],[Model],[VolumeEngine],[Power],[VIN],[Comment],[YearIssue]) VALUES
           ('Diesel','AKPP','KIA','Sorento',2500,170,'19785647342890134','Family car',2006)
GO

INSERT INTO [dbo].[UsersCars] ([idUser],[idCar]) VALUES
           ('9E3E27E7-65C7-4EDD-AD80-800DAEED2355','E3C10CA4-AC28-47A3-8294-18A7E62421C1')
GO

INSERT INTO [dbo].[TypeEvents]([TypeName]) VALUES
           ('Fuel'),
           ('Service'),
           ('Wash'),
           ('Other')
GO

INSERT INTO [dbo].[TypeServices]([TypeName]) VALUES
           ('TO'),
		   ('Repair'),
		   ('Replacement'),
		   ('Tuning'),
		   ('Spare part'),
		   ('Diagnostics'),
		   ('Tire service'),
		   ('Other')
GO
