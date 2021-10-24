----- | First proyect | -----
----- | Database creation script | -----
create database DBBoatAdministration
go
----- | Database selection | -----
use DBBoatAdministration
go

alter authorization on database::DBBoatAdministration to sa
go

----- | Boat table creation | -----
create table Boat (
	idBoat int identity (1, 1) primary key,
	idTypeBoat int,
	idCapacityBoat int,
	imoBoat varchar(50),
	nameBoat varchar(150),
	widthBoat int,
	lenghtBoat int,
	depthBoat int
);
go

----- | TypeBoat table creation | -----
create table TypeBoat (
	idTypeBoat int identity (1, 1) primary key,
	nameType varchar(150),
	descriptionType varchar(250)
);
go

----- | CapicityBoat table creation | -----
create table CapacityBoat (
	idCapacityBoat int identity (1, 1) primary key, 
	descriptionCapacity varchar(250),
	maxPassagers int,
	numberCabins int,
	levelsBoat int
);
go

----- | DepartureCity table creation | -----
create table DepartureCity (
	idDeparture int identity (1,1) primary key,
	idCountry int,
	nameCity varchar(150),
	latitude varchar(150),
	longitude varchar(150)
);
go

----- | DestinationCity table creation | -----
create table DestinationCity (
	idDestination int identity (1,1) primary key,
	idCountry int,
	nameCity int,
	latitude varchar(150),
	longitude varchar(150)
);
go

----- | Country table creation | -----
create table Country (
	idCountry int identity (1, 1) primary key,
	nameCountry varchar(150),
	latitude varchar(150),
	longitude varchar(150)
);
go

----- | Debarking table creation | -----
create table Debarking (
	idDebarking int identity (1,1) primary key,
	idTravelRoute int,
	descriptionDebarking varchar(250),
	dayDebarking date,
	hourDebarking time
);
go

----- | TravelRoute table creation | -----
create table TravelRoute (
	idTravelRoute int identity (1,1) primary key,
	nauticalMiles decimal (15, 2),
	hoursOfTravel decimal (5, 2),
	descriptionRoute varchar(250)
);
go

----- | Travel table creation | -----
create table Travel (
	idTravel int identity (1,1) primary key, 
	idDeparture int,
	idDestination int, 
	idBoat int,
	idTravelRoute int,
	idPerson int,
	startDate datetime,
	endDate datetime,
	descriptionTravel varchar(250)
);
go

----- | PhonePerson table creation | -----
create table PhonePerson (
	idPhone int identity (1,1) primary key,
	idMeansContact int, 
	phone varchar(25)
);
go

----- | EmailPerson table creation | -----
create table EmailPerson (
	idEmail int identity (1,1) primary key, 
	idMeansContact int, 
	email varchar(150)
);
go

----- | MeansContact table creation | -----
create table MeansContact (
	idMeansContact int identity (1,1) primary key,
	idPerson int
);
go

----- | BloodType table creation | -----
create table BloodType (
	idBloodType int identity (1,1) primary key, 
	descriptionBlood varchar(150)
);
go

----- | PersonType table creation | -----
create table PersonType (
	idPersonType int identity (1,1) primary key, 
	descriptionPersonType varchar(150)
);
go

----- | Person table creation | -----
create table Person (
	idPerson int identity (1,1) primary key,
	idPersonType int,
	idBloodType int, 
	idCountry int,
	identificationNumber varchar(25),
	namePerson varchar(150),
	lastnamePerson varchar(150),
	dateOfBirth date
);
go

----- | ReservationQueue table creation | -----
create table ReservationQueue (
	idReservationQueue int identity (1,1) primary key,
	idTravelLogBook int,
	statusReservation int,
	dayOfReservation date,
	idPerson int
);
go

----- | TravelLogBook table creation | -----
create table TravelLogBook (
	idTravelLogBook int identity (1,1) primary key,
	idTravel int
);
go

