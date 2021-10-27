----- | Processes for loading data into tables from .csv files | -----
----- | Inserting the Boat table | -----

----- | Database selection | -----
use DBBoatAdministration
go

bulk
insert Boat
from 'C:\Users\VICTORNOEHERNANDEZME\Documents\Universidad\Sexto semestre\Base de datos II\proyects\DBAdministration\data_files\Boat_data.csv'
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
from 'C:\Users\VICTORNOEHERNANDEZME\Documents\Universidad\Sexto semestre\Base de datos II\proyects\DBAdministration\data_files\BoatType_data.csv'
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
from 'C:\Users\VICTORNOEHERNANDEZME\Documents\Universidad\Sexto semestre\Base de datos II\proyects\DBAdministration\data_files\CapacityBoat_data.csv'
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
from 'C:\Users\VICTORNOEHERNANDEZME\Documents\Universidad\Sexto semestre\Base de datos II\proyects\DBAdministration\data_files\DataTable_DepartureCity.csv'
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
from 'C:\Users\VICTORNOEHERNANDEZME\Documents\Universidad\Sexto semestre\Base de datos II\proyects\DBAdministration\data_files\TableData_DestinationCity.csv'
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
from 'C:\Users\VICTORNOEHERNANDEZME\Documents\Universidad\Sexto semestre\Base de datos II\proyects\DBAdministration\data_files\DataTable_Country.csv'
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
from 'C:\Users\VICTORNOEHERNANDEZME\Documents\Universidad\Sexto semestre\Base de datos II\proyects\DBAdministration\data_files\Debarking_data.csv'
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
from 'C:\Users\VICTORNOEHERNANDEZME\Documents\Universidad\Sexto semestre\Base de datos II\proyects\DBAdministration\data_files\TravelRoute_data.csv'
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
from 'C:\Users\VICTORNOEHERNANDEZME\Documents\Universidad\Sexto semestre\Base de datos II\proyects\DBAdministration\data_files\Travel_data.csv'
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
from 'C:\Users\VICTORNOEHERNANDEZME\Documents\Universidad\Sexto semestre\Base de datos II\proyects\DBAdministration\data_files\PhonePerson_data.csv'
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
from 'C:\Users\VICTORNOEHERNANDEZME\Documents\Universidad\Sexto semestre\Base de datos II\proyects\DBAdministration\data_files\EmailPerson_data.csv'
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
from 'C:\Users\VICTORNOEHERNANDEZME\Documents\Universidad\Sexto semestre\Base de datos II\proyects\DBAdministration\data_files\MeansContact_data.csv'
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
from 'C:\Users\VICTORNOEHERNANDEZME\Documents\Universidad\Sexto semestre\Base de datos II\proyects\DBAdministration\data_files\BloodType_data.csv'
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
from 'C:\Users\VICTORNOEHERNANDEZME\Documents\Universidad\Sexto semestre\Base de datos II\proyects\DBAdministration\data_files\PersonType_data.csv'
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
from 'C:\Users\VICTORNOEHERNANDEZME\Documents\Universidad\Sexto semestre\Base de datos II\proyects\DBAdministration\data_files\PersonRegister_data.csv'
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
from 'C:\Users\VICTORNOEHERNANDEZME\Documents\Universidad\Sexto semestre\Base de datos II\proyects\DBAdministration\data_files\ReservationQueue.csv'
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
from 'C:\Users\VICTORNOEHERNANDEZME\Documents\Universidad\Sexto semestre\Base de datos II\proyects\DBAdministration\data_files\DataTable_TravelLogBook.csv'
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
from 'C:\Users\VICTORNOEHERNANDEZME\Documents\Universidad\Sexto semestre\Base de datos II\proyects\DBAdministration\data_files\Reservation.csv'
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
from 'C:\Users\VICTORNOEHERNANDEZME\Documents\Universidad\Sexto semestre\Base de datos II\proyects\DBAdministration\data_files\ChannelReservation_data.csv'
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
from 'C:\Users\VICTORNOEHERNANDEZME\Documents\Universidad\Sexto semestre\Base de datos II\proyects\DBAdministration\data_files\Cabin.csv'
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
from 'C:\Users\VICTORNOEHERNANDEZME\Documents\Universidad\Sexto semestre\Base de datos II\proyects\DBAdministration\data_files\CabinType.csv'
with (
	firstrow = 1, 
    maxerrors = 0, 
    fieldterminator = ',', 
    rowterminator = '\n'
)
go