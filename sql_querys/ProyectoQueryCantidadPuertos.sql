use DBBoatAdministration
go

CREATE OR ALTER TRIGGER PortCount on Debarking instead of insert as
begin
declare
@count int,
@idtravel int;

Select @idtravel = idTravelRoute from inserted

SELECT @count = COUNT(1) FROM Debarking
WHERE idTravelRoute = @idtravel

if(@count>=5)
begin
    print('El viaje ya tiene la cantidad maxima de puertos')
end
else
begin
	Insert into Debarking(idTravelRoute,descriptionDebarking,dayDebarking,hourDebarking)
	SELECT idTravelRoute,descriptionDebarking,dayDebarking,hourDebarking from inserted
end
end;