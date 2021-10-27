USE DBBoatAdministration 
Go 

CREATE OR ALTER PROCEDURE usp_ReservationsPerDay @Date Date 
AS
BEGIN
--Reservas por dia
SELECT reservationDate,COUNT(1) as Reservaciones FROM Reservation
WHERE reservationDate = @Date
GROUP BY reservationDate
END

--exec usp_ReservationsPerDay @Date = '2021-10-08'

CREATE OR ALTER PROCEDURE usp_ReservationsPerChannel @Date Date 
AS
BEGIN
--Reservas por canal
SELECT idChannelReservation,COUNT(1) as Reservaciones FROM Reservation
WHERE reservationDate = @Date
GROUP BY idChannelReservation
END

--exec usp_ReservationsPerChannel @Date = '2021-10-08'

CREATE OR ALTER PROCEDURE usp_TravelReport @Date Datetime 
AS
BEGIN
--Viajes de salida ocupados al 85% o mas
SELECT trav.idTravel
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
		WHERE trav.startDate = @Date
		GROUP BY trav.idTravel, maxPassagers
		HAVING SUM(tipocabina.capacityCabinType) > maxPassagers*0.85 
END


CREATE OR ALTER PROCEDURE usp_DebarkingCount @Date Datetime 
AS
BEGIN
--Viajes con 3 o más desembarcaciones, indicando la ruta completa y horas de salida y llegada.
SELECT db.idTravelRoute,idDebarking,dayDebarking,hourDebarking,tr.startDate,tr.endDate  FROM DEBARKING db
inner join Travel tr
on tr.idTravelRoute = db.idTravelRoute
WHERE db.idTravelROUTE in (SELECT idTravelRoute from Debarking
GROUP BY idTravelRoute
HAVING COUNT(idTravelRoute) >= 3) AND tr.startDate = @Date
GROUP BY idDebarking, db.idTravelRoute,dayDebarking,hourDebarking,tr.startDate,tr.endDate
Order by idTravelRoute
END







CREATE OR ALTER PROCEDURE usp_CheckQueue @Date Date 
AS
BEGIN
--Cuantas reservas en cola se quedaron en dicho estatus en un mes y año específico.
select count(idReservationQueue) as 'Cantidad de Reservaciones',month(dayOfReservation) as 'Mes', year(dayOfReservation) as 'Año' 
from ReservationQueue 
where statusReservation = 0 and dayOfReservation <= @Date
group by month(dayOfReservation), year(dayOfReservation) 
order by year(dayOfReservation), month(dayOfReservation)
END

CREATE OR ALTER PROCEDURE usp_PilotReport1 @Date Date 
AS
BEGIN
--Cuantas horas y millas náuticas lleva acumulado la tripulación tipo capitán en los últimos 6 meses
select SUM(tro.hoursOfTravel) as AccumulatedHours, SUM(tro.nauticalMiles) as AcumulatedNuticalMiles, pr.idPerson, pr.namePerson
from Travel tr inner join Person pr on pr.idPerson = tr.idPerson 
	inner join PersonType pt on pr.idPersonType = pt.idPersonType
	inner join TravelRoute tro on tro.idTravelRoute = tr.idTravelRoute
where pr.idPersonType = 1 and month(tr.startDate) >=  month(getdate()) - 6 and month(tr.startDate) <= month(getdate()) and year(tr.startDate) = year(getdate())
group by pr.idPerson,  pr.namePerson
END


CREATE OR ALTER PROCEDURE usp_PilotReport2 @Date Date 
AS
BEGIN
--Cuantas horas y millas náuticas lleva acumulado la tripulación tipo capitán en Sus últimos 10 vuelos
select T.idPerson, SUM(T.hoursOfTravel) as Horas, SUM(T.nauticalMiles) as Millas
from (
     select T.idPerson,TR.hoursOfTravel,TR.nauticalMiles,row_number() over(partition by T.idPerson order by T.startDate desc) as rn
     from Travel as T
	 inner join TravelRoute TR
	 on TR.idTravelRoute = T.idTravel
     ) as T
where T.rn <= 10
group by T.idPerson
END


