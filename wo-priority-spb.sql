--Author: Nitin Reddy
--Version: 1.0
--DB Type: MS SQL Server
--Description: Sets the WO priority based on service problem priority

declare @evtcode nvarchar(8), @evtpriority nvarchar(30), @evtspb nvarchar(30);
declare @spbpriority nvarchar(30);

select @evtcode=evt_code, @evtpriority=EVT_PRIORITY, @evtspb=EVT_SERVICEPROBLEM from r5events where evt_sqlidentity=:rowid;

if @evtpriority is null and @evtspb is not null
begin

select @spbpriority=SPB_PRIORITY from R5SERVICEPROBLEMCODES where spb_code=@evtspb;

if @spbpriority is not null
begin
update r5events set EVT_PRIORITY=@spbpriority where evt_code=@evtcode;
end;

end;