----- | Reservation table creation | -----
create table Reservation (
	idReservation int identity (1,1) primary key,
	idTravelLogBook int,
	idPerson int,
	idCabin int,
	idChannelReservation int,
	reservationDate date,
	reservationExpirationDate date,
	reservationStatus bit
);
go

----- | Channel Reservation table creation | -----
create table ChannelReservation (
	idChannelReservation int identity (1,1)  primary key,
	descriptionChannel varchar(150)
);
go
----- | Cabin table creation | -----
create table Cabin (
	idCabin int identity (1,1) primary key,
	idBoat int, 
	idCabinType int,
	levelCabin int
);
go

----- | CabinType table creation | -----
create table CabinType (
	idCabinType int identity (1,1) primary key,
	descriptionCabinType varchar(250),
	capacityCabinType int
);
go

----- | Creation of relationship between tables | -----
alter table Cabin add constraint FK_CabinType_Cabin foreign key (idCabinType) references CabinType (idCabinType)
go

alter table Cabin add constraint FK_Boat_Cabin foreign key (idBoat) references Boat (idBoat)
go

alter table Reservation add constraint FK_TravelLogBook_Reservation foreign key (idTravelLogBook) references TravelLogBook (idTravelLogBook)
go

alter table Reservation add constraint FK_Person_Reservation foreign key (idPerson) references Person (idPerson)
go

alter table Reservation add constraint FK_Cabin_Reservation foreign key (idCabin) references Cabin (idCabin)
go

alter table Reservation add constraint FK_ChannelReservation_Reservation foreign key (idChannelReservation) references ChannelReservation (idChannelReservation)
go

alter table TravelLogBook add constraint FK_Travel_TravelLogBook foreign key (idTravel) references Travel (idTravel)
go

alter table Travel add constraint FK_Departure_Travel foreign key (idDeparture) references DepartureCity (idDeparture)
go

alter table Travel add constraint FK_Destination_Travel foreign key (idDestination) references DestinationCity (idDestination)
go

alter table Travel add constraint FK_Boat_Travel foreign key (idBoat) references Boat (idBoat)
go

alter table Travel add constraint FK_TravelRoute_Travel foreign key (idTravelRoute) references TravelRoute (idTravelRoute)
go

alter table Travel add constraint FK_Person_Travel foreign key (idPerson) references Person (idPerson)

alter table ReservationQueue add constraint FK_TravelLogBook_ReservationQueue foreign key (idTravelLogBook) references TravelLogBook (idTravelLogBook)
go

alter table ReservationQueue add constraint FK_Person_ReservationQueue foreign key (idPerson) references Person (idPerson)
go

alter table DestinationCity add constraint FK_Country_DestinationCity foreign key (idCountry) references Country (idCountry)
go

alter table DepartureCity add constraint FK_Country_DepartureCity foreign key (idCountry) references Country (idCountry)
go

alter table Debarking add constraint FK_TravelRoute_Debarking foreign key (idTravelRoute) references TravelRoute (idTravelRoute)
go

alter table Person add constraint FK_PersonType_Person foreign key (idPersonType) references PersonType (idPersonType)
go

alter table Person add constraint FK_BloodType_Person foreign key (idBloodType) references BloodType (idBloodType)
go 

alter table Person add constraint FK_Country_Person foreign key (idCountry) references Country (idCountry)
go 

alter table MeansContact add constraint FK_Person_MeansContact foreign key (idPerson) references Person (idPerson)
go

alter table PhonePerson add constraint FK_MeansContact_PhonePerson foreign key (idMeansContact) references MeansContact (idMeansContact)
go

alter table EmailPerson add constraint FK_MeansContact_EmailPerson foreign key (idMeansContact) references MeansContact (idMeansContact)
go

alter table Boat add constraint FK_TypeBoat_Boat foreign key (idTypeBoat) references TypeBoat (idTypeBoat)
go

alter table Boat add constraint FK_CapacityBoat_Boat foreign key (idCapacityBoat) references CapacityBoat (idCapacityBoat)
go