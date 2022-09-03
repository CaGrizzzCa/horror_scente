function get_string_massive( stringfull )
	local fbuf = {}
	local count = 0;
	while stringfull:find( "\n" ) do
		count = count + 1;
		local lbuf = stringfull:sub(1,stringfull:find("\n")-1)
		stringfull = stringfull:sub(stringfull:find("\n")+1)
		fbuf[ count ] = lbuf;

	end;

	return fbuf;
end;

writer = [[
���������	Medicine
�������_�����	Round handle
������	Glass
�������_�����	Fish figurine
�������	Fire rake
������_����	Glass of water
�����_�������	Corkscrew handle
����������_��������	Wooden ladder
����	Hook
����_��_�������	Gate key
�����_�����_6/6	Puzzle piece
������	Corkscrew
�������	Mitten
�������	Screwdriver
���� (ex.�������_������)	Disk
��������	Signet ring
������_����_1,2	Green eye
�������	Screwdriver
����_�������	Chest key
���������	Propeller
����������_��������	Wooden plane
������������	Hexagon
��������	Spring
������_������	Buzzer button
���������_�������	Girl figurine
������_� �����	Rope with hook
��������_�����	Security badge
������	Stone
������_� �����	Rope with loop
�������	Shovel
����������_�����	Wooden cone
������_������	Statue notes
�����_2	Number 2
�����_3	Number 3
�������	Screwdriver
������	Mallet
�����������	Pliers
������	Torch
������	Flint
����	Saw
�������	Twig
����_�����	Wolf fang
��������_����	Fire eye
����	Saw
�����	Label
��������	Chisel
��������	Unicorn
Ƹ����_�����	Yellow resin
������_�����	Green resin
����_�_������	Chain with hook
���������_������	Rubber boots
�����	Clamp
�����_�������_1,2	Gate part
��������_������	Winding key
�������_����	Wrench
�������	Screwdriver
�����	Screw
�������	Cutters
������_����	Print amulet
��������_�������	Stone lizard
�����������_���_��������	Ingredients for healer
�����_����	Sieve handle
���	Knife
���������	Angel
��������	Tube
�������_����	Cheese slices
���������	Fertilizer
��������	Nail puller
������	Cane
�������	Coins
����������_����	Wooden key
��������_������	Pharmacy emblem
��������1	Hieroglyph
��������2	Hieroglyph
��������3	Hieroglyph
�������_1,2	Clasp
�����_����	Hand part
���������_������	Grinding stone
������_����	Wolf amulet
������_�����	Deer amulet
������	Corkscrew
�������	Bag
�������_������	Red rowan
��������_����	Poisonous mushroom
������	Fuschia
�� �������	Carpet bag
�� �����	Book
�� �����������_����	Blunt saw
�� �������_�����	Fur bag
�� �������_������	Leather package
�� ��������	Piper
�� �����	Can
�� ������	Recipe
�� ���������	Container
����������	Opener
]]

