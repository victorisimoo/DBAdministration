use DBBoatAdministration
go


create or alter trigger trig_PortManagement on Debarking instead of insert as
begin
declare
@occupied int,
@date date,
@count int,
@idtravel int;

Select @date = dayDebarking, @idtravel=idTravelRoute from inserted;

SELECT @occupied = COUNT(1)
From Debarking
WHERE dayDebarking = @date;

SELECT @count = COUNT(1) FROM Debarking
WHERE idTravelRoute = @idtravel

if(@occupied >=1 or @count>=5)
begin
	if(@occupied >=1)
	begin
		print('Error--El puerto ya esta ocupado por el dia')
	end
	if(@count>=5)
	begin
		Print('Error--El viaje ya tiene la cantidad maxima de puertos')
	end
end
else 
begin
	Insert into Debarking(idTravelRoute,descriptionDebarking,dayDebarking,hourDebarking)
	SELECT idTravelRoute,descriptionDebarking,dayDebarking,hourDebarking from inserted
end
end;