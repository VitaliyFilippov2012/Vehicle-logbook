USE Master_CarManager

DROP TRIGGER InsteadOfDeleteUser
GO
CREATE TRIGGER InsteadOfDeleteUser ON Users INSTEAD OF DELETE AS RETURN
GO

DROP TRIGGER InsteadOfDeleteCar
GO
CREATE TRIGGER InsteadOfDeleteCar ON Cars INSTEAD OF DELETE AS
	BEGIN
		UPDATE CARS SET ACTIVE = 0 WHERE CarId in (SELECT CarId FROM deleted) 
	END;
GO

DROP TRIGGER InsteadOfUpdateCarsUsers
GO
CREATE TRIGGER InsteadOfUpdateCarsUsers ON UsersCars INSTEAD OF UPDATE AS RETURN
GO

DROP TRIGGER InsteadOfInsertDetails
GO
CREATE TRIGGER InsteadOfInsertDetails ON Details INSTEAD OF INSERT AS
	BEGIN
		DECLARE @CAR_ID uniqueidentifier;
		DECLARE @DETAIL_ID uniqueidentifier;
		DECLARE @SERVICE_ID uniqueidentifier;
		DECLARE @NAME VARCHAR(100);
		DECLARE @TYPE VARCHAR(100);
		SELECT @DETAIL_ID = DetailId, @SERVICE_ID = idService, @NAME = Name, @TYPE = Type FROM inserted
		SET @CAR_ID = (SELECT TOP(1) idCar FROM CarEvents WHERE EventId IN (SELECT idEvent FROM CarServices WHERE ServiceId IN (SELECT ServiceId FROM inserted)))
		INSERT INTO [dbo].[Details]([DetailId],[idCar],[idService],[Name],[Type])
			VALUES (@DETAIL_ID,@CAR_ID,@SERVICE_ID,@NAME,@TYPE)
	END;
GO


DROP TRIGGER AuditTrigger_Users
GO
CREATE TRIGGER AuditTrigger_Users
    ON USERS AFTER UPDATE AS
    BEGIN
        DECLARE @COUNT_INSERTED INT;
        DECLARE @COUNT_DELETED INT;
        DECLARE @ENTITY_NAME VARCHAR(20);
        DECLARE @DATETIME VARCHAR(50);
        DECLARE @ACTION VARCHAR(20);
        DECLARE @ENTITY_ID uniqueidentifier;
        DECLARE @USER_ID uniqueidentifier;

		SET @ENTITY_NAME = 'Users';
		SET @DATETIME = (SELECT format(getdate(), 'yyyy-MM-dd HH:mm:ss.fff'));
		SET @COUNT_INSERTED = (SELECT COUNT(*) FROM inserted);
		SET @COUNT_DELETED = (SELECT COUNT(*) FROM deleted);
		SET @ENTITY_ID = (SELECT U.[UserId] FROM inserted AS U)
		SET @USER_ID = (SELECT U.[UserId] FROM inserted AS U)
		SET @ACTION = 'PUT';
		INSERT INTO [dbo].[ActionAudit] ([Entity], [EntityId] ,[IdUser] ,[Action] ,[DateUpdate])
			VALUES (@ENTITY_NAME, @ENTITY_ID, @USER_ID, @ACTION, @DATETIME);
    END


DROP TRIGGER AuditTrigger_Users

GO

DROP TRIGGER AuditTrigger_Cars
GO
CREATE TRIGGER AuditTrigger_Cars
    ON CARS AFTER UPDATE AS
    BEGIN
        DECLARE @ENTITY_NAME VARCHAR(20);
        DECLARE @DATETIME VARCHAR(50);
        DECLARE @ACTION VARCHAR(20);
        DECLARE @ENTITY_ID uniqueidentifier;
        DECLARE @USER_ID uniqueidentifier;

		SET @ENTITY_NAME = 'Cars';
		SET @DATETIME = (SELECT format(getdate(), 'yyyy-MM-dd HH:mm:ss.fff'));
		SET @ACTION = 'PUT';
		DECLARE USER_Ids CURSOR LOCAL FORWARD_ONLY FAST_FORWARD FOR
			SELECT idUser FROM UsersCars WHERE idCar in (SELECT CarId FROM inserted)
		SET @ENTITY_ID = (SELECT CarId FROM inserted)
		OPEN USER_IdS;
		FETCH NEXT FROM USER_IDS INTO @USER_ID;
			WHILE @@FETCH_STATUS = 0
				BEGIN
					INSERT INTO [dbo].[ActionAudit] ([Entity], [EntityId] ,[IdUser] ,[Action] ,[DateUpdate])
						VALUES (@ENTITY_NAME, @ENTITY_ID, @USER_ID, @ACTION, @DATETIME);
					FETCH NEXT FROM USER_IDS INTO @USER_ID
				END
		CLOSE USER_IdS;
    END
GO

