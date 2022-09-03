
local dx = 400
local dy = 54
local act_y = 0.28

local level_out = [[
<?xml version="1.0" encoding="utf-8"?>
<elephant_games>
  <service_data>
    <app_data name="LevelEditor" title="Редактор уровней" version="2.10.2.80" />
    <project_data name="level_out" ext=".lev" project_path="level_out.lev" content_format="Xml" date="2015-07-03 12:28:31" guid="42240101-d610-4c0d-9f7c-3de642ef67db" />
  </service_data>
  <work_data>
    <scheme>
      <size width="1920" height="1080" />
      <scale value="1" />
##telo##
	  <start_inventory />
    </scheme>
  </work_data>
</elephant_games>
]]

function get_file_massive( fname )
	local fbuf = {}
	local count = 0;
	for line in io.lines( fname ) do
		count = count + 1;
		fbuf[ count ] = line;
	end;
	return fbuf;
end;


act_buf = get_file_massive( "D:\\Work\\CS9\\src\\doc\\text_to_level\\actions.txt" )
local action = '<action id="##id##" id_local="!!!" type="##action_type##" text="##text##" name="##name##" />';
local action_type = {use=0;get=1;clk=2;dlg=222,mmg=22,win=22}
local actions_m = {}
local actions_n = {}
local id_action = 0;
for i = 1, #act_buf do
	local str = act_buf[i]
	if str:len() > 5 then
		id_action = id_action + 10
		local block = str:sub(1,str:find("\t")-1)
		actions_m[block] = actions_m[block] or {}

		str = str:sub(str:find("\t")+1);
		local action_type = action_type[str:sub(1,str:find("\t")-1)]

		str = str:sub(str:find("\t")+1);
		local name = str:sub(1,str:find("\t")-1)

		str = str:sub(str:find("\t")+1);
		local text = str

		if text:len() == 0 then
			text = actions_n[name]
		elseif actions_n[name] and actions_n[name]:len() == 0 then
			text = "Н?У ЭЊїЧЉНї¤"
		else
			actions_n[name] = text
		end;

		table.insert( actions_m[block], {
			id = id_action;
			action_type = action_type;
			text = text;
			name = name;
		} );
		--print( block, action_type, text, name, id_action)

	end;
end

for k,v in pairs(actions_m) do
	--print(k)
end;



local blocks ='      <blocks>';
local block = '        <block id="##id##" pos_x="##pos_x##" pos_y="##pos_y##" width="250" height="35" type="##type##" objname="##objname##" header="##header##" text="##text##" />'
local links = '      <links>';
local link =  '        <link id="##id##" source_x="##pos_x_owner##" source_y="##pos_y_owner##" destination_x="##pos_x_child##" destination_y="##pos_y_child##" source_block="##id_owner##" destination_block="##id_child##" type="0" />'


buf = get_file_massive( "D:\\Work\\CS9\\src\\doc\\text_to_level\\blocks.txt" )

local dx = 375
local dy = 125
local column = 0
local row = 0
local pos_x_owner = 0
local pos_y_owner = 0

local deploy_created = false

function pos_x( column )
	return column*dx
end
function pos_y( row )
	return row*dy
end

local id = 0;
local id_rm_now = 0;
local id_link = 0
local block_type = {rm=0;zz=1;mg=2;ho=3;inv=4;dlg=6;}
local proj = {};
for i = 1, #buf do
	local str = buf[i];

	--print(str)

	if not str:find("^\t") and str:find("\t") then
