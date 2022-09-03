
-------------DATA-----------

room_path = {
proj_path.."exe\\assets\\levels\\level\\",
proj_path.."exe\\assets\\interface\\resources\\"
}


-------------FUNCS-----------

function get_string_massive( stringfull )
	local fbuf = {}
	local count = 0;
	while stringfull:find( "\n" ) do
		count = count + 1;
		local lbuf = stringfull:sub(1,stringfull:find("\n")-1)
		stringfull = stringfull:sub(stringfull:find("\n")+1)
		if lbuf ~= "" then
			fbuf[ count ] = lbuf;
		end
	end;
	return fbuf;
end;

function file_to_table( fname )
	local fbuf = {}
	for line in io.lines( fname ) do
		if line:len() > 4 then
			table.insert( fbuf, line )
		end
	end;
	return fbuf;
end;

function replace_files_with_empties( list )
	local function clean_folder(path)
		local extentions = {"png", "jpg", "ogg", "oggalpha"}
		for i,o in ipairs(extentions) do
			local a,b,c,d = os.execute("for %i in ("..path.."\\*."..o..") do copy "..clean_path.."\\1."..o.." %i /y")
			if not a then
				print(a,b,c,d)
			end
		end
	end

	local one = type(list) == "string"
	if one then
		list = {{list}}
	else
		for i = 1, #list do
			list[ i ] = list[ i ]:gsub( room_path[ i ], "" )
			list[ i ] = get_string_massive( list[ i ] )
		end
	end

	for k,j in ipairs(list) do
		for i,o in ipairs(j) do
			clean_folder((one and proj_path or room_path[k])..o)
		end
	end
end

function clean_bonus_content()
	os.execute("rd /s/q "..proj_path.."exe\\assets\\levels\\menu\\rm_extra\\content")
	
	os.execute("rd /s/q "..proj_path.."exe\\assets\\levels\\menu\\rm_screensaver\\content")
	--os.execute("rd /s/q "..proj_path.."exe\\assets\\interface\\resources\\helper\\helper2")

	os.execute("rd /s/q "..proj_path.."exe\\assets\\levels\\levelext")
	os.execute("rd /s/q "..proj_path.."exe\\assets\\levels\\levelscr")
	os.execute("rd /s/q "..proj_path.."exe\\assets\\levels\\levelsgm")
end


--------VVVVVVVVVVVVVV TRASH

function str_to_table( s )
	local t = {}
	while s:find("\n") do
		local ss = s:sub(1,s:find("\n")-1)
		s = s:sub(ss:len()+2,s:len())
		--print(ss);
		if ss:len()>4 then table.insert( t, ss ) end
	end;
	return t
end;
