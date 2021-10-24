----- | Data storage procedures | -----

----- | Choice of database | -----
use DBBoatAdministration
go
----- | Stored process to add boats | -----
create procedure sp_AddBoat @idTypeBoat int, @idCapacityBoat int, @imoBoat varchar(50), @nameBoat varchar(150), @widthBoat int, @lenghtBoat int, @depthBoat int
as
begin 
	insert into Boat (idTypeBoat, idCapacityBoat, imoBoat, nameBoat, widthBoat, lenghtBoat, depthBoat) values (@idTypeBoat, @idCapacityBoat, @imoBoat, @nameBoat, @widthBoat, @lenghtBoat, @depthBoat)
end
go

----- | Stored process to add type boats | -----
create procedure sp_AddTypeBoat @nameType varchar(150), @descriptionType varchar(250)
as
begin
	insert into TypeBoat (nameType, descriptionType) values (@nameType, @descriptionType)
end
go

----- | Stored process to add capacity boats | -----
create procedure sp_AddCapacityBoat @desciptionCapacity varchar(250), @maxPassagers int, @numberCabins int, @levelsBoat int
as
begin
	insert into CapacityBoat (descriptionCapacity, maxPassagers, numberCabins, levelsBoat) values (@desciptionCapacity, @maxPassagers, @numberCabins, @levelsBoat)
end
go

----- | Stored process to add departure city | -----
create procedure sp_AddDepartureCity @idCountry int, @nameCity varchar(150), @latitude varchar(150), @longitude varchar(150)
as
begin
	insert into DepartureCity (idCountry, nameCity, latitude, longitude) values (@idCountry, @nameCity, @latitude, @longitude)
end
go

----- | Stored process to add Destination city | -----
create procedure sp_AddDestinationCity @idCountry int, @nameCity varchar(150), @latitude varchar(150), @longitude varchar(150)
as
begin
	insert into DestinationCity (idCountry, nameCity, latitude, longitude) values (@idCountry, @nameCity, @latitude, @longitude)
end
go

----- | Stored process to add country | -----
create procedure sp_AddCountry @nameCountry varchar(150), @latitude varchar(150), @longidute varchar(150)
as
begin
	insert into Country (nameCountry, latitude, longitude) values (@nameCountry, @latitude, @latitude)
end
go

----- | Stored process to add debarking | -----
create procedure sp_AddDebarking @idTravelRoute int, @descriptionDebarking varchar(250), @dayDebarking date, @hourDebarking time
as
begin
	insert into Debarking (idTravelRoute, descriptionDebarking, dayDebarking, hourDebarking) values (@idTravelRoute, @descriptionDebarking, @dayDebarking, @hourDebarking)
end
go

----- | Stored process to add travel route | -----
create procedure sp_AddTravelRoute @nauticalMiles decimal(15, 2), @hoursOfTravel decimal(5,2), @descriptionRoute varchar(250)
as
begin
	insert into TravelRoute (nauticalMiles, hoursOfTravel, descriptionRoute) values (@nauticalMiles, @hoursOfTravel, @descriptionRoute)
end
go

----- | Stored process to add travel | -----
create procedure sp_AddTravel @idDeparture int, @idDestination int, @idBoat int, @idTravelRoute int, @idPerson int, @startDate datetime, @endDate datetime, @descriptionTravel varchar(250)
as
begin
	insert into Travel (idDeparture, idDestination, idBoat, idTravelRoute, idPerson, startDate, endDate, descriptionTravel) values (@idDeparture, @idDestination, @idBoat, @idTravelRoute, @idPerson, @startDate, @endDate, @descriptionTravel)
end
go

----- | Stored process to add phone person | -----
create procedure sp_AddPhonePerson @idMeansContact int, @phone varchar(25)
as
begin 
	insert into PhonePerson (idMeansContact, phone) values (@idMeansContact, @phone)
end
go

----- | Stored process to add boats | -----
create procedure sp_AddEmailPerson @idMeansContact int, @email varchar(150)
as
begin 
	insert into EmailPerson (idMeansContact, email) values (@idMeansContact, @email)
end 
go

----- | Stored process to add means contact | -----
create procedure sp_AddMeansContact @idPerson int
as
begin
	insert into MeansContact (idPerson) values (@idPerson)
end
go

----- | Stored process to add blood type | -----
create procedure sp_AddBloodType @descriptionBlood varchar (150)
as
begin 
	insert into BloodType (descriptionBlood) values (@descriptionBlood)
end
go

----- | Stored process to add person type | -----
create procedure sp_AddPersonType @descriptionPersonType varchar(150)
as
begin
	insert into PersonType (descriptionPersonType) values (@descriptionPersonType)
end
go

----- | Stored process to add person | -----
create procedure sp_AddPerson @idPersonType int, @idBloodType int, @idCountry int, @identificationNumber varchar(25), @namePerson varchar(150), @lastnamePerson varchar(150), @dateOfBirth date
as
begin
	insert into Person (idPersonType, idBloodType, idCountry, identificationNumber, namePerson, lastnamePerson, dateOfBirth) values (@idPersonType, @idBloodType, @idCountry, @identificationNumber, @namePerson, @lastnamePerson, @dateOfBirth)
end
go

----- | Stored process to add reservation queue | -----
create procedure sp_AddReservationQueue @idTravelLogBook int, @statusReservation int, @dayOfReservation date, @idPerson int
as
begin
	insert into ReservationQueue (idTravelLogBook, statusReservation, dayOfReservation, idPerson) values (@idTravelLogBook, @statusReservation, @dayOfReservation, @idPerson)
end
go

----- | Stored process to add travel log book | -----
create procedure sp_AddTravelLogBook @idTravel int
as
begin 
	insert into TravelLogBook (idTravel) values (@idTravel)
end
go

----- | Stored process to add reservation | -----
create procedure sp_AddReservation @idTravelLogBook int, @idPerson int, @idCabin int, @idChannelReservation int, @reservationDate date, @reservationExpirationDate date, @reservationStatus bit
as
begin
	insert into Reservation (idTravelLogBook, idPerson, idCabin, idChannelReservation, reservationDate, reservationExpirationDate, reservationStatus) values (@idTravelLogBook, @idPerson, @idCabin, @idChannelReservation, @reservationDate, @reservationExpirationDate, @reservationStatus)
end
go

----- | Stored process to add channel reservation | -----
create procedure sp_AddChannelReservation @descriptionChannel varchar(150)
as
begin
	insert into ChannelReservation (descriptionChannel) values (@descriptionChannel)
end
go

----- | Stored process to add cabin | -----
create procedure sp_AddCabin @idBoat int, @idCabinType int, @levelCabin int
as
begin
	insert into Cabin (idBoat, idCabinType, levelCabin) values (@idBoat, @idCabinType, @levelCabin)
end
go

----- | Stored process to add cabin type | -----
create procedure sp_AddCabinType @descriptionCabinType varchar(250), @capacityCabinType int
as
begin
	insert into CabinType (descriptionCabinType, capacityCabinType) values (@descriptionCabinType, @capacityCabinType)
end
go