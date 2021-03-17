--Creez tabelele Versionen si History pt Teil2

create table Versionen (VersionNr int)
create table History 
(VersionNr int primary key,
prozedurName varchar(50),
parameter1 varchar(50),
parameter2 varchar(50),
parameter3 varchar(50),
parameter4 varchar(50),
parameter5 varchar(50))


delete from History
delete from Versionen

select * from History
select * from Versionen

insert into Versionen values (0) --in tabelul de Versiuni inserez initial valoarea 0 ca sa o pot modifica pe parcurs  !!!! NU UITA sa inserezi 0

delete from History where VersionNr = 4
update Versionen set VersionNr = 3

--Instructiuni

exec createTable 'tabelProba1', 'Coloana1', 'int'
--exec Rollback_createTable 'tabelProba1'

exec addColumn 'tabelProba1', 'newColumn1', 'varchar(20)'
--exec Rollback_addColumn 'tabelProba1', 'newColumn2'

exec updateTyp 'tabelProba1', 'newColumn1', 'varchar(100)' 

exec createConstraint 'tabelProba1', 'defaultConstraint1', 'abc', 'newColumn1'
--exec Rollback_createConstraint 'tabelProba1', 'defaultConstraint1'

exec createTable 'tabelProba2', 'Coloana2', 'int'
exec createForeignKey 'tabelProba1', 'Coloana1', 'tabelProba2', 'Coloana2', 'FK_Col1_Col2'
--exec Rollback_createForeignKey 'tabelProba1', 'FK_Col1_Col2'


exec goToVersion 6


exec addColumn 'tabelProba1', 'newColumn2', 'int'
exec createConstraint 'tabelProba1', 'defaultConstraint2', '1', 'newColumn2'

/*
exec createTable 'tabelProba3', 'Coloana3', 'varchar(10)'
exec addColumn 'tabelProba3', 'newColumn3', 'char'
exec updateTyp 'tabelProba3', 'newColumn3', 'varchar(20)' 
*/