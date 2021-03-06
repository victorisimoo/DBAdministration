USE DBBoatAdministration
GO
----- | Cancellation of the reservation | -----
create or alter procedure sp_CancelReservation @ReservationID int
as
begin 
--Revisa si existe una reservación con ese código
	if exists(select * from Reservation where idReservation = @ReservationID)
	begin
		declare @DateReservation date
		--Revisa 
		set @DateReservation = (select StartDate from Travel T 
								inner join TravelLogBook TL 
								on T.idTravel = TL.idTravel
								inner join Reservation R
								on R.idTravelLogBook = TL.idTravelLogBook
								where idReservation = @ReservationID)
		if(@DateReservation >= (convert(date ,getdate())))
		begin
			--Guarda el camarote, la bitacora del viaje y el tipo de camarote
			declare @IDCabintype int, @IDTravellogbook int, @IDCabin int
			set @IDCabintype = (select idCabinType from Cabin C
								inner join Reservation R
								on R.idCabin = C.idCabin
								where idReservation = @ReservationID);
			set @IDTravellogbook = (select idTravelLogBook from Reservation where idReservation = @ReservationID);
			set @IDCabin = (select idCabin from Reservation where idReservation = @ReservationID);
			--Cancelo la reservación y libero el camarote
			update Reservation 
			set reservationStatus = 2, idCabin = null
			where idReservation = @ReservationID;

			--Revisa si hay personas esperando para ocupar la cabina
			if exists(select * from ReservationQueue where idTravelLogBook = @IDTravellogbook and idCabinType = @IDCabintype)
			begin
				--Asigna variables de apoyo para la inserción de la persona en cola en reservación
				set @ReservationID = (select top 1 idReservationQueue from ReservationQueue where idTravelLogBook = @IDTravellogbook and idCabinType = @IDCabintype order by dayOfReservation)
				set @DateReservation = @DateReservation;
				declare @IDChannel int, @ReservationDay date, @IDPerson int
				set @IDPerson = (select idPerson from ReservationQueue where  idReservationQueue = @ReservationID);
				set @IDChannel = (select idChannelReservation from ReservationQueue where  idReservationQueue = @ReservationID);
				set @ReservationDay = (select dayOfReservation from ReservationQueue where  idReservationQueue = @ReservationID);
				--Inserta en Reservación la persona que estaba en cola
				exec sp_AddReservation @idTravelLogBook = @IDTravellogbook, @idPerson = @IDPerson, @idCabin = @IDCabin, @idChannelReservation = @IDChannel, @reservationDate = @ReservationDay, @reservationExpirationDate = @DateReservation, @reservationStatus = 1
				--Actualiza el estado de la persona que se encontraba en la cola
				update ReservationQueue
				set statusReservation = 1
				where idReservationQueue = @ReservationID;
			end
			print('La cancelación ha sido un exito')
		end
		else
		begin
			print('La fecha para cancelar el viaje ya ha pasado.')
		end
	end
	else
	begin
		print('La reservación ingresada no existe.')
	end
end
go