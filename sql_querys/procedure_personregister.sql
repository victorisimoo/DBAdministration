
USE DBBoatAdministration
GO
--Procedimiento de ingreso de N clientes
create or alter procedure sp_RegisterPerson @method int
as
begin
	if(@method = 0)
	begin
		exec sp_RegisterPersonM0
	end
	else
	begin
		exec sp_RegisterPersonM1
	end
end;

--Procedimiento de metodo 0
create or alter procedure sp_RegisterPersonM0
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

	--BULK INSERT #tempPersonR
	--FROM 'filepath'
	--WITH
	--(
	--	FIELDTERMINATOR = ',',  --CSV field delimiter
	--	ROWTERMINATOR = '\n',   --Use to shift the control to next row
	--	TABLOCK
	--)

	Declare	
		 @idPersonType int, 
		 @idBloodType int, 
		 @idCountry int, 
		 @identificationNumber varchar(25),
		 @namePerson varchar(150), 
		 @lastnamePerson varchar(150), 
		 @dateOfBirth date 

	-- Se inicia afuera para hacer un rollback masivo, y manejarlo como uno solo.
	BEGIN TRANSACTION
	-- el cursor se basa en una tabla temporal con los archivos recien añadidos.
	DECLARE CursorPerR CURSOR FOR select * from #tempPersonR
	OPEN  CursorPerR
	FETCH NEXT FROM  CursorPerR into @idPersonType, @idBloodType, @idCountry, @identificationNumber, @namePerson, @lastnamePerson, @dateOfBirth
	WHILE @@FETCH_STATUS = 0
	begin 

		if exists(Select * from Person where identificationNumber = @identificationNumber)
		begin
		--Realiza rollback a todos los datos anteriormente ingresados, e inicia una nueva transaccion.
			rollback transaction
			print ('Esta repetido la Persona')
			BEGIN TRANSACTION
		end
		ELSE
		begin
			exec sp_AddPerson @idPersonType = @idPersonType, @idBloodType = @idBloodType, @idCountry = @idCountry, @identificationNumber =@identificationNumber, @namePerson = @namePerson, 
			@lastnamePerson = @lastnamePerson, @dateOfBirth = @dateOfBirth
		end

		FETCH NEXT FROM  CursorPerR into @idPersonType, @idBloodType, @idCountry, @identificationNumber, @namePerson, @lastnamePerson, @dateOfBirth
	end		
	close CursorPerR
	Deallocate  CursorPerR
	-- Si no hubo nadie repetido, se realizara el commit de todas las personas ya ingresadas, de lo contrario no añadira nada.
	commit transaction
	Drop table #tempPersonR
END;

--Procedimiento de metodo 1
create or alter procedure sp_RegisterPersonM1
as
begin
	create table #tempPersonR2
	(
		idPersonType int,
		idBloodType int, 
		idCountry int,
		identificationNumber varchar(25),
		namePerson varchar(150),
		lastnamePerson varchar(150),
		dateOfBirth date
	)

		--BULK INSERT #tempPersonR
	--FROM 'filepath'
	--WITH
	--(
	--	FIELDTERMINATOR = ',',  --CSV field delimiter
	--	ROWTERMINATOR = '\n',   --Use to shift the control to next row
	--	TABLOCK
	--)

	Declare	
		 @idPersonType int, 
		 @idBloodType int, 
		 @idCountry int, 
		 @identificationNumber varchar(25),
		 @namePerson varchar(150), 
		 @lastnamePerson varchar(150), 
		 @dateOfBirth date 
	-- el cursor se basa en una tabla temporal con los archivos recien añadidos.
	DECLARE CursorPerR CURSOR FOR select * from #tempPersonR2
	OPEN  CursorPerR
	FETCH NEXT FROM  CursorPerR into @idPersonType, @idBloodType, @idCountry, @identificationNumber, @namePerson, @lastnamePerson, @dateOfBirth
	WHILE @@FETCH_STATUS = 0
	begin 
		--Inicia transaccion individual
		BEGIN TRANSACTION
		if exists(Select * from Person where identificationNumber = @identificationNumber)
		begin
		--Si esta repetida realiza rollback solamente a ese registro
			rollback transaction
			print ('Esta repetido la Persona')
		end
		ELSE
		begin
		-- al ser individual hace commit por cada registro
			exec sp_AddPerson @idPersonType = @idPersonType, @idBloodType = @idBloodType, @idCountry = @idCountry, @identificationNumber =@identificationNumber, @namePerson = @namePerson, 
			@lastnamePerson = @lastnamePerson, @dateOfBirth = @dateOfBirth
			commit transaction
		end
		FETCH NEXT FROM  CursorPerR into @idPersonType, @idBloodType, @idCountry, @identificationNumber, @namePerson, @lastnamePerson, @dateOfBirth

	end		
	close CursorPerR

	Deallocate  CursorPerR
	Drop table #tempPersonR2
END;




