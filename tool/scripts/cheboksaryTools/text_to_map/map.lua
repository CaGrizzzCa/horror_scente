  local screen = 4


  game = {};
  game.room_names =
  {
--   "rm_praguesquare"
--  ,"rm_ivankastore"
--[[	]]  "rm_parisstreet"
--[[	]]  ,"rm_carlbridge"
--[[	]]  ,"rm_cafe"
--[[	]]  ,"rm_kitchen"
  };


function show( str )
	print( "##################################" );
	for i =1, #game.room_names do
		if game.room_names[i]:find("^rm_") then
			local rm = game.room_names[i]:gsub("^rm_","")
			local s = str:gsub("##screen##",screen):gsub("##rm##",rm)
			s = s:gsub("##screen##",screen)
			print( s );
		end
	end
end

local str = [[					<obj __type="spr" _name="spr_map_impl_##rm##" pos_x="0" pos_y="0" res="assets/interface/resources/map/screen_##screen##/##rm##">
						<obj __type="spr" _name="spr_map_impl_##rm##2" res="assets/interface/resources/map/screen_##screen##/##rm##2"/>
						<obj __type="obj" _name="obj_map_impl_##rm##_pointers" input="0" pos_x="-8" pos_y="18" pos_z="3">
							<obj __type="spr" _name="spr_map_impl_##rm##_pointer_screen_place" input="0" res="assets/interface/resources/map/pointer_screen_place"/>
							<obj __type="spr" _name="spr_map_impl_##rm##_pointer_screen_action" input="0" pos_z="3" res="assets/interface/resources/map/pointer_screen_action"/>
							<obj __type="spr" _name="spr_map_impl_##rm##_pointer_screen_puzzle" input="0" pos_x="20" pos_y="4" pos_z="3" res="assets/interface/resources/map/pointer_screen_puzzle"/>
						</obj>
					</obj>
					<obj __type="spr" _name="spr_map_impl_##rm##_block" res="assets/interface/resources/map/screen_##screen##/##rm##_block"/>]];

show( str )


local str = [[					<obj __type="spr" _name="spr_map_impl_##rm##_magnifer" pos_x="0" pos_y="0" res="assets/interface/resources/map/screen_##screen##/##rm##3"/>]];
show( str )
