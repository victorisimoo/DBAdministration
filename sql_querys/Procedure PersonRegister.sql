
USE DBBoatAdministration
GO
--Procedimiento de ingreso de N clientes

create or alter procedure dbo.Person_usp_Register @method int
as
begin
	create table #tempPersonR
	(
		idPersonType int,
		idBloodType int, 
		idCountry int,
		identificationNumber varchar(25),
		namePerson varchar(150),
		lastnamePerson varchar(150),
		dateOfBirth date
	)
	BULK INSERT #tempPersonR
	FROM 'C:\Users\Owner-1\Documents\BASE DE DATOS 2\informacion.csv'
	WITH
	(
		FIELDTERMINATOR = ',',  --CSV field delimiter
		ROWTERMINATOR = '\n',   --Use to shift the control to next row
		TABLOCK
	)
	--Revisa si usara el metodo de rollback masivo
	if(@method = 0)
	begin
	BEGIN TRANSACTION
	end
	Declare	
		 @idPersonType int, 
		 @idBloodType int, 
		 @idCountry int, 
		 @identificationNumber varchar(25),
		 @namePerson varchar(150), 
		 @lastnamePerson varchar(150), 
		 @dateOfBirth date 

	DECLARE CursorPerR CURSOR FOR select * from #tempPersonR
	OPEN  CursorPerR
	FETCH NEXT FROM  CursorPerR into @idPersonType, @idBloodType, @idCountry, @identificationNumber, @namePerson, @lastnamePerson, @dateOfBirth
	WHILE @@FETCH_STATUS = 0
	begin 
		BEGIN TRY 
			--Revisa si usara el metodo de rollback individual
			if(@method = 1)
			begin
				BEGIN TRANSACTION
				if exists(Select * from Person where identificationNumber = @identificationNumber)
				begin
				--Rollback individual
					rollback transaction
					print ('Esta repetido la Persona')
				end
				ELSE
				begin
					insert into Person (idPersonType, idBloodType, idCountry, identificationNumber, namePerson, lastnamePerson, dateOfBirth) 
					values (@idPersonType, @idBloodType, @idCountry, @identificationNumber, @namePerson, @lastnamePerson, @dateOfBirth)
					commit;
				end
			end	
			ELSE IF(@method = 0)
			BEGIN
				if exists(Select * from Person where identificationNumber = @identificationNumber)
				begin
				--Rollback de  todos
					rollback transaction
					print ('Esta repetido la Persona')
				end
				ELSE
				begin
					insert into Person (idPersonType, idBloodType, idCountry, identificationNumber, namePerson, lastnamePerson, dateOfBirth) 
					values (@idPersonType, @idBloodType, @idCountry, @identificationNumber, @namePerson, @lastnamePerson, @dateOfBirth)
					commit;
				end
			END
			FETCH NEXT FROM  CursorPerR into @idPersonType, @idBloodType, @idCountry, @identificationNumber, @namePerson, @lastnamePerson, @dateOfBirth
		END TRY
		begin catch 
			print 'Método no Válido'
		end catch
	end		
	close CursorPerR

	Deallocate  CursorPerR
	Drop table #tempPersonR
END;