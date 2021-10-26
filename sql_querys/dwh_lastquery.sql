/* cuantas horas y millas n�uticas lleva acumulado la tripulaci�n tipo capit�n en: 
	sus �ltimos 10 viajes
	los �ltimos 6 meses */
select SUM(tro.hoursOfTravel) as AccumulatedHours, SUM(tro.nauticalMiles) as AcumulatedNuticalMiles, pr.idPerson, pr.namePerson
from Travel tr inner join Person pr on pr.idPerson = tr.idPerson 
	inner join PersonType pt on pr.idPersonType = pt.idPersonType
	inner join TravelRoute tro on tro.idTravelRoute = tr.idTravelRoute
where pr.idPersonType = 1 and month(tr.startDate) >=  month(getdate()) - 6 and month(tr.startDate) <= month(getdate()) and year(tr.startDate) = year(getdate())
group by pr.idPerson,  pr.namePerson