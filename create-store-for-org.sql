--
--Stored Procedure: dbo.uspCreateStoreForOrg
--

create procedure [dbo].[uspCreateStoreForOrg](
@orgcod nvarchar(30)
) as
begin
	--declare @orgcod nvarchar(30);
	declare @dashval_orgcod_loc int;
	declare @cod nvarchar(30);
	declare @dupcnt int;


	select 
		@dashval_orgcod_loc=min(cnt)
	from
	(
		select 
		charindex('-', @orgcod, 1)  cnt
		union
		select
		charindex('-', @orgcod, charindex('-', @orgcod, 1)+1) cnt
	) a;


	if @dashval_orgcod_loc > 0
	begin
		select @cod=substring(@orgcod, charindex('-', @orgcod, charindex('-', @orgcod, 1)+1)+1, len(@orgcod)-charindex('-', @orgcod, charindex('-', @orgcod, 1)+1))

		select @dupcnt=count(1) from r5stores where STR_CODE=@cod+'-STO-01';
		if @dupcnt=0
		insert into r5stores(
			STR_CODE,
			STR_DESC,
			STR_CLASS,
			STR_LEADTIME,
			STR_LOCATION,
			STR_LTYPE,
			STR_PARENT,
			STR_PRICECODE,
			STR_FACILITY,
			STR_AUTOAPPVSTATUS,
			STR_ORG,
			STR_COPY,
			STR_CLASS_ORG,
			STR_LOCATION_ORG,
			STR_PRICETYPE,
			STR_UPDATECOUNT,
			STR_CREATED,
			STR_UPDATED,
			STR_AUTOPOSTATUS,
			STR_RESERVEDPARTBUFFER,
			STR_INTERNALLEADTIME,
			STR_SUNDAY,
			STR_MONDAY,
			STR_TUESDAY,
			STR_WEDNESDAY,
			STR_THURSDAY,
			STR_FRIDAY,
			STR_SATURDAY,
			STR_NOTUSED,
			STR_PRINTER,
			STR_PRINTSERVER,
			STR_ISSUETEMPLATE,
			STR_RECEIPTTEMPLATE,
			STR_NONPOTEMPLATE,
			STR_SEGMENTVALUE,
			STR_STRECEIPTTEMPLATE,
			STR_ENTERPRISELOCATION,
			STR_LASTSTATUSUPDATE,
			STR_UDFCHAR01,
			STR_UDFCHAR02,
			STR_UDFCHAR03,
			STR_UDFCHAR04,
			STR_UDFCHAR05,
			STR_UDFCHAR06,
			STR_UDFCHAR07,
			STR_UDFCHAR08,
			STR_UDFCHAR09,
			STR_UDFCHAR10,
			STR_UDFCHAR11,
			STR_UDFCHAR12,
			STR_UDFCHAR13,
			STR_UDFCHAR14,
			STR_UDFCHAR15,
			STR_UDFCHAR16,
			STR_UDFCHAR17,
			STR_UDFCHAR18,
			STR_UDFCHAR19,
			STR_UDFCHAR20,
			STR_UDFCHAR21,
			STR_UDFCHAR22,
			STR_UDFCHAR23,
			STR_UDFCHAR24,
			STR_UDFCHAR25,
			STR_UDFCHAR26,
			STR_UDFCHAR27,
			STR_UDFCHAR28,
			STR_UDFCHAR29,
			STR_UDFCHAR30,
			STR_UDFNUM01,
			STR_UDFNUM02,
			STR_UDFNUM03,
			STR_UDFNUM04,
			STR_UDFNUM05,
			STR_UDFDATE01,
			STR_UDFDATE02,
			STR_UDFDATE03,
			STR_UDFDATE04,
			STR_UDFDATE05,
			STR_UDFCHKBOX01,
			STR_UDFCHKBOX02,
			STR_UDFCHKBOX03,
			STR_UDFCHKBOX04,
			STR_UDFCHKBOX05,
			STR_TAX_PARTS,
			STR_TAX_SERVICES,
			STR_SYSTEM,
			STR_SYSTEM_ORG,
			STR_WARRANTYTEMPLATE
		) VALUES (
			@cod+'-STO-01',
			@cod+' Store',
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			'U',
			@orgcod,
			'-',
			NULL,
			NULL,
			'A',
			0,
			GETDATE(),
			NULL,
			NULL,
			999.9,
			NULL,
			'+',
			'+',
			'+',
			'+',
			'+',
			'+',
			'+',
			'-',
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			GETDATE(),
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			'-',
			'-',
			'-',
			'-',
			'-',
			NULL,
			NULL,
			NULL,
			NULL,
			NULL
		);

		select @dupcnt=count(1) from r5bins where BIN_STORE=@cod+'-STO-01';
		if @dupcnt=0
		insert into r5bins (
			BIN_STORE,
			BIN_CODE,
			BIN_DESC,
			BIN_CREATED,
			BIN_CREATEDBY,
			BIN_UPDATED,
			BIN_UPDATEDBY,
			BIN_NOTUSED,
			BIN_UPDATECOUNT
		) VALUES (
			@cod+'-STO-01',
			'*',
			'T.B.D.',
			GETDATE(),
			'R5',
			NULL,
			NULL,
			'-',
			0
		);

		select @dupcnt=count(1) from r5descriptions where DES_CODE=@cod+'-STO-01';
		if @dupcnt=0
		insert into r5descriptions (
			DES_ENTITY,
			DES_RENTITY,
			DES_TYPE,
			DES_RTYPE,
			DES_CODE,
			DES_LANG,
			DES_TEXT,
			DES_TRANS,
			DES_ORG,
			DES_UPDATECOUNT
		) VALUES (
			'STOR',
			'STOR',
			'*',
			'*',
			@cod+'-STO-01',
			'EN',
			@cod+' Store',
			'+',
			@orgcod,
			0
		);
	end;
end;

GO



--
--Flex - r5organization - PostInsert
--

declare @orgcode nvarchar(30);
select @orgcode=org_code from r5organization where org_sqlidentity=:rowid;
exec dbo.uspCreateStoreForOrg @orgcode;