DROP TRIGGER AuditTrigger_UserCars
GO
CREATE TRIGGER AuditTrigger_UserCars
    ON UsersCars AFTER INSERT, Delete AS
    BEGIN
        DECLARE @COUNT_INSERTED INT;
        DECLARE @COUNT_DELETED INT;
        DECLARE @ENTITY_NAME VARCHAR(20);
        DECLARE @DATETIME VARCHAR(50);
        DECLARE @ACTION VARCHAR(20);
        DECLARE @ENTITY_ID uniqueidentifier;
        DECLARE @USER_ID uniqueidentifier;

		
		SET @COUNT_INSERTED = (SELECT COUNT(*) FROM inserted);
		SET @COUNT_DELETED = (SELECT COUNT(*) FROM deleted);
		SET @ENTITY_NAME = 'Cars';
		SET @DATETIME = (SELECT format(getdate(), 'yyyy-MM-dd HH:mm:ss.fff'));

		IF(@COUNT_DELETED = 1 AND @COUNT_INSERTED = 0)
			BEGIN
				SET @ENTITY_ID = (SELECT idCar FROM deleted)
				SET @USER_ID = (SELECT idUser FROM deleted)
				SET @ACTION = 'DELETE';
			END
		IF(@COUNT_DELETED = 0 AND @COUNT_INSERTED = 1)
			BEGIN
				SET @ENTITY_ID = (SELECT idCar FROM inserted)
				SET @USER_ID = (SELECT idUser FROM inserted)
				SET @ACTION = 'POST';
			END
		INSERT INTO [dbo].[ActionAudit] ([Entity], [EntityId] ,[IdUser] ,[Action] ,[DateUpdate])
			VALUES (@ENTITY_NAME, @ENTITY_ID, @USER_ID, @ACTION, @DATETIME);
    END
GO


DROP TRIGGER AuditTrigger_CarEvents
GO

CREATE TRIGGER AuditTrigger_CarEvents
    ON CarEvents AFTER INSERT, Update, Delete AS
    BEGIN
        DECLARE @COUNT_INSERTED INT;
        DECLARE @COUNT_DELETED INT;
        DECLARE @ENTITY_NAME VARCHAR(20);
        DECLARE @DATETIME VARCHAR(50);
        DECLARE @ACTION VARCHAR(20);
        DECLARE @ENTITY_ID uniqueidentifier;
        DECLARE @USER_ID uniqueidentifier;

		SET @COUNT_INSERTED = (SELECT COUNT(*) FROM inserted);
		SET @COUNT_DELETED = (SELECT COUNT(*) FROM deleted);
		SET @ENTITY_NAME = 'EVENTS';
		SET @DATETIME = (SELECT format(getdate(), 'yyyy-MM-dd HH:mm:ss.fff'));

		IF(@COUNT_DELETED = 1 AND @COUNT_INSERTED = 0)
			BEGIN
				SET @ENTITY_ID = (SELECT EventId FROM deleted)
				SET @ACTION = 'DELETE';
				DECLARE USER_Ids CURSOR LOCAL FORWARD_ONLY FAST_FORWARD FOR
					SELECT idUser FROM UsersCars where idCar in (SELECT idCar FROM deleted)
				OPEN USER_IdS;
				FETCH NEXT FROM USER_IDS INTO @USER_ID;
				WHILE @@FETCH_STATUS = 0
					BEGIN
						INSERT INTO [dbo].[ActionAudit] ([Entity], [EntityId] ,[IdUser] ,[Action] ,[DateUpdate])
							VALUES (@ENTITY_NAME, @ENTITY_ID, @USER_ID, @ACTION, @DATETIME);
						FETCH NEXT FROM USER_IDS INTO @USER_ID
					END
				CLOSE USER_IdS;
			END
		ELSE
			BEGIN
				SET @ENTITY_ID = (SELECT EventId FROM inserted)
				IF(@COUNT_DELETED = 0 AND @COUNT_INSERTED = 1)
					BEGIN
						SET @ACTION = 'POST';
					END
				IF(@COUNT_DELETED = 1 AND @COUNT_INSERTED = 1)
					BEGIN
						SET @ACTION = 'PUT';
					END
				DECLARE USER_Ids CURSOR LOCAL FORWARD_ONLY FAST_FORWARD FOR
					SELECT idUser FROM UsersCars where idCar in (SELECT idCar FROM inserted)
				OPEN USER_IdS;
				FETCH NEXT FROM USER_IDS INTO @USER_ID;
				WHILE @@FETCH_STATUS = 0
					BEGIN
						INSERT INTO [dbo].[ActionAudit] ([Entity], [EntityId] ,[IdUser] ,[Action] ,[DateUpdate])
							VALUES (@ENTITY_NAME, @ENTITY_ID, @USER_ID, @ACTION, @DATETIME);
						FETCH NEXT FROM USER_IDS INTO @USER_ID
					END
				CLOSE USER_IdS;	
			END
    END


DROP TRIGGER AuditTrigger_CarServices
GO

