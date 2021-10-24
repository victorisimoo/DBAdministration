--Procedimiento de ingreso de N clientes, mandar a llamar dentro de un cursor.

create or alter procedure dbo.Person_usp_Register @idPersonType int, @idBloodType int, @idCountry int, @identificationNumber varchar(25), @namePerson varchar(150), @lastnamePerson varchar(150), @dateOfBirth date, @method int as
begin

if(@method = 0)
	begin
		begin transaction
		if exists(Select * from Person where identificationNumber = @identificationNumber)
		begin 
				rollback transaction
				print ('Esta repetido la Persona')
		end
		else
		begin
			insert into Person values (@idPersonType, @idBloodType, @idCountry, @identificationNumber, @namePerson, @lastnamePerson, @dateOfBirth, 1)
			print ('Se agrego Correctamente')
			commit transaction
		end
	end
else if(@method = 1)
	begin
		begin transaction
		if exists(Select * from Person where identificationNumber = @identificationNumber)
		begin 
				insert into Person values (@idPersonType, @idBloodType, @idCountry, @identificationNumber, @namePerson, @lastnamePerson, @dateOfBirth, 0)
				print ('Esta repetida la Persona')
		end
		else
		begin
			insert into Person values (@idPersonType, @idBloodType, @idCountry, @identificationNumber, @namePerson, @lastnamePerson, @dateOfBirth, 1)
			print ('Se agrego Correctamente')
			commit transaction
		end
	end


end;

--DELETE FROM Person WHERE idPerson = 1;
--DBCC CHECKIDENT ('Person', RESEED, 0)








