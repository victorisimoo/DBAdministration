----- | Processes for loading data into tables from .csv files | -----
----- | Inserting the Boat table | -----
bulk
insert Boat
from 'filepath'
with (
	firstrow = 1, 
    maxerrors = 0, 
    fieldterminator = ',', 
    rowterminator = '\n'
)
go

----- | Inserting the TypeBoat table | -----
bulk
insert TypeBoat
from 'filepath'
with (
	firstrow = 1, 
    maxerrors = 0, 
    fieldterminator = ',', 
    rowterminator = '\n'
)
go

----- | Inserting the CapacityBoat table | -----
bulk
insert CapacityBoat
from 'filepath'
with (
	firstrow = 1, 
    maxerrors = 0, 
    fieldterminator = ',', 
    rowterminator = '\n'
)
go

----- | Inserting the DepartureCity table | -----
bulk
insert DepartureCity
from 'filepath'
with (
	firstrow = 1, 
    maxerrors = 0, 
    fieldterminator = ',', 
    rowterminator = '\n'
)
go

----- | Inserting the DestinationCity table | -----
bulk
insert DestinationCity
from 'filepath'
with (
	firstrow = 1, 
    maxerrors = 0, 
    fieldterminator = ',', 
    rowterminator = '\n'
)
go

----- | Inserting the Country table | -----
bulk
insert Country
from 'filepath'
with (
	firstrow = 1, 
    maxerrors = 0, 
    fieldterminator = ',', 
    rowterminator = '\n'
)
go

----- | Inserting the Debarking table | -----
bulk
insert Debarking
from 'filepath'
with (
	firstrow = 1, 
    maxerrors = 0, 
    fieldterminator = ',', 
    rowterminator = '\n'
)
go

----- | Inserting the TravelRoute table | -----
bulk
insert TravelRoute
from 'filepath'
with (
	firstrow = 1, 
    maxerrors = 0, 
    fieldterminator = ',', 
    rowterminator = '\n'
)
go

----- | Inserting the Travel table | -----
bulk
insert Travel
from 'filepath'
with (
	firstrow = 1, 
    maxerrors = 0, 
    fieldterminator = ',', 
    rowterminator = '\n'
)
go

----- | Inserting the PhonePerson table | -----
bulk
insert PhonePerson
from 'filepath'
with (
	firstrow = 1, 
    maxerrors = 0, 
    fieldterminator = ',', 
    rowterminator = '\n'
)
go

----- | Inserting the EmailPerson table | -----
bulk
insert EmailPerson
from 'filepath'
with (
	firstrow = 1, 
    maxerrors = 0, 
    fieldterminator = ',', 
    rowterminator = '\n'
)
go

----- | Inserting the MeansContact table | -----
bulk
insert MeansContact
from 'filepath'
with (
	firstrow = 1, 
    maxerrors = 0, 
    fieldterminator = ',', 
    rowterminator = '\n'
)
go

----- | Inserting the BloodType table | -----
bulk
insert BloodType
from 'filepath'
with (
	firstrow = 1, 
    maxerrors = 0, 
    fieldterminator = ',', 
    rowterminator = '\n'
)
go

----- | Inserting the PersonType table | -----
bulk
insert PersonType
from 'filepath'
with (
	firstrow = 1, 
    maxerrors = 0, 
    fieldterminator = ',', 
    rowterminator = '\n'
)
go

----- | Inserting the Person table | -----
bulk
insert Person
from 'filepath'
with (
	firstrow = 1, 
    maxerrors = 0, 
    fieldterminator = ',', 
    rowterminator = '\n'
)
go 

----- | Inserting the ReservationQueue table | -----
bulk
insert ReservationQueue
from 'filepath'
with (
	firstrow = 1, 
    maxerrors = 0, 
    fieldterminator = ',', 
    rowterminator = '\n'
)
go

----- | Inserting the TravelLogBook table | -----
bulk
insert TravelLogBook
from 'filepath'
with (
	firstrow = 1, 
    maxerrors = 0, 
    fieldterminator = ',', 
    rowterminator = '\n'
)
go

----- | Inserting the Reservation table | -----
bulk
insert Reservation
from 'filepath'
with (
	firstrow = 1, 
    maxerrors = 0, 
    fieldterminator = ',', 
    rowterminator = '\n'
)
go

----- | Inserting the ChannelReservation table | -----
bulk
insert ChannelReservation
from 'filepath'
with (
	firstrow = 1, 
    maxerrors = 0, 
    fieldterminator = ',', 
    rowterminator = '\n'
)
go

----- | Inserting the Cabin table | -----
bulk
insert Cabin
from 'filepath'
with (
	firstrow = 1, 
    maxerrors = 0, 
    fieldterminator = ',', 
    rowterminator = '\n'
)
go

----- | Inserting the CabinType table | -----
bulk
insert CabinType
from 'filepath'
with (
	firstrow = 1, 
    maxerrors = 0, 
    fieldterminator = ',', 
    rowterminator = '\n'
)
go