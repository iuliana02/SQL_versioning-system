--Schimba din versiunea actuala in versiunea data ca parametru

alter procedure goToVersion (@versiune_data int)
as
begin
	declare @versiune_actuala int
	select @versiune_actuala = VersionNr from Versionen --setez ultima versiune din History ca si versiune actuala

	declare @versiune_string as char
	declare @procedura as varchar(50)
	declare @param1 as varchar(30)
	declare @param2 as varchar(30)
	declare @param3 as varchar(30)
	declare @param4 as varchar(30)
	declare @param5 as varchar(30)

	--daca versiunea data ca parametru e chiar versiunea la care sunt acum
	if @versiune_actuala = @versiune_data
	begin
		print 'Same Version!';
		return;
	end
	--daca versiunea data ca parametru nu exista in tabelul de versiuni (deci e mai mare ca versiunea actuala)
	if @versiune_data not in (select VersionNr from History) and @versiune_data != 0
	begin
		print 'This version does not exist yet!';
		return;
	end

	--cazul in care versiunea data e mai mica ca versiunea actuala --> trebuie sa merg inapoi si sa execut rollback-urile procedurilor precedente 
	--pana ajung la versiunea data
	if @versiune_data < @versiune_actuala
		while @versiune_data < @versiune_actuala
		begin
			select @procedura = prozedurName from History where VersionNr = @versiune_actuala
			
			 --daca am o procedura simpla, o sa pun in fata numelui procedurii 'Rollback_'
--			begin
			declare @reverse_procedure as varchar(50)
			set @reverse_procedure = 'Rollback_' + @procedura + ' ' 
			declare @sql_query2 as varchar(100)
			select @param1 = parameter1 from History where VersionNr = @versiune_actuala 
			--cel putin 1 argument am la toate procedurile cu Rollback
				
			--cazul pt foreign key
			declare @param_special as varchar(30)
			select @param_special = parameter5 from History where VersionNr = @versiune_actuala 
			if @procedura = 'createForeignKey'
			begin
				set @sql_query2 = @reverse_procedure + '''' + @param1 + ''',''' + @param_special + ''''
				exec (@sql_query2);
				print (@sql_query2);
			end
			else
			begin
				set @sql_query2 = @reverse_procedure + '''' + @param1 + ''''

				select @param2 = parameter2 from History where VersionNr = @versiune_actuala 
				select @param3 = parameter3 from History where VersionNr = @versiune_actuala 

				if @procedura != 'createTable'
				begin
					set @sql_query2 = @sql_query2 + ' , ''' + @param2 + ''''
					if @procedura = 'updateTyp'
						set @sql_query2 = @sql_query2 + ' , ''' + @param3 +''''
				end
			
				exec (@sql_query2);
				print (@sql_query2); 
			end

			update Versionen set VersionNr = @versiune_actuala-1 
			set @versiune_actuala = @versiune_actuala - 1;
		end


	--cazul in care versiunea data ca parametru e mai mare ca versiunea actuala --> trebuie sa merg inainte si sa execut fiecare procedura pe rand 
	--pana ajung la versiunea data
	if @versiune_data > @versiune_actuala
	begin
		while @versiune_data > @versiune_actuala
		begin
			set @versiune_actuala = @versiune_actuala + 1;
			select @procedura = prozedurName from History where VersionNr = @versiune_actuala
			declare @sql_query as varchar(max)
			select @param1 = parameter1 from History where VersionNr = @versiune_actuala 
			select @param2 = parameter2 from History where VersionNr = @versiune_actuala 
			select @param3 = parameter3 from History where VersionNr = @versiune_actuala 
			set @sql_query = @procedura + ' ' + '''' + @param1 + ''',''' + '' + @param2 + ''',''' + @param3 + ''''
			
			if @procedura = 'createConstraint' or @procedura =  'createForeignKey'
			begin
				select @param4 = parameter4 from History where VersionNr = @versiune_actuala 
				set @sql_query = @sql_query + ',''' + @param4 + ''''
				if @procedura = 'createForeignKey'
				begin
					select @param5 = parameter5 from History where VersionNr = @versiune_actuala 
					set @sql_query = @sql_query + ',''' + @param5 + ''''
				end
			end

			exec (@sql_query)
			print (@sql_query)

			update Versionen set VersionNr = @versiune_actuala where VersionNr = @versiune_data
		end
	
end
end
go



--exec goToVersion 3