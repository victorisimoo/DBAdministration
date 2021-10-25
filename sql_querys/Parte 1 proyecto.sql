USE DBBoatAdministration
GO

CREATE OR ALTER PROCEDURE RESERVA @cola int, @Delay time, @idBitacora int, @idPersona int, @idCabina int, @idCanal int, @Fecha date, @FechadeExpiracion date, @Status bit  AS
BEGIN
DECLARE @existe int;
DECLARE @estalleno int;
DECLARE @maxCapacidad int;
DECLARE @existeid int;
DECLARE @cabinanueva int;
DECLARE @tipocabina int;

-- Verifica si la cabina de ese viaje esta reservada o no.
SELECT @existe = Count(1)
FROM  Reservation
WHERE idCabin = @idCabina AND reservationStatus = '1' AND idTravelLogBook = @idBitacora;

if(@existe > 0)
begin
	Print('Error, esa cabina ya se encuentra reservada')
end
else
begin
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED; ---- QUE LO LEA AUNQUE NO ESTE CONFIRMADA
	begin tran
	--Suma cantidad de personas en cabina y selecciona la capacidad maxima que tiene ese bote asociado en el mismo viaje donde se encuentran las cabinas.
		SELECT @estalleno = SUM(capacityCabynType), @maxCapacidad = maxPassagers
		FROM  Reservation Res
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
		GROUP BY maxPassagers
		 
		 if(@estalleno >= @maxCapacidad)
		begin
			Print('La capacidad del bote esta al máximo, seleccione 1 para quedar en cola, si no lo desea coloque 0')
			if(@cola = 1) -- quiere cola
			begin 
				--Conoce el tipo de la cabina que anteriormente se habia elegido
				Select @tipocabina = C.idCabinType from CabinType C
				inner join Cabin cabina
					on cabina.idCabinType = C.idCabinType
				Where cabina.idCabin = @idCabina

				Select Top 1 @cabinanueva = idCabin from CabinType C
				inner join Cabin cabina
					on cabina.idCabinType = C.idCabinType
				Where @tipocabina = C.idCabinType AND StatusCabin = '0' 


				--Encuentra la proxima cabina para asignarle a la persona
				Select Top 1 @cabinanueva = idCabin from CabinType C
				inner join Cabin cabina
					on cabina.idCabinType = C.idCabinType
				Where @tipocabina = C.idCabinType AND StatusCabin = '0' 

				INSERT INTO Reservation (idTravelLogBook, idPerson, idCabin, idChannelReservation, reservationDate, reservationExpirationDate, reservationStatus)
				VALUES(@idBitacora ,@idPersona, @cabinanueva, @idCanal, @Fecha, @FechadeExpiracion, '0')

				INSERT INTO ReservationQueue(idTravelLogBook, idPerson, dayOfReservation,statusReservation)
				VALUES(@idBitacora, @idPersona, @Fecha, '0')
				commit;
			end
			else
			begin
				rollback;
				print('Gracias por elegirnos, la proxima será')
			end
		end
		else
		begin
				WAITFOR DELAY @Delay
				-- La persona debe elegir si confirma o no 
			    DECLARE @confirmado int;   
				set @confirmado = FLOOR(RAND()*(1-0+1))+0; -- se genera con un random

			if(@confirmado = 1 )
				begin
				INSERT INTO Reservation (idTravelLogBook, idPerson, idCabin, idChannelReservation, reservationDate, reservationExpirationDate, reservationStatus)
				VALUES(@idBitacora, @idPersona, @idCabina, @idCanal, @Fecha, @FechadeExpiracion, '1')

				SELECT @existeid = Count(1)
				FROM  Reservation
				WHERE idPerson = @idPersona AND @idCabina = idCabin AND @Fecha = reservationDate AND  @FechadeExpiracion =  reservationExpirationDate AND idTravelLogBook = @idBitacora AND idChannelReservation = @idCanal;

					if(@existeid > 0)
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

END

