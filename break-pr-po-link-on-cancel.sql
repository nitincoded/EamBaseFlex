--
--Stored Procedure: uspAddPoComment
--


CREATE procedure [dbo].[uspAddPoComment](@a_pocode nvarchar(20), @a_txtcomment nvarchar(2000)) as
begin
declare @pocode nvarchar(8);
declare @txtcomment nvarchar(2000);
declare @cnt int;
declare @orgcode nvarchar(15);

set @pocode=@a_pocode;
select @orgcode=ord_org from r5orders where ord_code=@pocode;

if @pocode is null return;

set
    @txtcomment=@a_txtcomment
    ;

select @cnt=COUNT(1) from R5ADDETAILS where ADD_ENTITY='PORD' and ADD_CODE=@pocode+'#'+@orgcode and CAST(ADD_TEXT AS NVARCHAR(MAX))=@txtcomment;

if @cnt=0
insert into r5addetails(
add_code, add_text,
add_line, add_created, add_user,
add_entity, add_rentity, add_type, add_rtype, add_lang, add_print)
values (
@pocode+'#'+@orgcode, @txtcomment,
(select COALESCE(MAX(ADD_LINE), 0)+10 from R5ADDETAILS where ADD_ENTITY='PORD' and ADD_CODE=@pocode+'#'+@orgcode), 
GETDATE(), 'R5',
'PORD', 'PORD', '*', '*', 'EN', '+'
);

end;

GO



--
-- Flex - R5ORDERS - PostUpdate
--

declare @ordcode nvarchar(30), @ordorg nvarchar(30), @orldiscpct numeric(10,3);
select @ordcode=ord_code, @ordorg=ord_org, @orldiscpct=coalesce(ord_udfnum01, 0) from R5ORDERS
where ORD_SQLIDENTITY=:rowid;

update r5orderlines 
set ORL_DISCPERC=@orldiscpct, 
ORL_TOTEXTRA=0 -- -1*@orldiscpct*ORL_PRICE*ORL_ORDQTY/100
where ORL_ORDER=@ordcode and ORL_ORDER_ORG=@ordorg;

update r5orders set 
ord_price=dbo.udfGetDiscountedTotal(ord_code, ord_org)
where ord_code=@ordcode and ord_org=@ordorg;
