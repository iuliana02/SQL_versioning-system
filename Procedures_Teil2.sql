--Lab3 - Teil 2!!! -->proceduri modificate

--eine neue Tabelle erstellt (create table)
--am creat un tabel nou cu 1 coloana
alter procedure createTable
(@tableName varchar(20),
@column1 varchar(20), @column1Type varchar(20))
as
begin
	DECLARE @versiuneActuala int = 0
	SELECT @versiuneActuala = VersionNr from History --iau ultima versiune din tabelul de history
	DECLARE @versiuneV int = 0
	SELECT @versiuneV = VersionNr from Versionen --iau ultima versiune din tabelul de versiuni
	IF NOT EXISTS (SELECT 1 FROM History WHERE VersionNr = @versiuneV+1) --verific daca exista procedura cu nr Versiune + 1 in tabelul History
		INSERT INTO History VALUES (@versiuneActuala+1, 'createTable', @tableName, @column1, @column1Type, null, null) --inserez numele procedurii cu parametrii (inseamna ca nu exista)		
	UPDATE Versionen SET VersionNr = @versiuneV + 1 
	
	declare @sqlQuery1 as varchar(max)
	set @sqlQuery1 = 'create table ' + @tableName + ' ( ' + @column1 + ' ' + @column1Type + ' primary key)'

	print @sqlQuery1
	exec (@sqlQuery1)
end
go

--Rollback --> delete table
alter procedure Rollback_createTable
(@tableName varchar(20))
as
begin
	declare @sqlQuery as varchar(max)
	set @sqlQuery = 'drop table ' + @tableName

	print @sqlQuery
	exec (@sqlQuery)
end
go


--eine neue Spalte für eine Tabelle erstellt (add a column)
alter procedure addColumn
(@tableName varchar(20),
@newColumn varchar(20), @newColumnType varchar(20))
as
begin
	DECLARE @versiuneActuala int = 0
	SELECT @versiuneActuala = VersionNr from History --iau ultima versiune din tabelul de versiuni
	DECLARE @versiuneV int = 0
	SELECT @versiuneV = VersionNr from Versionen --iau ultima versiune din tabelul de versiuni
	--print @versiuneActuala
	IF NOT EXISTS (SELECT 1 FROM History WHERE VersionNr = @versiuneV+1) --verific daca exista procedura asta in tabelul History prin verificarea versiunii actuale cu foreign key-ul VersionNr
		INSERT INTO History VALUES (@versiuneActuala+1, 'addColumn', @tableName, @newColumn, @newColumnType, null, null) --inserez numele procedurii cu parametrii (inseamna ca nu exista)
	UPDATE Versionen SET VersionNr = @versiuneV + 1 

	declare @sqlQuery as varchar(max)
	set @sqlQuery = 'alter table ' + @tableName + ' add ' + @newColumn + ' ' + @newColumnType
	print @sqlQuery
	exec (@sqlQuery)
end
go


--Rollback --> delete column
alter procedure Rollback_addColumn
(@tableName varchar(20),
@newColumn varchar(20))
as
begin
	declare @sqlQuery as varchar(max)
	set @sqlQuery = 'alter table ' + @tableName + ' drop column ' + @newColumn
	print @sqlQuery
	exec (@sqlQuery)
end
go


--den Typ einer Spalte (Attribut) ändert (modify type of column)
alter procedure updateTyp
(@tableName varchar(20),
@columnName varchar(20),
@newType varchar(20))
as
begin
	DECLARE @versiuneActuala int = 0
	SELECT @versiuneActuala = VersionNr from History --iau ultima versiune din tabelul de versiuni
	DECLARE @versiuneV int = 0
	SELECT @versiuneV = VersionNr from Versionen --iau ultima versiune din tabelul de versiuni
	--print @versiuneActuala
	IF NOT EXISTS (SELECT 1 FROM History WHERE VersionNr = @versiuneV+1) --verific daca exista procedura asta in tabelul History prin verificarea versiunii actuale cu foreign key-ul VersionNr
		INSERT INTO History VALUES (@versiuneActuala+1, 'updateTyp', @tableName, @columnName, @newType, null, null) --inserez numele procedurii cu parametrii (inseamna ca nu exista)
	UPDATE Versionen SET VersionNr = @versiuneV + 1 

	declare @sqlQuery1 as varchar(max)
