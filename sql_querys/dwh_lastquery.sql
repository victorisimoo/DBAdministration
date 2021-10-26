USE DBBoatAdministration 
Go 
--Hacerlo procedimiento
--Reservas por dia
SELECT reservationDate,COUNT(1) as Reservaciones FROM Reservation
WHERE reservationDate = CAST(CURRENT_TIMESTAMP AS DATE)
GROUP BY reservationDate



--Reservas por canal
SELECT COUNT(1) as Reservaciones FROM Reservation
WHERE reservationDate = CAST(CURRENT_TIMESTAMP AS DATE)
GROUP BY idChannelReservation


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
		GROUP BY trav.idTravel, maxPassagers
		HAVING SUM(tipocabina.capacityCabinType) > maxPassagers*0.85

--Viajes con 3 o más desembarcaciones, indicando la ruta completa y horas de salida y llegada.
SELECT db.idTravelRoute,idDebarking,dayDebarking,hourDebarking,tr.startDate,tr.endDate  FROM DEBARKING db
inner join Travel tr
on tr.idTravelRoute = db.idTravelRoute
WHERE db.idTravelROUTE in (SELECT idTravelRoute from Debarking
GROUP BY idTravelRoute
HAVING COUNT(idTravelRoute) >= 3)
GROUP BY idDebarking, db.idTravelRoute,dayDebarking,hourDebarking,tr.startDate,tr.endDate
Order by idTravelRoute








--Cuantas reservas en cola se quedaron en dicho estatus en un mes y año específico.
select count(idReservationQueue) as 'Cantidad de Reservaciones',month(dayOfReservation) as 'Mes', year(dayOfReservation) as 'Año' 
from ReservationQueue 
where statusReservation = 0 and dayOfReservation <= CAST(CURRENT_TIMESTAMP AS DATE) 
group by month(dayOfReservation), year(dayOfReservation) 
order by year(dayOfReservation), month(dayOfReservation)


--Cuantas horas y millas náuticas lleva acumulado la tripulación tipo capitán en los últimos 6 meses
select SUM(tro.hoursOfTravel) as AccumulatedHours, SUM(tro.nauticalMiles) as AcumulatedNuticalMiles, pr.idPerson, pr.namePerson
from Travel tr inner join Person pr on pr.idPerson = tr.idPerson 
	inner join PersonType pt on pr.idPersonType = pt.idPersonType
	inner join TravelRoute tro on tro.idTravelRoute = tr.idTravelRoute
where pr.idPersonType = 1 and month(tr.startDate) >=  month(getdate()) - 6 and month(tr.startDate) <= month(getdate()) and year(tr.startDate) = year(getdate())
group by pr.idPerson,  pr.namePerson

--PENDIENTE REVISAR Cuantas horas y millas náuticas lleva acumulado la tripulación tipo capitán en Sus últimos 10 vuelos
--Select pr.idPerson, pr.namePerson, (select top 10 SUM(tro.hoursOfTravel) as AccumulatedHours
--from Travel tr inner join Person pr on pr.idPerson = tr.idPerson
--inner join PersonType pt on pr.idPersonType = pt.idPersonType
--inner join TravelRoute tro on tro.idTravelRoute = tr.idTravelRoute
--inner join Travel  trav on trav.idTravel = tr.idTravel 
--where pr.idPersonType = 1
--group by pr.idPerson, pr.namePerson, trav.StartDate
--order by trav.StartDate) as HorasAcumuladas,
--(select top 10 SUM(tro.nauticalMiles) as AcumulatedNuticalMiles
--from Travel tr inner join Person pr on pr.idPerson = tr.idPerson
--inner join PersonType pt on pr.idPersonType = pt.idPersonType
--inner join TravelRoute tro on tro.idTravelRoute = tr.idTravelRoute
--inner join Travel  trav on trav.idTravel = tr.idTravel 
--where pr.idPersonType = 1
--group by pr.idPerson, pr.namePerson, trav.StartDate
--order by trav.StartDate) as MillasAcumuladas
--from Travel tr inner join Person pr on pr.idPerson = tr.idPerson
--inner join PersonType pt on pr.idPersonType = pt.idPersonType
--inner join TravelRoute tro on tro.idTravelRoute = tr.idTravelRoute
--where pr.idPersonType = 1
--group by pr.idPerson, pr.namePerson



