use DBBoatAdministration
go


create or alter trigger PortCheck on Debarking instead of insert as
begin
declare
@occupied int,
@date date;

Select @date = dayDebarking from inserted;

SELECT @occupied = COUNT(1)
From Debarking
WHERE dayDebarking = @date;

if(@occupied >=1)
begin
	Print('Puerto ocupado por el dia')
end
else 
begin
	Insert into Debarking(idTravelRoute,descriptionDebarking,dayDebarking,hourDebarking)
	SELECT idTravelRoute,descriptionDebarking,dayDebarking,hourDebarking from inserted
end
end;