--print(str)
		local header = str:sub(1,str:find("\t")-1);
		local text = str:sub(str:find("\t")+1);

		if header:find("^zz_") or header:find("^rm_") or header:find("^mg_") or header:find("^ho_") or header:find("^inv_") then
			header, text = text, header
		elseif not text:find("^zz_") and not text:find("^rm_") and not text:find("^mg_") and not text:find("^ho_") and not text:find("^inv_") then
			print( "\n\nнет имени комнаты  >>  "..str.."\n\n" );
			return
		end



			local block_type = block_type[text:sub(1,text:find("_")-1)]
			--print(block_type);
			local obj_full = text
			local obj = text:sub(text:find("_")+1)

			table.insert(proj,obj_full);

			column = column + 1

			if block_type == 0 then
				column = 0
				row = row + 1
				if id > 0 then
					local link = link:gsub("##id_owner##",id_rm_now)
									:gsub("##id_child##",id)
									:gsub("##id##",id_link)
									:gsub("##pos_x_owner##",pos_x_owner)
									:gsub("##pos_y_owner##",pos_y_owner)
									:gsub("##pos_x_child##",pos_x( column ))
									:gsub("##pos_y_child##",pos_y( row ))
					links = links.."\n"..link
					id_link = id_link + 1
					--column = column + 1

				end

				id_rm_now = id
				pos_x_owner = pos_x( column )
				pos_y_owner = pos_y( row )


			elseif block_type == 4 then
				if not deploy_created then row = row + 1 column = 0 deploy_created = true end
			else
					local link = link:gsub("##id_owner##",id_rm_now)
									:gsub("##id_child##",id)
									:gsub("##id##",id_link)
									:gsub("##pos_x_owner##",pos_x_owner)
									:gsub("##pos_y_owner##",pos_y_owner)
									:gsub("##pos_x_child##",pos_x( column ))
									:gsub("##pos_y_child##",pos_y( row ))
				links = links.."\n"..link
				
				id_link = id_link + 1
			end




			local block = block:gsub("##id##",id)
								:gsub("##type##",block_type)
								:gsub("##objname##",obj)
								:gsub("##text##",obj)
								:gsub("##header##",header)
								:gsub("##pos_x##",pos_x( column ))
								:gsub("##pos_y##",pos_y( row ))


			local action = '          <action id="##id##" id_local="!!!" type="##action_type##" text="##text##" name="##name##" />';
			if actions_m[obj_full] then
				local dy_get = 0
				local dy_other = 0

				block = block:gsub("/>",">");
				for j = 1, #actions_m[obj_full] do
					local act = actions_m[obj_full][j]
					if not act.action_type
					or not act.text
					or not act.name
					then
						print("\n\nBAD ACTION "..j.." "..(obj_full or "NULL").." >> "..(act.action_type or "NULL").." >> "..(act.name or "NULL").." >> "..(act.text or "NULL").."\n\n");
					end


					--print (act.action_type);
					if act.action_type == 22 then
						act.action_type = 2
						if not act.name:find( "^mmg_" ) then
							act.name = "mmg_"..act.name
						end
					end
					if act.action_type == 222 then
						act.action_type = 2
						if not act.name:find( "^dlg_" ) then
							act.name = "dlg_"..act.name
						end
					end

					local action = action:gsub("##id##",act.id)
											:gsub("##action_type##",act.action_type)
											:gsub("##text##",act.text)
											:gsub("##name##",act.name)

					block = block.."\n"..action

					if act.action_type == 1 then
						dy_get = dy_get + 1
					else
						dy_other = dy_other + 1
					end
				end;

				if dy_get > dy_other then
					--row = row +  math.ceil(dy_get * act_y)
				else
					--row = row + math.ceil(dy_other * act_y)
				end;

				block = block.."\n        </block>"
			end;
			blocks = blocks.."\n"..block


			--row = row + 1

			id=id+1;

		--end
	end
end;

--print(links.."\n</links>")
--print(blocks.."\n</blocks>")

level_out = level_out:gsub("##telo##",links.."\n      </links>\n"..blocks.."\n      </blocks>");
local f = io.open ( "D:\\Work\\CS9\\src\\doc\\text_to_level\\level_out.lev", "w" )
io.output( f );
io.write( level_out );
f:close()
