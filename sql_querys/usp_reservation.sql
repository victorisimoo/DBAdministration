USE DBBoatAdministration
GO

Select * From Person
Select * From Boat
Select * From CabinType
Select * From Cabin
Select * From Reservation
Select * From ReservationQueue
Select * From TravelLogBook
Select * From Travel

exec sp_AddTravel @idDeparture = 6, @idDestination = 5, @idBoat = 41, @idTravelRoute = 100, @idPerson = 10, @startDate = '2021-01-01', @endDate = '2021-02-01', @descriptionTravel = 'Hoolaaa'
exec sp_AddTravelLogBook @idTravel = 51


--Crea cabinas del mismo tipo
exec sp_AddCabin @idBoat = 41 , @idCabinType = 2, @levelCabin = 3 
exec sp_AddCabin @idBoat = 41 , @idCabinType = 2, @levelCabin = 3
exec sp_AddCabin @idBoat = 41 , @idCabinType = 2, @levelCabin = 2
exec sp_AddCabin @idBoat = 41 , @idCabinType = 2, @levelCabin = 2
--101 a 104

--crea una cabina que es unica 107
exec sp_AddCabin @idBoat = 41 , @idCabinType = 12, @levelCabin = 2

 --ingresa una persona usando la cabina 101 y confirmada
exec sp_AddReservation @idTravelLogBook = 51, @idPerson = 86, @idCabin = 101, @idChannelReservation = 2, @reservationDate = '2021-01-01', @reservationExpirationDate = '2021-02-01', @reservationStatus = 1
 
-- ingresa una persona que no tiene asociado a nadie
exec usp_reservation @cola = 1, @Delay = '00:00:02', @idBitacora = 51, @idPersona = 10, @idCabina = 103, @idCanal = 2, @Fecha = '2021-01-01', @FechadeExpiracion = '2021-02-01'

-- ingresa una persona que quiera estar en la misma cabina y en el mismo viaje por lo tanto le asignan la 102
exec usp_reservation @cola = 1, @Delay = '00:00:02', @idBitacora = 51, @idPersona = 2, @idCabina = 101, @idCanal = 2, @Fecha = '2021-01-01', @FechadeExpiracion = '2021-02-01'

-- ingresa una persona que quiera estar en la misma cabina y en el mismo viaje pero es cabina unica 
exec usp_reservation @cola = 1, @Delay = '00:00:02', @idBitacora = 51, @idPersona = 3, @idCabina = 107, @idCanal = 2, @Fecha = '2021-01-01', @FechadeExpiracion = '2021-02-01'

-- ingresa una persona que quiera estar en la misma cabina y en el mismo viaje pero es cabina unica y ya no hay espacio por consiguiente desea estar en cola
exec usp_reservation @cola = 1, @Delay = '00:00:02', @idBitacora = 51, @idPersona = 4, @idCabina = 107, @idCanal = 2, @Fecha = '2021-01-01', @FechadeExpiracion = '2021-02-01'

-- ingresa una persona que quiera estar en la misma cabina y en el mismo viaje pero es cabina unica y ya no hay espacio por consiguiente desea no estar en la cola
exec usp_reservation @cola = 0, @Delay = '00:00:02', @idBitacora = 51, @idPersona = 5, @idCabina = 107, @idCanal = 2, @Fecha = '2021-01-01', @FechadeExpiracion = '2021-02-01'


create or alter procedure usp_reservation @cola int, @Delay varchar(12), @idBitacora int, @idPersona int, @idCabina int, @idCanal int, @Fecha date, @FechadeExpiracion date  AS
begin
	declare @existsReservation int,
			@itsfull int,
			@maxCapacity int,
			@existsid int,
			@newcabin int,
			@confirmado int,
			@boteid int,
			@cabintype int;

	-- Verifica si la cabina de ese viaje esta reservada o no.
	select @existsReservation = Count(1)
	from  Reservation
	where idCabin = @idCabina AND reservationStatus = '1' AND idTravelLogBook = @idBitacora;

	-- Si existe le busca una cabina del mismo tipo
	if(@existsReservation > 0)
	begin
		set transaction isolation level read uncommitted; ---- se puede leer aunque no este confirmada
		begin tran
		--Conoce el tipo de la cabina que anteriormente se habia elegido
		Select @cabintype = C.idCabinType from CabinType C
		inner join Cabin cabina
			on cabina.idCabinType = C.idCabinType
		Where cabina.idCabin = @idCabina

		-- Conoce el bote que se subira
		Select @boteid = T.idBoat from TravelLogBook TLB
		inner join Travel T
			on  TLB.idTravel = T.idTravel
		Where @idBitacora = TLB.idTravelLogBook

		--Encuentra la proxima cabina para asignarle a la persona donde no este reservada la cabina
		Select Top 1 @newcabin = cabina.idCabin from CabinType C
		inner join Cabin cabina
			on cabina.idCabinType = C.idCabinType
		left join Reservation R
			on cabina.idCabin = R.idCabin
		Where @cabintype = C.idCabinType AND R.idCabin is null AND @boteid = cabina.idBoat

		if(@newcabin is null)
		begin
			Print('El bote no cuenta con el tipo de cabina que busca, desea ingresar a la cola')
			Print('1-> cola, 0 -> no estar en cola. Usted selecciono: 1')


				if(@cola = 1) -- La persona desea quedar en cola
				begin 
					--Ingresa a la persona a la cola de reservacion
					exec sp_AddReservationQueue @idTravelLogBook = @idBitacora, @statusReservation = '0', @dayOfReservation = @Fecha, @idPerson = @idPersona, @idReservationChannel = @idCanal, @idCabinType = @cabintype
					print('Ingresado a la cola con exito')
					commit;
				end
				else
					begin
					--La persona no quiere estar en cola rollback;
						print('Usted no quiere estar en cola. Gracias por elegirnos')
						rollback;
					end
			end
		else
		begin
				waitfor delay @Delay
				-- La persona debe elegir si confirma o no   
				set @confirmado = FLOOR(RAND()*(1-0+1))+0; -- se genera con un random
			
				if(@confirmado = 1 )
				begin
					print('la cabina que eligio fue cambiada pero le encontramos una con el mismo tipo')
					exec sp_AddReservation @idTravelLogBook = @idBitacora, @idPerson = @idPersona, @idCabin = @newcabin , @idChannelReservation = @idCanal, @reservationDate = @Fecha, @reservationExpirationDate = @FechadeExpiracion, @reservationStatus = '1'
					print('ingresado con exito')
					commit
				end
				else
				begin
					print('Usted cancelo. Gracias por elegirnos')
					--Cancelo
					rollback;
				end
		end
	end
	-- La cabina que eligio no esta reservada
	else
	begin
		set transaction isolation level read uncommitted; ---- se puede leer aunque no este confirmada
		begin tran
				waitfor delay @Delay
				-- La persona debe elegir si confirma o no   
				set @confirmado = FLOOR(RAND()*(1-0+1))+0; -- se genera con un random

				if(@confirmado = 1 )
				begin
					exec sp_AddReservation @idTravelLogBook = @idBitacora, @idPerson = @idPersona, @idCabin = @idCabina , @idChannelReservation = @idCanal, @reservationDate = @Fecha, @reservationExpirationDate = @FechadeExpiracion, @reservationStatus = '1'
					print('ingresado con exito')
					commit;
				end
				else
				begin
					print('Usted Cancelo. Gracias por elegirnos')
					--Cancelo
					rollback;
				end
			end
	end
	go

