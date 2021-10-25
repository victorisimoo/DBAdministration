
USE DBBoatAdministration
GO
--Procedimiento de ingreso de N clientes

create or alter procedure sp_Register @method int
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
	--Revisa si usara el metodo de rollback masivo, si este lo es inicia la transaccion antes del cursor, si no no lo abre.
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
			-- Si es el otro metodo de continuar sin confirmar, inicia la transaccion de manera individual.
			if(@method = 1)
			begin
				BEGIN TRANSACTION
				if exists(Select * from Person where identificationNumber = @identificationNumber)
				begin
				--Continua sin confirmar, simplemente haciendo rollback a la persona repetida.
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
				--Realiza el rollback sobre todas las personas insertadas.
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