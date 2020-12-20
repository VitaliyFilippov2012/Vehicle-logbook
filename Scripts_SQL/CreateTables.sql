USE [Master_CarManager]
GO

--DROP TABLE AUTHENTICATION
--DROP TABLE Fuels
--DROP TABLE TypeServices
--DROP TABLE CarServices
--DROP TABLE CarEvents
--DROP TABLE TypeEvents
--DROP TABLE UsersCars
--DROP TABLE Users
--DROP TABLE Details
--DROP TABLE Cars
--DROP TABLE ActionAudit

CREATE TABLE Users(
	UserId uniqueidentifier not null DEFAULT newid(),
	Sex nvarchar(1) check (sex in ('m','f')) not null,
	Birthday date not null,
	Name nvarchar(20) not null,
	Lastname nvarchar(20) not null,
	Patronymic nvarchar(30) not null,
	Address nvarchar(60) not null,
	Phone nvarchar(20),
	City nvarchar(20) not null,
	photo varbinary(max),
	Constraint PK_Users Primary key(userId)
);

CREATE TABLE Cars(
	CarId uniqueidentifier not null DEFAULT newid(),
	TypeFuel varchar(20) not null,
	TypeTransmission varchar(20) not null,
	Mark varchar(20) not null,
	Model varchar(20) not null,
	VolumeEngine int not null,
	Power int not null,
	Active bit default(1),
	VIN varchar(17) unique not null,
	Comment varchar(17),
	photo varbinary(max),
	YearIssue int not null check (YearIssue <= Year(getDate())),
	Constraint PK_Cars Primary key(CarId)
);

CREATE TABLE AUTHENTICATION(
	idUser uniqueidentifier not null DEFAULT newid(),
	Password nvarchar(32) not null,
	Login nvarchar(50) not null,
	LastModify date not null check (LastModify <= getDate()),
	DisableUser bit default(0)
	Constraint PK_AUTHENTICATION Primary key(Login)
	Constraint FK_Authentication_User foreign key(idUser) references Users(UserId)
);

CREATE TABLE UsersCars(
	idUser uniqueidentifier not null,
	idCar uniqueidentifier not null,
	Constraint FK_UserCars_User foreign key(idUser) references Users(UserId),
	Constraint FK_UserCars_Car foreign key(idCar) references Cars(CarId),
	Constraint PK_UsersCars Primary key(idUser,idCar)
);

CREATE TABLE TypeEvents(
	TypeEventId uniqueidentifier not null DEFAULT newid(),
	TypeName varchar(20) not null unique,
	Constraint PK_TypeEvents Primary key(TypeEventId)
);

CREATE TABLE CarEvents(
	EventId uniqueidentifier not null DEFAULT newid(),
	idTypeEvents uniqueidentifier not null,
	idUser uniqueidentifier not null,
	idCar uniqueidentifier not null,
	Date date not null,
	Costs money not null,
	UnitPrice money,
	Comment varchar(200),
	Mileage bigint,
	photo varbinary(max),
	AddressStation varchar(100),
	Constraint FK_Events_TypeEvents foreign key(idTypeEvents) references TypeEvents(TypeEventId),
	Constraint FK_Events_User foreign key(idUser) references Users(UserId),
	Constraint FK_Events_Car foreign key(idCar) references Cars(CarId),
	Constraint PK_Events Primary key(EventId)
);

CREATE TABLE Fuels(
	FuelId uniqueidentifier not null DEFAULT newid(),
	idEvent uniqueidentifier not null,
	Volume real not null,
	Constraint FK_Fuels_Events foreign key(idEvent) references CarEvents(EventId) on delete cascade,
	Constraint PK_Fuels Primary key(FuelId)
);

CREATE TABLE TypeServices(
	TypeServiceId uniqueidentifier not null DEFAULT newid(),
	TypeName varchar(20) not null unique,
	Constraint PK_TypeService Primary key(TypeServiceId)
);

CREATE TABLE CarServices(
	ServiceId uniqueidentifier not null DEFAULT newid(),
	idEvent uniqueidentifier not null,
	idTypeService uniqueidentifier not null,
	Name varchar(100),
	Constraint FK_Services_Events foreign key(idEvent) references CarEvents(EventId) on delete cascade,
	Constraint FK_Services_TypeServices foreign key(idTypeService) references TypeServices(TypeServiceId),
	Constraint PK_Service Primary key(ServiceId)
);

CREATE TABLE Details(
	DetailId uniqueidentifier not null DEFAULT newid(),
	idCar uniqueidentifier DEFAULT newid(),
	idService uniqueidentifier not null,
	Name varchar(100),
	Type varchar(100),
	Constraint FK_Details_Cars foreign key(idCar) references Cars(CarId),
	Constraint PK_Details Primary key(DetailId),
	Constraint FK_Details_Service foreign key(idService) references CarServices(ServiceId) on delete cascade,
);

CREATE TABLE ActionAudit(
	Entity varchar(50) not null,
	EntityId uniqueidentifier not null,
	IdUser uniqueidentifier not null,
	Action varchar(20) not null,
	DateUpdate VARCHAR(50) not null
	Constraint PK_ActionAudit Primary key(EntityId,DateUpdate,IdUser)
	Constraint FK_ActionAudit_User foreign key(idUser) references Users(UserId),
);
