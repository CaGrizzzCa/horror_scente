--RUN CTRL+SHIFT+Z
clean_path = "D:\\Work\\CS9\\src\\doc\\SE_DEMO_cleaner\\"
proj_path = "D:\\Work\\CS9\\"

dofile(clean_path.."common.lua") -- attach common functions

exe_name = "ChristmasStories_TheChristmasTreeForest"

os.execute("rename "..proj_path.."exe\\"..exe_name.."_CE.exe "..exe_name..".exe ")
os.execute("rename "..proj_path.."exe\\"..exe_name.."_CE_Editor.exe "..exe_name.."_Editor.exe ")


list = {
[[

]],

[[
map\screen_2
strguide
]]
}

replace_files_with_empties( list )

print(">> video")
local add_list_ogg = {

 --proj_path.."exe\\assets\\levels\\level\\rm_square\\".."vid_santa_1_1_voc.ogg";
 --proj_path.."exe\\assets\\levels\\level\\rm_square\\".."vid_santa_1_2_voc.ogg";
 --proj_path.."exe\\assets\\levels\\level\\rm_square\\".."vid_santa_1_3_voc.ogg";
 --
 --proj_path.."exe\\assets\\levels\\level\\rm_sweetshop\\".."vid_confectioner_cat_1_1_voc.ogg";
 --proj_path.."exe\\assets\\levels\\level\\rm_sweetshop\\".."vid_confectioner_cat_1_2_voc.ogg";

}
local add_list_oggalpha = {
  --proj_path.."exe\\assets\\levels\\level\\rm_square\\".."vid_santa_1_1_voc.oggalpha";
  --proj_path.."exe\\assets\\levels\\level\\rm_square\\".."vid_santa_1_2_voc.oggalpha";
  --proj_path.."exe\\assets\\levels\\level\\rm_square\\".."vid_santa_1_3_voc.oggalpha";
  --
  --proj_path.."exe\\assets\\levels\\level\\rm_sweetshop\\".."vid_confectioner_cat_1_1_voc.oggalpha";
  --proj_path.."exe\\assets\\levels\\level\\rm_sweetshop\\".."vid_confectioner_cat_1_2_voc.oggalpha";
  }

for k,j in ipairs(add_list_ogg) do
	os.execute("copy "..clean_path.."\\1.ogg "..j.." /y")
end
for k,j in ipairs(add_list_oggalpha) do
	os.execute("copy "..clean_path.."\\1.oggalpha "..j.." /y")
end
print("<< video")


-- + 49 m bonus content
print(">> bonus content")
	clean_bonus_content()
print(">> bonus content")

-- + collectibles
print(">> collectors edition")
----------Folders additional to clean
replace_files_with_empties( "exe\\assets\\levels\\menu\\rm_achievements\\" )
replace_files_with_empties( "exe\\assets\\levels\\menu\\rm_achievements\\achiv\\" )
replace_files_with_empties( "exe\\assets\\levels\\menu\\rm_achievements\\preview\\" )
replace_files_with_empties( "exe\\assets\\levels\\menu\\rm_collectibles\\" )
replace_files_with_empties( "exe\\assets\\interface\\int_achievements\\" )
replace_files_with_empties( "exe\\assets\\levels\\menu\\rm_extra\\" )
replace_files_with_empties( "exe\\assets\\levels\\menu\\rm_extra\\art_mini\\" )
replace_files_with_empties( "exe\\assets\\levels\\menu\\rm_extra\\hidden_object\\" )
replace_files_with_empties( "exe\\assets\\levels\\menu\\rm_extra\\mini_games\\" )
replace_files_with_empties( "exe\\assets\\levels\\menu\\rm_extra\\screensavers_mini\\" )
replace_files_with_empties( "exe\\assets\\levels\\menu\\rm_extra\\wallpapers_mini\\" )

replace_files_with_empties( "exe\\assets\\levels\\menu\\rm_screensaver\\" )
replace_files_with_empties( "exe\\assets\\levels\\menu\\rm_screensaver\\screensaver_1\\" )
replace_files_with_empties( "exe\\assets\\levels\\menu\\rm_screensaver\\screensaver_2\\" )
replace_files_with_empties( "exe\\assets\\levels\\menu\\rm_screensaver\\screensaver_3\\" )
replace_files_with_empties( "exe\\assets\\levels\\menu\\rm_screensaver\\screensaver_4\\" )
os.execute("rd /s/q "..proj_path.."exe\\assets\\levels\\menu\\rm_screensaver\\content")
print("<< collectors edition")

-- + 29 m guide
print(">> guide")
    os.execute("rd /s/q "..proj_path.."exe\\assets\\interface\\resources\\strguide\\res")
	--os.execute("rd "..proj_path.."exe\\assets\\interface\\resources\\strguide\\res /S/Q")
	--os.execute("md "..proj_path.."exe\\assets\\interface\\resources\\strguide\\res")
	--os.execute("xcopy res "..proj_path.."exe\\assets\\interface\\resources\\strguide\\res /e")
print("<< guide")


-- + 96 m audio
print(">> audio")

--~ local sfx_use = file_to_table( "sfx_use.txt" )
--~ local sfx_all = file_to_table( "sfx_all.txt" )


--~ --local all = str_to_table( all_sfx )
--~ local sfx_use = get_string_massive( sfx_use )
--~ local sfx_all = get_string_massive( sfx_all )

--~ for i = 1, #sfx_use do
--~ 	sfx_use[i] = sfx_use[i]:gsub(" ","");
--~ end
--~ for i = 1, #sfx_all do
--~ 	sfx_all[i] = sfx_all[i]:gsub(" ","");
--~ end

--~ local del = {}
--~ for i = 1, #sfx_all do
--~ 	local add = false

--~ 	for j = 1, #sfx_use do
--~ 		if sfx_all[i] == sfx_use[j] then
--~ 			--print(all[i],lvl[j])
--~ 			add = true;
--~ 			break;
--~ 		end;
--~ 	end;
--~ 	if not add then
--~ 		os.execute( "DEL | ERASE ".. proj_path.."exe\\assets\\levels\\common\\audio\\"..sfx_all[i]..".ogg")
--~ 	end;
--~ end;


print("<< audio")

print(os.clock ())










