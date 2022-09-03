Steps to make cleaner:

1) common.lua 
replace !!RD5!! with your folder
>>>
clean_path = "D:\\Work\\!!RD5!!\\src\\doc\\SE_DEMO_cleaner\\"
proj_path = "D:\\Work\\!!RD5!!\\"
<<<

in function clean_bonus_content()
comment/uncomment line 
>>>
--os.execute("rd /s/q "..proj_path.."exe\\assets\\interface\\resources\\helper\\helper2")
<<<

2) getstruct.bat

replace !!RD5!! with your folder
>>>
Set Fld=D:\Work\!!RD5!!\exe\assets\levels\level
<<<

run getstruct.bat
now you have file FolderStruct.txt

3) XXXdemo_surv_clean.lua

replace list = {} with folders what DO NOT included in demo
get them from FolderStruct.txt

replace map pages what DO NOT included in demo

fill next lists with videos in final loc that DO NOT included in demo
local add_list_ogg 
local add_list_oggalpha 

4)fill sounds list from sound doc
sfx_all.txt - all sounds in game
sfx_use.txt - sounds in first level and all common sounds excepts reserved

5) make demo Strategy Guide version in res folder


[[[[[[[FOR SE CLEANER]]]]]]]

1)XXXse_clean.lua
change to corect SE name
exe_name = "RoyalDetective_ThePrincessReturns" 

2)
replace map pages what DO NOT included in demo
and strguide

3) in section
----------Folders additional to clean
specify correct additional folders
content cleared in common