CREATE TRIGGER AuditTrigger_CarServices
    ON CarServices AFTER Update AS
    BEGIN
        DECLARE @COUNT_INSERTED INT;
        DECLARE @COUNT_DELETED INT;
        DECLARE @ENTITY_NAME VARCHAR(20);
        DECLARE @DATETIME VARCHAR(50);
        DECLARE @ACTION VARCHAR(20);
        DECLARE @ENTITY_ID uniqueidentifier;
        DECLARE @USER_ID uniqueidentifier;

		SET @COUNT_INSERTED = (SELECT COUNT(*) FROM inserted);
		SET @COUNT_DELETED = (SELECT COUNT(*) FROM deleted);
		SET @ENTITY_NAME = 'CarServices';
		SET @DATETIME = (SELECT format(getdate(), 'yyyy-MM-dd HH:mm:ss.fff'));
		SET @ENTITY_ID = (SELECT idEvent FROM inserted)
		SET @ACTION = 'PUT';
		DECLARE USER_Ids CURSOR LOCAL FORWARD_ONLY FAST_FORWARD FOR
			SELECT idUser FROM UsersCars where idCar in (SELECT idCar FROM CarEvents WHERE EventId IN (SELECT idEvent FROM inserted))
		OPEN USER_IdS;
		FETCH NEXT FROM USER_IDS INTO @USER_ID;
		WHILE @@FETCH_STATUS = 0
			BEGIN
				INSERT INTO [dbo].[ActionAudit] ([Entity], [EntityId] ,[IdUser] ,[Action] ,[DateUpdate])
					VALUES (@ENTITY_NAME, @ENTITY_ID, @USER_ID, @ACTION, @DATETIME);
				FETCH NEXT FROM USER_IDS INTO @USER_ID
			END
		CLOSE USER_IdS;
	END
GO

DROP TRIGGER AuditTrigger_Fuels
GO

CREATE TRIGGER AuditTrigger_Fuels
    ON Fuels AFTER Update AS
    BEGIN
        DECLARE @COUNT_INSERTED INT;
        DECLARE @COUNT_DELETED INT;
        DECLARE @ENTITY_NAME VARCHAR(20);
        DECLARE @DATETIME VARCHAR(50);
        DECLARE @ACTION VARCHAR(20);
        DECLARE @ENTITY_ID uniqueidentifier;
        DECLARE @USER_ID uniqueidentifier;

		SET @COUNT_INSERTED = (SELECT COUNT(*) FROM inserted);
		SET @COUNT_DELETED = (SELECT COUNT(*) FROM deleted);
		SET @ENTITY_NAME = 'Fuels';
		SET @DATETIME = (SELECT format(getdate(), 'yyyy-MM-dd HH:mm:ss.fff'));
		SET @ENTITY_ID = (SELECT idEvent FROM inserted)
		SET @ACTION = 'PUT';
		DECLARE USER_Ids CURSOR LOCAL FORWARD_ONLY FAST_FORWARD FOR
			SELECT idUser FROM UsersCars where idCar in (SELECT idCar FROM CarEvents WHERE EventId IN (SELECT idEvent FROM inserted))
		OPEN USER_IdS;
		FETCH NEXT FROM USER_IDS INTO @USER_ID;
		WHILE @@FETCH_STATUS = 0
			BEGIN
				INSERT INTO [dbo].[ActionAudit] ([Entity], [EntityId] ,[IdUser] ,[Action] ,[DateUpdate])
					VALUES (@ENTITY_NAME, @ENTITY_ID, @USER_ID, @ACTION, @DATETIME);
				FETCH NEXT FROM USER_IDS INTO @USER_ID
			END
		CLOSE USER_IdS;
	END
GO

DROP TRIGGER AuditTrigger_Details
GO

CREATE TRIGGER AuditTrigger_Details
    ON Details AFTER Update AS
    BEGIN
        DECLARE @COUNT_INSERTED INT;
        DECLARE @COUNT_DELETED INT;
        DECLARE @ENTITY_NAME VARCHAR(20);
        DECLARE @DATETIME VARCHAR(50);
        DECLARE @ACTION VARCHAR(20);
        DECLARE @ENTITY_ID uniqueidentifier;
        DECLARE @USER_ID uniqueidentifier;

		SET @COUNT_INSERTED = (SELECT COUNT(*) FROM inserted);
		SET @COUNT_DELETED = (SELECT COUNT(*) FROM deleted);
		SET @ENTITY_NAME = 'Details';
		SET @DATETIME = (SELECT format(getdate(), 'yyyy-MM-dd HH:mm:ss.fff'));
		SET @ENTITY_ID = (SELECT idEvent FROM CarServices WHERE ServiceId = (SELECT ServiceId FROM inserted))
		SET @ACTION = 'PUT';
		DECLARE USER_Ids CURSOR LOCAL FORWARD_ONLY FAST_FORWARD FOR
			SELECT idUser FROM UsersCars where idCar in (SELECT idCar FROM inserted)
		OPEN USER_IdS;
		FETCH NEXT FROM USER_IDS INTO @USER_ID;
			WHILE @@FETCH_STATUS = 0
				BEGIN
					INSERT INTO [dbo].[ActionAudit] ([Entity], [EntityId] ,[IdUser] ,[Action] ,[DateUpdate])
						VALUES (@ENTITY_NAME, @ENTITY_ID, @USER_ID, @ACTION, @DATETIME);
					FETCH NEXT FROM USER_IDS INTO @USER_ID
				END
		CLOSE USER_IdS;
	END