strings = [[
pop_inv_ringbuttonext	������_������ assets\levels\levelext\rm_atworkshopext\zz_ladderext\inv_ringbuttonext	������_������
pop_inv_claspext2	�������_2 assets\levels\levelext\rm_atworkshopext\zz_ladderext\inv_claspext2	�������_2
pop_inv_corkscrewhandleext	�����_������� assets\levels\levelext\rm_atworkshopext\zz_logsext\inv_corkscrewhandleext	�����_�������
pop_inv_rockext	������ assets\levels\levelext\rm_atworkshopext\zz_logsext\inv_rockext	������
pop_inv_digitalext3	�����_3 assets\levels\levelext\rm_atworkshopext\zz_logsext\inv_digitalext3	�����_3
pop_inv_springext	�������� assets\levels\levelext\rm_atworkshopext\zz_toforestext\inv_springext	��������
pop_inv_planeext	����������_�������� assets\levels\levelext\rm_atworkshopext\zz_toforestext\inv_planeext	����������_��������
pop_inv_girlext	���������_������� assets\levels\levelext\rm_atworkshopext\zz_workshopdoorext\inv_girlext	���������_�������
pop_inv_wicketkeyext	����_��_������� assets\levels\levelext\ho_commodehoext\inv_wicketkeyext	����_��_�������
pop_inv_rakeext	������� assets\levels\levelext\rm_entrypointext\zz_aquariumext\inv_rakeext	�������
pop_inv_glasswithwaterext	������_���� assets\levels\levelext\rm_entrypointext\zz_aquariumext\inv_glasswithwaterext	������_����
pop_inv_puzzleext	�����_�����_4/6 # NO OWNER #	�����_�����_4/6
pop_inv_puzzleext_all	�����_�����_4/6 # NO OWNER #	�����_�����_4/6
pop_inv_glassext	������ assets\levels\levelext\rm_entrypointext\zz_commodeext\inv_glassext	������
pop_inv_roundhandleext	�������_����� assets\levels\levelext\rm_entrypointext\zz_fireplaceext\inv_roundhandleext	�������_�����
pop_inv_corkscrewext	������ assets\levels\levelext\rm_entrypointext\zz_fireplaceext\inv_corkscrewext	������
pop_inv_booksext	����� assets\levels\levelext\rm_entrypointext\zz_secondfloorext\inv_booksext	�����
pop_inv_spadeext	������� assets\levels\levelext\rm_entrypointext\zz_secondfloorext\inv_spadeext	�������
pop_inv_screwdriverext	������� assets\levels\levelext\rm_entrypointext\zz_wicketext\inv_screwdriverext	�������
pop_inv_fangext	����_����� assets\levels\levelext\mg_woodyext\inv_fangext	����_�����
pop_inv_grindstoneext	���������_������ assets\levels\levelext\rm_forestext\zz_dragonext\inv_grindstoneext	���������_������
pop_inv_clipext	����� assets\levels\levelext\rm_forestext\zz_dragonext\inv_clipext	�����
pop_inv_traceext	������_���� assets\levels\levelext\rm_forestext\zz_dragonext\inv_traceext	������_����
pop_inv_winderext	��������_������ assets\levels\levelext\rm_forestext\zz_dragonext\inv_winderext	��������_������
pop_inv_bagext	�������_����� assets\levels\levelext\rm_forestext\zz_flowerext\inv_bagext	�������_�����
pop_inv_screwext	����� assets\levels\levelext\rm_forestext\zz_flowerext\inv_screwext	�����
pop_inv_greenresinext	������_����� assets\levels\levelext\rm_forestext\zz_flowerext\inv_greenresinext	������_�����
pop_inv_yellowresinext	Ƹ����_����� assets\levels\levelext\rm_forestext\zz_flowerext\inv_yellowresinext	Ƹ����_�����
pop_inv_twigext	������� assets\levels\levelext\rm_forestext\zz_tomargeext\inv_twigext	�������
pop_inv_handext	�����_���� assets\levels\levelext\ho_inpantryext\inv_handext	�����_����
pop_inv_flintext	������ assets\levels\levelext\rm_inmillext\zz_cellingext\inv_flintext	������
pop_inv_keyext	����_������� assets\levels\levelext\rm_inmillext\zz_cellingext\inv_keyext	����_�������
pop_inv_propellerext	��������� assets\levels\levelext\rm_inmillext\zz_chestext\inv_propellerext	���������
pop_inv_greeneyeext2	������_����_2 assets\levels\levelext\rm_inmillext\zz_chestext\inv_greeneyeext2	������_����_2
pop_inv_hammerext	������ assets\levels\levelext\rm_inmillext\zz_lodgingsext\inv_hammerext	������
pop_inv_bootsext	���������_������ assets\levels\levelext\ho_vanhoext\inv_bootsext	���������_������
pop_inv_angelext	��������� assets\levels\levelext\rm_margeext\zz_pontoonext\inv_angelext	���������
pop_inv_wicketext2	�����_�������_2 assets\levels\levelext\rm_margeext\zz_pontoonext\inv_wicketext2	�����_�������_2
pop_inv_packageext	�������_������ assets\levels\levelext\rm_margeext\zz_swampext\inv_packageext	�������_������
pop_inv_tagext	����� assets\levels\levelext\rm_margeext\zz_tovillageext\inv_tagext	�����
pop_inv_wolfext	������_���� assets\levels\levelext\rm_margeext\zz_tovillageext\inv_wolfext	������_����
pop_inv_chainext	����_�_������ assets\levels\levelext\rm_margeext\zz_vanext\inv_chainext	����_�_������
pop_inv_fuchsiaext	������ assets\levels\levelext\ho_pharmacyhoext\inv_fuchsiaext	������
pop_inv_canext	����� assets\levels\levelext\mg_shopmgext\inv_canext	�����
pop_inv_hieroglyphext1	��������1 assets\levels\levelext\rm_villageext\zz_boxsext\inv_hieroglyphext1	��������1
pop_inv_hieroglyphext2	��������2 assets\levels\levelext\rm_villageext\zz_boxsext\inv_hieroglyphext2	��������2
pop_inv_crowbarext	�������� assets\levels\levelext\rm_villageext\zz_hatchext\inv_crowbarext	��������
pop_inv_symbolext	��������_������ assets\levels\levelext\rm_villageext\zz_hatchext\inv_symbolext	��������_������
pop_inv_coinsext	������� assets\levels\levelext\rm_villageext\zz_hatchext\inv_coinsext	�������
pop_inv_knifeext	��� assets\levels\levelext\rm_villageext\zz_hatchext\inv_knifeext	���
pop_inv_caneext	������ assets\levels\levelext\rm_villageext\zz_pharmacyext\inv_caneext	������
pop_inv_piperext	�� �������� assets\levels\levelext\rm_villageext\zz_shopext\inv_piperext	�� ��������
pop_inv_woodladderext	����������_�������� assets\levels\levelext\rm_watermillext\inv_woodladderext	����������_��������
pop_inv_hexahedronext	������������ assets\levels\levelext\rm_watermillext\zz_treeext\inv_hexahedronext	������������
pop_inv_claspext1	�������_1 assets\levels\levelext\rm_watermillext\zz_treeext\inv_claspext1	�������_1
pop_inv_ropeext	������_�_����� assets\levels\levelext\rm_watermillext\zz_treeext\inv_ropeext	������_�_�����
pop_inv_fishext	�������_����� assets\levels\levelext\rm_watermillext\zz_verandaext\inv_fishext	�������_�����
pop_inv_hookext	���� assets\levels\levelext\rm_watermillext\zz_verandaext\inv_hookext	����
pop_inv_cureext	��������� assets\levels\levelext\rm_witchhouseext\inv_cureext	���������
pop_inv_recipeext	������ assets\levels\levelext\rm_witchhouseext\inv_recipeext	������
pop_inv_wicketext1	�����_�������_1 assets\levels\levelext\rm_witchhouseext\zz_bellsext\inv_wicketext1	�����_�������_1
pop_inv_hieroglyphext3	��������3 assets\levels\levelext\rm_witchhouseext\zz_bellsext\inv_hieroglyphext3	��������3
pop_inv_deerext	������_����� assets\levels\levelext\rm_witchhouseext\zz_bellsext\inv_deerext	������_�����
pop_inv_sacext	������� assets\levels\levelext\rm_witchhouseext\zz_lockerext\inv_sacext	�������
pop_inv_handleext	�����_���� assets\levels\levelext\rm_witchhouseext\zz_lockerext\inv_handleext	�����_����
pop_inv_wrenchext	�������_���� assets\levels\levelext\rm_witchhouseext\zz_lockerext\inv_wrenchext	�������_����
pop_inv_rowanext	�������_������ assets\levels\levelext\rm_witchhouseext\zz_lockerext\inv_rowanext	�������_������
pop_inv_flameeyeext	��������_���� assets\levels\levelext\rm_witchhouseext\zz_tableext\inv_flameeyeext	��������_����
pop_inv_cheeseext	�������_���� assets\levels\levelext\rm_witchhouseext\zz_tableext\inv_cheeseext	�������_����
pop_inv_fertilizerext	��������� assets\levels\levelext\rm_witchhouseext\zz_tableext\inv_fertilizerext	���������
pop_inv_badgeext	��������_����� assets\levels\levelext\rm_workshopext\inv_badgeext	��������_�����
pop_inv_lizardext	��������_������� assets\levels\levelext\rm_workshopext\inv_lizardext	��������_�������
pop_inv_dullsawext	�����_���� assets\levels\levelext\rm_workshopext\zz_couchext\inv_dullsawext	�����_����
pop_inv_mittenext	������� assets\levels\levelext\rm_workshopext\zz_couchext\inv_mittenext	�������
pop_inv_greeneyeext1	������_����_1 assets\levels\levelext\rm_workshopext\zz_couchext\inv_greeneyeext1	������_����_1
pop_inv_valiseext	������� assets\levels\levelext\rm_workshopext\zz_headsext\inv_valiseext	�������
pop_inv_sunext	�������_������ assets\levels\levelext\rm_workshopext\zz_headsext\inv_sunext	�������_������
pop_inv_coneext	����������_����� assets\levels\levelext\rm_workshopext\zz_headsext\inv_coneext	����������_�����
pop_inv_ringext	�������� assets\levels\levelext\rm_workshopext\zz_headsext\inv_ringext	��������
pop_inv_digitalext2	�����_2 assets\levels\levelext\rm_workshopext\zz_windowext\inv_digitalext2	�����_2
pop_inv_lampext	������ assets\levels\levelext\rm_workshopext\zz_windowext\inv_lampext	������
pop_inv_nippersext	������� assets\levels\levelext\inv_deploy\inv_complex_bagext\inv_nippersext	�������
pop_inv_woodkeyext	����������_���� assets\levels\levelext\inv_deploy\inv_complex_bagext\inv_woodkeyext	����������_����
pop_inv_unicornext	�������� assets\levels\levelext\inv_deploy\inv_complex_bagext\inv_unicornext	��������
pop_inv_recordsext	������_������ assets\levels\levelext\inv_deploy\inv_complex_booksext\inv_recordsext	������_������
pop_inv_fungusext	��������_���� assets\levels\levelext\inv_deploy\inv_complex_canext\inv_fungusext	��������_����
pop_inv_sawext	���� assets\levels\levelext\inv_deploy\inv_complex_dullsawext\inv_sawext	����
pop_inv_chiselext	�������� assets\levels\levelext\inv_deploy\inv_complex_packageext\inv_chiselext	��������
pop_inv_tubeext	�������� assets\levels\levelext\inv_deploy\inv_complex_piperext\inv_tubeext	��������
pop_inv_ingredientsext	�����������_���_�������� assets\levels\levelext\inv_deploy\inv_complex_recipeext\inv_ingredientsext	�����������_���_��������
pop_inv_pliersext	����������� assets\levels\levelext\inv_deploy\inv_complex_valiseext\inv_pliersext	�����������
]]

function trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

local wr = get_string_massive( writer )
local sr = get_string_massive( strings )

for i = 1, #wr do
	for j = i + 1, #wr do
		if wr[ i ] == wr[ j ] then
			print( wr[ i ], "!!!!!������ � ������ ��������� ��������" )
		end
	end
end

local sr_out = {};
	for j = 1, #sr do
		local sbuf-- = sr[j]:sub(sr[j]:find("\t")+1)
		local s_id-- = sr[j]:sub(1,sr[j]:find("\t")-1)
		local s_val-- = sbuf--:sub(1,sbuf:find("\t")-1)
		local s_rus-- = sbuf--:sub(sbuf:find("\t")+1)

		if sr[j]:len() > 3 then
			if sr[j]:find("\t") then
				sbuf = sr[j]:sub(sr[j]:find("\t")+1)
				s_id = sr[j]:sub(1,sr[j]:find("\t")-1)
				if sbuf:find("\t") then
					s_val = sbuf:sub(1,sbuf:find("\t")-1)
					s_rus = sbuf:sub(sbuf:find("\t")+1):gsub("_"," ")
					--print(s_rus:upper())
				end
			end
		end


		table.insert( sr_out, { s_id, s_val, s_rus } );
	end;

function compareWordPrepare( word )
	word = trim( word:upper() ):gsub( "_", " " ):gsub( "^��", "" )
	word = trim( word )
	if word:find( "^-" ) then
		word = word:sub( 2 )
	end
	if word:find( "," ) then
		local pos = word:find( "," )
		word = word:sub( 1, pos - 1 )
		--print(word,"!!!!!!!!!!!!!!!!");
	end
	return word
