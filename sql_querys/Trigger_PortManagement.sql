use DBBoatAdministration
go


create or alter trigger trig_PortManagement on Debarking instead of insert as
begin
declare
@occupied int,
@date date,
@count int,
@idtravel int;
--Obtener fecha de insercion
Select @date = dayDebarking, @idtravel=idTravelRoute from inserted;
--Revisar si el dia ya esta en la tabla
SELECT @occupied = COUNT(1)
From Debarking
WHERE dayDebarking = @date;
--Revisar cuantos debarkings tiene un travel
SELECT @count = COUNT(1) FROM Debarking
WHERE idTravelRoute = @idtravel
--Si se cumple alguno de los dos errores detener la insercion
if(@occupied >=1 or @count>=5)
begin
--Verificar que error fue el que ocurrio
	if(@occupied >=1)
	begin
		print('Error--El puerto ya esta ocupado por el dia')
	end
	if(@count>=5)
	begin
		Print('Error--El viaje ya tiene la cantidad maxima de puertos')
	end
end
else 
begin
--Todo bien insertar
	Insert into Debarking(idTravelRoute,descriptionDebarking,dayDebarking,hourDebarking)
	SELECT idTravelRoute,descriptionDebarking,dayDebarking,hourDebarking from inserted
end
end;

--Test de funcionamiento
--Generar un nuevo route
--exec dbo.sp_AddTravelRoute @nauticalMiles = 2.00, @hoursOfTravel = 2.00, @descriptionRoute = 'hola xd'

--Generar un nuevo travel
--exec dbo.sp_AddTravel @idDeparture = 1, @idDestination =1, @idBoat = 41, @idTravelRoute = 102, @idPerson = 1, @startDate = '2021-07-07 18:06:46.000', @endDate = '2021-07-07 18:06:46.000', @descriptionTravel = 'holaxd'
--Generar Debarkings
--exec dbo.sp_AddDebarking @idTravelRoute = 102,@descriptionDebarking = 'hola xd 1', @dayDebarking = '2021-10-26',@hourDebarking = '4:12:35.000'
--exec dbo.sp_AddDebarking @idTravelRoute = 102,@descriptionDebarking = 'hola xd error', @dayDebarking = '2021-10-26',@hourDebarking = '4:12:35.000'
--exec dbo.sp_AddDebarking @idTravelRoute = 102,@descriptionDebarking = 'hola xd 2', @dayDebarking = '2021-10-27',@hourDebarking = '4:12:35.000'
--exec dbo.sp_AddDebarking @idTravelRoute = 102,@descriptionDebarking = 'hola xd 3', @dayDebarking = '2021-10-28',@hourDebarking = '4:12:35.000'
--exec dbo.sp_AddDebarking @idTravelRoute = 102,@descriptionDebarking = 'hola xd 4', @dayDebarking = '2021-10-29',@hourDebarking = '4:12:35.000'
--exec dbo.sp_AddDebarking @idTravelRoute = 102,@descriptionDebarking = 'hola xd 5', @dayDebarking = '2021-10-30',@hourDebarking = '4:12:35.000'
--exec dbo.sp_AddDebarking @idTravelRoute = 102,@descriptionDebarking = 'hola xd 6 error', @dayDebarking = '2021-10-31',@hourDebarking = '4:12:35.000'

--Para visualizar
--SELECT * FROM Travel
--SELECT * FROM TravelRoute
--SELECT * FROM Debarking
--DELETE FROM Travel WHERE idTravel = 53 --por definir
--DELETE FROM TravelRoute WHERE idTravelRoute = --por definir
--DELETE FROM Debarking WHERE idDebarking = por definir or idDebarking = por definir or idDebarking = por definir or idDebarking = por definir or idDebarking = por definir
