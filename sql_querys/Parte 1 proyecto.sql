USE DBBoatAdministration
GO

CREATE OR ALTER PROCEDURE RESERVA @Delay time, @idBitacora int, @idPersona int, @idCabina int, @idCanal int, @Fecha date, @FechadeExpiracion date, @Status bit  AS
BEGIN
DECLARE @existe int;
DECLARE @estalleno int;
DECLARE @maxCapacidad int;
DECLARE @existeid int;

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
		SELECT @estalleno = Count(1), @maxCapacidad = maxPassagers
		FROM  Reservation Res
		inner join TravelLogBook traLog
			on traLog.idTravelLogBook = Res.idTravelLogBook
		inner join Travel trav
			on trav.idTravel = traLog.idTravel
		inner join Boat bote
			on bote.idBoat = trav.idBoat
		inner join CapacityBoat CapBoat
			on CapBoat.idCapacityBoat = bote.idCapacityBoat
		 
		 if(@estalleno >= @maxCapacidad)
		begin
			INSERT INTO Reservation (idTravelLogBook, idPerson, idCabin, idChannelReservation, reservationDate, reservationExpirationDate, reservationStatus)
			VALUES(@idBitacora ,@idPersona, @idCabina, @idCanal, @Fecha, @FechadeExpiracion, '0')
			Print('La capacidad del bote esta al máximo, tendrá la opción de quedar en “cola” para poder optar a un camarote.')
			INSERT INTO ReservationQueue(idTravelLogBook, idPerson, dayOfReservation,statusReservation)
			VALUES(@idBitacora, @idPersona, @Fecha, '0')
			commit

		end
		else
		begin
			INSERT INTO Reservation (idTravelLogBook, idPerson, idCabin, idChannelReservation, reservationDate, reservationExpirationDate, reservationStatus)
			VALUES(@idBitacora, @idPersona, @idCabina, @idCanal, @Fecha, @FechadeExpiracion, '1')
			WAITFOR DELAY @Delay

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

end

END