end

function compareItemWords( word1, word2 )
	word1 = compareWordPrepare( word1 )
	word2 = compareWordPrepare( word2 )
	--print( word1, word2, word2:gsub( "%(%+%)", "" ), word2:gsub( "(%d%/%d)", ""  ), word2:gsub( "( %d)", "" ) )
	if ( word1 == word2 )
	or ( word1:gsub( "%(%+%)", "" ) == word2:gsub( "%(%+%)", "" )  )
	or ( word1:gsub( "(%d%/%d)", ""  ) == word2:gsub( "(%d%/%d)", ""  ) )
	or ( word1:gsub( "( %d)", "" ) == word2:gsub( "( %d)", "" ) )
	then
		return true
	else
		return false
	end
end

for i = 1, #wr do
	local wbuf = wr[i]:sub(wr[i]:find("\t")+1)
	local w_rus
	local w_val
	local tabs_count = 0
	if wbuf:find("\t") then
		--3 �������
		w_rus = wbuf:sub(1,wbuf:find("\t")-1)
		w_val = wbuf:sub(wbuf:find("\t")+1)
		tabs_count = 2
	else
		--2 �������
		w_rus = wr[i]:sub(1,wr[i]:find("\t")-1)
		w_val = wr[i]:sub(wr[i]:find("\t")+1)
		tabs_count = 1
	end

	for j = 1, #sr_out do
		--print(  sr_out[j][3]:upper(), trim( sr_out[j][3]:upper():gsub( "%(%+%)", "" ) ) );
		--print(  sr_out[j][3]:upper(), trim( sr_out[j][3]:upper():gsub( "(%d%/%d)", "" ) ) );
		if compareItemWords( w_rus, sr_out[j][3] ) then
			sr_out[j][2] = w_val

			if wr[i]:find( "pop_inv_" ) then
				wr[i] = wr[i].."; "..sr_out[j][1]
			else
				wr[i] = wr[i].."\t"..sr_out[j][1]
			end

			sr_out[j][3] = "||OK|| >> "..sr_out[j][3];

		end
	end;
end;

print("=============================== � ������� Strings.xml");
for j = 1, #sr_out do
	print( sr_out[j][1], sr_out[j][2], sr_out[j][3] );
end;

print("=============================== � ���� ���");

for j = 1, #wr do
	print( wr[j] );
end;