--	if @newType like '_%)'
--		set @sqlQuery1 = 'alter table ' + @tableName + ' alter column ' + @columnName + ' ' + @newType + ')'''
--	else
		set @sqlQuery1 = 'alter table ' + @tableName + ' alter column ' + @columnName + ' ' + @newType
	
	print @sqlQuery1
	exec (@sqlQuery1)
end
go


--Rollback Operation
--aceeasi sintaxa pt procedura de rollback
alter procedure Rollback_updateTyp
(@tableName varchar(20),
@columnName varchar(20),
@newType varchar(20))
as
begin
	declare @sqlQuery1 as varchar(max)
	declare @oldType as varchar(20)
	select @oldType = parameter3 from History where prozedurName = 'addColumn'
	set @newType = @oldType

	set @sqlQuery1 = 'alter table ' + @tableName + ' alter column ' + @columnName + ' ' + @newType
	
	print @sqlQuery1
	exec (@sqlQuery1)
end
go


--ein default Constraint erstellt
alter procedure createConstraint
(@tableName varchar(20),
@constraintName varchar(20),
@value varchar(10),
@column varchar(20))
as
begin
	DECLARE @versiuneActuala int = 0
	SELECT @versiuneActuala = VersionNr from History --iau ultima versiune din tabelul de versiuni
	DECLARE @versiuneV int = 0
	SELECT @versiuneV = VersionNr from Versionen --iau ultima versiune din tabelul de versiuni
	--print @versiuneActuala
	IF NOT EXISTS (SELECT 1 FROM History WHERE VersionNr = @versiuneV+1) --verific daca exista procedura asta in tabelul History prin verificarea versiunii actuale cu foreign key-ul VersionNr
		INSERT INTO History VALUES (@versiuneActuala+1, 'createConstraint', @tableName, @constraintName, @value, @column, null) --inserez numele procedurii cu parametrii (inseamna ca nu exista)
	UPDATE Versionen SET VersionNr = @versiuneV + 1 

	declare @sqlQuery1 as varchar(max)
	if @value like '%[_0-9]%'
		set @sqlQuery1 = 'alter table ' + @tableName + ' add constraint ' + @constraintName + ' default  ' + @value + ' for ' + @column
	else
		set @sqlQuery1 = 'alter table ' + @tableName + ' add constraint ' + @constraintName + ' default  ' + '''' + @value + '''' + ' for ' + @column
	print @sqlQuery1
	exec (@sqlQuery1)
end
go


--Rollback
alter procedure Rollback_createConstraint
(@tableName varchar(20),
@constraintName varchar(20))
as
begin
	declare @sqlQuery as varchar(max)
	set @sqlQuery = 'alter table ' + @tableName + ' drop constraint ' + @constraintName
	print @sqlQuery
	exec (@sqlQuery)
end
go


--eine Referenz-Integritätsregel erstellt (foreign key constraint)
alter proc createForeignKey
(@tableName varchar(20),
@foreignKey varchar(20), @pkTable varchar(20), @primaryKey varchar(20),
@constraintName varchar(20))
as
begin
	DECLARE @versiuneActuala int = 0
	SELECT @versiuneActuala = VersionNr from History --iau ultima versiune din tabelul de versiuni
	DECLARE @versiuneV int = 0
	SELECT @versiuneV = VersionNr from Versionen --iau ultima versiune din tabelul de versiuni
	--print @versiuneActuala
	IF NOT EXISTS (SELECT 1 FROM History WHERE VersionNr = @versiuneV+1) --verific daca exista procedura asta in tabelul History prin verificarea versiunii actuale cu foreign key-ul VersionNr
		INSERT INTO History VALUES (@versiuneActuala+1, 'createForeignKey', @tableName, @foreignKey, @pkTable, @primaryKey, @constraintName) --inserez numele procedurii cu parametrii (inseamna ca nu exista)
	UPDATE Versionen SET VersionNr = @versiuneV + 1 

	declare @sqlQuery as varchar(max)
	set @sqlQuery = 'alter table ' + @tableName + ' add constraint ' + @constraintName + ' foreign key (' + @foreignKey + ') references ' + @pkTable + '(' + @primaryKey + ');'
	print @sqlQuery
	exec (@sqlQuery)
end
go


--Rollback --> delete foreign key
alter proc Rollback_createForeignKey
(@tableName varchar(20),
@foreignKeyConstraint varchar(20))
as
begin
	declare @sqlQuery as varchar(max)
	set @sqlQuery = 'alter table ' + @tableName + ' drop constraint ' + @foreignKeyConstraint
	print @sqlQuery
	exec (@sqlQuery)
end
go
