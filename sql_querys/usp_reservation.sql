USE DBBoatAdministration
GO

create or alter procedure usp_reservation @cola int, @Delay time, @idBitacora int, @idPersona int, @idCabina int, @idCanal int, @Fecha date, @FechadeExpiracion date  AS
begin
	declare @existsReservation int,
			@itsfull int,
			@maxCapacity int,
			@existsid int,
			@newcabin int,
			@confirmado int,
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

		--Encuentra la proxima cabina para asignarle a la persona donde no este reservada la cabina
		Select Top 1 @newcabin = R.idCabin from CabinType C
		inner join Cabin cabina
			on cabina.idCabinType = C.idCabinType
		left join Reservation R
			on R.idCabin = cabina.idCabin
		Where @cabintype = C.idCabinType
		
		if(@newcabin is null)
		begin
			Print('El bote no cuenta con el tipo de cabina que busca, desea ingresar a la cola')
			Print('1-> cola, 0 -> no estar en cola. Usted selecciono: ' + @cola)

				if(@cola = 1) -- La persona desea quedar en cola
				begin 
					--Ingresa a la persona a la cola de reservacion
					insert into ReservationQueue(idTravelLogBook, idPerson, dayOfReservation,statusReservation,idChannelReservation,idCabinType)
					values(@idBitacora, @idPersona, @Fecha, '0', @idCanal, @cabintype)
					commit;
				end
				else
					begin
					--La persona no quiere estar en cola rollback;
						rollback;
						print('Gracias por elegirnos')
					end
			end
		else
		begin
				waitfor delay @Delay
				-- La persona debe elegir si confirma o no   
				set @confirmado = FLOOR(RAND()*(1-0+1))+0; -- se genera con un random

				if(@confirmado = 1 )
				begin
					insert into Reservation (idTravelLogBook, idPerson, idCabin, idChannelReservation, reservationDate, reservationExpirationDate, reservationStatus)
					values(@idBitacora, @idPersona, @newcabin, @idCanal, @Fecha, @FechadeExpiracion, '1')

					select @existsid = Count(1)
					from  Reservation
					where idPerson = @idPersona AND @newcabin = idCabin AND @Fecha = reservationDate AND  @FechadeExpiracion =  reservationExpirationDate AND idTravelLogBook = @idBitacora AND idChannelReservation = @idCanal;
					commit
				end
				else
				begin
					--Cancelo
					rollback;
				end
		end
	end
	-- La cabina que eligio no esta reservada
	else
	begin
				waitfor delay @Delay
				-- La persona debe elegir si confirma o no   
				set @confirmado = FLOOR(RAND()*(1-0+1))+0; -- se genera con un random

				if(@confirmado = 1 )
				begin
					insert into Reservation (idTravelLogBook, idPerson, idCabin, idChannelReservation, reservationDate, reservationExpirationDate, reservationStatus)
					values(@idBitacora, @idPersona, @idCabina, @idCanal, @Fecha, @FechadeExpiracion, '1')

					select @existsid = Count(1)
					from  Reservation
					where idPerson = @idPersona AND @idCabina = idCabin AND @Fecha = reservationDate AND  @FechadeExpiracion =  reservationExpirationDate AND idTravelLogBook = @idBitacora AND idChannelReservation = @idCanal;
						commit;
				end
				else
				begin
					--Cancelo
					rollback;
				end
			end


	end


