INSERT INTO [Users](UserId,Sex,Birthday,Name,Lastname,Patronymic,Address,Phone,City) VALUES
	('487EF3B4-077E-49D6-BF46-F9769339DAE5','m',cast('23.02.2000' as date),'Vitali','Filippov','Leonidovich','Perekopskay 22-71','+375298954635','Orsha')

INSERT INTO [Cars]([TypeFuel],[TypeTransmission],[Mark],[Model],[VolumeEngine],[Power],[VIN],[Comment],[YearIssue]) VALUES
           ('Diesel','AKPP','KIA','Sorento',2500,170,'19785647342890134','Family car',2006)

INSERT INTO [TypeEvents]([typeEventId],[TypeName]) VALUES
           ('E3581151-870D-4EA4-9D34-9756FFD87F84','Fuel'),
           ('6771DFDB-B42D-4538-87C6-9ED9AF792A60','Service'),
           ('1E27C04A-82F5-4C80-93B5-934802A2E538','Wash'),
           ('A1BDE902-B012-4B2E-B631-95B19C8EF795','Other')

INSERT INTO [TypeServices]([typeServiceId],[TypeName]) VALUES
           ('2A9E238C-9DAD-4771-8C01-953BDF792644','TO'),
		   ('AF710F73-E079-4910-B5CB-617212250C0C','Repair'),
		   ('A08DFCCE-932F-4A51-B092-EFAAA9051FFC','Replacement'),
		   ('9F9B6A8D-BEE7-48B1-A910-0947E247F40F','Tuning'),
		   ('8CA17FF7-B979-4575-9E22-5F598838D10B','Spare part'),
		   ('A94EBA5B-7126-4982-A879-21E81BD21917','Diagnostics'),
		   ('237EC6A8-59E7-4D56-87E3-A7EA37821345','Tire service'),
		   ('CC858B15-4DC8-4579-8250-096E9CE06445','Other')
