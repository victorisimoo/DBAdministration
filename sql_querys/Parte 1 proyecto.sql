USE DBBoatAdministration
GO

create or alter procedure usp_reservation @cola int, @Delay time, @idBitacora int, @idPersona int, @idCabina int, @idCanal int, @Fecha date, @FechadeExpiracion date  AS
begin
	declare @existsReservation int,
			@itsfull int,
			@maxCapacity int,
			@existsid int,
			@newcabin int,
			@cabintype int;

	-- Verifica si la cabina de ese viaje esta reservada o no.
	select @existsReservation = Count(1)
	from  Reservation
	where idCabin = @idCabina AND reservationStatus = '1' AND idTravelLogBook = @idBitacora;

	-- Si existe imprime error
	if(@existsReservation > 0)
	begin
		Print('Error, esa cabina ya se encuentra reservada')
	end
	else
	begin
		set transaction isolation level read uncommitted; ---- se puede leer aunque no este confirmada
		begin tran

		--Suma cantidad de personas en cabina y selecciona la capacidad maxima que tiene ese bote asociado en el mismo viaje donde se encuentran las cabinas.
			select @itsfull = SUM(capacityCabynType), @maxCapacity = maxPassagers
			from  Reservation Res
			inner join Cabin cabina
				on cabina.idCabin = Res.idCabin
			inner join CabinType tipocabina
				on tipocabina.idCabinType = cabina.idCabinType
			inner join TravelLogBook traLog
				on traLog.idTravelLogBook = Res.idTravelLogBook
			inner join Travel trav
				on trav.idTravel = traLog.idTravel
			inner join Boat bote
				on bote.idBoat = trav.idBoat
			inner join CapacityBoat CapBoat
				on CapBoat.idCapacityBoat = bote.idCapacityBoat
			group by maxPassagers
		 
			--Verifica la cantidad de personas por cabina en el bote es mayor a la capacidad maxima de personas en el bote
			 if(@itsfull >= @maxCapacity)
			begin
				--El usuario no puede ingresar al bote por lo tanto debe decir si quedar en cola o no
				Print('La capacidad del bote esta al máximo usted.... 1-> cola, 0 -> no estar en cola. Usted selecciono: ' + @cola)

				if(@cola = 1) -- La persona desea quedar en cola
				begin 
					--Conoce el tipo de la cabina que anteriormente se habia elegido
					Select @cabintype = C.idCabinType from CabinType C
					inner join Cabin cabina
						on cabina.idCabinType = C.idCabinType
					Where cabina.idCabin = @idCabina

					--Encuentra la proxima cabina para asignarle a la persona
					Select Top 1 @newcabin = R.idCabin from CabinType C
					inner join Cabin cabina
						on cabina.idCabinType = C.idCabinType
					left join Reservation R
						on R.idCabin = cabina.idCabin
					Where @cabintype = C.idCabinType 

					--Ingresa a la persona a la cola de reservacion
					insert into ReservationQueue(idTravelLogBook, idPerson, dayOfReservation,statusReservation)
					values(@idBitacora, @idPersona, @Fecha, '0')
					commit;
				end
				else
				begin
					rollback;
					print('Gracias por elegirnos')
				end
			end
			else
			begin
					waitfor delay @Delay
					-- La persona debe elegir si confirma o no 
					declare @confirmado int;   
					set @confirmado = FLOOR(RAND()*(1-0+1))+0; -- se genera con un random

				if(@confirmado = 1 )
					begin
					insert into Reservation (idTravelLogBook, idPerson, idCabin, idChannelReservation, reservationDate, reservationExpirationDate, reservationStatus)
					values(@idBitacora, @idPersona, @idCabina, @idCanal, @Fecha, @FechadeExpiracion, '1')

					select @existsid = Count(1)
					from  Reservation
					where idPerson = @idPersona AND @idCabina = idCabin AND @Fecha = reservationDate AND  @FechadeExpiracion =  reservationExpirationDate AND idTravelLogBook = @idBitacora AND idChannelReservation = @idCanal;

						if(@existsid > 0)
						begin 
							print('usted ya esta ingresado en el sistema')
							rollback;
						end
						else
						begin
							commit;
						end
					end
					else
					begin
					--Cancelo
					rollback;
					end
			end
		end

	end
end

